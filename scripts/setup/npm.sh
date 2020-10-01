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

# REQUIRED: sudo apt-get install -y nodejs npm
npm -g config set proxy $http_proxy
npm -g config set https-proxy $https_proxy
npm -g config set registry http://registry.npmjs.org/
# NOTE: below are delete commands
# npm -g config rm proxy
# npm -g config rm https-proxy
# npm -g config rm registry

npm install -g n
npm install -g neovim
npm install -g jsonlint
npm install -g vue-language-server
npm install -g bash-language-server
npm install -g vscode-html-languageserver-bin
npm install -g vscode-css-languageserver-bin
npm install -g javascript-typescript-langserver
npm install -g node-notifier-cli
# for markdown linting
npm install -g alex
# FYI: [Exporting Plots — Bokeh 1\.0\.4 documentation]( https://bokeh.pydata.org/en/latest/docs/user_guide/export.html )
# for bokeh svg
npm install -g phantomjs-prebuilt --unsafe-perm
# for yaml format
npm install -g align-yaml

npm install -g yarn

# for generating markdown Table of Contents
npm install -g doctoc
