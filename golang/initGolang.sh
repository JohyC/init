#!/bin/bash

custom='/usr/local/custom'
if [ ! -d "$custom/go/.config" ]; then
  mkdir $custom/go/.config/
fi
if [ ! -d "$custom/gowork" ]; then
  mkdir $custom/gowork
fi

read -r -t 30 -p "write golang packages url;if not set then use 1.18.2 >" url
if [ ! -n "$url" ]; then
  url='https://go.dev/dl/go1.18.2.linux-amd64.tar.gz'
fi
# wget $url -O golang.tar.gz
# if [ ! "$?" == "0" ]; then
#   echo 'wget error!' 1>&2
#   exit 1
# fi
# tar -xvf golang.tar.gz -C $custom
# ln -s $custom/go/bin/* /usr/local/bin
if [ -n "$ZDOTDIR" ]; then
  echo -e 'export GOENV=/usr/local/custom/go/.config/env
export PATH=$PATH:/usr/local/custom/gowork/bin' >>$ZDOTDIR/.custom/.zprofile
  echo -e '
GOCACHE=/usr/local/custom/gowork/.cache/go-build
GOPATH=/usr/local/custom/gowork
GOPROXY=https://goproxy.io,direct' >$custom/go/.config/env
  source ~/.zshenv
else
  echo -e 'export GOENV=/usr/local/custom/go/.config/env
export PATH=$PATH:/usr/local/custom/gowork/bin'
  echo 'please wirte GOENV and PATH in your profile'
  echo -e '
GOCACHE=/usr/local/custom/gowork/.cache/go-build
GOPATH=/usr/local/custom/gowork
GOPROXY=https://goproxy.io,direct'
  echo 'please wirte GOCACHE GOPATH GOPROXY in your env'
fi
