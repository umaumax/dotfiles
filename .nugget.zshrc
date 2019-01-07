#!/usr/bin/env zsh
# TODO: --dry-run
# TODO: list or show
# TODO: with out sudo option

function nugget-h() {
	echo "nugget [-h] [-l] <package>"
	echo '  -h: help'
	echo '  -l: list installable packages'
}
function _os() {
	local OS=''
	[[ $(uname) == "Darwin" ]] && local OS='mac'
	[[ $(uname) == "Linux" ]] && local OS='ubuntu'
	echo -n "$OS"
}
function nugget-l() {
	local OS=$(_os)
	# NOTE: this eval is to avoid only zsh syntax (for shfmt)
	local install_function_list=($(eval 'print -l ${(ok)functions}' | grep '^nugget_'"$OS"))
	echo "${install_function_list[@]}" | tr ' ' '\n' | sort
}

function nugget() {
	function debug() { echo -e "\033[0;35m[log]\033[0m \033[0;33m$@\033[0m" && "$@"; }

	# NOTE: WIP
	local brew_list=(aha autossh bash bat boost ccat clang-format cliclick cmake coreutils datamash direnv ffmpeg figlet freetype gcc gdrive git gnu-sed go grep htop icdiff imagemagick jid jq libpng micro ninja node pstree pyenv python3 qt rlwrap screen shellcheck terminal-notifier tig tmux translate-shell unrar vim watch zsh zsh-autosuggestions zsh-completions zsh-git-prompt zsh-history-substring-search)
	# NOTE: WIP
	local apt_get_list=()

	[[ $# == 0 ]] && nugget-h && return 1
	local package="$1"
	case $package in
	-l | -h)
		"nugget$package"
		return
		;;
	*) ;;
	esac

	local OS=$(_os)
	if [[ $OS == "mac" ]] && $(echo ${brew_list[@]} | grep -E -q "(^| )${package}( |$)"); then
		debug brew install "$package"
		return
	fi

	if [[ $OS == "ubuntu" ]] && $(echo ${apt_get_list[@]} | grep -E -q "(^| )${package}( |$)"); then
		debug sudo apt-get install "$package"
		return
	fi

	# init
	mkdir -p ~/local/bin
	mkdir -p ~/opt
	# NOTE: don't use local
	tmpdir="$HOME/tmp"
	mkdir -p "$tmpdir"

	if cmdcheck "nugget_${OS}_${package}"; then
		debug "nugget_${OS}_${package}"
		return
	fi

	echo "${RED}I don't know how to install it($package)\nUm, google it! ${DEFAULT}"
	return
}

# ################################
# ################################
# ################################

# ################################
# nvim for linux
function nugget_ubuntu_nvim() {
	cmdcheck nvim && return

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
		mv nvim.appimage ~/local/bin/nvim
	fi

	echo "${GREEN}Add ~/local/bin to \$PATH${DEFAULT}"
	popd
}
# ################################

# ################################
# tig for linux
function nugget_ubuntu_tig() {
	cmdcheck tig && return

	pushd "$tmpdir"
	# for fatal error: curses.h: No such file or directory
	sudo apt-get install -y libncurses5-dev
	# for Japanese language
	sudo apt-get install -y libncursesw5-dev
	git clone git://github.com/jonas/tig.git
	pushd "$tmpdir"/tig
	./autogen.sh
	# for Japanese language
	./configure --without-ncurses
	make -j$(nproc --all) prefix=$HOME/local
	make install prefix=$HOME/local
	popd
	popd
	rm -rf "$tmpdir"/tig
}
# ################################

# ################################
# tmux for linux
function nugget_ubuntu_tmux() {
	# NOTE: there is /usr/bin/tmux (2.1)
	# 	cmdcheck tmux && return

	sudo apt install -y build-essential automake libevent-dev ncurses-dev
	pushd "$tmpdir"
	git clone https://github.com/tmux/tmux.git
	pushd "$tmpdir"/tmux
	sh autogen.sh && ./configure && make -j$(nproc --all) prefix=$HOME/local && make install prefix=$HOME/local
	popd
	popd
	rm -rf "$tmpdir"/tmux
}
# ################################

# ################################
# rtags for linux
function nugget_ubuntu_rtags() {
	cmdcheck rdm && return

	# for <clang-c/Index.h>
	sudo apt-get install -y libclang-3.8-dev
	# for Could NOT find CPPUNIT (missing: CPPUNIT_LIBRARY CPPUNIT_INCLUDE_DIR)
	sudo apt-get install -y libcppunit-dev
	pushd "$tmpdir"
	git clone --recursive https://github.com/Andersbakken/rtags.git
	pushd "$tmpdir"/rtags
	cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_INSTALL_PREFIX=$HOME/local . && make -j$(nproc --all) && make install
	popd
	popd
	rm -rf "$tmpdir"/rtags
}
# ################################

# ################################
# fzy for ubuntu
function nugget_ubuntu_fzy() {
	cmdcheck fzy && return

	pushd "$tmpdir"
	wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
	sudo dpkg -i fzy_0.9-1_amd64.deb
	rm -f fzy_0.9-1_amd64.deb
	popd
}
# ################################

# ################################
# fzy for ubuntu
function nugget_ubuntu_fzf() {
	cmdcheck fzf && return

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --no-key-bindings --completion --no-update-rc
}
# ################################

# ################################
# deoplete
function nugget_ubuntu_vim_deoplete() {
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
function nugget_ubuntu_peco() {
	cmdcheck peco && return

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
function nugget_ubuntu_bat() {
	cmdcheck bat && return

	pushd "$tmpdir"
	wget https://github.com/sharkdp/bat/releases/download/v0.7.0/bat_0.7.0_amd64.deb
	sudo dpkg -i bat_0.7.0_amd64.deb
	rm -rf bat_0.7.0_amd64.deb
	popd
}
# ################################

# ################################
# ################################

# ################################
# ################################
