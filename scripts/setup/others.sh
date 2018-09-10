#!/usr/bin/env bash

# nvim for linux
mkdir -p ~/local/bin
mkdir ~/opt
cd ~/opt
# nightly build
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
# stable build
# wget https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage
mv nvim ~/local/bin/

# tig for linux
# WIP
