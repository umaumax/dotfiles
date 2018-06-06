# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
# ---- bash ----
# set -x #for debug

# ----------------
# 環境変数を`export`するときには`-`は使用不可ではあるが、`env`で設定する際には問題ないので使用可能(alias -sでのbash起動時に自動的に関数化され、環境変数から消える)
# [shell script - what is the zsh equivalent of bash's export -f - Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/59360/what-is-the-zsh-equivalent-of-bashs-export-f )
# 関数をexportする(e.g. ./piyo.sh内で使用可能とする)

_export_funcs=()
function exportf() {
	[[ $# == 0 ]] && echo "Usage: $0 [func name]" && return 1
	! funccheck "$1" && echo "$1 is not function" && return 1
	[[ -n $BASH ]] && export -f "$1" && return 0

	local func="$(whence -f $1 | sed -e "s/$1 //")"
	local _export_func="BASH_FUNC_${1}%%=$func"
	_export_funcs=($_export_funcs $_export_func)
}

# suffix alias
# ファイルの拡張子によって実行するコマンドを自動判別する
# to export zsh function to bash
## envで環境変数に一時的に登録してbashを実行するとそれが環境変数としてとりこまれる(exportでは"%%"で弾かれる)
## [bash - 環境変数から関数を取得する機能のセキュリティ強化 - 気ままなブログ]( http://d.hatena.ne.jp/entree/20140928/1411885652 )
## [shell script - what is the zsh equivalent of bash's export -f - Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/59360/what-is-the-zsh-equivalent-of-bashs-export-f )
## 一定の規則(e.g. "BASH_FUNC_piyo%%=( { echo piyo;})")で環境変数に指定すると関数として実行される
## あくまで拡張子がないといけないため、中身がshellの疑似実行ファイルに対しては無効なので、注意
[[ $ZSH_NAME == zsh ]] && alias -s {sh,bash}='env "${_export_funcs[@]}" bash'
# ----------------

doctor() {echo $_NO_CMD}
funccheck() { declare -f "$1" >/dev/null; }
cmdcheck() {
	type "$1" >/dev/null 2>&1
	local code=$?
	[[ ! $code ]] && _NO_CMD="$_NO_CMD:$1"
	return $code
}
alias_if_exist() {
	local tmp="${@:3:($# - 2)}"
	[[ -e "$2" ]] && alias $1=\'"$2"\'" $tmp"
}
exportf funccheck
exportf cmdcheck
exportf alias_if_exist

# [iandeth. - bashにて複数端末間でコマンド履歴(history)を共有する方法]( http://iandeth.dyndns.org/mt/ian/archives/000651.html )
function share_history() {
	history -a # .bash_historyに前回コマンドを1行追記
	history -c # 端末ローカルの履歴を一旦消去
	history -r # .bash_historyから履歴を読み込み直す
}
if [[ -n $BASH ]]; then
	PROMPT_COMMAND='share_history' # 上記関数をプロンプト毎に自動実施
	shopt -u histappend            # .bash_history追記モードは不要なのでOFFに
else
	# zsh
	unset share_history
	setopt share_history # シェルのプロセスごとに履歴を共有
fi

################
####  Mac   ####
################

# ls
[[ -n $_Darwin ]] && alias ls='ls -G'
[[ -n $_Ubuntu ]] && alias ls='ls --color=auto'

alias l='ls'
alias la='ls -al'
alias lal='ls -al'
alias lat='ls -alt'
alias latr='ls -altr'
alias lalt='ls -alt'
alias laltr='ls -altr'
alias lsa='ls -al'
alias lsal='ls -al'
alias lsat='ls -alt'
alias lsatr='ls -altr'
alias lsalt='ls -alt'
alias lsaltr='ls -altr'
cmdcheck 'git-ls' && alias gls='git-ls'

# cd
alias dl='cd ~/Downloads/'
alias downloads='cd ~/Downloads/'
alias ds='cd ~/Desktop/'
alias desktop='cd ~/Desktop/'

[[ -d ~/chrome-extension ]] && alias chrome-extension='cd ~/chrome-extension'
[[ -d ~/dotfiles/cheatsheets ]] && alias cheatsheets='cd ~/dotfiles/cheatsheets'
[[ -d ~/dotfiles/snippets ]] && alias snippetes='cd ~/dotfiles/snippets'
[[ -d ~/gshare ]] && alias gshare='cd ~/gshare'
[[ -d ~/.config ]] && alias config='cd ~/.config'

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias 1u='u'
alias 2u='uu'
alias 3u='uuu'
alias 4u='uuuu'
alias 5u='uuuuu'

# history
alias history='history 1'
alias h='history'
alias hgrep='h | grep'

# exit
alias q!='exit'
alias qq='exit'
alias qqq='exit'

alias type='type -af'
if [[ -n $_Darwin ]]; then
	export LSCOLORS=gxfxcxdxbxegexabagacad
	# cmds
	alias_if_exist airport '/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
	alias sysinfo='system_profiler SPSoftwareDataType'
	alias js='osascript -l JavaScript'
	alias_if_exist jsc '/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
	alias_if_exist vmrun '/Applications/VMware Fusion.app/Contents/Library/vmrun'
	alias_if_exist subl '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'

	# browser
	alias safari='open -a /Applications/Safari.app'
	alias firefox='open -a /Applications/Firefox.app'
	alias chrome='open -a /Applications/Google Chrome.app'

	# image
	# 	alias imgshow='qlmanage -p "$@" >& /dev/null'
	alias imgsize="mdls -name kMDItemPixelWidth -name kMDItemPixelHeight"

	# [osx - Concisely starting Mac OS apps from the command line - Ask Different](http://apple.stackexchange.com/questions/4240/concisely-starting-mac-os-apps-from-the-command-line)
	# alias skim='open -a Skim'

	# brew
	alias cellar='cd /usr/local/Cellar'

	# 要検証
	#	[[ -e /Applications/MacVim.app/Contents/MacOS/Vim ]] && alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

	# base64
	alias b64e='base64'
	alias b64d='base64 -D'
	# [UTF-8-MACをUTF-8に変換する - Qiita]( http://qiita.com/youcune/items/badaec55af6bbae9aca8 )
	alias mactext='p | nkf -w --ic=utf8-mac | c'
	# [MacOSXでstraceが欲しいけどdtrace意味わからん→dtruss使おう]( https://qiita.com/hnw/items/269f8eb44614556bd6bf )
	alias strace='sudo dtruss -f sudo -u $(id -u -n)'
fi

################
#### Ubuntu ####
################
if [[ -n $_Ubuntu ]]; then
	if cmdcheck xclip; then
		alias pbcopy='xclip -sel clip'
		alias pbpaste='xclip -o -sel clip'
	elif cmdcheck xsel; then
		alias pbcopy='xsel --clipboard --input'
		alias pbpaste='xsel --clipboard --output'
	fi
	alias gsed='sed'
	alias open='xdg-open &>/dev/null'

	alias apt-upgrade='sudo apt-get upgrade'
	alias apt-update='sudo apt-get update'
	alias apt-install='sudo apt-get install'
	alias apt-search='apt-cache search'
	alias apt-show='apt-cache show'

	# [Sample Usage · peco/peco Wiki]( https://github.com/peco/peco/wiki/Sample-Usage#peco--apt )
	function peco-apt() {
		if [ -z "$1" ]; then
			echo "Usage: peco-apt <initial search string> - select packages on peco and they will be installed"
		else
			sudo apt-cache search $1 | peco | awk '{ print $1 }' | tr "\n" " " | xargs -- sudo apt-get install
		fi
	}
fi

# copy prev command
alias cpc='echo !! | c'

alias kaiba='echo "ヽ(*ﾟдﾟ)ノ"'
alias gopher='echo "ʕ ◔ ϖ ◔ ʔ"'

# window path -> unix path
alias w2upath='sed "s:\\\:/:g"'
alias w2p='p|w2upath|c'

alias git-diff='git diff --color-words'
alias git-log-peco='cat ~/.git-logs/*.log | peco'

alias relogin='exec $SHELL -l'

function sed-range() {
	[[ $# < 3 ]] && echo "$0 filepath start-line-no end-line-no" && return
	name=$1
	start=$2
	end=$3
	cat -n $name | sed -n ${start},${end}p
}

alias ascii='man ascii'
# http servers
alias httpserver='httpserver.python2'
alias httpserver.python2='python -m SimpleHTTPServer'
alias httpserver.python3='python3 -m http.server'
alias httpserver.ruby='ruby -run -e httpd . -p 8000'
alias httpserver.php='php -S localhost:3000'

# NOTE:googler
# NOTE:peco
# alias pvim="xargs -L 1 -IXXX sh -c 'vim \$1 < /dev/tty' - 'XXX'"
alias pvim='vim -'
alias g='googler -n 5'
alias xargs-vim='_xargs-vim -'
alias viminfogrep="egrep '^>' ~/.viminfo | cut -c3- | perl -E 'say for map { chomp; \$_ =~ s/^~/\$ENV{HOME}/e; -f \$_ ? \$_ : () } <STDIN>'"
if cmdcheck peco; then
	alias pecovim='peco | xargs-vim'
	# peco copy
	alias pc='peco | c'
	alias pecopy='peco | c'
	alias pe='peco'
	alias hpeco='builtin history -nr 1 | peco | tee $(tty) | c'
	alias apeco='alias | peco'
	alias fpeco='local zzz(){ local f=`command cat`; functions $f } && print -l ${(ok)functions} | peco | zzz'
	alias epeco='env | peco | tee $(tty) | c'
	alias dirspeco='cd `dirs -lv | peco | sed -r "s/[0-9]+\s*//g"`/.'
	alias pecokill='local xxx(){ pgrep -lf $1 | peco | cut -d' ' -f1 | xargs kill -KILL } && xxx'
	# [最近 vim で編集したファイルを、peco で選択して開く \- Qiita]( https://qiita.com/Cside/items/9bf50b3186cfbe893b57 )
	# 	alias rvim="viminfogrep | peco | tee $(tty) | xargs -o vim"
	# 	alias rvim="viminfogrep | peco | tee $(tty) | xargs sh -c 'vim \$1 < /dev/tty' -"
	alias rvim="viminfogrep | peco | tee $(tty) | xargs-vim"
	# 選択したファイルが存在する場合にはそのディレクトリを取得し，'/'を加える
	# 存在しない場合には空白となる
	# 最終的に'./'を加えても動作は変更されない
	alias rvcd="cd \$(viminfogrep | peco | sed 's:/[^/]*$::g' | sed 's:$:/:g')./"
	# TODO: duplicate dirs
	alias rcd="cd \$(command cat ~/.cdinfo | peco | sed 's:$:/:g')./"
	# [git ls\-tree]( https://qiita.com/sasaplus1/items/cff8d5674e0ad6c26aa9 )
	alias gcd='cd "$(git ls-tree -dr --name-only --full-name --full-tree HEAD | sed -e "s|^|`git rev-parse --show-toplevel`/|" | peco)"'
	alias up='cd `_up | peco`/.'
fi
alias rvgrep="viminfogrep | xargs-grep"

function _up() {
	dir="$PWD"
	while [[ $dir != / ]]; do
		echo $dir
		dir=${dir%/*}
		[[ $dir == '' ]] && break
	done
	echo /
}

# [pecoでcdを快適にした｜bashでもpeco \- マクロ生物学徒の備忘録]( http://bio-eco-evo.hatenablog.com/entry/2017/04/30/044703 )
function peco-cd() {
	local sw="1"
	while [ "$sw" != "0" ]; do
		if [ "$sw" = "1" ]; then
			local list=$(echo -e "---$PWD\n../\n$(ls -F | grep /)\n---Show hidden directory\n---Show files, $(echo $(ls -F | grep -v /))\n---HOME DIRECTORY")
		elif [ "$sw" = "2" ]; then
			local list=$(echo -e "---$PWD\n$(ls -a -F | grep / | sed 1d)\n---Hide hidden directory\n---Show files, $(echo $(ls -F | grep -v /))\n---HOME DIRECTORY")
		else
			local list=$(echo -e "---BACK\n$(ls -F | grep -v /)")
		fi
		local slct=$(echo -e "$list" | peco)
		if [ "$slct" = "---$PWD" ]; then
			local sw="0"
		elif [ "$slct" = "---Hide hidden directory" ]; then
			local sw="1"
		elif [ "$slct" = "---Show hidden directory" ]; then
			local sw="2"
		elif [ "$slct" = "---Show files, $(echo $(ls -F | grep -v /))" ]; then
			local sw=$(($sw + 2))
		elif [ "$slct" = "---HOME DIRECTORY" ]; then
			cd "$HOME"
		elif [[ "$slct" =~ / ]]; then
			cd "$slct"
		elif [ "$slct" = "" ]; then
			:
		else
			local sw=$(($sw - 2))
		fi
	done
}
alias sd='peco-cd'

# <C-R>
# [pecoる]( https://qiita.com/tmsanrinsha/items/72cebab6cd448704e366 )
function _peco-select-history() {
	# historyを番号なし、逆順、最初から表示。
	# 順番を保持して重複を削除。
	# カーソルの左側の文字列をクエリにしてpecoを起動
	# \nを改行に変換
	BUFFER="$(builtin history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
	CURSOR=$#BUFFER # カーソルを文末に移動
	zle -R -c       # refresh
}
zle -N _peco-select-history
bindkey '^R' _peco-select-history

# <C-X><C-S>
function _peco-snippets() {
	BUFFER=$(grep -sv "^#" ~/dotfiles/snippets/* | sed 's:'$HOME/dotfiles/snippets/'::g' | peco --query "$LBUFFER" | sed -r 's!^[^:]*:!!g')
	CURSOR=$#BUFFER
	zle -R -c # refresh
}
zle -N _peco-snippets
bindkey '^x^s' _peco-snippets

function cheat() {
	# below commands enable alias
	# for 高速vim起動
	# vim -u NONE -N
	export VIM_FAST_MODE='on'
	local cheat_root="$HOME/dotfiles/cheatsheets/"
	local _=$(grep -rns "" $cheat_root | sed 's:'$cheat_root'::g' | peco | sed -r 's!^([^:]*:[^:]*):.*$!'$cheat_root'\1!g' | xargs-vim)
	unset VIM_FAST_MODE
}

function _sed_check_test() {
	echo '# in function (alias is disable)'
	sed --version
	echo '# in $() in function (alias is enable)'
	echo $(sed --version)
}

# 各行に同じテキストを挿入する
## md表記の"> "追加などに役立つ
function prefix() { while read n; do echo "${@}${n}"; done; }
function suffix() { while read n; do echo "${n}${@}"; done; }

# which
## which -a $COMMAND_NAME 完全一致のみ
## `which -a` means `where`?
## $PATH上に存在するコマンドのgrep
alias which2="echo $PATH | sed 's/:/\n/g' | xargs -J % find % -maxdepth 1 | grep "

# awk
# n~m列のみを表示(省略時には先頭または最後となる)
function cut2() {
	[[ $# == 0 ]] && echo "cut2 [START_FIELD_INDEX] (END_FIELD_INDEX)" && return 1
	local START=${1:-1}
	local END=${2:-NF}
	awk '{for(i='"$START"';i<='"$END"';i++){printf("%s", $i);if(i<'"$END"')printf(" ");} print ""}'
}
exportf cut2

# for python(3.3~) venv activation
cmdcheck python && alias activate='source bin/activate' # <-> deactivate
cmdcheck ninja && alias ncn='ninja -t clean && ninja'

## 要検証
if cmdcheck docker; then
	# [dockerでコンテナにログインするのを省力化してみる - Qiita]( http://qiita.com/taichi0529/items/1550a276c90c780494ca )
	function docker-login() {
		SHELL='bash'
		if [ $# -gt 0 ]; then
			SHELL=$1
		fi
		containers=($(docker ps --format "{{.Names}}"))
		len=${#containers[@]}
		#### ++++
		if [[ $len == 0 ]]; then
			echo "There is no running containers."
			return 0
		fi
		#### ++++
		echo "Please enter container number."
		for ((i = 0; i < $len; ++i)); do
			echo $i ${containers[$i]}
		done
		while read -p "" num; do
			expr "$num" + 1 >/dev/null 2>&1
			if [ $? -ge 2 ]; then
				echo "Please enter only numeric characters."
				return 0
			fi
			if [ $num -lt 0 -o $num -ge $len ]; then
				echo 'Please enter valid number.'
				return 0
			fi
			docker exec -it ${containers[$num]} $SHELL
			return 0
		done
	}
	alias docker-remove-all-container='docker rm $(docker ps -aq)'
	alias docker-remove-image='docker images | peco | awk "{print \$3}" | pipecheck xargs -L 1 echo docker rmi'
fi

# to avoid xargs no args error on ubuntu
function pipecheck() {
	local val=$(cat)
	[[ -z $val ]] && return 1
	echo $val | $@
}

# n秒後に通知する
function timer() { echo "required:terminal-notifier"; }
cmdcheck terminal-notifier && function timer() {
	[[ $# -le 1 ]] && echo "$0 [sleep-second] [message]" && return 1
	sleep $1 && terminal-notifier -sound Basso -message $2
}

# below command are accepted
# got github.com/BurntSushi/toml
# got https://github.com/BurntSushi/toml
# got go get https://github.com/BurntSushi/toml
cmdcheck 'go' && function got() {
	[[ $1 == go ]] && shift
	[[ $1 == get ]] && shift
	local args=()
	for arg in ${@}; do
		arg=${arg#https://}
		args+=$arg
	done
	go get ${args}
}

# cmd alias
cmdcheck vim && alias vi='vim'
# 行番号指定で開く
function vim() {
	if [[ $# -ge 1 ]] && [[ $1 =~ : ]]; then
		local file_path="${1%%:*}"
		local line_no=$(echo "$1" | cut -d":" -f2)
		# "" => 0
		line_no=$((line_no))
		shift
		command vim -c $line_no $file_path $@
		local code=$?
		set-dirname-title
		return $code
	fi
	command vim $@
	local code=$?
	set-dirname-title
	return $code
}
function _xargs-vim() {
	if [[ $1 == - ]]; then
		shift
		cat | while read file_path; do
			# recursive call
			vim "$file_path" $@ </dev/tty >/dev/tty
		done
		return
	fi
	vim $@
}

alias dotfiles='cd ~/dotfiles'

alias v='vim'
# don't use .viminfo file option
# alias tvim='vim -c "set viminfo="'
alias tvim='vim -i NONE'
alias virc='vim ~/.vimrc'
alias vimrc='vim ~/.vimrc'
alias viminfo='vim ~/.viminfo'
# for bash
# alias vibrc='vi ~/.bashrc'
# alias vibp='vi ~/.bash_profile'
# alias vimbrc='vi ~/.bashrc'
# alias vimbp='vi ~/.bash_profile'
# alias srcbp='source ~/.bash_profile'
# alias srcbrc='source ~/.bashrc'
# for zsh
alias src='source ~/.zshrc'
alias zshrc='vim ~/.zshrc'
alias vizrc='vim ~/.zshrc'
alias vimzrc='vim ~/.zshrc'
alias vizp='vim ~/.zprofile'
alias vimzp='vim ~/.zprofile'
alias zp='vim ~/.zprofile'
alias zrc='vim ~/.zshrc'
alias lzp='[[ -f ~/.local.zprofile ]] && vim ~/.local.zprofile'
alias lzrc='[[ -f ~/.local.zshrc ]]vim ~/.local.zshrc'
alias lvrc='[[ -f ~/.local.vimrc ]]vim ~/.local.vimrc'

# for ssh
alias vissh='vim ~/.ssh/config'
alias vimssh='vim ~/.ssh/config'
alias sshconfig='vim ~/.ssh/config'

# show path each line
alias path='echo $PATH | sed "s/:/\n/g"'

# 指定したディレクトリに存在する実行可能なファイルを列挙する
function cmds() {
	[[ $# -ne 1 ]] && echo "# Usage: $0 \"dir path\"" && return 1
	# 再帰なし
	# -type f とするとシンボリックリンクのファイルを無視してしまうので-followを付加
	find $1 -maxdepth 1 -type f -follow -perm -=+x
}
function allcmds() {
	for name in $(echo $PATH | sed "s/:/\n/g"); do
		echo $name
		find $name -maxdepth 1 -type f -follow -perm -=+x
	done
	alias
	functions | grep "() {" | grep -v -E "^\s+" | grep -v -E "^_" | sed "s/() {//g"
}

# get abs path
# [bash で ファイルの絶対パスを得る - Qiita](http://qiita.com/katoy/items/c0d9ff8aff59efa8fcbb)
function abspath() {
	if [[ -n $_Darwin ]]; then
		abspathdir=$(builtin cd $(dirname $1) && pwd)
		echo ${abspathdir%/}/$(basename $1)
	else
		readlink -f $1
	fi
}

# create markdown table body (not including header)
# e.g. paste <(seq 1 10) <(seq 11 20) | mdt "\t"
# $1: delimiter
function mdt() {
	local delim=${1:-" "}
	gsed 's/'"$delim"'/\|/g' | awk '{print "|"$0"|"}'
}

# show user home dir. as `~`
_home=$(echo $HOME | sed "s/\//\\\\\//g")
alias pwd="pwd | sed \"s/$_home/~/\""
unset _home

# `$`付きコマンドでも実行可能に(bashではinvalid)
[[ $ZSH_NAME == zsh ]] && alias \$=''
# ignore command which starts with `#`
alias \#='echo "skip comment: "'

# for colordiff
if cmdcheck icdiff; then
	alias diff='icdiff -U 1 --line-numbers'
	alias git-icdiff='git difftool --extcmd icdiff -y | less'
elif cmdcheck colordiff; then
	alias diff='colordiff -u'
else
	alias diff='diff -u'
fi

# install command: `brew install ccat` or `go get github.com/jingweno/ccat`
if cmdcheck ccat; then
	alias cat='ccat'
else
	cmdcheck pygmentize && alias ccat='pygmentize -g -O style=colorful,linenos=1'
fi
# for mac
cmdcheck gsed && alias sed='gsed'
# -s: suppress 'Is a directory'
alias grep='grep -s --color=auto'
cmdcheck ggrep && alias grep='ggrep -s --color=auto'
cmdcheck tac || alias tac='tail -r'

# mac: brew install translate-shell
# [LinuxのCUIを使ってgoogle翻訳を実行する - Qiita]( http://qiita.com/YuiM/items/1287286386b8efd58147 )
cmdcheck trans && cmdcheck rlwrap && alias trans='rlwrap trans'
cmdcheck trans && cmdcheck rlwrap && alias transja='rlwrap trans :ja'
cmdcheck rlwrap && alias bc='rlwrap bc'

## git
cmdcheck git && alias gl='git log --oneline --decorate --graph --branches --tags --remotes'

# html整形コマンド
## [XMLを整形(tidy)して読みやすく、貼りつけやすくする。 - それマグで！](http://takuya-1st.hatenablog.jp/entry/20120229/1330519953)
alias fixhtml='tidy -q -i -utf8'
alias urlencode="nkf -WwMQ | tr '=' '%'"
alias urldecode='nkf -w --url-input'
function htmldecode() {
	php -r 'while(($line=fgets(STDIN)) !== FALSE) echo html_entity_decode($line, ENT_QUOTES|ENT_HTML401);'
}
function htmlencode() {
	php -r 'while(($line=fgets(STDIN)) !== FALSE) echo htmlspecialchars($line);'
}
# alias htmlencode="perl -MHTML::Entities -pe 'encode_entities($_);'"
# alias htmlencode="perl -MHTML::Entities -pe 'encode_entities($_);'"

# 改行削除
alias one="tr -d '\r' | tr -d '\n'"
# クリップボードの改行削除
alias poc="p | one | c"

if $(cmdcheck pbcopy && cmdcheck pbpaste); then
	if cmdcheck nkf; then
		alias c='nkf -w | pbcopy'
		alias p='pbpaste | nkf -w'
		alias udec='nkf -w --url-input'
		alias uenc='nkf -WwMQ | tr = %'
		alias overwrite-utf8='nkf -w --overwrite'
	else
		alias c='pbcopy'
		alias p='pbpaste'
	fi
	# 改行コードなし
	# o: one
	alias oc="tr -d '\n' | c"
	alias op="p | tr -d '\n'"
fi

# aliasでは引数がうまく取れないので、関数化
# built-inコマンドがすでに存在している場合にはfunctionを省略してはならない
# only bash?
#function cd() { builtin cd $@ && ls; }

function set-dirname-title() {
	title=$(echo $PWD | sed -E "s:^.+/::g")
	echo -en '\e]0;'"$title"'\a'
}
# when cd
function chpwd() {
	ls_abbrev
	# NOTE: cdr
	# [pecoる]( https://qiita.com/tmsanrinsha/items/72cebab6cd448704e366#cdr%E3%81%A7peco%E3%82%8B )
	echo $PWD >>"$HOME/.cdinfo"
	set-dirname-title
}
set-dirname-title
# [chpwd内のlsでファイル数が多い場合に省略表示する - Qiita]( https://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059 )
ls_abbrev() {
	if [[ ! -r $PWD ]]; then
		return
	fi
	# -a : Do not ignore entries starting with ..
	# -C : Force multi-column output.
	# -F : Append indicator (one of */=>@|) to entries.
	local cmd_ls='ls'
	local -a opt_ls
	opt_ls=('-aCF' '--color=always')
	case "${OSTYPE}" in
	freebsd* | darwin*)
		if type gls >/dev/null 2>&1; then
			cmd_ls='gls'
		else
			# -G : Enable colorized output.
			opt_ls=('-aCFG')
		fi
		;;
	esac

	local ls_result
	ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

	local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

	if [ $ls_lines -gt 10 ]; then
		echo "$ls_result" | head -n 5
		echo '...'
		echo "$ls_result" | tail -n 5
		echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
	else
		echo "$ls_result"
	fi
}

# ディレクトリ作成及び移動
mk() {
	mkdir -p "$1"
	cd "$1" || return 1
}

alias memo='touch README.md'
alias tmp='cd ~/tmp/'

# cat all
function cat-all() {
	[[ $1 == "" ]] && echo "set file reg? e.g.) cat-all '*txt'" && return 0
	find . -name "$1" -exec awk '{ if (FNR==1) print "####################\n",FILENAME,"\n####################"; print $0}' {} +
}

# NOTE: grepに対して任意のオプションを渡せる状態?
function xargs-grep() {
	[[ $# == 0 ]] && echo 'grep_keyword' && return
	local keyword=(${@:1})
	local grep_cmd='grep'
	cmdcheck ggrep && local grep_cmd='ggrep'
	# 	xargs -n 1 -IXXX find XXX -exec $grep_cmd --color=auto -H -n ${keyword[@]} {} +
	xargs -L 1 -IXXX find XXX -exec $grep_cmd --color=auto -H -n ${keyword[@]} {} +
}
# そもそもfindとgrepの引数を同時に指定すること自体がおかしいので，仕様を見直すべき
function fgrep() {
	[[ $# == 1 ]] && echo '[root_dir_path] grep_keyword' && return
	local find_name="$1"
	local root='.'
	local keyword=(${@:2})
	if [[ $# -ge 3 ]]; then
		local root="$2"
		local keyword=(${@:3})
	fi
	find $root -type f -name $find_name | xargs-grep ${keyword[@]}
}
# FIX: merge with funtion
function fgrep2() {
	[[ $# == 2 ]] && echo '[root_dir_path] grep_keyword' && return
	local find_name1="$1"
	local find_name2="$2"
	local root='.'
	local keyword=(${@:3})
	if [[ $# -ge 4 ]]; then
		local root="$3"
		local keyword=(${@:4})
	fi
	find $root -type f -name $find_name1 -o -name $find_name2 | xargs-grep ${keyword[@]}
}
alias fg.vim='fgrep "*.vim" $@'
alias fg.my.vim='find "$HOME/.vim/config/" "$HOME/.vimrc" "$HOME/.local.vimrc" "$HOME/vim/" -type f -name "*.vim" -o -name "*.vimrc" | xargs-grep $@'
alias fg.3rd.vim='find "$HOME/.vim/plugged/" -type f -name "*.vim" | xargs-grep $@'
alias fg.go='fgrep "*.go" $@'
alias fg.my.go='find $(echo $GOPATH | cut -d":" -f2) -type f -name "*.go" | xargs-grep $@'
alias fg.3rd.go='find $(echo $GOPATH | cut -d":" -f1) -type f -name "*.go" | xargs-grep $@'
alias fg.py='fgrep "*.py" $@'
alias fg.sh='fgrep "*.sh" $@'
alias fg.cpp='fgrep "*.c[px][px]" $@'
alias fg.hpp='fgrep2 "*.h" "*.hpp" $@'
alias fg.c='fgrep "*.c" $@'
alias fg.h='fgrep "*.h" $@'
alias fg.ch='fgrep "*.[ch]" $@'
alias fg.cpp-all='fgrep2 "*.c[px][px]" "*.[ch]" $@'
alias fg.md='fgrep "*.md" $@'
alias fg.my.md='find "$HOME/md" -type f -name "*.md" | xargs-grep $@'
alias rf='sudo find / \( -type d -name home -prune \) -o'
alias hf='find ~'

alias jagrep="grep -P '\p{Hiragana}'"

# 確認くん
#global_ip() { curl http://www.ugtop.com/spill.shtml 2>&1 | nkf -w | grep -A 2 "IP" |grep font | grep "size=+" | sed -e 's/^\(.\+\)>\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)<\(.\+\)/\2/g'; }# [Linux コマンドでグローバルIPを調べる方法 - weblog of key_amb]( http://keyamb.hatenablog.com/entry/2014/01/17/195038 )
alias global_ip='curl ifconfig.moe || curl ifconfig.io'

# swap file
function swap() {
	if (($# != 2)); then
		echo "Usage: swap <file1> <file2>"
		return 1
	fi
	b1=$(basename $1)
	_l=$_l"mv $1 /tmp/"
	if [[ $? != 0 ]]; then
		echo "err:$_l"
		return 1
	fi
	mv "$1" "/tmp/"

	_l=$_l"mv $2 $1"
	mv "$2" "$1"
	if [[ $? != 0 ]]; then
		echo "err:$_l"
		return 1
	fi

	_l=$_l"mv /tmp/$1 $2"
	mv "/tmp/$b1" "$2"
	if [[ $? != 0 ]]; then
		echo "err:$_l"
		return 1
	fi
}

# 改行コード変換
alias CR2LF='sed "s/\r/\n/g"'
alias remove-blank-line='awk "NF > 0"'

alias cl='clear'
alias t='touch'

# 特定の文字で挟み込む
function sand() {
	local B=${1:-\"}
	local E
	[[ $B == \( ]] && E=")"
	[[ $B == \[ ]] && E="]"
	[[ $B == \< ]] && E=">"
	[[ $B == \{ ]] && E="}"
	[[ $B == \" ]] && B=\\\"
	E=${E:-$B}
	[[ $B == "\\" ]] && B="\\\\"
	[[ $E == \" ]] && E=\\\"
	[[ $E == "\\" ]] && E="\\\\"
	awk '{printf "'$B'%s'$E'", $0}'
}
function line() {
	local C=${1:-=} seq -f "$C" -s '' $(($(tput cols) / $(printf "%s" "$C" | wc -m)))
	echo
}

# terminal session logger
function script() {
	if [[ $# -gt 0 ]]; then
		command script "$@"
		return $?
	fi
	local dirpath=~/.typescript/$(date "+%Y-%m-%d")
	mkdir -p $dirpath
	local filename=$(date "+%H.%M.%S")"-$$.log"
	local filepath="$dirpath/$filename"
	echo "Script started, output file is $filepath"
	script -q "$filepath"
	echo "Script done, output file is $filepath"
}

# 特定のプロセスがいつから起動していたかを確かめる
# [Linuxプロセスの起動時刻を調べる方法 - Qiita](http://qiita.com/isaoshimizu/items/ee555b99582f251bd295)
# [PSコマンドでプロセスの起動時刻を調べる | ex1-lab](http://ex1.m-yabe.com/archives/1144)
function when() { ps -eo lstart,pid,args | grep -v grep; }

# カラー表示
# [aliasとシェル関数の使い分け - ももいろテクノロジー](http://inaz2.hatenablog.com/entry/2014/12/13/044630)
# [bashでラッパースクリプトを覚えたい - Qiita](http://qiita.com/catfist/items/57327b7352940b1fd4ec)
# [bashのalias に引数を渡すには？ - それマグで！](http://takuya-1st.hatenablog.jp/entry/2015/12/15/030119)
function tree() { if [ -p /dev/stdout ]; then command tree "$@"; else command tree -C "$@"; fi; }

# auto zstyle ':prezto:load' pmodule function
# e.g.
# zploadadd homebrew osx git rails syntax-highlighting history-substring-search
# zploadadd ssh tmux rsync archive
# [sed でシンボリックリンクのファイルを書き換えると、実体ファイルに変わる – Tower of Engineers]( https://toe.bbtower.co.jp/20160915/136/ )
cmdcheck gsed && function zploadadd() {
	for package in $@; do
		gsed -i --follow-symlinks -e '/^zstyle.*pmodule \\$/a '\'$package\'' \\' ~/.zpreztorc
	done
}

# 文献消失
COLORRED="\e[91m"
COLORGREEN="\e[92m"
COLORYELLOW="\e[93m"
COLOREND="\e[m"
alias ifconfig="ifconfig | perl -pe 's/(?<=inet )(\d+\.){3}\d+(\/\d+)?/${COLORYELLOW}$&${COLOREND}/g' | \
	perl -pe 's/(?![0f:]{17})([\da-f]{2}:){5}[\da-f]+/${COLORGREEN}$&${COLOREND}/g' | \
	perl -pe 's/(([\da-f]{4})?:){2,7}[\da-f]+(\/\d+)?/${COLORRED}$&${COLOREND}/g'"

function off() { printf "\e[0;m$*\e[m"; }
function bold() { printf "\e[1;m$*\e[m"; }
function under() { printf "\e[4;m$*\e[m"; }
function blink() { printf "\e[5;m$*\e[m"; }
function reverse() { printf "\e[7;m$*\e[m"; }
function back() { printf "\e[7;m$*\e[m"; }
function concealed() { printf "\e[8;m$*\e[m"; }
function black() { printf "\e[30m$*\e[m"; }
function red() { printf "\e[31m$*\e[m"; }
function green() { printf "\e[32m$*\e[m"; }
function yellow() { printf "\e[33m$*\e[m"; }
function blue() { printf "\e[34m$*\e[m"; }
function magenta() { printf "\e[35m$*\e[m"; }
function cyan() { printf "\e[36m$*\e[m"; }
function white() { printf "\e[37m$*\e[m"; }

# [正規表現でスネークケース↔キャメルケース/パスカルケースの変換 - Qiita]( http://qiita.com/ryo0301/items/7c7b3571d71b934af3f8 )
alias snake="sed -r 's/([A-Z])/_\L\1\E/g'"
alias camel="sed -r 's/_(.)/\U\1\E/g'"
alias lower="tr '[:upper:]' '[:lower:]'"
alias upper="tr '[:lower:]' '[:upper:]'"

alias jobs='jobs -l'
# [裏と表のジョブを使い分ける \- ザリガニが見ていた\.\.\.。]( http://d.hatena.ne.jp/zariganitosh/20141212/fore_back_ground_job )
alias stop='kill -TSTP'

# [command line \- Print a 256\-color test pattern in the terminal \- Ask Ubuntu]( https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal )
function color-test-256() {
	for i in {0..255}; do
		printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
		if ((i == 15)) || ((i > 15)) && (((i - 15) % 6 == 0)); then
			printf "\n"
		fi
	done
}
function color-test-full() {
	# [True Colour \(16 million colours\) support in various terminal applications and terminals]( https://gist.github.com/XVilka/8346728 )
	awk 'BEGIN{
	s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
	for (colnum = 0; colnum<77; colnum++) {
		r = 255-(colnum*255/76);
		g = (colnum*510/76);
		b = (colnum*255/76);
		if (g>255) g = 510-g;
		printf "\033[48;2;%d;%d;%dm", r,g,b;
		printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
		printf "%s\033[0m", substr(s,colnum+1,1);
	}
	printf "\n";
}'
}

function cterms() {
	# [ターミナルで使える色と色番号を一覧にする \- Qiita]( https://qiita.com/tmd45/items/226e7c380453809bc62a )
	local PROGRAM=$(
		command cat <<EOF
# -*- coding: utf-8 -*-

@fg = "\x1b[38;5;"
@bg = "\x1b[48;5;"
@rs = "\x1b[0m"

def color(code)
  number = '%3d' % code
  "#{@bg}#{code}m #{number}#{@rs}#{@fg}#{code}m #{number}#{@rs} "
end

256.times do |n|
  print color(n)
  print "\n" if (n + 1).modulo(8).zero?
end
print "\n"
EOF
	)
	ruby -e "$PROGRAM"
}

# required: gdrive
function gsync() {
	local ID=$1
	[[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
	[[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'"
	echo "ID:$ID"
	echo "# downloading..."
	gdrive sync download $ID .
	echo "# uploading..."
	gdrive sync upload . $ID
}

# [Vimの生産性を高める12の方法 \| POSTD]( https://postd.cc/how-to-boost-your-vim-productivity/ )
# Ctrl-Zを使ってVimにスイッチバックする
# vim -> C-z -> zsh -> Ctrl-z or fg
fancy-ctrl-z() {
	if [[ $#BUFFER -eq 0 ]]; then
		BUFFER="fg"
		zle accept-line
	else
		zle push-input
		zle clear-screen
	fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

if [[ -s "${ZDOTDIR:-$HOME}/.local.zshrc" ]]; then
	source "${ZDOTDIR:-$HOME}/.local.zshrc"
fi

# [~/.bashrcは何も出力してはいけない（するならエラー出力に） - None is None is None]( http://doloopwhile.hatenablog.com/entry/2014/11/04/124725 )
ls -G >&2

# ---- bash ----
# ---- zsh ----

setopt clobber
SAVEHIST=100000
[[ -x $(which direnv) ]] && eval "$(direnv hook zsh)"

if [[ $ZSH_NAME == zsh ]]; then
	# [zshの個人的に便利だと思った機能（suffix alias、略語展開） - Qiita]( http://qiita.com/matsu_chara/items/8372616f52934c657214 )
	alias -s txt='cat'
	alias -s rb='ruby'
	alias -s py='python'
	alias -s php='php -f'
	alias -s gp='gnuplot'
	alias -s {gz,tar,zip,rar,7z}='unarchive' # preztoのarchiveモジュールのコマンド(https://github.com/sorin-ionescu/prezto/tree/master/modules)

	# option for completion
	setopt magic_equal_subst              # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
	setopt GLOB_DOTS                      # 明確なドットの指定なしで.から始まるファイルをマッチ
	zstyle ':completion:*' use-cache true # apt-getとかdpkgコマンドをキャッシュを使って速くする
	setopt list_packed                    # 保管結果をできるだけ詰める
fi

# git://の方ではproxyの設定が反映されないので，https://形式の方が無難
zshdir=~/.zsh
[[ ! -e $zshdir ]] && mkdir -p $zshdir
[[ ! -e $zshdir/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions $zshdir/zsh-completions
fpath=($zshdir/zsh-completions/src $fpath)
[[ ! -e $zshdir/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions $zshdir/zsh-autosuggestions
source $zshdir/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ ! -e $zshdir/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search $zshdir/zsh-history-substring-search
source $zshdir/zsh-history-substring-search/zsh-history-substring-search.zsh

## [[zsh]改行のない行が無視されてしまうのはzshの仕様だった件 · DQNEO起業日記]( http://dqn.sakusakutto.jp/2012/08/zsh_unsetopt_promptcr_zshrc.html )
## preztoや他のライブラリとの兼ね合いで効かなくなるので注意(次のzsh command hookで対応)
#unsetopt promptcr
## [シェルでコマンドの実行前後をフックする - Hibariya]( http://note.hibariya.org/articles/20170219/shell-postexec.html )
#autoload -Uz add-zsh-hook
#add-zsh-hook preexec my_preexec
#add-zsh-hook precmd my_precmd
