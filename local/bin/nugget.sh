#!/usr/bin/env bash
# TODO: --dry-run
# TODO: list or show
# TODO: with out sudo option

set -e

NUGGET_SUCCESS=0
NUGGET_FAILURE=1
NUGGET_ALREADY_INSTALLED=2

function cmdcheck() {
  type "$1" >/dev/null 2>&1
}
function nugget-h() {
  echo "nugget [-h] [-l] <package>"
  echo '  -h: help'
  echo '  -u,--upgrade: upgrade package'
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
  # NOTE: grep current file
  cat ${BASH_SOURCE} | grep '^function nugget_'"$OS" | perl -ne 'printf "%s\n", $& if (/_'"$OS"'_\K([^()]+)/)'
}

function nugget() {
  function debug() { echo -e "\033[0;35m[log]\033[0m \033[0;33m$@\033[0m" && "$@"; }

  # NOTE: WIP
  local brew_list=(aha autossh bash bat boost ccat clang-format cliclick cmake coreutils datamash direnv ffmpeg figlet freetype gcc gdrive git gnu-sed go grep htop icdiff imagemagick jid jq libpng micro ninja node pstree pyenv python3 qt rlwrap screen shellcheck terminal-notifier tig tmux translate-shell unrar vim watch zsh zsh-autosuggestions zsh-completions zsh-git-prompt zsh-history-substring-search)
  # NOTE: WIP
  local apt_get_list=()

  [[ $# == 0 ]] && nugget-h && return 1
  local opt="$1"
  case $opt in
    -l | -h)
      # NOTE: call function
      "nugget$opt"
      return
      ;;
    -u | --upgrade)
      NUGGET_UPGRADE_FLAG=1
      shift
      ;;
    *) ;;
  esac
  local package="$1"

  local OS=$(_os)
  if [[ $OS == "mac" ]] && $(echo ${brew_list[@]} | grep -E -q "(^| )${package}( |$)"); then
    debug brew install "$package"
    return
  fi
  if [[ $OS == "ubuntu" ]] && $(echo ${apt_get_list[@]} | grep -E -q "(^| )${package}( |$)"); then
    debug sudo apt-get install "$package"
    return
  fi

  if ! cmdcheck "nugget_${OS}_${package}"; then
    echo -e "${RED}I don't know how to install it($package)\nUm, google it! ${DEFAULT}"
    return $NUGGET_FAILURE
  fi

  # init
  NUGGET_INSTALL_PREIFX=${NUGGET_INSTALL_PREIFX:-~/local}
  NUGGET_INSTALL_BIN_PREIFX="$NUGGET_INSTALL_PREIFX/bin"
  mkdir -p "$NUGGET_INSTALL_BIN_PREIFX"
  mkdir -p ~/opt

  local tmpdir=$(mktemp -d)
  [[ -z $tmpdir ]] && echo 1>&2 "Fail to mktemp -d!" && return 1
  mkdir -p "$tmpdir"

  local exit_code=0
  debug "nugget_${OS}_${package}" || exit_code=$?
  [[ $exit_code == $NUGGET_SUCCESS ]] && echo "${GREEN}SUCCESS${DEFAULT}"
  [[ $exit_code == $NUGGET_FAILURE ]] && echo "${RED}FAILED${DEFAULT}"
  [[ $exit_code == $NUGGET_ALREADY_INSTALLED ]] && echo -e "${PURPLE}already installed${DEFAULT}\n${YELLOW}if you want to upgrade, add '-u' option${DEFAULT}"
  return
}

# ################################
# ################################
# ################################

# ################################
# nvim for mac
function nugget_mac_nvim() {
  cmdcheck nvim && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  # nightly build
  wget https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
  # stable build
  # wget https://github.com/neovim/neovim/releases/download/v0.4.3/nvim-macos.tar.gz

  tar xzvf nvim-macos.tar.gz
  rm -rf "$NUGGET_INSTALL_PREIFX/nvim-osx64/"
  mv nvim-osx64/ "$NUGGET_INSTALL_PREIFX/"
  ln -sf "$NUGGET_INSTALL_PREIFX/nvim-osx64/bin/nvim" "$NUGGET_INSTALL_BIN_PREIFX/nvim"

  echo "${GREEN}Add $NUGGET_INSTALL_BIN_PREIFX to \$PATH${DEFAULT}"
  popd
}
# ################################

# ################################
# nvim for linux
function nugget_ubuntu_nvim() {
  cmdcheck nvim && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  # nightly build
  wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
  # stable build
  # wget https://github.com/neovim/neovim/releases/download/v0.4.2/nvim.appimage

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
    mv nvim.appimage "$NUGGET_INSTALL_BIN_PREIFX/nvim"
  fi

  echo "${GREEN}Add $NUGGET_INSTALL_BIN_PREIFX to \$PATH${DEFAULT}"
  popd
}
# ################################

# ################################
# tig for linux
function nugget_ubuntu_tig() {
  cmdcheck tig && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  # for fatal error: curses.h: No such file or directory
  sudo apt-get install -y libncurses5-dev
  # for Japanese language
  sudo apt-get install -y libncursesw5-dev
  git clone git://github.com/jonas/tig.git
  pushd "$tmpdir/tig"
  ./autogen.sh
  # for Japanese language
  ./configure --without-ncurses
  make -j4
  make install prefix=$HOME/local
  popd
  popd
  rm -rf "$tmpdir/tig"
}
# ################################

# ################################
# tmux for linux
function nugget_ubuntu_tmux() {
  # NOTE: There is tmux at ubutnu by apt-get? /usr/bin/tmux (2.1)
  cmdcheck tmux && [[ $(which tmux) != '/usr/bin/tmux' ]] && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  sudo apt install -y build-essential automake libevent-dev ncurses-dev pkg-config yacc bison flex
  pushd "$tmpdir"
  git clone https://github.com/tmux/tmux.git
  pushd "$tmpdir/tmux"
  # NOTE: version next3.2 has screen bug (screen buffer is broken when spllited)
  git checkout 3.1b
  sh autogen.sh && ./configure && make -j4 prefix=$HOME/local && make install prefix=$HOME/local
  popd
  popd
  rm -rf "$tmpdir/tmux"
}
# ################################

# ################################
# rtags for linux
function nugget_ubuntu_rtags() {
  cmdcheck rdm && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  # for <clang-c/Index.h>
  # NOTE: choose your clang version
  local clang_version=$(clang --version | grep 'clang version' | sed -E 's/^clang version ([0-9]+\.[0-9]+).*$/\1/')
  if [[ -z "$clang_version" ]]; then
    echo "${RED}Failed get clang version${DEFAULT}" 1>&2
    return 1
  fi
  sudo apt-get install -y libclang-${clang_version}-dev
  # for Could NOT find CPPUNIT (missing: CPPUNIT_LIBRARY CPPUNIT_INCLUDE_DIR)
  sudo apt-get install -y libcppunit-dev
  pushd "$tmpdir"
  git clone --recursive https://github.com/Andersbakken/rtags.git
  pushd "$tmpdir/rtags"
  cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_INSTALL_PREFIX=$HOME/local . && make -j8 && make install
  popd
  popd
  rm -rf "$tmpdir/rtags"
}
# ################################

# ################################
# fzy for ubuntu
function nugget_ubuntu_fzy() {
  cmdcheck fzy && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

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
  cmdcheck fzf && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  else
    pushd ~/.fzf
    git pull
    popd
  fi
  ~/.fzf/install --key-bindings --completion --no-update-rc
}
# ################################

# ################################
# deoplete
function nugget_ubuntu_nvim_deoplete() {
  sudo apt-get install -y python-pip
  sudo apt-get install -y python3-pip
  pip2 install neovim
  pip3 install neovim

  echo "[NOTE] set python setting to e.g. ~/.local.vimrc"
  echo "[NOTE] run below comamnds at nvim"
  echo ":PlugUpdate"
  echo ":UpdateRemotePlugins"
}
# ################################

# ################################
# for peco
function nugget_ubuntu_peco() {
  cmdcheck peco && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  wget https://github.com/peco/peco/releases/download/v0.4.6/peco_linux_amd64.tar.gz
  tar zxvf peco_linux_amd64.tar.gz
  cp peco_linux_amd64/peco "$NUGGET_INSTALL_BIN_PREIFX"
  rm -rf peco_linux_amd64.tar.gz
  rm -rf peco_linux_amd64
  echo "${GREEN}Add $NUGGET_INSTALL_BIN_PREIFX to \$PATH${DEFAULT}"
  popd
}
# ################################

# ################################
function nugget_ubuntu_bat() {
  cmdcheck bat && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  wget https://github.com/sharkdp/bat/releases/download/v0.15.4/bat_0.15.4_amd64.deb
  sudo dpkg -i bat_*_amd64.deb
  rm -rf bat_*_amd64.deb
  popd
}
# ################################

# ################################
function nugget_ubuntu_bats() {
  cmdcheck bats && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  # WARN: bats is not maintenanced use bats-core
  pushd "$tmpdir"
  wget https://launchpad.net/ubuntu/+archive/primary/+files/bats_0.4.0-1.1_all.deb
  sudo gdebi bats_0.4.0-1.1_all.deb
  rm -rf bats_0.4.0-1.1_all.deb
  popd
}
# ################################

# ################################
function nugget_ubuntu_exa() {
  cmdcheck exa && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  wget https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
  unzip exa-linux-x86_64-*.zip
  cp exa-linux-x86_64 "$NUGGET_INSTALL_BIN_PREIFX/exa"
  rm -rf exa-linux-x86_64-*.zip
  rm -rf exa-linux-x86_64
  echo "${GREEN}Add $NUGGET_INSTALL_BIN_PREIFX to \$PATH${DEFAULT}"
  popd
}
# ################################

# ################################
# * [Ubuntu 16\.04 LTS 上で Pandoc を使って markdown から PDF を生成する]( http://cotaro-science.blogspot.com/2016/04/ubuntu-1604-lts-pandoc-markdown-pdf.html )
#   * [Pandoc \- Installing pandoc]( http://pandoc.org/installing.html )
#     * [Release pandoc 2\.5 · jgm/pandoc · GitHub]( https://github.com/jgm/pandoc/releases/tag/2.5 )
function nugget_ubuntu_pandoc() {
  cmdcheck pandoc && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  sudo apt install -y texlive texlive-lang-cjk texlive-luatex texlive-xetex texlive-math-extra
  pushd "$tmpdir"
  wget https://github.com/jgm/pandoc/releases/download/2.5/pandoc-2.5-1-amd64.deb
  sudo dpkg -i pandoc-*-amd64.deb
  rm -rf pandoc-*-amd64.deb
  popd
}
# ################################

# ################################
function nugget_ubuntu_rust() {
  [[ -d ~/.cargo/bin/rustc ]] && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  # NOTE: Dont't use brew because we cannot use rustup
  # -y                  Disable confirmation prompt.
  # --no-modify-path    Don't configure the PATH environment variable
  curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
  source $HOME/.cargo/env
  rustup update
  rustup install nightly
}
function nugget_mac_rust() {
  nugget_ubuntu_rust "$@"
}
# ################################

# ################################
function nugget_ubuntu_ctop() {
  local ctop_bin_path="$NUGGET_INSTALL_BIN_PREIFX/ctop"
  [[ -f "$ctop_bin_path" ]] && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  local download_url="https://github.com/bcicen/ctop/releases/download/v0.7.3/ctop-0.7.3-linux-amd64"
  wget "$download_url" -O "$ctop_bin_path"
  chmod +x "$ctop_bin_path"
}
function nugget_mac_ctop() {
  brew install ctop
}
# ################################

# ################################
# NOTE: for c++ library
function nugget_ubuntu_googlebenchmark() {
  [[ -d /usr/local/include/benchmark ]] && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  git clone https://github.com/google/benchmark.git
  pushd benchmark
  git clone https://github.com/google/googletest.git
  mkdir build
  pushd build
  cmake .. -DCMAKE_BUILD_TYPE=RELEASE
  make -j4
  sudo make install
  popd
  popd
  popd
  rm -rf "$tmpdir/benchmark"
}

function nugget_ubuntu_googletest() {
  [[ -d /usr/local/include/gtest ]] && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  git clone https://github.com/google/googletest
  pushd googletest
  mkdir build
  pushd build
  cmake ..
  make -j4
  sudo make install
  popd
  popd
  popd
  rm -rf "$tmpdir/googletest"
}
function nugget_mac_googletest() {
  nugget_ubuntu_googletest "$@"
}
# ################################

# ################################
# pennywise for linux
function nugget_ubuntu_pennywise() {
  cmdcheck pennywise && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  wget https://github.com/kamranahmedse/pennywise/releases/download/v0.8.0/pennywise-0.8.0-x86_64.AppImage
  chmod u+x ./pennywise-*-x86_64.AppImage
  cp pennywise-*-x86_64.AppImage "${NUGGET_INSTALL_BIN_PREIFX}/pennywise"
  popd
  rm -rf "$tmpdir/pennywise"
}
# ################################

# ################################
function nugget_ubuntu_radare2() {
  cmdcheck radare2 && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  git clone https://github.com/radare/radare2.git
  pushd radare2
  sudo ./sys/install.sh --install
  popd
  popd
  sudo rm -rf "$tmpdir/radare2"
}
# ################################

# ################################
function nugget_ubuntu_go() {
  cmdcheck go && [[ -z $NUGGET_UPGRADE_FLAG ]] && return $NUGGET_ALREADY_INSTALLED

  pushd "$tmpdir"
  wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
  tar -C "$NUGGET_INSTALL_PREIFX" -xzf go1.14.4.linux-amd64.tar.gz
  popd
  rm -rf "$tmpdir"
}
# ################################
nugget "$@"
