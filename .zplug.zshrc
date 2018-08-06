local USE_ZPLUG=0

if [[ $USE_ZPLUG == 0 ]]; then
	# git://の方ではproxyの設定が反映されないので，https://形式の方が無難
	zshdir=~/.zsh
	[[ ! -e $zshdir ]] && mkdir -p $zshdir
	[[ ! -e $zshdir/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions $zshdir/zsh-completions
	fpath=($zshdir/zsh-completions/src $fpath)
	[[ ! -e $zshdir/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions $zshdir/zsh-autosuggestions
	source $zshdir/zsh-autosuggestions/zsh-autosuggestions.zsh
	[[ ! -e $zshdir/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search $zshdir/zsh-history-substring-search
	source $zshdir/zsh-history-substring-search/zsh-history-substring-search.zsh
	[[ ! -e $zshdir/easy-oneliner ]] && git clone https://github.com/umaumax/easy-oneliner $zshdir/easy-oneliner
	# NOTE: 変数を設定してからsourceする必要がある
	EASY_ONE_REFFILE=~/dotfiles/snippets/snippet.txt
	EASY_ONE_KEYBIND="^r" # default "^x^x"
	EASY_ONE_FILTER_COMMAND="fzy"
	EASY_ONE_FILTER_OPTS="-l $(($(tput lines) / 2))"
	source $zshdir/easy-oneliner/easy-oneliner.zsh
	return
fi

# zplug
# NOTE: zplug影響下ではreloginができなくなる...，ため， zplugで大量に管理しない場合には上記のほうがおすすめ
[[ ! -e ~/.zplug ]] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
if [[ -e ~/.zplug ]]; then
	source ~/.zplug/init.zsh

	# 	zplug "zplug/zplug", hook-build:'zplug --self-manage'

	# [b4b4r07/zsh\-history\-ltsv: Command history tool available on Zsh enhanced drastically]( https://github.com/b4b4r07/zsh-history-ltsv )
	zplug "b4b4r07/zsh-history-enhanced"
	if zplug check "b4b4r07/zsh-history-enhanced"; then
		# 		ZSH_HISTORY_FILE="$HISTFILE"
		ZSH_HISTORY_FILTER="fzy:fzf:peco:percol"
		ZSH_HISTORY_KEYBIND_GET_BY_DIR="^r"
		ZSH_HISTORY_KEYBIND_GET_ALL="^r^a"
	fi

	# [b4b4r07/enhancd: A next\-generation cd command with an interactive filter]( https://github.com/b4b4r07/enhancd )
	# use: source ~/.zplug/repos/b4b4r07/enhancd/init.sh
	zplug "b4b4r07/enhancd", use:init.sh
	ENHANCD_FILTER="command peco"
	export ENHANCD_FILTER

	zplug "zsh-users/zsh-history-substring-search", hook-build:"__zsh_version 4.3"
	zplug "zsh-users/zsh-syntax-highlighting", defer:2
	zplug "zsh-users/zsh-completions"
	zplug "zsh-users/zsh-autosuggestions"
	zplug 'Valodim/zsh-curl-completion'
	zplug "chrissicool/zsh-256color"

	# Install easy-oneliner (If fzf is already installed)
	zplug "b4b4r07/easy-oneliner", if:"which fzf"

	# install conrifmation
	if ! zplug check --verbose; then
		printf "Install? [y/N]: "
		if read -q; then
			echo
			zplug install
		fi
	fi

	# コマンドをリンクして、PATH に追加し、プラグインは読み込む
	# 	zplug load --verbose
	zplug load
fi
