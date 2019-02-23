#!/usr/bin/env bash
current_abs_directory_path=$(cd $(dirname $0) && pwd)
cd ${current_abs_directory_path%/}

set -ex

# git submodule
git submodule update -i

# link
dotfiles=(
	.vimrc
	.tmux.conf
	.screenrc
	.tigrc
	.clang-format
	.zshrc
	.zprofile
	.zshenv
	.zpreztorc
	.textlintrc
	.inputrc
	.gdbinit
	.gdb-dashboard
	.wgit
)
for filepath in "${dotfiles[@]}"; do
	ln -sf ~/dotfiles/"$filepath" ~/
done

zsh_dotfiles=(
	.git.zshrc
	.peco.zshrc
	.zplug.zshrc
	.abbrev.zshrc
	.comp.zshrc
	.bindkey.zshrc
	.windows.zshrc
	.nugget.zshrc
	.ros.zshrc
	.prezto.git.init.zshrc
)
[[ ! -d ~/.zsh/ ]] && mkdir -p ~/.zsh
for filepath in "${zsh_dotfiles[@]}"; do
	ln -sf ~/dotfiles/"$filepath" ~/.zsh/
done

# cp not ln -f
[[ ! -f ~/.gitconfig ]] && cp ~/dotfiles/.tmpl.gitconfig ~/.gitconfig
[[ ! -f ~/.local.vimrc ]] && cp ~/dotfiles/.tmpl.local.vimrc ~/.local.vimrc
[[ ! -d ~/.local.git_template/ ]] && cp -R ~/dotfiles/.local.git_template ~/

# cp .git_template dirs
find .git_template/hooks -type d -not -name '.*' -print0 | xargs -0 -L 1 -IXXX mkdir -p "$HOME/XXX"
# ln .git_template files
find .git_template/hooks -type f -not -name '.*' -print0 | xargs -0 -L 1 -IXXX ln -sf "$HOME/dotfiles/XXX" "$HOME/XXX"
# -a: enable copy symbolic links
find .git_template/hooks -type l -not -name '.*' -print0 | xargs -0 -L 1 -IXXX cp -a "$HOME/dotfiles/XXX" "$HOME/XXX"

[[ ! -d ~/.vim/ ]] && mkdir -p ~/.vim
# NOTE: windows ln behave like cp (to avoid 'cannot overwrite directory')
if [[ $OS =~ Windows ]]; then
	[[ -e ~/.vim/config ]] && rm -rf ~/.vim/config
fi
ln -fs ~/dotfiles/.vim/config ~/.vim/

[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=".config"
ln -sf ~/dotfiles/.config/pep8 "$HOME/$XDG_CONFIG_HOME/pep8"

# NOTE: auto create .config dir
find .config -type d -print0 | xargs -0 -L 1 -IXXX mkdir -p "$HOME/XXX"

ln -sf ~/dotfiles/.config/peco/config.json ~/.config/peco/config.json
ln -sf ~/dotfiles/.config/git/ignore ~/.gitignore
ln -sf ~/dotfiles/.config/git/ignore ~/.config/git/ignore
ln -sf ~/dotfiles/.config/golfix/*.golfix ~/.config/golfix/
ln -sf ~/dotfiles/.vimrc ~/.config/nvim/init.vim

if [[ $(uname) == "Linux" ]]; then
	ln -sf ~/dotfiles/.toprc ~/
	ln -sf ~/dotfiles/.xbindkeysrc ~/
	ln -sf ~/dotfiles/.config/xkeysnail/config.py ~/.config/xkeysnail/config.py
	ln -sf ~/dotfiles/.config/autostart/*.desktop ~/.config/autostart/
	ln -sf ~/dotfiles/.config/tilda/style.css ~/.config/tilda/style.css
	ln -sf ~/dotfiles/.config/pip/pip.conf ~/.config/pip/pip.conf
fi
# FYI: [User Guide — pip 19\.0\.1 documentation]( https://pip.pypa.io/en/stable/user_guide/#configuration )
if [[ $(uname) == "Darwin" ]]; then
	mkdir -p "$HOME/Library/Application Support/pip/"
	ln -sf ~/dotfiles/.config/pip/pip.conf "$HOME/Library/Application Support/pip/pip.conf"
fi

# NOTE: backup original setting file if exists
function safe_ln() {
	[[ $# -lt 2 ]] && echo "$(basename "$0") source_file target_file" && return 1
	local source_file=$1
	local target_file=$2
	# NOTE: backup
	[[ -f "$target_file" ]] && [[ ! -L "$target_file" ]] && mv "$target_file" "${target_file}~"
	# NOTE: target_file -> source_file
	ln -sf "$source_file" "$target_file"
}
safe_ln ~/dotfiles/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
safe_ln ~/dotfiles/.minimal.bashrc ~/.config/oressh/default/.bashrc
safe_ln ~/dotfiles/.minimal.vimrc ~/.config/oressh/default/.vimrc
safe_ln ~/dotfiles/.inputrc ~/.config/oressh/default/.inputrc

if [[ -d ~/.config/karabiner/assets/complex_modifications ]]; then
	ls ~/dotfiles/.config/karabiner/assets/complex_modifications/ | while read -r filepath || [ -n "${filepath}" ]; do
		karabiner_name=${filepath#*.}
		ln -sf ~/dotfiles/.config/karabiner/assets/complex_modifications/$filepath ~/.config/karabiner/assets/complex_modifications/$karabiner_name
	done
fi

echo "[OK]"
