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

funccheck() { declare -f "$1" >/dev/null; }
cmdcheck() { type "$1" >/dev/null 2>&1; }
alias_if_exist() {
	local tmp="${@:3:($# - 2)}"
	[[ -e "$2" ]] && alias $1=\'"$2"\'" $tmp"
}
exportf funccheck
exportf cmdcheck
exportf alias_if_exist

# [iandeth. - bashにて複数端末間でコマンド履歴(history)を共有する方法]( http://iandeth.dyndns.org/mt/ian/archives/000651.html )
share_history() {
	history -a
	history -c
	history -r
}
if [[ -n $BASH ]]; then
	PROMPT_COMMAND='share_history'
	shopt -u histappend
else
	unset share_history
fi

################
####  Mac   ####
################
# ls
alias ls='ls -G'
alias lat='ls -altG'
alias lsat='ls -altG'
alias lsal='ls -alG'
alias lsalt='ls -altG'
alias h='history'
alias hgrep='h | grep'
alias type='type -af'
# cd
alias dl='cd ~/Downloads/'
alias desktop='cd ~/Desktop/'
alias ds='cd ~/Desktop/'
if [[ -n $_Darwin ]]; then
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

	# history
	alias history='history 1'

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
	if cmdcheck xsel; then
		alias pbcopy='xsel --clipboard --input'
		alias pbpaste='xsel --clipboard --output'
	fi
	alias gsed='sed'
fi

# http servers
alias ascii='man ascii'
alias httpserver='httpserver.python2'
alias httpserver.python2='python -m SimpleHTTPServer'
alias httpserver.python3='python3 -m http.server'
alias httpserver.ruby='ruby -run -e httpd . -p 8000'
alias httpserver.php='php -S localhost:3000'

alias qq='exit'
alias q!='exit'

# NOTE:googler
# NOTE:peco
alias g='googler -n 5'
alias viminfogrep="egrep '^>' ~/.viminfo | cut -c3- | perl -E 'say for map { chomp; \$_ =~ s/^~/\$ENV{HOME}/e; -f \$_ ? \$_ : () } <STDIN>'"
if cmdcheck peco; then
	# peco copy
	alias pc='peco | c'
	alias pecopy='peco | c'
	alias pe='peco'
	alias hpeco='history | peco | c'
	# [最近 vim で編集したファイルを、peco で選択して開く \- Qiita]( https://qiita.com/Cside/items/9bf50b3186cfbe893b57 )
	alias rvim="viminfogrep | peco | tee $(tty) | xargs -o vim"
	# 選択したファイルが存在する場合にはそのディレクトリを取得し，'/'を加える
	# 存在しない場合には空白となる
	# 最終的に'./'を加えても動作は変更されない
	alias rvcd="cd \$(viminfogrep | peco | sed 's:/[^/]*$::g' | sed 's:$:/:g')./"
	# TODO: duplicate dirs
	alias rcd="cd \$(cat ~/.cdinfo | peco | sed 's:$:/:g')./"
	# [git ls\-tree]( https://qiita.com/sasaplus1/items/cff8d5674e0ad6c26aa9 )
	alias gcd='cd "$(git ls-tree -dr --name-only --full-name --full-tree HEAD | sed -e "s|^|`git rev-parse --show-toplevel`/|" | peco)"'
fi
alias rvgrep="viminfogrep | xargs-grep"

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
	function dlogin() {
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
fi

# n秒後に通知する
function timer() { echo "required:terminal-notifier"; }
cmdcheck terminal-notifier && function timer() {
	[[ $# -le 1 ]] && echo "$0 [sleep-second] [message]" && return 1
	sleep $1 && terminal-notifier -sound Basso -message $2
}

# cmd alias
cmdcheck vim && alias vi='vim'
# 行番号指定で開く
function vim() {
	if [[ $# == 1 ]] && [[ $1 =~ : ]]; then
		local file_path="${1%%:*}"
		local line_no=$(echo "$1" | cut -d":" -f2)
		# "" => 0
		line_no=$((line_no))
		command vim -c $line_no $file_path
		return $?
	fi
	command vim $@
}

alias dotfiles='cd ~/dotfiles'

alias v='vim'
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
cmdcheck ccat && alias cat='ccat'

# for mac
cmdcheck gsed && alias sed='gsed'
alias grep='grep --color=auto'
cmdcheck ggrep && alias grep='ggrep --color=auto'
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

# [chpwd内のlsでファイル数が多い場合に省略表示する - Qiita]( https://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059 )
chpwd() {
	ls
	echo $PWD >>"$HOME/.cdinfo"
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
	xargs -n 1 -IXXX find XXX -exec $grep_cmd --color=auto -H -n ${keyword[@]} {} +
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
alias fg.py='fgrep "*.py" $@'
alias fg.sh='fgrep "*.sh" $@'
alias fg.cpp='fgrep "*.c[px][px]" $@'
alias fg.hpp='fgrep2 "*.h" "*.hpp" $@'
alias fg.c='fgrep "*.c" $@'
alias fg.h='fgrep "*.h" $@'
alias fg.ch='fgrep "*.[ch]" $@'
alias fg.cpp-all='fgrep2 "*.c[px][px]" "*.[ch]" $@'

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

# [zshの個人的に便利だと思った機能（suffix alias、略語展開） - Qiita]( http://qiita.com/matsu_chara/items/8372616f52934c657214 )
alias -s txt='cat'
alias -s rb='ruby'
alias -s py='python'
alias -s php='php -f'
alias -s gp='gnuplot'
alias -s {gz,tar,zip,rar,7z}='unarchive' # preztoのarchiveモジュールのコマンド(https://github.com/sorin-ionescu/prezto/tree/master/modules)

#  if [[ -n $_Darwin ]]; then
# 	# brew install zsh-autosuggestions zsh-history-substring-search zsh-git-prompt zsh-completions
# 	source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# 	source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# # 	# 	source /usr/local/opt/zsh-git-prompt/zshrc.sh
# 	fpath=(/usr/local/share/zsh-completions $fpath)
# fi
# if [[ -n $_Ubuntu ]]; then
zshdir=~/.zsh
[[ ! -e $zshdir ]] && mkdir -p $zshdir
[[ ! -e $zshdir/zsh-completions ]] && git clone git://github.com/zsh-users/zsh-completions.git $zshdir/zsh-completions
fpath=($zshdir/zsh-completions/src $fpath)
[[ ! -e $zshdir/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions $zshdir/zsh-autosuggestions
source $zshdir/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ ! -e $zshdir/zsh-history-substring-search ]] && git clone https://github.com/zsh-users/zsh-history-substring-search $zshdir/zsh-history-substring-search
source $zshdir/zsh-history-substring-search/zsh-history-substring-search.zsh
# fi

## [[zsh]改行のない行が無視されてしまうのはzshの仕様だった件 · DQNEO起業日記]( http://dqn.sakusakutto.jp/2012/08/zsh_unsetopt_promptcr_zshrc.html )
## preztoや他のライブラリとの兼ね合いで効かなくなるので注意(次のzsh command hookで対応)
#unsetopt promptcr
## [シェルでコマンドの実行前後をフックする - Hibariya]( http://note.hibariya.org/articles/20170219/shell-postexec.html )
#autoload -Uz add-zsh-hook
#add-zsh-hook preexec my_preexec
#add-zsh-hook precmd my_precmd
