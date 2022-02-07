#!/bin/bash
#tcp_wrappers

help='
-a --add;empty
add: add loginFailed ip to /etc/hosts.deny
empty: show loginFailed ip;
'
workdir=$(cd $(dirname $0); pwd)
max=${2:-100}
addDeny() {
    lastb | awk '{print $3}' | sort | uniq -c | sort -n | awk '$1 > '$max'' | awk '{print "sshd:"$2}' >> /etc/hosts.deny
    awk '!a[$0]++' /etc/hosts.deny >| /tmp/hosts.deny && cat /tmp/hosts.deny >| /etc/hosts.deny
}
backupLastb() {
   lastb >> $workdir/lastb.log
}
clearLastb() {
    echo "" >| /var/log/btmp
}

TEMP=`getopt -o ha --long help,add -- "$@"`
# [ $? != 0 ] $? 代表上次命令是否执行成功；成功为 0 否为不为0；
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1; fi
eval set -- "$TEMP"
while true ; do
    case "$1" in
        -h|--help) echo $help; break ;;
    	-a|--add) addDeny && backupLastb && clearLastb ; break ;;
        *) lastb | awk '{print $3}' | sort | uniq -c | sort -n ; exit 1 ;;
    esac
done

