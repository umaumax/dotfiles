#!/bin/bash
set -x
ln -sf ~/dotfiles/.vim ~/
ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.tmux.conf ~/
ln -sf ~/dotfiles/.clang-format ~/
ln -sf ~/dotfiles/.zshrc ~/
ln -sf ~/dotfiles/.zprofile ~/
ln -sf ~/dotfiles/.zshenv ~/
ln -sf ~/dotfiles/.zpreztorc ~/

[[ ! -d ~/.config/peco ]] && mkdir -p ~/.config/peco
ln -sf ~/dotfiles/peco.config.json ~/.config/peco/config.json
