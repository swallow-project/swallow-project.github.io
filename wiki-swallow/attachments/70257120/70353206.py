#!/usr/bin/python

import socket,time


IP_MTU_DISCOVER   = 10
IP_PMTUDISC_DONT  =  0  # Never send DF frames.
IP_PMTUDISC_WANT  =  1  # Use per route hints.
IP_PMTUDISC_DO    =  2  # Always DF.
IP_PMTUDISC_PROBE =  3  # Ignore dst pmtu.

RX_IP = "192.168.128.2"
RX_PORT = 0x5b5b

rxsoc = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
rxsoc.setsockopt(socket.SOL_IP, socket.SO_REUSEADDR, 1)
rxsoc.bind((RX_IP, RX_PORT))

print "Receiving debug"
# 128 is maximum data buffer size
rxdata, rxadr = rxsoc.recvfrom(0xffff)
print "rxdata: ", rxdata.encode("hex")

rxsoc.close()
