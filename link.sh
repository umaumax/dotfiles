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
ln -sf ~/dotfiles/.xremap ~/

[[ ! -d ~/.config/ ]] && mkdir -p ~/.config
[[ ! -d ~/.config/peco ]] && mkdir -p ~/.config/peco
ln -sf ~/dotfiles/.config/peco/config.json ~/.config/peco/config.json

if [[ -n $XDG_CONFIG_HOME ]]; then
	ln -sf ~/dotfiles/.config/pep8 ~/"$XDG_CONFIG_HOME"/pep8
else
	ln -sf ~/dotfiles/.config/pep8 ~/.config/pep8
fi
