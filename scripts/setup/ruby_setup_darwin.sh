#!/usr/bin/env bash
set -eux

# gem needs sudo at mac
brew install rbenv
brew install ruby-build
brew install rbenv-gemset

# 7min
rbenv install 2.3.7

rbenv global 2.3.7
