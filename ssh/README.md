# sshMemo

## 终端登录前提示信息

```
#本地登录
/etc/issue
#远程登录
/etc/issue.net
```

## 禁止与允许ssh登录

```
#允许登录ip配置
/etc/hosts.allow
#禁止登录ip配置
/etc/hosts.deny
```

## 禁止登录失败ip继续登录

1. tcp_wrappers 在openssh6.7以下版本有效；

   ```shell
   #!/bin/bash
   # 登录失败max次以上ip进去 hosts黑名单
   help='
   -a --add;empty
   add: add loginFailed ip to /etc/hosts.deny
   empty: show loginFailed ip;
   '
   
   max=${2:-100}
   addDeny=$(lastb | awk '{print $3}' | sort | uniq -c | sort -n | awk '$1 > '$max'' | awk '{print "sshd:"$2}' >> /etc/hosts.deny)
   
   TEMP=`getopt -o ha --long help,add -- "$@"`
   # [ $? != 0 ] $? 代表上次命令是否执行成功；成功为 0 否为不为0；
   if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1; fi
   eval set -- "$TEMP"
   while true ; do
       case "$1" in
           -h|--help) echo $help; break ;;
           -a|--add) $addDeny && awk '!a[$0]++' /etc/hosts.deny >| /tmp/hosts.deny && cat /tmp/hosts.deny >| /etc/hosts.deny ; break ;;
           *) lastb | awk '{print $3}' | sort | uniq -c | sort -n ; exit 1 ;;
       esac
   done
   ```

2. iptables方式

   - 创建 iptables 命令脚本；deny.sh

   ```shell
   #!/bin/bash
   iptables -F
   iptables -X
   iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
   iptables -A INPUT -p icmp --icmp-type 8 -m length --length 84 -j LOG --log-prefix 'SSH_OPEN_KEY'
   iptables -A INPUT -p icmp --icmp-type 8 -m length --length 84 -m recent --name SSH --set --rsource -j ACCEPT
   iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --rcheck --seconds 60 --name SSH --rsource -j ACCEPT
   iptables -A INPUT -p tcp --dport 22 -j DROP
   iptables -I INPUT 1 -s 127.0.0.1/24,10.0.0.1/24,172.16.0.0/24 -p tcp --dport 22 -j ACCEPT
   ```

   - `sh deny.sh && iptables-save >| ~/deny.fw`
   - `sh deny6.sh && ip6tables-save >| ~/deny6.fw`
   - /etc/network/if-up.d 文件夹中创建 `iptables-restore` 文件输入以下内容，并给予执行权限；

   ```shell
   #!/bin/sh
   iptables-restore < /root/wapper/ssh/deny.fw
   ip6tables-restore < /root/wapper/ssh/deny6.fw
   exit 0
   ```
   
   - `reboot` 

