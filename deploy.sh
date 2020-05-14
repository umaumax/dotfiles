#!/usr/bin/env bash
trap 'exit_code=$?; echo -ne "\033[90m[ERR]:\033[35m$BASH_SOURCE:$LINENO:$BASH_COMMAND\033[00m"; read -p " "; exit "$exit_code"' ERR

current_abs_directory_path=$(cd $(dirname $0) && pwd)
cd ${current_abs_directory_path%/}

set -e

# git submodule
git submodule update -i

# link
dotfiles=(
  .cargo/config
  .clang-format
  .config/git/attributes
  .config/git/ignore
  .config/litecli/config
  .config/peco/config.json
  .config/ranger/rc.conf
  .config/tilda/style.css
  .config/xkeysnail/config.py
  .gdbinit
  .inputrc
  .myclirc
  .replyrc
  .screenrc
  .textlintrc
  .tigrc
  .tmux.conf
  .toprc
  .vimrc
  .wgit
  .xbindkeysrc
  .zpreztorc
  .zprofile
  .zshenv
  .zshrc
)
for filepath in "${dotfiles[@]}"; do
  target_dirpath="$HOME/$(dirname "$filepath")/"
  mkdir -p "$target_dirpath"
  ln -sf ~/dotfiles/"$filepath" "$target_dirpath"
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
[[ ! -d "$HOME/$XDG_CONFIG_HOME" ]] && mkdir -p "$HOME/$XDG_CONFIG_HOME"

ln -sf ~/dotfiles/.config/pep8 "$HOME/$XDG_CONFIG_HOME/pep8"

# NOTE: auto create .config dir
find .config -type d -print0 | xargs -0 -L 1 -IXXX mkdir -p "$HOME/XXX"

ln -sf ~/dotfiles/.vimrc ~/.config/nvim/init.vim
ln -sf ~/dotfiles/.config/golfix/*.golfix ~/.config/golfix/
ln -sf ~/dotfiles/.config/auto_fix/* ~/.config/auto_fix/
ln -sf ~/dotfiles/.config/autostart/*.desktop ~/.config/autostart/

if [[ $(uname) == "Linux" ]]; then
  ln -sf ~/dotfiles/.config/pip/pip.conf ~/.config/pip/pip.conf
  ln -sf ~/dotfiles/.config/rustfmt/.rustfmt.toml ~/.config/rustfmt/.rustfmt.toml
fi
if [[ $(uname) == "Darwin" ]]; then
  # FYI: [User Guide — pip 19\.0\.1 documentation]( https://pip.pypa.io/en/stable/user_guide/#configuration )
  mkdir -p "$HOME/Library/Application Support/pip/"
  ln -sf ~/dotfiles/.config/pip/pip.conf "$HOME/Library/Application Support/pip/pip.conf"
  mkdir -p "$HOME/Library/Preferences/rustfmt/"
  ln -sf ~/dotfiles/.config/rustfmt/.rustfmt.toml "$HOME/Library/Preferences/rustfmt/.rustfmt.toml"
fi

eval "cat <<EOF
$(<~/dotfiles/compile_flags.txt.bash.tmpl)
EOF
" >~/compile_flags.txt
if [[ -f ~/compile_flags.local.txt ]]; then
  eval "cat <<EOF
$(<~/compile_flags.local.txt)
EOF
" >>~/compile_flags.txt
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

# tmux
[[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
output=$(~/.tmux/plugins/tpm/scripts/install_plugins.sh 2>&1) || {
  echo $'\e[91m'"[✗] tmux plugin install failed."$'\e[m'
  echo "$output"
  exit 1
}
output=$(~/.tmux/plugins/tpm/scripts/update_plugin.sh all 2>&1) || {
  echo $'\e[91m'"[✗] tmux plugin update failed."$'\e[m'
  echo "$output"
  exit 1
}

mkdir -p ~/local/src/
if [[ $(uname) == "Linux" ]]; then
  # only Ubuntu16.04
  if cat /etc/os-release | grep -q '^VERSION_ID="16.04"$'; then
    if [[ ! -d ~/local/src/glibc-2.23 ]]; then
      wget https://ftp.gnu.org/gnu/glibc/glibc-2.23.tar.gz -O - | tar zxvf - -C ~/local/src/
    fi
  fi
  if cat /etc/os-release | grep -q '^VERSION_ID="18.04"$'; then
    if [[ ! -d ~/local/src/glibc-2.27 ]]; then
      wget https://ftp.gnu.org/gnu/glibc/glibc-2.27.tar.gz -O - | tar zxvf - -C ~/local/src/
    fi
  fi
fi

echo $'\e[92m'"[✔] Succeeded."$'\e[m'
