#!/usr/bin/env zsh
local USE_ZPLUG=0

if [[ $USE_ZPLUG == 0 ]]; then
	# NOTE: this redundant lambda function expression is for shfmt
	function lambda() {
		# git://の方ではproxyの設定が反映されないので，https://形式の方が無難
		local zshdir=~/.zsh
		[[ ! -e $zshdir ]] && mkdir -p $zshdir

		[[ ! -e $zshdir/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions $zshdir/zsh-completions
		fpath=($zshdir/zsh-completions/src $fpath)

		[[ ! -e $zshdir/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions $zshdir/zsh-autosuggestions
		source $zshdir/zsh-autosuggestions/zsh-autosuggestions.zsh

		[[ ! -e $zshdir/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search $zshdir/zsh-history-substring-search
		source $zshdir/zsh-history-substring-search/zsh-history-substring-search.zsh

		[[ ! -e $zshdir/zsh-abbrev-alias ]] && git clone https://github.com/momo-lab/zsh-abbrev-alias $zshdir/zsh-abbrev-alias
		source $zshdir/zsh-abbrev-alias/abbrev-alias.plugin.zsh

		# NOTE: original version
		[[ ! -e $zshdir/zce.zsh ]] && git clone https://github.com/hchbaw/zce.zsh $zshdir/zce.zsh
		source $zshdir/zce.zsh/zce.zsh
		# NOTE: extended version
		[[ ! -e $zshdir/zsh-easy-motion ]] && git clone https://github.com/IngoHeimbach/zsh-easy-motion $zshdir/zsh-easy-motion
		source $zshdir/zsh-easy-motion/easy_motion.plugin.zsh

		[[ ! -e $zshdir/easy-oneliner ]] && git clone https://github.com/umaumax/easy-oneliner $zshdir/easy-oneliner
		# NOTE: set variable before source
		EASY_ONE_REFFILE=~/dotfiles/snippets/snippet.txt
		EASY_ONE_KEYBIND='^x^x' # default "^x^x"
		# NOTE: for fzy(文字列の色が途中で変化するとその文字の色が初期化されてしまう)
		# EASY_ONE_FILTER_COMMAND="fzy"
		# EASY_ONE_FILTER_OPTS="-l $(($(tput lines) / 2))"
		# NOTE: for fzf
		EASY_ONE_FILTER_COMMAND="fzf"
		EASY_ONE_FILTER_OPTS="--no-mouse --ansi --reverse --height 50%"
		source $zshdir/easy-oneliner/easy-oneliner.zsh

		# [よく使うディレクトリをブックマークする zsh のプラグイン \- Qiita]( https://qiita.com/mollifier/items/46b080f9a5ca9f29674e )
		[[ ! -e $zshdir/cd-bookmark ]] && git clone https://github.com/mollifier/cd-bookmark.git $zshdir/cd-bookmark
		fpath=($zshdir/cd-bookmark $fpath)
		autoload -Uz cd-bookmark
		function cdb() {
			[[ $# -gt 0 ]] && cd-bookmark "$@" && return
			local tag=$(cd-bookmark | peco | cut -d'|' -f1)
			[[ -n $tag ]] && cd-bookmark "$tag"
		}

		function ln_if_noexist() {
			[[ $# -le 1 ]] && echo "$0 <src> <dst>" && return
			[[ -e $1 ]] && [[ ! -e $2 ]] && ln -s $1 $2
		}

		local zsh_completion_dir=''
		[[ $(uname) == "Darwin" ]] && local zsh_completion_dir='/usr/local/share/zsh/site-functions'
		[[ $(uname) == "Linux" ]] && local zsh_completion_dir="$HOME/.zsh/completion"
		# [docker コマンドの zsh autocompletion \- Qiita]( https://qiita.com/mickamy/items/daa2a0de5f34c9c59ad9 )
		if [[ $(uname) == "Darwin" ]]; then
			ln_if_noexist /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion "${zsh_completion_dir}/_docker"
			ln_if_noexist /Applications/Docker.app/Contents/Resources/etc/docker-machine.zsh-completion "${zsh_completion_dir}/_docker-machine"
			ln_if_noexist /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion "${zsh_completion_dir}/_docker-compose"
		elif [[ $(uname) == "Linux" ]]; then
			mkdir -p "$zsh_completion_dir"
			# [Command\-line completion \| Docker Documentation]( https://docs.docker.com/compose/completion/#zsh )
			# NOTE: you cat get docker-compose version by $(docker-compose version --short)
			[[ ! -e $zsh_completion_dir/_docker-compose ]] && curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/zsh/_docker-compose >$zsh_completion_dir/_docker-compose

			# NOTE: below setting is written in README.md
			[[ ! -e $zsh_completion_dir/_tig ]] && wget https://raw.githubusercontent.com/jonas/tig/master/contrib/tig-completion.zsh -O $zsh_completion_dir/_tig
			[[ ! -e $zsh_completion_dir/tig-completion.bash ]] && wget https://raw.githubusercontent.com/jonas/tig/master/contrib/tig-completion.bash -O $zsh_completion_dir/tig-completion.bash

			fpath=(~/.zsh/completion $fpath)
		fi

		# pip
		cmdcheck pip && [[ ! -e $zsh_completion_dir/_pip ]] && pip completion --zsh >$zsh_completion_dir/_pip
		[[ -e $zsh_completion_dir/_pip ]] && source $zsh_completion_dir/_pip && compctl -K _pip_completion pip2 && compctl -K _pip_completion pip3

		# NOTE: enbale zsh completion
		# [zshの起動が遅いのでなんとかしたい 2 \- Qiita]( https://qiita.com/vintersnow/items/c29086790222608b28cf )
		# NOTE: slow with security check
		# 		autoload -Uz compinit && compinit -i
		# NOTE: fast(0.0x sec) without security check
		autoload -Uz compinit && compinit -C
	} && lambda
	return
fi

bindkey $EASY_ONE_KEYBIND easy-oneliner
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
	zplug "momo-lab/zsh-abbrev-alias"
	zplug 'Valodim/zsh-curl-completion'
	zplug "chrissicool/zsh-256color"

	# Install easy-oneliner (If fzf is already installed)
	zplug "b4b4r07/easy-oneliner", if:"which fzf"

	# TODO: add cd-bookmark setting

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

	autoload -Uz compinit && compinit -i
fi
