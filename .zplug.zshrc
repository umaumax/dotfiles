# git://の方ではproxyの設定が反映されないので，https://形式の方が無難
zshdir=~/.zsh
[[ ! -e $zshdir ]] && mkdir -p $zshdir
[[ ! -e $zshdir/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions $zshdir/zsh-completions
fpath=($zshdir/zsh-completions/src $fpath)
[[ ! -e $zshdir/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions $zshdir/zsh-autosuggestions
source $zshdir/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ ! -e $zshdir/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search $zshdir/zsh-history-substring-search
source $zshdir/zsh-history-substring-search/zsh-history-substring-search.zsh

# zplug
[[ ! -e ~/.zplug ]] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
if [[ -e ~/.zplug ]]; then
	source ~/.zplug/init.zsh

	zplug "b4b4r07/zsh-history-enhanced"
	if zplug check "b4b4r07/zsh-history-enhanced"; then
		# 		ZSH_HISTORY_FILE="$HISTFILE"
		ZSH_HISTORY_FILTER="peco:fzy:fzf:peco:percol"
		ZSH_HISTORY_KEYBIND_GET_BY_DIR="^r"
		ZSH_HISTORY_KEYBIND_GET_ALL="^r^a"
	fi

	# 未インストール項目をインストールする
	if ! zplug check --verbose; then
		printf "Install? [y/N]: "
		if read -q; then
			echo
			zplug install
		fi
	fi

	# コマンドをリンクして、PATH に追加し、プラグインは読み込む
	zplug load --verbose
fi
