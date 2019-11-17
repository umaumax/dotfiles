#!/usr/bin/env bash

set -ex

# brew
brew_install_formula_list=(
  aha
  ansible
  autossh
  bash
  bat
  boost
  ccat
  clang-format
  cliclick
  cmake
  coreutils
  datamash
  direnv
  exa # A modern version of ‘ls’.
  ffmpeg
  figlet
  freetype
  fzf
  gcc
  gdrive
  git
  gnu-sed
  go
  grep
  htop
  icdiff
  imagemagick
  jid
  jq
  libpng
  lcov
  lsd # The next gen ls command
  micro
  ninja
  node
  peco
  pstree
  pyenv
  python3
  qt
  rlwrap
  screen
  shellcheck
  terminal-notifier
  tig
  tmux
  tree
  translate-shell
  unrar
  vim
  watch
  zsh
  zsh-autosuggestions
  zsh-completions
  zsh-git-prompt
  zsh-history-substring-search
)
for formula in "${brew_install_formula_list[@]}"; do
  brew install "$formula"
done

brew install rpl
brew install rust
brew install colormake
brew install sshfs
brew install ghq
brew install bats
brew install colordiff
brew install neovim
# for c++ lib
brew install google-benchmark
# for git instaweb
brew install lighttpd

# for confirm cp command progress
# [Xfennec/progress: Linux tool to show progress for cp, mv, dd, \.\.\. \(formerly known as cv\)]( https://github.com/Xfennec/progress )
brew install progress

# coloring output
brew install lolcat

brew install parallel
brew install socat

# for perl
brew install cpanminus

# for dump struct
# NOTE: this requires brew cask install adoptopenjdk
# brew install kaitai-struct-compiler

# brew tap
brew tap aki017/sixel
brew install libsixel

# brew cask
## WARN: don't install by your self (by GUI)
brew cask install iterm2
brew cask install alacritty
brew cask install cheatsheet
brew cask install firefox
brew cask install google-chrome
brew cask install chromedriver
brew cask install google-japanese-ime
brew cask install karabiner-elements
brew cask install sublime-text
brew cask install shiftit
brew cask install xquartz
brew cask install ip-in-menu-bar
# NOTE: not brew install docker
brew cask install docker
brew cask install adobe-acrobat-reader
brew cask install totalspaces
brew cask install qlmarkdown
brew cask install qlstephen
brew cask install quicklook-json
brew cask install quicklook-csv
brew cask install betterzip
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install texpad
brew cask install osxfuse
# NOTE: after osxfuse beacuse of dependency
brew install ext4fuse
brew cask install flash-player

# NOTE: if you need
# brew cask install blender
# brew cask install cura
# brew cask install atom
# brew cask install gimp
# brew cask install skype
