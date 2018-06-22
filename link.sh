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
ln -sf ~/dotfiles/.xbindkeysrc ~/

[[ ! -d ~/.config/ ]] && mkdir -p ~/.config
[[ ! -d ~/.config/peco ]] && mkdir -p ~/.config/peco
ln -sf ~/dotfiles/.config/peco/config.json ~/.config/peco/config.json

[[ ! -d ~/.config/git ]] && mkdir -p ~/.config/git
ln -sf ~/dotfiles/.config/git/ignore ~/.config/git/ignore
ln -sf ~/dotfiles/.config/git/ignore ~/.gitignore

if [[ $(uname) == "Linux" ]]; then
	[[ ! -d ~/.config/xkeysnail ]] && mkdir -p ~/.config/xkeysnail
	ln -sf ~/dotfiles/.config/xkeysnail/config.py ~/.config/xkeysnail/config.py
fi

if [[ -n $XDG_CONFIG_HOME ]]; then
	ln -sf ~/dotfiles/.config/pep8 ~/"$XDG_CONFIG_HOME"/pep8
else
	ln -sf ~/dotfiles/.config/pep8 ~/.config/pep8
fi

# if [[ -n $LOCAL_BIN ]]; then
# 	[[ ! -d ~/local/bin ]] && mkdir -p ~/local/bin
# 	ln -sf ~/dotfiles/local/bin/xxx ~/local/bin/xxx
# fi
