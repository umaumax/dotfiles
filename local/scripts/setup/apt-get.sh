#!/usr/bin/env bash

set -ex

if [[ $1 == '--sudo-env' ]]; then
  function sudo() {
    command sudo -E "$@"
  }
elif [[ $1 == '--no-sudo' ]]; then
  function sudo() {
    "$@"
  }
fi

function dpkg_url() {
  [[ $# -le 0 ]] && echo "$0 <url>" && return 1
  local url="$1"
  local TEMP_DEB="$(mktemp)"
  wget -O "$TEMP_DEB" "$url" \
    && sudo dpkg -i "$TEMP_DEB"
  rm -f "$TEMP_DEB"
}
function gdebi_url() {
  [[ $# -le 0 ]] && echo "$0 <url>" && return 1
  local url="$1"
  local TEMP_DEB="$(mktemp)"
  wget -O "$TEMP_DEB" "$url" \
    && sudo gdebi --non-interactive "$TEMP_DEB"
  rm -f "$TEMP_DEB"
}

sudo apt-get update
sudo apt-get upgrade -y

# basic tools
# net-tools: for ifconfig
sudo apt-get install -y openssh-server git tree wget less vim zsh sudo curl man iputils-ping net-tools
# build for yourself
# sudo apt-get install -y tmux

sudo apt-get install -y aha
sudo apt-get install -y apt-file
sudo apt-get install -y ccze
sudo apt-get install -y clang llvm
sudo apt-get install -y clang-format
sudo apt-get install -y clang-tidy
sudo apt-get install -y colordiff
sudo apt-get install -y direnv
sudo apt-get install -y doxygen
sudo apt-get install -y expect
sudo apt-get install -y figlet
sudo apt-get install -y gawk
sudo apt-get install -y gdb-multiarch
sudo apt-get install -y gdebi
sudo apt-get install -y gist
sudo apt-get install -y git
sudo apt-get install -y gnuplot
sudo apt-get install -y golang-go # HINT: export PATH="/usr/lib/go/bin:$PATH"
sudo apt-get install -y graphviz
sudo apt-get install -y htop
sudo apt-get install -y imagemagick
sudo apt-get install -y jq
sudo apt-get install -y lcov
sudo apt-get install -y ldap-utils
sudo apt-get install -y libc6-dbg
sudo apt-get install -y libsixel-bin
sudo apt-get install -y lolcat
sudo apt-get install -y nasm
sudo apt-get install -y nkf
sudo apt-get install -y nmap
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo apt-get install -y ntp
sudo apt-get install -y openssh-server
sudo apt-get install -y pandoc
sudo apt-get install -y parallel
sudo apt-get install -y plantuml
sudo apt-get install -y python3-pip
sudo apt-get install -y rlwrap
sudo apt-get install -y rpl
sudo apt-get install -y shellcheck
sudo apt-get install -y silversearcher-ag
sudo apt-get install -y socat
sudo apt-get install -y sshfs
sudo apt-get install -y sshpass
sudo apt-get install -y sshuttle
sudo apt-get install -y valgrind
sudo apt-get install -y xsel xclip

# NOTE: for pip3 install pygraphviz
sudo apt-get install -y graphviz-dev

# build tools
sudo apt-get install -y cmake
sudo apt-get install -y cmake-curses-gui
sudo apt-get install -y colormake
sudo apt-get install -y ninja-build
sudo apt-get install -y ccache

# tags
sudo apt-get install -y ctags
# sudo apt-get install -y global # gtags 5.7.1-2
# NOTE: [6\.5\.6\-2 : global : amd64 : Zesty \(17\.04\) : Ubuntu]( https://launchpad.net/ubuntu/zesty/amd64/global/6.5.6-2 )
# for x86_64 Ubuntu
# dpkg_url 'http://launchpadlibrarian.net/301614632/global_6.5.6-2_amd64.deb'
sudo apt-get install -y global

# for man
sudo apt-get install -y ruby-ronn

if [[ ! -f /.dockerenv ]]; then
  # NOTE: only Ubuntu16.04
  # sudo apt-get install -y pdftk
  # NOTE: for Ubuntu18.04 or later
  sudo apt-get install -y snapd
  sudo snap install pdftk

  # NOTE: install docker
  # [Get Docker CE for Debian \| Docker Documentation]( https://docs.docker.com/install/linux/docker-ce/debian/#set-up-the-repository )
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce
  # for using docker command without sudo
  sudo gpasswd -a $USER docker

  # NOTE: install docker-compose
  # [Install Docker Compose \| Docker Documentation]( https://docs.docker.com/compose/install/ )
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  # for gui
  sudo apt-get install -y compizconfig-settings-manager unity-tweak-tool

  # for keymapping
  # NOTE: xbindkeys is more better than xmodmap for me
  # sudo apt-get install -y xorg-xmodmap
  sudo apt-get install -y xdotool
  sudo apt-get install -y wmctrl
  # for global shortcutkey
  sudo apt-get install -y xbindkeys

  # for open command
  sudo apt-get install -y gnome-terminal

  # terminal
  sudo apt-get install -y guake
  sudo apt-get install -y tilda
  sudo apt-get install -y rxvt-unicode-256color
  gdebi_url 'http://cdn-fastly.deb.debian.org/debian/pool/main/t/terminator/terminator_1.91-2_all.deb'
fi

# for virus
# sudo apt-get install -y clamav clamav-daemon
# sudo apt-get install -y clamav-base clamav-daemon clamav-freshclam

# for windows server
sudo apt-get install -y cifs-utils
# sudo apt-get install -y samba

# for serial communication
sudo apt-get install -y cu
sudo apt-get install -y screen

# language
sudo apt-get install -y locales
sudo locale-gen en_US.UTF-8
sudo apt-get install -y language-pack-ja
sudo update-locale LANG=ja_JP.UTF-8

# NOTE: Ubuntu 18.04 has no bashdb package
# [apt \- How can I install bashdb on Ubuntu 18\.04 \- Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/440816/how-can-i-install-bashdb-on-ubuntu-18-04 )
# sudo apt-get install -y bashdb

# for nfs mount
sudo apt-get install -y nfs-common

# for arm corss build
## 32bit(arm)
sudo apt install -y g++-arm-linux-gnueabihf
## 64bit(arm64)
sudo apt install -y g++-aarch64-linux-gnu

sudo apt-get install -y pv

# NOTE: ubuntu 18.04 has no pkg of colorgcc
# sudo apt-get install -y colorgcc
# if which colorgcc >/dev/null 2>&1; then
# mkdir -p ~/local/bin/
# ln -s $(which colorgcc) ~/local/bin/color-g++
# ln -s $(which colorgcc) ~/local/bin/color-gcc
# ln -s $(which colorgcc) ~/local/bin/color-c++
# ln -s $(which colorgcc) ~/local/bin/color-cc
# fi

# NOTE: for git instaweb
sudo apt-get install -y lighttpd

# NOTE: for lddtree
sudo apt-get install -y pax-utils

# NOTE: for bookmark sarcher
# Ubuntu:16.04 use pip
# sudo apt-get install -y buku

# svg to pdf
sudo apt-get install -y librsvg2-bin

# for perl
sudo apt-get install -y cpanminus
sudo apt-get install -y perltidy

# for sql
sudo apt-get install -y sqlite3 libsqlite3-dev
# NOTE: for gui
sudo apt-get install -y sqlitebrowser

sudo apt-get install -y chromium-browser
# for flash
# sudo apt-get install -y pepperflashplugin-nonfree
# sudo update-pepperflashplugin-nonfree --install

# NOTE: for perf
sudo apt-get install -y linux-tools-generic
if [[ ! -f /.dockerenv ]]; then
  sudo apt-get install -y linux-tools-$(uname -r)
fi

# for ubuntu 16.04
sudo apt-get install -y lua5.3
sudo update-alternatives --install /usr/bin/lua lua /usr/bin/lua5.3 10
