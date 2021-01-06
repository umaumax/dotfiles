#!/usr/bin/env bash
trap 'exit_code=$?; echo -e "\033[90m[ERR]:\033[35m$BASH_SOURCE:$LINENO:$BASH_COMMAND\033[00m"; exit "$exit_code"' ERR

current_abs_directory_path=$(cd $(dirname $0) && pwd)
cd ${current_abs_directory_path%/}

set -e

DOTPATH=${DOTPATH:-~/dotfiles}

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
  .config/gitui/key_config.ron
  .config/ecat/config.yaml
  .gdbinit
  .inputrc
  .myclirc
  .omnisharp/omnisharp.json
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
  ln -sf "$DOTPATH/$filepath" "$target_dirpath"
done

zsh_dotfiles=(
  .git.zshrc
  .peco.zshrc
  .zplug.zshrc
  .abbrev.zshrc
  .comp.zshrc
  .bindkey.zshrc
  .windows.zshrc
  .wsl.zshrc
  .nugget.zshrc
  .ros.zshrc
  .prezto.git.init.zshrc
)
[[ ! -d ~/.zsh/ ]] && mkdir -p ~/.zsh
for filepath in "${zsh_dotfiles[@]}"; do
  ln -sf "$DOTPATH/$filepath" ~/.zsh/
done

# cp not ln -f
[[ ! -f ~/.gitconfig ]] && cp "$DOTPATH/.tmpl.gitconfig" ~/.gitconfig
[[ ! -f ~/.local.vimrc ]] && cp "$DOTPATH/.tmpl.local.vimrc" ~/.local.vimrc
[[ ! -d ~/.local.git_template/ ]] && cp -R "$DOTPATH/.local.git_template" ~/

# cp .git_template dirs
find .git_template/hooks -type d -not -name '.*' -print0 | xargs -0 -L 1 -IXXX mkdir -p "$HOME/XXX"
# ln .git_template files
find .git_template/hooks -type f -not -name '.*' -print0 | xargs -0 -L 1 -IXXX ln -sf "$DOTPATH/XXX" "$HOME/XXX"
# -a: enable copy symbolic links
find .git_template/hooks -type l -not -name '.*' -print0 | xargs -0 -L 1 -IXXX cp -a "$DOTPATH/XXX" "$HOME/XXX"

[[ ! -d ~/.vim/ ]] && mkdir -p ~/.vim
# NOTE: windows ln behave like cp (to avoid 'cannot overwrite directory')
if [[ $OS =~ Windows ]]; then
  [[ -e ~/.vim/config ]] && rm -rf ~/.vim/config
fi
ln -fs "$DOTPATH"/.vim/config ~/.vim/
ln -fs "$DOTPATH"/.vim/patch ~/.vim/

[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME=".config"
[[ ! -d "$HOME/$XDG_CONFIG_HOME" ]] && mkdir -p "$HOME/$XDG_CONFIG_HOME"

ln -sf "$DOTPATH"/.config/pep8 "$HOME/$XDG_CONFIG_HOME/pep8"

# NOTE: auto create .config dir
find .config -type d -print0 | xargs -0 -L 1 -IXXX mkdir -p "$HOME/XXX"

ln -sf "$DOTPATH"/.vimrc ~/.config/nvim/init.vim
ln -sf "$DOTPATH"/.config/golfix/*.golfix ~/.config/golfix/
ln -sf "$DOTPATH"/.config/auto_fix/* ~/.config/auto_fix/
ln -sf "$DOTPATH"/.config/autostart/*.desktop ~/.config/autostart/

if [[ $(uname) == "Linux" ]]; then
  ln -sf "$DOTPATH"/.config/pip/pip.conf ~/.config/pip/pip.conf
  ln -sf "$DOTPATH"/.config/rustfmt/.rustfmt.toml ~/.config/rustfmt/.rustfmt.toml
  mkdir -p ~/.config/Code/User/snipepts/
  ln -sf "$DOTPATH"/.config/Code/User/settings.json ~/.config/Code/User/settings.json
  ln -sf "$DOTPATH"/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
  ln -sf "$DOTPATH"/.config/Code/User/snippets/* ~/.config/Code/User/snipepts/
  mkdir -p "$HOME/.config/Code - Insiders/User/snippets"
  ln -sf "$DOTPATH"/.config/Code/User/settings.json "$HOME/.config/Code - Insiders/User/settings.json"
  ln -sf "$DOTPATH"/.config/Code/User/keybindings.json "$HOME/.config/Code - Insiders/User/keybindings.json"
  ln -sf "$DOTPATH"/.config/Code/User/snippets/* "$HOME/.config/Code - Insiders/User/snippets/"
fi
if [[ $(uname) == "Darwin" ]]; then
  # FYI: [User Guide — pip 19\.0\.1 documentation]( https://pip.pypa.io/en/stable/user_guide/#configuration )
  mkdir -p "$HOME/Library/Application Support/pip/"
  ln -sf "$DOTPATH"/.config/pip/pip.conf "$HOME/Library/Application Support/pip/pip.conf"
  mkdir -p "$HOME/Library/Preferences/rustfmt/"
  ln -sf "$DOTPATH"/.config/rustfmt/.rustfmt.toml "$HOME/Library/Preferences/rustfmt/.rustfmt.toml"
  mkdir -p "$HOME/Library/Application Support/gitui/"
  ln -sf "$DOTPATH"/.config/gitui/key_config.ron "$HOME/Library/Application Support/gitui/key_config.ron"
  mkdir -p "$HOME/Library/Application Support/Code/User/snippets/"
  ln -sf "$DOTPATH"/.config/Code/User/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
  ln -sf "$DOTPATH"/.config/Code/User/keybindings.json "$HOME/Library/Application Support/Code/User/keybindings.json"
  ln -sf "$DOTPATH"/.config/Code/User/snippets/* "$HOME/Library/Application Support/Code/User/snippets/"
  mkdir -p "$HOME/Library/Application Support/Code - Insiders/User/snippets/"
  ln -sf "$DOTPATH"/.config/Code/User/settings.json "$HOME/Library/Application Support/Code - Insiders/User/settings.json"
  ln -sf "$DOTPATH"/.config/Code/User/keybindings.json "$HOME/Library/Application Support/Code - Insiders/User/keybindings.json"
  ln -sf "$DOTPATH"/.config/Code/User/snippets/* "$HOME/Library/Application Support/Code - Insiders/User/snippets/"
  if [[ -d ~/.vscode-insiders/extensions ]] && [[ ! -L ~/.vscode-insiders/extensions ]]; then
    echo 1>&2 $'\e[93m'"[!] ~/.vscode-insiders/extensions is not symbolic link"$'\e[m'
    echo 1>&2 $'\e[93m'"rm -rf ~/.vscode-insiders/extensions"$'\e[m'
    echo 1>&2 $'\e[93m'"ln -s ~/.vscode/extensions ~/.vscode-insiders/extensions"$'\e[m'
  fi
fi

eval "cat <<EOF
$(<"$DOTPATH"/compile_flags.txt.bash.tmpl)
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
safe_ln "$DOTPATH"/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
safe_ln "$DOTPATH"/.minimal.bashrc ~/.config/oressh/default/.bashrc
safe_ln "$DOTPATH"/.minimal.vimrc ~/.config/oressh/default/.vimrc
safe_ln "$DOTPATH"/.inputrc ~/.config/oressh/default/.inputrc

if [[ -d ~/.config/karabiner/assets/complex_modifications ]]; then
  ls "$DOTPATH"/.config/karabiner/assets/complex_modifications/ | while read -r filepath || [ -n "${filepath}" ]; do
    karabiner_name=${filepath#*.}
    ln -sf "$DOTPATH"/.config/karabiner/assets/complex_modifications/$filepath ~/.config/karabiner/assets/complex_modifications/$karabiner_name
  done
fi

# tmux
if type >/dev/null 2>&1 tmux; then
  # install manager
  [[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  tmux source-file ~/.tmux.conf
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
else
  echo $'\e[91m'"[✗] tmux command not found."$'\e[m'
  exit 1
fi

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
