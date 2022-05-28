#!/bin/bash
ip6tables -F
ip6tables -X
ip6tables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -p icmpv6 --icmpv6-type 8 -m length --length 53 -j LOG --log-prefix 'SSH_OPEN_KEY'
ip6tables -A INPUT -p icmpv6 --icmpv6-type 8 -m length --length 53 -m recent --name SSH --set --rsource -j ACCEPT
ip6tables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --rcheck --seconds 60 --name SSH --rsource -j ACCEPT
ip6tables -A INPUT -p tcp --dport 22 -j DROP
ip6tables -I INPUT 1 -s ::1/128,fd3e:958:5bf2::1/60 -p tcp --dport 22 -j ACCEPT
