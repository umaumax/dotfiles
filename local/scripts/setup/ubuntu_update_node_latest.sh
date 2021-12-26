#!/usr/bin/env bash

# NOTE: install
# /usr/bin/node
# /usr/bin/npm
# NOTE: update for latest
# curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y npm

# NOTE: install
# /usr/local/bin/npm
curl -0 -L http://npmjs.org/install.sh | sudo sh

# NOTE: install
# /usr/local/bin/node
sudo npm install n -g
sudo n stable

# NOTE: remove
# /usr/bin/node
# /usr/bin/npm
sudo apt-get remove -y nodejs
sudo apt-get remove -y npm
