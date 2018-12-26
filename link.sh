#!/bin/bash
set -x
ln -sf ~/dotfiles/.vimrc ~/
ln -sf ~/dotfiles/.tmux.conf ~/
ln -sf ~/dotfiles/.screenrc ~/
ln -sf ~/dotfiles/.tigrc ~/
ln -sf ~/dotfiles/.clang-format ~/
ln -sf ~/dotfiles/.zshrc ~/
ln -sf ~/dotfiles/.zprofile ~/
ln -sf ~/dotfiles/.zshenv ~/
ln -sf ~/dotfiles/.zpreztorc ~/
ln -sf ~/dotfiles/.textlintrc ~/

ln -sf ~/dotfiles/.gdbinit ~/
ln -sf ~/dotfiles/.gdb-dashboard ~/

[[ ! -d ~/.zsh/ ]] && mkdir -p ~/.zsh
ln -sf ~/dotfiles/.git.zshrc ~/.zsh/
ln -sf ~/dotfiles/.peco.zshrc ~/.zsh/
ln -sf ~/dotfiles/.zplug.zshrc ~/.zsh/
ln -sf ~/dotfiles/.bindkey.zshrc ~/.zsh/
ln -sf ~/dotfiles/.windows.zshrc ~/.zsh/
ln -sf ~/dotfiles/.nugget.zshrc ~/.zsh/
ln -sf ~/dotfiles/.ros.zshrc ~/.zsh/

# cp not ln -f
[[ ! -f ~/.gitconfig ]] && cp ~/dotfiles/.tmpl.gitconfig ~/.gitconfig
[[ ! -f ~/.local.vimrc ]] && cp ~/dotfiles/.tmpl.local.vimrc ~/.local.vimrc

[[ ! -d ~/.local.git_template/ ]] && command cp -r ~/dotfiles/.local.git_template ~/

# cp .git_template dirs
(cd ~/dotfiles && find .git_template/hooks -type d -not -name '.*' | xargs -L 1 -IXXX mkdir -p "$HOME/XXX")
# ln .git_template files
(cd ~/dotfiles && find .git_template/hooks -type f -not -name '.*' | xargs -L 1 -IXXX ln -sf "$HOME/dotfiles/XXX" "$HOME/XXX")
# -a: enable copy symbolic links
(cd ~/dotfiles && find .git_template/hooks -type l -not -name '.*' | xargs -L 1 -IXXX cp -a "$HOME/dotfiles/XXX" "$HOME/XXX")

ln -sf ~/dotfiles/.wgit ~/

[[ ! -d ~/.vim/ ]] && mkdir -p ~/.vim
# NOTE: windows ln behave like cp (to avoid 'cannot overwrite directory')
if [[ "$OS" =~ "Windows" ]]; then
	[[ -e ~/.vim/config ]] && rm -rf ~/.vim/config
fi
ln -fs ~/dotfiles/.vim/config ~/.vim/

[[ ! -d ~/.config/ ]] && mkdir -p ~/.config
[[ ! -d ~/.config/peco ]] && mkdir -p ~/.config/peco
ln -sf ~/dotfiles/.config/peco/config.json ~/.config/peco/config.json

[[ ! -d ~/.config/git ]] && mkdir -p ~/.config/git
ln -sf ~/dotfiles/.config/git/ignore ~/.config/git/ignore
ln -sf ~/dotfiles/.config/git/ignore ~/.gitignore

[[ ! -d ~/.config/golfix ]] && mkdir -p ~/.config/golfix
ln -sf ~/dotfiles/.config/golfix/*.golfix ~/.config/golfix/

[[ ! -d ~/.config/nvim ]] && mkdir -p ~/.config/nvim
# ln -sf ~/dotfiles/.config/nvim/init.vim ~/.config/nvim/
ln -sf ~/dotfiles/.vimrc ~/.config/nvim/init.vim

if [[ $(uname) == "Linux" ]]; then
	ln -sf ~/dotfiles/.xremap ~/
	ln -sf ~/dotfiles/.xbindkeysrc ~/
	[[ ! -d ~/.config/xkeysnail ]] && mkdir -p ~/.config/xkeysnail
	ln -sf ~/dotfiles/.config/xkeysnail/config.py ~/.config/xkeysnail/config.py
	ln -sf ~/dotfiles/.toprc ~/

	[[ ! -d ~/.config/autostart ]] && mkdir -p ~/.config/autostart
	(cd ~/dotfiles/.config/autostart && find . -type f -name '*.desktop' | xargs -L 1 -IXXX ln -sf "$HOME/dotfiles/.config/autostart/XXX" "$HOME/.config/autostart/XXX")
fi

if [[ -n $XDG_CONFIG_HOME ]]; then
	ln -sf ~/dotfiles/.config/pep8 ~/"$XDG_CONFIG_HOME"/pep8
else
	ln -sf ~/dotfiles/.config/pep8 ~/.config/pep8
fi

if [[ -d ~/.config/karabiner/assets/complex_modifications ]]; then
	while read line || [ -n "${line}" ]; do
		filepath=$line
		dirname=${filepath%/*}
		basename=${filepath##*/}
		karabiner_name=${filepath#*.}
		ln -sf $PWD/$filepath ~/.config/karabiner/assets/complex_modifications/$karabiner_name
	done < <(ls karabiner/*.json)
fi

# if [[ -n $LOCAL_BIN ]]; then
# 	[[ ! -d ~/local/bin ]] && mkdir -p ~/local/bin
# 	ln -sf ~/dotfiles/local/bin/xxx ~/local/bin/xxx
# fi
