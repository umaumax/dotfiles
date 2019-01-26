#!/usr/bin/env bash

set -ex

# brew
# WIP
brew install rpl
brew install rust
brew install colormake
brew install sshfs
brew install ghq
brew install bats
# for c++ lib
brew install google-benchmark

# for confirm cp command progress
# [Xfennec/progress: Linux tool to show progress for cp, mv, dd, \.\.\. \(formerly known as cv\)]( https://github.com/Xfennec/progress )
brew install progress

# brew tap
# WIP

# brew cask
brew cask install chromedriver
brew cask install alacritty
