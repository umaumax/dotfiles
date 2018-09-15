#!/usr/bin/env bash
set -e

BLACK="\033[0;30m" RED="\033[0;31m" GREEN="\033[0;32m" YELLOW="\033[0;33m" BLUE="\033[0;34m" PURPLE="\033[0;35m" LIGHT_BLUE="\033[0;36m" WHITE="\033[0;37m" GRAY="\033[0;39m" DEFAULT="\033[0m"
function echo() { command echo -e "$@"; }

# ################################
# nvim for linux
mkdir -p ~/opt
pushd ~/opt
# nightly build
wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
# stable build
# wget https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage

# TODO: how to detect FUSE or not?

# [Release NVIM 0\.3\.1 · neovim/neovim]( https://github.com/neovim/neovim/releases/tag/v0.3.1 )
if [[ -f /.dockerenv ]]; then
	# NOTE: no fuse pattern
	./nvim.appimage --appimage-extract
	./squashfs-root/usr/bin/nvim
	ln -sf ./squashfs-root/usr/bin/nvim ~/local/bin/nvim
else
	# FYI: [FUSE · AppImage/AppImageKit Wiki]( https://github.com/AppImage/AppImageKit/wiki/FUSE#type-2-appimage )
	# NOTE: AppImages require FUSE to run.
	# NOTE: fuse pattern
	sudo apt-get install -y fuse
	chmod u+x nvim.appimage && ./nvim.appimage
	mkdir -p ~/local/bin
	mv nvim ~/local/bin/
fi

echo "${GREEN}Add ~/local/bin to \$PATH${DEFAULT}"
popd
# ################################

# ################################
# tig for linux
# for Japanese language
pushd /tmp
sudo apt-get install -y libncursesw5-dev
git clone git://github.com/jonas/tig.git
cd /tmp/tig
# make clean
make -j$(nproc --all) prefix=$HOME/local
make install prefix=$HOME/local
popd
# ################################

# ################################
# fzy for ubuntu
pushd /tmp
wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
sudo dpkg -i fzy_0.9-1_amd64.deb
rm -f fzy_0.9-1_amd64.deb
popd
# ################################

# ################################
#
# ################################
