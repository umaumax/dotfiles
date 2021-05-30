#!/usr/bin/env bash

set -eux

brew_install_formula_list=(
  aha
  ansible
  autossh
  bash
  bat
  binutils # add /usr/local/opt/binutils/bin to PATH
  boost
  ccat
  clang-format
  cliclick
  cmake
  coreutils
  datamash
  ddcctl
  direnv
  exa # A modern version of ‘ls’.
  expect # for unbuffer command
  ffmpeg
  figlet
  freetype
  fzf # run /opt/homebrew/opt/fzf/install to install useful keybindings and fuzzy completion:
  gcc
  gdrive
  git
  gitui
  gist
  gnu-sed
  go
  grep
  htop
  hub
  icdiff
  imagemagick
  jid
  jq
  libpng
  lcov
  micro
  ninja
  nkf
  node
  peco
  pstree
  pyenv
  python3
  qt
  rlwrap
  rustup
  screen
  # shellcheck
  terminal-notifier
  tig
  tmux
  tree
  translate-shell
  # unrar
  vim
  watch
  wget
  zsh
  zsh-autosuggestions
  zsh-completions
  zsh-git-prompt
  zsh-history-substring-search
)
for formula in "${brew_install_formula_list[@]}"; do
  brew install "$formula"
done

# brew install mono # for unity(compltion)
# for Apple M1
# brew install --build-from-source mono

brew install rpl
# brew install rust # don't install rust by brew (cannot use cargo +nightly option)
brew install colormake
# brew install sshfs
brew install st
brew install ghq
# WARN: original repo
# brew install bats
brew install bats-core
brew install colordiff
brew install neovim
# for c++ lib
brew install google-benchmark
# for git instaweb
brew install lighttpd

brew install nmap
# brew install bashdb
brew install fd

# for bookmarklet
brew install closure-compiler

# for confirm cp command progress
# [Xfennec/progress: Linux tool to show progress for cp, mv, dd, \.\.\. \(formerly known as cv\)]( https://github.com/Xfennec/progress )
brew install progress

# coloring output
brew install lolcat

brew install parallel
brew install socat

brew install plantuml

# brew install hadolint

# for perl
brew install cpanminus

# for dump struct
# NOTE: this requires brew cask install adoptopenjdk
# brew install kaitai-struct-compiler

# brew tap
# brew tap aki017/sixel
# brew install libsixel

# brew cask
## WARN: don't install by your self (by GUI)
brew install --cask visual-studio-code
brew install --cask iterm2
brew install --cask cheatsheet
brew install --cask firefox
brew install --cask google-chrome
brew install --cask chromedriver
brew install --cask chromium
brew install --cask google-japanese-ime
brew install --cask karabiner-elements
brew install --cask sublime-text
brew install --cask hammerspoon
brew install --cask xquartz
brew install --cask ip-in-menu-bar
brew install --cask alt-tab
# WARN: do not brew install docker
brew install --cask docker
brew install --cask adobe-acrobat-reader
# brew install --cask totalspaces
brew install --cask qlmarkdown
brew install --cask qlstephen
brew install --cask quicklook-json
brew install --cask quicklook-csv
brew install --cask betterzip
brew install --cask qlcolorcode
brew install --cask qlimagesize
brew install --cask texpad
brew install --cask osxfuse
brew install --cask copyq
# NOTE: after osxfuse because of dependency
# brew install ext4fuse
# brew install --cask flash-player
brew install homebrew/cask-versions/visual-studio-code-insiders

# NOTE: if you need
# brew cask install blender
# brew cask install cura
# brew cask install atom
# brew cask install gimp
# brew cask install skype
