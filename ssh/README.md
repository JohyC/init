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

```
#!/bin/bash
# 登录失败max次以上ip进去 hosts黑名单
help='
-a --add;empty
add: add loginFailed ip to /etc/hosts.deny
empty: show loginFailed ip;
'

max=${2:-100}
addDeny=$(lastb | awk '{print $3}' | sort | uniq -c | sort -n | awk '$1 > '$max'' | awk '{print $2}' >> /etc/hosts.deny)

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

