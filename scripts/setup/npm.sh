#!/usr/bin/env bash

if [[ $1 == '--sudo' ]]; then
	sudo su
else
	sudo su -
fi

# sudo apt-get install -y nodejs npm
npm install -g n
npm install -g neovim
npm install -g jsonlint
npm install -g vue-language-server
npm install -g node-notifier-cli
