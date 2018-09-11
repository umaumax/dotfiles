#!/usr/bin/env bash

mkdir -p ~/local/bin
mkdir ~/opt

# ################################
# nvim for linux
cd ~/opt
# nightly build
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
# stable build
# wget https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage
chmod u+x nvim.appimage && ./nvim.appimage
mv nvim ~/local/bin/
# ################################

# ################################
# tig for linux
# for Japanese language
cd ~/opt
sudo apt-get install libncursesw5-dev
git clone git://github.com/jonas/tig.git
cd ~/opt/tig
# make clean
make -j4 prefix=$HOME/local
make install prefix=$HOME/local
# ################################
