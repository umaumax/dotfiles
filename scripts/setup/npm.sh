#!/usr/bin/env bash

set -ex

if [[ $1 == '--sudo-env' ]]; then
	function npm() {
		sudo -E npm "$@"
	}
else
	function npm() {
		sudo npm "$@"
	}
fi

# sudo apt-get install -y nodejs npm
npm install -g n
npm install -g neovim
npm install -g jsonlint
npm install -g vue-language-server
npm install -g node-notifier-cli
