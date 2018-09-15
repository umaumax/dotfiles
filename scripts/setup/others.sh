#!/usr/bin/env bash
set -e

cmdcheck() { type >/dev/null 2>&1 "$@"; }
BLACK="\033[0;30m" RED="\033[0;31m" GREEN="\033[0;32m" YELLOW="\033[0;33m" BLUE="\033[0;34m" PURPLE="\033[0;35m" LIGHT_BLUE="\033[0;36m" WHITE="\033[0;37m" GRAY="\033[0;39m" DEFAULT="\033[0m"
function echo() { command echo -e "$@"; }

mkdir -p ~/local/bin
mkdir -p ~/opt
tmpdir='/tmp'

# ################################
# nvim for linux
function naget_ubuntu_nvim() {
	pushd ~/opt
	# nightly build
	wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
	# stable build
	# wget https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage

	# TODO: how to detect FUSE or not?

	# [Release NVIM 0\.3\.1 · neovim/neovim]( https://github.com/neovim/neovim/releases/tag/v0.3.1 )
	if [[ -f /.dockerenv ]]; then
		# NOTE: no fuse pattern
		chmod u+x nvim.appimage
		./nvim.appimage --appimage-extract
		cp -r squashfs-root/usr/* ~/local
	else
		# FYI: [FUSE · AppImage/AppImageKit Wiki]( https://github.com/AppImage/AppImageKit/wiki/FUSE#type-2-appimage )
		# NOTE: AppImages require FUSE to run.
		# NOTE: fuse pattern
		sudo apt-get install -y fuse
		chmod u+x nvim.appimage
		./nvim.appimage
		mv nvim ~/local/bin/
	fi

	echo "${GREEN}Add ~/local/bin to \$PATH${DEFAULT}"
	popd
}
# ################################

# ################################
# tig for linux
function naget_ubuntu_tig() {
	pushd "$tmpdir"
	# for fatal error: curses.h: No such file or directory
	sudo apt-get install -y libncurses5-dev
	# for Japanese language
	sudo apt-get install -y libncursesw5-dev
	git clone git://github.com/jonas/tig.git
	cd "$tmpdir"/tig
	# make clean
	make -j$(nproc --all) prefix=$HOME/local
	make install prefix=$HOME/local
	popd
	# ################################

	# ################################
	# fzy for ubuntu
	pushd "$tmpdir"
	wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
	sudo dpkg -i fzy_0.9-1_amd64.deb
	rm -f fzy_0.9-1_amd64.deb
	popd
}
# ################################

# ################################
# deoplete
function naget_ubuntu_vim_deoplete() {
	sudo apt-get install -y python-pip
	sudo apt-get install -y python3-pip
	pip2 install neovim
	pip3 install neovim
	# set ~/.local.vimrc
	# :PlugUpdate
	# :UpdateRemotePlugins
}
# ################################

# ################################
# for peco
function naget_ubuntu_peco() {
	pushd "$tmpdir"
	wget https://github.com/peco/peco/releases/download/v0.4.6/peco_linux_amd64.tar.gz
	tar zxvf peco_linux_amd64.tar.gz
	cp peco_linux_amd64/peco ~/local/bin
	rm -rf peco_linux_amd64.tar.gz
	rm -rf peco_linux_amd64
	popd
}
# ################################

# ################################
#
# ################################
