#!/usr/bin/env bash

set -ex

# LinuxBrew installs software in user-specified directory (not system-wide), and does not require sudo access.

# maybe latest(so I recommend to install below package by linuxbrew or build your self)
brew install git    # 2.19.0
brew install tig    # 2.4.1
brew install peco   # 0.5.3
brew install fzy    # 0.9
brew install fzf    # 0.17.4
brew install tmux   # 2.7
brew install screen # 4.06.02
brew install go     # 1.11
# NOTE: [github/hub: A command\-line tool that makes git easier to use with GitHub\.]( https://github.com/github/hub )
# We do not recommend installing the snap anymore.
brew install hub

brew install wget
brew install tree
brew install lsof curl
brew install readline cmake jq
brew install ncurses openssl
brew install pkg-config
brew install ccat
brew install ninja

# takes a lot of time
# brew install vim # 8.1.0350 :requires: python: this takes a lot of time
# brew install python

# takes a loooooot of time
# brew install bat # x.x.x :requires: rust: this takes a lot of time
# brew install rust

# error
# Checked out revision 342395.
# Error: An exception occured within a build process:
#   NoMethodError: undefined method `installed?' for OS::Mac::Xcode:Module
# Did you mean?  instance_of?
# brew install clang-format

# brew install neovim # error
# brew install umaumax/neovim/neovim
