#!/usr/bin/env bash
set -ex

cat <<EOF | sudo tee -a /etc/apt/sources.list >/dev/null
deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib
EOF

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

sudo apt-get update
apt-cache search "Oracle VM Virtualbox"
sudo apt-get install -y virtualbox-6.0
