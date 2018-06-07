#!/usr/bin/env bash
find . -name="" -exec grep --color=auto -H -n {} +
sudo find / -name="" -exec grep --color=auto -H -n {} +

vim /etc/hosts
vim /etc/network/interfaces
vim /etc/resolv.conf

cd ~/.config/autostart
cd /usr/share/applications

sudo service networking restart
sudo ip addr flush
NIC= && sudo ifup $NIC && sudo ifdown $NIC

tar zxvf
tar zxvf xxxx.tar.gz # 解凍
tar zcvf
tar -zcvf xxxx.tar.gz directory # 圧縮

perl -nle '$_=~/([0-9]+)/;print $1;'

netstat -p tcp | peco | perl -nle '$_=~/\.([0-9]+)/;print $1;' | xargs -IXXX lsof -i:XXX

du -s *
df -h

docker run built -t "image" .
docker run --rm -it "image" /bin/bash

cmake -DCMAKE_CXX_CLANG_TIDY="clang-tidy;-checks=-*" ..

timeout -sKILL
timeout -sKILL 5 bash -c 'while true; do date;sleep 1;done'
