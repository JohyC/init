#!/bin/bash
iptables -F
iptables -X
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -m length --length 84 -j LOG --log-prefix 'SSH_OPEN_KEY'
iptables -A INPUT -p icmp --icmp-type 8 -m length --length 84 -m recent --name SSH --set --rsource -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --rcheck --seconds 60 --name SSH --rsource -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
iptables -I INPUT 1 -s 127.0.0.1/24,10.0.0.1/24,172.16.0.0/24 -p tcp --dport 22 -j ACCEPT