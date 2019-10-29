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
  wget -O "$TEMP_DEB" "$url" &&
    sudo dpkg -i "$TEMP_DEB"
  rm -f "$TEMP_DEB"
}
function gdebi_url() {
  [[ $# -le 0 ]] && echo "$0 <url>" && return 1
  local url="$1"
  local TEMP_DEB="$(mktemp)"
  wget -O "$TEMP_DEB" "$url" &&
    sudo gdebi --non-interactive "$TEMP_DEB"
  rm -f "$TEMP_DEB"
}

sudo apt-get update
sudo apt-get upgrade -y

# basic tools
sudo apt-get install -y openssh-server git tree wget less vim zsh sudo curl man iputils-ping net-tools
# build for yourself
# sudo apt-get install -y tmux

sudo apt-get install -y python-pip
sudo apt-get install -y python3-pip

sudo apt-get install -y git
sudo apt-get install -y direnv
sudo apt-get install -y jq
sudo apt-get install -y nkf
sudo apt-get install -y htop
sudo apt-get install -y silversearcher-ag
sudo apt-get install -y gdebi
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo apt-get install -y xsel xclip
sudo apt-get install -y colordiff
sudo apt-get install -y ccze
sudo apt-get install -y rpl

sudo apt-get install -y clang-tidy
sudo apt-get install -y clang-format # maybe 3.8
sudo apt-get install -y clang-format-5.0
# sudo apt-get install -y vim-gnome # old vim
sudo apt-get install -y golang-1.10
# HINT: export PATH="/usr/lib/go-1.10/bin:$PATH"
sudo apt-get install -y openssh-server
sudo apt-get install -y sshpass
sudo apt-get install -y sshfs
sudo apt-get install -y imagemagick
sudo apt-get install -y pdftk
sudo apt-get install -y figlet
sudo apt-get install -y expect
sudo apt-get install -y pandoc
sudo apt-get install -y shellcheck
sudo apt-get install -y doxygen
sudo apt-get install -y graphviz

# build tools
sudo apt-get install -y cmake
sudo apt-get install -y cmake-curses-gui
sudo apt-get install -y colormake
sudo apt-get install -y ninja-build
sudo apt-get install -y ccache

sudo apt-get install -y gnuplot

# tags
sudo apt-get install -y ctags
# sudo apt-get install -y global # gtags 5.7.1-2
# NOTE: [6\.5\.6\-2 : global : amd64 : Zesty \(17\.04\) : Ubuntu]( https://launchpad.net/ubuntu/zesty/amd64/global/6.5.6-2 )
dpkg_url 'http://launchpadlibrarian.net/301614632/global_6.5.6-2_amd64.deb'

# for man
sudo apt-get install -y ruby-ronn

if [[ ! -f /.dockerenv ]]; then
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
# sudo apt-get install -y ckermit

# maybe you can install -y by pip
# sudo apt-get install -y python-pygments

sudo apt-get install -y clang llvm
sudo apt-get install -y libclang-5.0-dev

sudo apt-get install -y gawk

# for tig
sudo apt-get install -y libncursesw5-dev
# maybe you should build tig yourself
# [jonas/tig: Text\-mode interface for git]( https://github.com/jonas/tig )
# sudo apt-get install -y tig

# NOTE: you should use nvim.appimage
# [neovim/neovim: Vim\-fork focused on extensibility and usability]( https://github.com/neovim/neovim )
# sudo apt-get install -y nvim

sudo apt-get install -y rlwrap

# language
sudo apt-get install -y locales
sudo locale-gen en_US.UTF-8
sudo apt-get install -y language-pack-ja
sudo update-locale LANG=ja_JP.UTF-8

sudo apt-get install -y ldap-utils

sudo apt-get install -y ntp

# for nfs mount
sudo apt-get install -y nfs-common

# for arm corss build
## 32bit(arm)
sudo apt install -y g++-arm-linux-gnueabihf
## 64bit(arm64)
sudo apt install -y g++-aarch64-linux-gnu

sudo apt-get install -y colorgcc
if which colorgcc >/dev/null 2>&1; then
  mkdir -p ~/local/bin/
  ln -s $(which colorgcc) ~/local/bin/color-g++
  ln -s $(which colorgcc) ~/local/bin/color-gcc
  ln -s $(which colorgcc) ~/local/bin/color-c++
  ln -s $(which colorgcc) ~/local/bin/color-cc
fi

# NOTE: for git instaweb
sudo apt-get install -y lighttpd

sudo apt-get install -y lolcat

# NOTE: for lddtree
sudo apt-get install -y pax-utils

# NOTE: for bookmark sarcher
# Ubuntu:16.04 use pip
# sudo apt-get install -y buku

sudo apt-get install -y parallel

# svg to pdf
sudo apt-get install -y librsvg2-bin

sudo apt-get install -y plantuml

sudo apt-get install -y lcov
sudo apt-get install -y valgrind

# --------------------------------
# below packages are WIP
# --------------------------------

# sudo apt-get install -y source-highlight

# sudo apt-get install -y arp-scan
# sudo apt-get install -y lsyncd
# # for input method?
# sudo apt-get install -y ibus-mozc
# sudo apt-get install -y ibus-gtk ibus-gtk3 ibus-qt4
# sudo apt-get install -y libedit-dev
#
# # sudo apt-get install -y g++-4.8
# # sudo apt-get install -y g++-4.9
# # sudo apt-get install -y g++-5.0
# # sudo apt-get install -y g++-5.1
# # sudo apt-get install -y g++-5.2
# # sudo apt-get install -y g++-5.3
#
# sudo apt-get install -y libjpeg-dev
# sudo apt-get install -y lsb-core
# sudo apt-get install -y gksu
# sudo apt-get install -y libc6-dev-i386
# sudo apt-get install -y libpng12-dev:i386
# sudo apt-get install -y gcc-multilib g++-multilib
# sudo apt-get install -y libc6:i386
# sudo apt-get install -y libncurses
# sudo apt-get install -y ncurses
# sudo apt-get install -y libncurses5
# sudo apt-get install -y libncurses5:i386
# sudo apt-get install -y gnuplot-qt
# sudo apt-get install -y libpcl-1.7-all-dev
# sudo apt-get install -y libopencv-dev build-essential cmake git libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils libvtk5-dev unzip
# sudo apt-get install -y libbz2-dev
# sudo apt-get install -y libtiff5-dev
# sudo apt-get install -y libxine-dev
# sudo apt-get install -y libxine2-dev
# sudo apt-get install -y libpcl-1.7-all
# sudo apt-get install -y libpng
# sudo apt-get install -y libpng12-dev
# sudo apt-get install -y libbz2-dev
# sudo apt-get install -y uncrustify
# sudo apt-get install -y libelf-dev
# sudo apt-get install -y kpartd
# sudo apt-get install -y kpartx
# sudo apt-get install -y umake
# sudo apt-get install -y openjdk-8-jdk
# sudo apt-get install -y android-tools-adb
# sudo apt-get install -y nitrogen
# sudo apt-get install -y translate-shell
# sudo apt-get install -y xserver-xorg-video-intel
# sudo apt-get install -y python-gtk2-dev
# sudo apt-get install -y pango
# sudo apt-get install -y googler
# sudo apt-get install -y unity-control-center
# sudo apt-get install -y atool
# sudo apt-get install -y svn
# sudo apt-get install -y ntp
# sudo apt-get install -y python3-dev python3-pip
# sudo apt-get install -y software-properties-common
# sudo apt-get install -y python-dev python-pip python3-dev python3-pip
# sudo apt-get install -y python-dev python-pip python3-dev
# sudo apt-get install -y python3-setuptools
# sudo apt-get install -y cmake libfreetype6-dev libfontconfig1-dev xclip
# sudo apt-get install -y ubuntu-restricted-extras libdvdread4 vlc
# sudo apt-get install -y oathtool
# sudo apt-get install -y autoconf libtool pkg-config
# sudo apt-get install -y librfxcodec
# sudo apt-get install -y nasm
