#!/usr/bin/env bash
find . -name="" -exec grep --color=auto -H -n {} +
sudo find / -name="" -exec grep --color=auto -H -n {} +

vim /etc/hosts
vim /etc/network/interfaces
vim /etc/resolv.conf

cd ~/.config/autostart
cd /usr/share/applications

sudo service networking restart
NIC= && sudo ifup $NIC && sudo ifdown $NIC

tar xvzf
tar czvf

perl -nle '$_=~/([0-9]+)/;print $1;'

netstat -p tcp | peco | perl -nle '$_=~/\.([0-9]+)/;print $1;' | xargs -IXXX lsof -i:XXX

du -s *
df -h

docker run built -t "image" .
docker run --rm -it "image" /bin/bash
