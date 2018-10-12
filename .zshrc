# HINT: if you want to calclate login time uncomment next line
# DEBUG_MODE='ON'
[[ -n $DEBUG_MODE ]] && zmodload zsh/zprof && zprof

# NOTE: 現在のwindowsのmy settingではログインシェルの変更に不具合があるため(bash経由でzshを呼び出しているため，zshrcからzprofileを呼ぶ必要がある)
if [[ $OS == Windows_NT ]]; then
	test -r ~/.zprofile && source ~/.zprofile
fi

# auto compile
# NOTE: 関数内のalias展開に影響するため，compile前後の動作を確かめる必要がある
# -nt: file1 is newer than file2? (used modified time)
# zsh_compile_files=(~/.zshrc ~/.zprofile ~/.zlogin ~/.zlogout $(ls ~/.zsh/.*.zshrc) $(ls ~/.zsh/*/*.zsh))
# for src in "${zsh_compile_files[@]}"; do
# 	[[ -e $src ]] && ([[ ! -e $src.zwc ]] || [[ ${src} -nt $src.zwc ]]) && zcompile $src
# done

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
else
	# NOTE: install zprezto
	git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
	echo "${BLUE}[HINT]${DEFAULT} exec /bin/zsh -l"
fi

# default 10000?
export HISTSIZE=100000

# Customize to your needs...
# ---- bash ----
# set -x #for debug

_NO_CMD=''
function doctor() {
	[[ -z _NO_CMD ]] && echo "You are be in good health!" && return
	echo "# These commands are missing..."
	echo $_NO_CMD | sed 's/^://' | tr ':' '\n' | sort | uniq
}
function funccheck() { declare -f "$1" >/dev/null; }
function cmdcheck() {
	[[ $# == 0 ]] && echo "$0 <cmd>" && return
	type "$1" >/dev/null 2>&1
	local code=$?
	[[ $code != 0 ]] && _NO_CMD="$_NO_CMD:$1"
	return $code
}
function alias_if_exist() {
	local tmp="${@:3:($# - 2)}"
	[[ -e "$2" ]] && alias $1=\'"$2"\'" $tmp"
}
function traverse_path_list() {
	local dirpath=$(perl -MCwd -e 'print Cwd::abs_path shift' ${1:-$PWD})
	while true; do
		echo $dirpath
		[[ "$dirpath" == "/" ]] && break
		local dirpath="$(dirname $dirpath)"
	done
}

function source() {
	local pwd_tmp=$(alias pwd)
	alias pwd >/dev/null 2>&1 && unalias pwd
	builtin source "$@"
	local exit_code=$?
	[[ -n $pwd_tmp ]] && eval alias $pwd_tmp
	return $exit_code
}

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
# [[ $ZSH_NAME == zsh ]] && alias -s {sh,bash}='env "${_export_funcs[@]}" bash'
# ----------------

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
fi
if [[ $ZSH_NAME == zsh ]]; then
	# NOTE: how to check
	# setopt | grep 'xxx'

	# history
	setopt hist_ignore_dups
	# 	unset share_history
	# シェルのプロセスごとに履歴を共有
	setopt share_history

	# NOTE: these options are enabled
	## 補完候補を一覧表示
	# 	setopt auto_list
	## =command を command のパス名に展開する
	# 	setopt equals
	## --prefix=/usr などの = 以降も補完
	# 	setopt magic_equal_subst
fi

# ----
# NOTE: source bellow file to unalias git commands
[[ -e ~/.zsh/.git.zshrc ]] && source ~/.zsh/.git.zshrc
# ----

cmdcheck tac || alias tac='tail -r'

# ls
[[ $(uname) == "Darwin" ]] && alias ls='ls -G'
[[ $(uname) == "Linux" ]] && alias ls='ls --color=auto'

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

# NOTE: -o nolookups: speedup
cmdcheck ccze && alias ccze='ccze -A -o nolookups'

# delete all file without starting . prefix at 'build' dir
cmdcheck 'cmake' && function cmake-clean() {
	[[ ! $(basename $PWD) =~ ^build ]] && echo "cwd is not cmake build dir '^build'" && return 1
	find . -maxdepth 1 -not -name '.*' -exec rm -r {} +
}

alias basedirname='basename $PWD'

alias find-time-sort='find . -not -iwholename "*/.git/*" -type f -print0 | xargs -0 ls -altr'
alias find-time-sortr='find . -not -iwholename "*/.git/*" -type f -print0 | xargs -0 ls -alt'
alias find-dotfiles='find . -name ".*" -not -name ".git" | sed "s:\./\|^\.$::g" | grep .'

alias find-orig-files="find . -name '*.orig'"
alias find-orig-files-and-delete="find . -name '*.orig' -delete"

# [ソートしないで重複行を削除する]( https://qiita.com/arcizan/items/9cf19cd982fa65f87546 )
alias uniq-without-sort='awk "!a[\$0]++"'

alias vars='declare -p'

# cd
alias ho='\cd ~'
alias home='\cd ~'
alias dl='cd ~/Downloads/'
alias downloads='cd ~/Downloads/'
alias desktop='cd ~/Desktop/'

[[ -d ~/local/bin ]] && alias local-bin='cd ~/local/bin'
[[ -d ~/github.com ]] && alias github='cd ~/github.com'
[[ -d ~/chrome-extension ]] && alias chrome-extension='cd ~/chrome-extension'
[[ -d ~/gshare ]] && alias gshare='cd ~/gshare' && alias vigshare='tabvim ~/gshare/*.md' && alias vimshare='vishare'
[[ -d ~/.config ]] && alias config='cd ~/.config'

[[ -d ~/dotfiles/.config/gofix ]] && alias gofixdict='cd ~/dotfiles/.config/gofix'
[[ -d ~/dotfiles/.git_template/hooks ]] && alias githooks='cd ~/dotfiles/.git_template/hooks'
[[ -d ~/dotfiles/cheatsheets ]] && alias cheatsheets='cd ~/dotfiles/cheatsheets'
[[ -d ~/dotfiles/neosnippet ]] && alias neosnippet='cd ~/dotfiles/neosnippet'
[[ -d ~/dotfiles/snippets ]] && alias snippetes='cd ~/dotfiles/snippets'
[[ -d ~/dotfiles/template ]] && alias template='cd ~/dotfiles/template'

[[ -e ~/dotfiles/snippets/snippet.txt ]] && alias visnippetes='vim ~/dotfiles/snippets/snippet.txt'
[[ -e ~/dotfiles/.gitconfig ]] && alias vigc='vim ~/dotfiles/.gitconfig' && alias vimgc='vigc'

[[ -e ~/dotfiles/.git.zshrc ]] && alias vigitrc='vim ~/dotfiles/.git.zshrc' && alias vimgitrc='vigitrc'
[[ -e ~/dotfiles/.zplug.zshrc ]] && alias vizplugrc='vim ~/dotfiles/.zplug.zshrc' && alias vimzplugrc='vizplugrc'
[[ -e ~/dotfiles/.zbindkey.zshrc ]] && alias vizbindkeyrc='vim ~/dotfiles/.zbindkey.zshrc' && alias vimzbindkeyrc='vizbindkeyrc'

[[ -e ~/.gitignore ]] && alias vigi='vim ~/.gitignore'
[[ -e ~/.gitignore ]] && alias vimgi='vim ~/.gitignore'

[[ $(uname) == "Darwin" ]] && alias vim-files='pgrep -alf vim | grep "^[0-9]* [n]vim"'
[[ $(uname) == "Linux" ]] && alias vim-files='pgrep -al vim'

alias vp='cdvproot'
alias vpr='cdvproot'
alias vproot='cdvproot'
alias cdv='cdvproot'
alias cdvp='cdvproot'
alias cdvproot='cd $VIM_PROJECT_ROOT'

alias cpp-system-include-path="echo | CPATH='' clang -x c++ -v -fsyntax-only - |& grep '^ /' | sed 's:^ ::g'"

alias mk='mkcd'
function mkcd() {
	if [ ! -n "$1" ]; then
		echo "Enter a directory name"
	elif [ -d $1 ]; then
		echo "'$1' already exists"
	else
		mkdir -p $1 && cd $1
	fi
}

alias clear-by-ANSI='echo -n "\x1b[2J\x1b[1;1H"'
alias fix-terminal='stty sane'
alias clear-terminal='stty sane'

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

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# history
alias history='history 1'
function history_ranking() {
	builtin history -n 1 | grep -e "^[^#]" | awk '{ print $1 }' | sort | uniq -c | sort
}
alias h='history'
alias hgrep='h | grep'
alias envgrep='env | grep'

# 年号コマンド
# name of an era; year number
#date | awk '{print "H"$6-2000+12}'
alias era='echo H$(($(date +"%y") + 12))'

# exit
alias q!='exit'
alias qq='exit'
alias :q='exit'
alias :q!='exit'
alias qqq='exit'
alias qqqq='exit'
alias quit='exit'

alias type='type -af'
################
####  Mac   ####
################
if [[ $(uname) == "Darwin" ]]; then
	# cmds
	alias_if_exist airport '/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
	alias sysinfo='system_profiler SPSoftwareDataType'
	alias js='osascript -l JavaScript'
	alias_if_exist jsc '/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
	alias_if_exist vmrun '/Applications/VMware Fusion.app/Contents/Library/vmrun'
	# 	alias_if_exist subl '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'

	# browser
	alias safari='open -a /Applications/Safari.app'
	alias firefox='open -a /Applications/Firefox.app'
	alias chrome='open -a /Applications/Google\ Chrome.app'

	# image
	# 	alias imgshow='qlmanage -p "$@" >& /dev/null'
	alias imgsize="mdls -name kMDItemPixelWidth -name kMDItemPixelHeight"

	# [osx - Concisely starting Mac OS apps from the command line - Ask Different](http://apple.stackexchange.com/questions/4240/concisely-starting-mac-os-apps-from-the-command-line)
	# alias skim='open -a Skim'

	# brew
	alias cellar='cd /usr/local/Cellar'

	# base64
	alias b64e='base64'
	alias b64d='base64 -D'
	# [UTF-8-MACをUTF-8に変換する - Qiita]( http://qiita.com/youcune/items/badaec55af6bbae9aca8 )
	alias mactext='p | nkf -w --ic=utf8-mac | c'
	# [MacOSXでstraceが欲しいけどdtrace意味わからん→dtruss使おう]( https://qiita.com/hnw/items/269f8eb44614556bd6bf )
	alias strace='sudo dtruss -f sudo -u $(id -u -n)'

	function code() {
		VSCODE_CWD="$PWD"
		open -n -b "com.microsoft.VSCode" --args $*
	}
fi

if cmdcheck mvim; then
	alias gvim='mvim'
	alias mvim='mvim --remote-tab-silent'
	function mvim() {
		[[ $# == 1 ]] && [[ $1 == "--remote-tab-silent" ]] && $(command which mvim) && return $?
		$(command which mvim) $@
	}
fi

################
#### Ubuntu ####
################
if [[ $(uname) == "Linux" ]]; then
	if cmdcheck xclip; then
		alias pbcopy='xclip -sel clip'
		alias pbpaste='xclip -o -sel clip'
	elif cmdcheck xsel; then
		alias pbcopy='xsel --clipboard --input'
		alias pbpaste='xsel --clipboard --output'
	fi
	# 	alias gsed='sed'
	alias open='xdg-open &>/dev/null'

	alias apt-upgrade='sudo apt-get upgrade'
	alias apt-update='sudo apt-get update'
	alias apt-install='sudo apt-get install'
	alias apt-search='apt-cache search'
	alias apt-show='apt-cache show'
	# [How can I get a list of all repositories and PPAs from the command line into an install script? \- Ask Ubuntu]( https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an )
	alias add-apt-repository-list="grep -r --include '*.list' '^deb ' /etc/apt/ | sed -re 's/^\/etc\/apt\/sources\.list((\.d\/)?|(:)?)//' -e 's/(.*\.list):/\[\1\] /' -e 's/deb http:\/\/ppa.launchpad.net\/(.*?)\/ubuntu .*/ppa:\1/'"
	alias dpkg-list='sudo dpkg -l'
	function dpkg-executable-list() {
		[[ $# == 0 ]] && echo '<package name>' && return 1
		dpkg -L $1 | executable_filter
	}

	function xdotool-infos() {
		[[ $# == 0 ]] && echo "$0 <class>" && return 1
		xdotool search --class "$1" | xargs -L 1 sh -c 'printf "# $0"; xwininfo -id $0'
	}

	alias os_ver='cat /etc/os-release | grep VERSION_ID | grep -o "[0-9.]*"'

	# [How can I get a list of all repositories and PPAs from the command line into an install script? \- Ask Ubuntu]( https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an )
	function ppa-list() {
		# listppa Script to get all the PPA installed on a system ready to share for reininstall
		for APT in $(find /etc/apt/ -name \*.list); do
			grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" $APT | while read ENTRY; do
				USER=$(echo $ENTRY | cut -d/ -f4)
				PPA=$(echo $ENTRY | cut -d/ -f5)
				echo sudo apt-add-repository ppa:$USER/$PPA
			done
		done
	}
fi

function pipe-EOF-do() {
	local v=$(cat)
	echo $v | ${@}
}

alias kaiba='echo "ヽ(*ﾟдﾟ)ノ"'
alias gopher='echo "ʕ ◔ ϖ ◔ ʔ"'

# window path -> unix path
alias w2upath='sed "s:\\\:/:g"'
alias w2p='p|w2upath|c'

alias relogin='exec $SHELL -l'

alias trimspace='sed "s/^[ \t]*//"'

# add ast prefix
alias add-ast="'sed 's/\(^\|\s*\)/\1* /g'"

alias filter-exist-line="awk '/.+/{print "'$0'"}'"

function sed-range() {
	[[ $# < 3 ]] && echo "$0 filepath start-line-no end-line-no" && return
	name=$1
	start=$2
	end=$3
	cat -n $name | sed -n ${start},${end}p
}

# NOTE: 普通に出力するとゴミデータ?が混じっている
function mancat() {
	# 	MANPAGER="sed \"s/.$(echo \"\\x08\")//g\"" man "$@"
	MANPAGER="col -b -x" man "$@"
}

alias ascii='man ascii'
# http servers
alias httpserver='httpserver.python2'
alias httpserver.python2='python -m SimpleHTTPServer'
alias httpserver.python3='python3 -m http.server'
alias httpserver.ruby='ruby -run -e httpd . -p 8000'
alias httpserver.php='php -S localhost:3000'

executable_filter() {
	while read line; do
		[[ -x $line ]] && echo $line
	done
}
readable_filter() {
	while read line; do
		[[ -r $line ]] && echo $line
	done
}
writable_filter() {
	while read line; do
		[[ -w $line ]] && echo $line
	done
}

if cmdcheck pandoc; then
	function html2md-pandoc() {
		[[ $# == 0 ]] && echo "$0 <input file> [<output file>]" && return 1
		local input=$1
		local output=$2
		[[ $output == "" ]] && local output=${input%.*}.html
		pandoc -s "$input" -t html5 -c github.css -o "$output"
	}
fi

#       sudo ansi-color          search_algo
# fzf:  NG   OK                  NG(for me)
# peco: OK   NG                  OK
# fzy:  OK   Input OK, Output NG OK
# 結論として，fzyの出力からansiコードを取り除いた場合が最適解?

# alias pvim="xargs -L 1 -IXXX sh -c 'vim \$1 < /dev/tty' - 'XXX'"
alias view='vim -R'
alias pipevim='vim -'
# alias g='googler -n 5'
alias xargs-vim='_xargs-vim -'
# alias viminfo-ls="egrep '^>' ~/.viminfo | cut -c3- | perl -E 'say for map { chomp; \$_ =~ s/^~/\$ENV{HOME}/e; -f \$_ ? \$_ : () } <STDIN>'"
alias viminfo-ls="cat ~/.vim_edit_log | grep -v '^$' | awk '!a[\$0]++' | tac"
alias viminfo-ls-edit='vim ~/.vim_edit_log'

alias rvgrep="viminfo-ls | xargs-grep"

alias ls-non-dotfiles="find . -name '*' -maxdepth 1 | sed 's:^\./::g' | grep -E -v '\..*'"

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
# for GNU
# alias which-all="echo $PATH | sed 's/:/\n/g' | xargs -J % find % -executable -type f -maxdepth 1"
# for BSD
alias which-all="echo $PATH | sed 's/:/\n/g' | xargs -J % find % -type f -perm +111 -maxdepth 1"

# awk
# n~m列のみを表示(省略時には先頭または最後となる)
function cut2() {
	[[ $# == 0 ]] && echo "cut2 [START_FIELD_INDEX] (END_FIELD_INDEX)" && return 1
	local START=${1:-1}
	local END=${2:-NF}
	awk '{for(i='"$START"';i<='"$END"';i++){printf("%s", $i);if(i<'"$END"')printf(" ");} print ""}'
}
exportf cut2

function ping-web() {
	[[ $# -le 1 ]] && echo "$0 <url>" && exit 1
	local url="$1"
	while true; do
		status=$(curl -sL --head -m 3 -w "%{http_code}" "$url" -o /dev/null)
		if [ $status = 200 ]; then
			printf '.'
		else
			printf 'F'
		fi
		sleep 0.5
	done
}

# for python(3.3~) venv activation
cmdcheck python && alias activate='source bin/activate' # <-> deactivate
cmdcheck ninja && alias ncn='ninja -t clean && ninja'

cmdcheck ipython && function python() {
	if [[ $# == 0 ]]; then
		ipython
	else
		command python "$@"
	fi
}

# rtags daemon start
cmdcheck rdm && alias rdmd='pgrep rdm || rdm --daemon'

if cmdcheck docker; then
	alias docker-remove-all-container='docker rm $(docker ps -aq)'
	alias docker-remove-image='docker images | peco | awk "{print \$3}" | pipecheck xargs -L 1 docker rmi'
	alias docker-stop='docker ps | peco | awk "{print \$1}" | pipecheck xargs -L 1 docker stop'
	alias docker-stop-all='docker stop $(docker ps -aq)'
	alias docker-start='docker ps -a | peco | awk "{print \$1}" | pipecheck xargs -L 1 docker start'
	# to avoid 'the input device is not a TTY'
	function docker-attach() {
		local container_id=$(docker ps | peco | awk '{print $1}')
		[[ -n $container_id ]] && docker attach $container_id
	}
	function docker-exec() {
		# NOTE: sudo su with '-' cause "Session terminated, terminating shell..." message when C-c is pressed ... why?
		# local login_shell="env zsh || env bash"
		# NOTE: sudo suを行わない場合と比較してLANGの設定が変化する(sudo suのみでは~/.zprofileは実行されていないっぽい)
		# local login_shell='type sudo >/dev/null 2>&1 && exec sudo su $(whoami) || type zsh >/dev/null 2>&1 && exec zsh -l || type bash >/dev/null 2>&1 && exec bash -l'
		local login_shell='type zsh >/dev/null 2>&1 && exec zsh -l || type bash >/dev/null 2>&1 && exec bash -l'
		[[ $1 == '--bash' ]] && local login_shell='exec bash -l'

		local container_id=$(docker ps | peco | awk '{print $1}')
		local val=$(stty size)
		local rows=$(echo $val | cut -d ' ' -f 1)
		local cols=$(echo $val | cut -d ' ' -f 2)
		[[ -z $container_id ]] && return

		echo "${YELLOW}[HINT]${DEFAULT}[relogin command]:"' sudo su $(whoami)'
		docker exec -it $container_id /bin/bash -c "stty rows $rows cols $cols; eval '$login_shell'"
	}
	function docker-start-and-attach() {
		local container_id=$(docker ps -a | peco | awk '{print $1}')
		[[ -n $container_id ]] && docker start $container_id && docker attach $container_id
	}
	function docker-remove-container() {
		local container_id=$(docker ps -a | peco | awk '{print $1}')
		[[ -n $container_id ]] && docker rm $container_id
	}
	function docker-container-id() {
		local ret=$(docker ps | peco | awk '{print $1}')
		[[ -n $ret ]] && CONTAINER_ID="$ret" && echo "\$CONTAINER_ID=$CONTAINER_ID"
	}
	alias de='docker-exec'
	alias dexec='docker-exec'
	alias da='docker-attach'
	alias dattach='docker-attach'
	alias ds='docker-start'
	alias dsa='docker-start-and-attach'
	alias dls='docker ps'
	alias dlsa='docker ps -a'
	alias did='docker-container-id'
fi
if [[ -f /.dockerenv ]]; then
	# NOTE: to avoid 表示の乱れ (don't use sorin)
	prompt kylewest
	function check_last_exit_code() {
		local LAST_EXIT_CODE=$?
		if [[ $LAST_EXIT_CODE -ne 0 ]]; then
			local EXIT_CODE_PROMPT=' '
			EXIT_CODE_PROMPT+="%F{166}$LAST_EXIT_CODE"
			echo "$EXIT_CODE_PROMPT"
		fi
	}
	RPROMPT='$(check_last_exit_code)'
	PS1='(docker) %F{135}%n%f %F{118}%~%f ${git_info:+${(e)git_info[prompt]}}$ '
	[[ $LC_CTYPE == "ja_JP.UTF-8" ]] && PS1='🐳 %F{135}%n%f %F{118}%~%f ${git_info:+${(e)git_info[prompt]}}$ '
fi

if cmdcheck tmux; then
	function tmux-attach() {
		if [ -n "$TMUX" ]; then
			echo 'Do not use this command in a tmux session.'
			return 1
		fi
		local output=$(tmux ls)
		[[ -z $output ]] && return 1
		local tag_id=$(echo $output | peco | cut -d : -f 1)
		[[ -n $tag_id ]] && tmux a -t $tag_id
	}
	# [Tmux のセッション名を楽に変えて楽に管理する \- Qiita]( https://qiita.com/s4kr4/items/b6ad512ea9160fc8e90e )
	function tmux-rename-session() {
		if [ $# -lt 1 ]; then
			git status >/dev/null 2>&1
			if [ $? -eq 0 ]; then
				local name=$(basename $(git rev-parse --show-toplevel))
			else
				local name=$(basename $(pwd))
			fi
		else
			local name=$1
		fi
		tmux rename-session ${name//./_}
	}
fi

# NOTE: to avoid xargs no args error on ubuntu
# [xargs で標準入力が空だったら何もしない \- Qiita]( https://qiita.com/m_doi/items/432b9145b69a0ba3132d )
# --no-run-if-empty: macでは使用不可
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
cmdcheck nvim && alias vterminal="command nvim -c terminal -c \"call feedkeys('i','n')\""
cmdcheck nvim && alias vt='vterminal'
# NOTE: 行番号指定で開く
function vim() {
	local vim_cmd='command vim'
	cmdcheck nvim && vim_cmd='nvim'
	if [[ $# -ge 1 ]] && [[ $1 =~ : ]]; then
		local file_path="${1%%:*}"
		local line_no=$(echo "$1" | cut -d":" -f2)
		# "" => 0
		line_no=$((line_no))
		shift
		# 		eval $vim_cmd -c $line_no $file_path $@
		# -c: do command
		local cmd="$vim_cmd -c $line_no $file_path $@"
	else
		# 		eval $vim_cmd $@
		local cmd="$vim_cmd $@"
	fi
	eval $cmd
	local code=$?
	# NOTE: nvim crash with changing window size
	# ### window size change crash
	# [tui\_flush: Assertion \`r\.bot < grid\->height && r\.right < grid\->width' failed\. Core dumped · Issue \#8774 · neovim/neovim · GitHub]( https://github.com/neovim/neovim/issues/8774 )
	# [\[RFC\] tui: clip invalid regions on resize by bfredl · Pull Request \#8779 · neovim/neovim · GitHub]( https://github.com/neovim/neovim/pull/8779 )
	# [Releases  neovim/neovim  GitHub]( https://github.com/neovim/neovim/releases )
	# nvim v0.3.2-dev 5f15788ですでにmerge済み
	# ```
	# wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -O ~/local/bin/nvim && chmod u+x ~/local/bin/nvim
	# ```
	# 	[[ $code == 134 ]] && fix-terminal && echo "nvim crash: $cmd"
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

alias minvi='vim -u ~/dotfiles/.minimal.vimrc'
alias minvim='vim -u ~/dotfiles/.minimal.vimrc'
alias minivi='vim -u ~/dotfiles/.minimal.vimrc'
alias minivim='vim -u ~/dotfiles/.minimal.vimrc'

alias dot='cd ~/dotfiles'
alias dotfiles='cd ~/dotfiles'
alias plugged='cd ~/.vim/plugged'

alias v='vim'
# don't use .viminfo file option
# alias tvim='vim -c "set viminfo="'
alias tvim='vim -i NONE'
alias tmpvim='vim -i NONE'
alias tempvim='vim -i NONE'
alias tabvim='vim -p'
alias fastvim='VIM_FAST_MODE=on vim'
alias virc='vim ~/.vimrc'
alias vimrc='vim ~/.vimrc'
alias viminfo='vim ~/.viminfo'
alias vimpluginstall="VIM_FAST_MODE='off' vim -c ':PlugInstall' ''"
alias vimplugupdate="VIM_FAST_MODE='off' vim -c ':PlugUpdate' ''"
alias vimplugupgrade="VIM_FAST_MODE='off' vim -c ':PlugUpgrade' ''"
alias vimpi="vim -c ':PlugInstall' ''"
alias vimpud="vim -c ':PlugUpdate' ''"
alias vimpug="vim -c ':PlugUpgrade' ''"

alias vimr='vim README.md'
alias vimre='vim README.md'
alias vimR='vim README.md'
alias vimRe='vim README.md'

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
alias lzshrc='vim ~/.local.zshrc'
alias zshenv='vim ~/.zshenv'
alias lzshenv='vim ~/.local.zshenv'
alias vizrc='vim ~/.zshrc'
alias vimzrc='vim ~/.zshrc'
alias vizp='vim ~/.zprofile'
alias vimzp='vim ~/.zprofile'
alias zp='vim ~/.zprofile'
alias zrc='vim ~/.zshrc'
alias lzp='[[ -f ~/.local.zprofile ]] && vim ~/.local.zprofile'
alias lzrc='[[ -f ~/.local.zshrc ]] && vim ~/.local.zshrc'
alias lvrc='[[ -f .local.vimrc ]] && vim .local.vimrc || [[ -f ~/.local.vimrc ]] && vim ~/.local.vimrc'

alias vimemo='vim README.md'
alias vmemo='vim README.md'
alias vm='vim README.md'

alias allow='direnv allow'

alias envrc='vim .envrc'
alias vm='vim README.md'

# for ssh
alias vissh='vim ~/.ssh/config'
alias vimssh='vim ~/.ssh/config'
alias sshconfig='vim ~/.ssh/config'

# FYI: there is similar command `ssh-copy-id`
function ssh-register_id_rsa.pub() {
	[[ $# -le 1 ]] && echo "$0 <id_rsa.pub filepath> <ssh host name>" && return 1
	local id_rsa_pub_filepath="$1"
	local ssh_host_name="$2"
	cat "$id_rsa_pub_filepath" | ssh "$ssh_host_name" 'mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && cat >> ~/.ssh/authorized_keys'
}

# show path each line
alias path='echo $PATH | sed "s/:/\n/g"'
alias cpath='echo $CPATH | sed "s/:/\n/g"'
# NOTE: zsh var
alias fpath='echo $fpath | tr " " "\n"'

# 指定したディレクトリに存在する実行可能なファイルを列挙する
function cmds() {
	[[ $# -ne 1 ]] && echo "# Usage: $0 \"dir path\"" && return 1
	# 再帰なし
	# -type f とするとシンボリックリンクのファイルを無視してしまうので-followを付加
	find $1 -maxdepth 1 -type f -follow -perm -=+x
}
alias lscmds='allcmds'
function allcmds() {
	for name in $(echo $PATH | sed "s/:/\n/g"); do
		echo $name
		find $name -maxdepth 1 -type f -follow -perm -=+x
	done
	alias
	functions-list
}
alias functions-list='functions | grep "() {" | grep -v -E "^\s+" | grep -v -E "^_" | sed "s/() {//g"'

# get abs path
# [bash で ファイルの絶対パスを得る - Qiita](http://qiita.com/katoy/items/c0d9ff8aff59efa8fcbb)
function abspath() {
	if [[ $(uname) == "Darwin" ]]; then
		local _home=$(echo $HOME | sed "s/\//\\\\\//g")
		local abspathdir=$(sh -c "cd $(dirname $1) && pwd | sed \"s/$_home/~/\"")
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
	sed 's/'"$delim"'/\|/g' | awk '{print "|"$0"|"}'
}

# show user home dir. as `~`
_home=$(echo $HOME | sed "s/\//\\\\\//g")
alias pwd="pwd | sed \"s/$_home/~/\""
unset _home

# `$`付きコマンドでも実行可能に(bashではinvalid)
[[ $ZSH_NAME == zsh ]] && alias \$=''
# ignore command which starts with `#`
alias \#='echo "skip comment: "'

# brew install source-highlight
cmdcheck src-hilite-lesspipe.sh && alias hless="src-hilite-lesspipe.sh"
# ubuntu
[[ -e "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]] && alias hless="/usr/share/source-highlight/src-hilite-lesspipe.sh"

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
	alias catless='local _ccat(){cat --color=always "$@" | command cat -n | less} && _ccat'
else
	if cmdcheck pygmentize; then
		alias ccat='pygmentize -g -O style=colorful,linenos=1'
		alias catless='local _ccat(){cat "$@" | less} && _ccat'
	fi
fi
# brew install bat or access [sharkdp/bat: A cat\(1\) clone with wings\.]( https://github.com/sharkdp/bat )
cmdcheck bat && alias cat='bat'
# original cat
alias ocat='command cat'

# for mac
cmdcheck gsed && alias sed='gsed'
# -s: suppress 'Is a directory'
alias grep='grep -s --color=auto'
cmdcheck ggrep && alias grep='ggrep -s --color=auto'
# brew install coreutils
cmdcheck gtimeout && alias timeout='gtimeout'

# mac: brew install translate-shell
# [LinuxのCUIを使ってgoogle翻訳を実行する - Qiita]( http://qiita.com/YuiM/items/1287286386b8efd58147 )
cmdcheck trans && cmdcheck rlwrap && alias trans='rlwrap trans'
cmdcheck trans && cmdcheck rlwrap && alias transja='rlwrap trans :ja'
cmdcheck rlwrap && alias bc='rlwrap bc'

# html整形コマンド
## [XMLを整形(tidy)して読みやすく、貼りつけやすくする。 - それマグで！](http://takuya-1st.hatenablog.jp/entry/20120229/1330519953)
alias fixhtml='tidy -q -i -utf8'
alias urldecode='nkf -w --url-input'
# [シェルスクリプトでシンプルにurlエンコードする話 \- Qiita]( https://qiita.com/ik-fib/items/cc983ca34600c2d633d5 )
# alias urlencode="nkf -WwMQ | tr '=' '%'"
function urlencode() {
	echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
}
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

if cmdcheck nkf; then
	alias udec='nkf -w --url-input'
	alias uenc='nkf -WwMQ | tr = %'
	alias overwrite-utf8='nkf -w --overwrite'
fi

if $(cmdcheck pbcopy && cmdcheck pbpaste); then
	if cmdcheck nkf; then
		alias _c='nkf -w | pbcopy'
		alias _p='pbpaste | nkf -w'
	else
		alias _c='pbcopy'
		alias _p='pbpaste'
	fi
	# 改行コードなし
	# o: one
	alias oc="tr -d '\n' | c"
	alias op="p | tr -d '\n'"
fi

if [[ -z $DISPLAY ]]; then
	function c() {
		mkdir -p ~/tmp
		local VIM="vim"
		cmdcheck nvim && VIM="nvim"
		tee ~/tmp/clipboard | $VIM -u NONE -c 'let @"=join(getline(1, "$"), "\n")' -c 'q!'
	}
	function p() {
		mkdir -p ~/tmp
		touch ~/tmp/clipboard
		local VIM="vim"
		cmdcheck nvim && VIM="nvim"
		$VIM -u NONE -c 'call system("tee ~/tmp/clipboard", @")' -c 'q!'
		command cat ~/tmp/clipboard
	}
else
	function c() {
		if [[ $# == 0 ]]; then
			_c
		else
			command cat $1 | _c
		fi
	}
	function p() {
		_p
	}
fi
alias "p" >/dev/null 2>&1 && unalias "p"

function remove_clipboard_format() {
	local tmpfile=$(mktemp "/tmp/$(basename $0).$$.tmp.XXXXX")
	p >"$tmpfile" && command cat "$tmpfile" | c
	[[ -e "$tmpfile" ]] && rm -f "$tmpfile"
}

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

	# NOTE: auto python venv activate and deactivate
	function lambda() {
		local python_venv_activator='bin/activate'
		local dirpath=$PWD && while true; do
			if [[ -e "$dirpath/$python_venv_activator" ]]; then
				[[ -z "$VIRTUAL_ENV" ]] && source "$dirpath/$python_venv_activator"
				return
			fi
			[[ "$dirpath" == "/" ]] && break || local dirpath="$(dirname $dirpath)"
		done
		[[ -n "$VIRTUAL_ENV" ]] && deactivate
	} && lambda

	# NOTE: auto ros devel/setup.zsh runner
	function lambda() {
		for dir in $(traverse_path_list $PWD); do
			local setup_zsh_filepath="$dir/devel/setup.zsh"
			[[ -f $setup_zsh_filepath ]] && source "$setup_zsh_filepath"
		done
	} && lambda
}

function cdninja() {
	for dir in $(traverse_path_list $PWD); do
		local build_ninja_filepath="$dir/build.ninja"
		[[ -f $build_ninja_filepath ]] && cd "$dir"
	done
}

# [chpwd内のlsでファイル数が多い場合に省略表示する - Qiita]( https://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059 )
function ls_abbrev() {
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

function clean-cdinfo() {
	local tmpfile=$(mktemp)
	command cp ~/.cdinfo "$tmpfile"
	cat "$tmpfile" | sort | uniq | awk '{if(system("test -f " "\""$0"\"")) print $0}' >~/.cdinfo
	rm -f "$tmpfile"
}

alias memo='touch README.md'
alias tmp='cd ~/tmp/'

function cat-find() {
	[[ $1 == "" ]] && echo "set file reg? e.g.) $0 '*.txt'" && return
	find . -name "$1" -exec awk '{ if (FNR==1) print "####################\n",FILENAME,"\n####################"; print $0}' {} +
}
function cat-all() {
	[[ $# == 0 ]] && echo "$0 <files...>" && return
	for filepath in "$@"; do
		echo "$YELLOW"
		echo "####################"
		echo "# $(basename $filepath)"
		echo "####################"
		echo "$DEFAULT"
		cat $filepath
	done
}

# NOTE: grepに対して任意のオプションを渡せる状態?
function xargs-grep-0() {
	[[ $# == 0 ]] && echo 'grep_keyword' && return
	local keyword=(${@:1})
	local grep_cmd='grep'
	local color_opt='--color=auto'
	cmdcheck fzf && color_opt='--color=always'
	cmdcheck ggrep && local grep_cmd='ggrep'
	# NOTE: to prevent xargs from quitting on error
	# NOTE: e.g. symbolic link no exist error
	xargs -0 -L 1 -IXXX sh -c "find "'"$@"'" -exec $grep_cmd $color_opt -H -n \"${keyword[@]}\" {} +" '' XXX
}
function xargs-grep() {
	[[ $# == 0 ]] && echo 'grep_keyword' && return
	local keyword=(${@:1})
	local grep_cmd='grep'
	local color_opt='--color=auto'
	cmdcheck fzf && color_opt='--color=always'
	cmdcheck ggrep && local grep_cmd='ggrep'
	# NOTE: to prevent xargs from quitting on error
	xargs -L 1 -IXXX sh -c "find "'"$@"'" -exec $grep_cmd $color_opt -H -n \"${keyword[@]}\" {} +" '' XXX
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
	find $root -type f -name $find_name -print0 | xargs-grep-0 ${keyword[@]}
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
	find $root -type f \( -name $find_name1 -o -name $find_name2 \) -print0 | xargs-grep-0 ${keyword[@]}
}
alias fg.vim='fgrep "*.vim"'
[[ $(uname) == "Darwin" ]] && alias fg.my.vim='find "$HOME/.vim/config/" "$HOME/.vimrc" "$HOME/.local.vimrc" "$HOME/vim/" \( -type f -o -type l \) \( -name "*.vim" -o -name "*.vimrc" \) -print0 | xargs-grep-0'
[[ $(uname) == "Linux" ]] && alias fg.my.vim='find "$HOME/.vim/config/" "$HOME/.vimrc" "$HOME/.local.vimrc"              \( -type f -o -type l \) \( -name "*.vim" -o -name "*.vimrc" \) -print0 | xargs-grep-0'
alias fg.3rd.vim='find "$HOME/.vim/plugged/" -type f -name "*.vim" -print0 | xargs-grep-0'
alias fg.go='find "." \( -not -name "bindata_assetfs.go" -not -iwholename "*/vendor/*" \) -type f -name "*.go" -print0 | xargs-grep-0'
alias fg.my.go='find $( echo $GOPATH | cut -d":" -f2) \( -not -name "bindata_assetfs.go" -not -iwholename "*/vendor/*" \) -type f -name "*.go" -print0 | xargs-grep-0'
alias fg.3rd.go='find $( echo $GOPATH | cut -d":" -f1) \( -not -name "bindata_assetfs.go" -not -iwholename "*/vendor/*" \) -type f -name "*.go" -print0 | xargs-grep-0'
alias fg.py='fgrep "*.py"'
alias fg.sh='fgrep "*.sh"'
alias fg.cpp='fgrep "*.c[px][px]"'
alias fg.hpp='fgrep2 "*.h" "*.hpp"'
alias fg.c='fgrep "*.c"'
alias fg.h='fgrep "*.h"'
alias fg.ch='fgrep "*.[ch]"'
alias fg.cpp-all='fgrep2 "*.[ch][px][px]" "*.[ch]"'
alias fg.md='fgrep "*.md"'
alias fg.my.md='find "$HOME/md" -name "*.md" -print0 | xargs-grep-0'
alias f.make='find . \( -name "Makefile" -o -name "*.mk" \)'
alias fg.make='f.make -print0 | xargs-grep-0'
alias f.cmake='find . \( \( -name "CMakeLists.txt" -o -name "*.cmake" \) -not -iwholename "*build*" \)'
alias fg.cmake='f.cmake -print0 | xargs-grep-0'
alias rf='sudo find / \( -not -iwholename "$HOME/*" -not -iwholename "/var/lib/docker/*" \)'
alias hf='find ~'

function fg.vim.pv() { local _=$(fg.vim "$@" | pecovim); }
function fg.my.vim.pv() { local _=$(fg.my.vim "$@" | pecovim); }
function fg.3rd.vim.pv() { local _=$(fg.3rd.vim "$@" | pecovim); }
function fg.go.pv() { local _=$(fg.go "$@" | pecovim); }
function fg.my.go.pv() { local _=$(fg.my.go "$@" | pecovim); }
function fg.3rd.go.pv() { local _=$(fg.3rd.go "$@" | pecovim); }
function fg.py.pv() { local _=$(fg.py "$@" | pecovim); }
function fg.sh.pv() { local _=$(fg.sh "$@" | pecovim); }
function fg.cpp.pv() { local _=$(fg.cpp "$@" | pecovim); }
function fg.hpp.pv() { local _=$(fg.hpp "$@" | pecovim); }
function fg.c.pv() { local _=$(fg.c "$@" | pecovim); }
function fg.h.pv() { local _=$(fg.h "$@" | pecovim); }
function fg.ch.pv() { local _=$(fg.ch "$@" | pecovim); }
function fg.cpp-all.pv() { local _=$(fg.cpp-all "$@" | pecovim); }
function fg.md.pv() { local _=$(fg.md "$@" | pecovim); }
function fg.my.md.pv() { local _=$(fg.my.md "$@" | pecovim); }
function f.make.pv() { local _=$(f.make "$@" | pecovim); }
function fg.make.pv() { local _=$(fg.make "$@" | pecovim); }
function f.cmake.pv() { local _=$(f.cmake "$@" | pecovim); }
function fg.cmake.pv() { local _=$(fg.cmake "$@" | pecovim); }

alias md.pv='fg.md.pv'
alias md.my.pv='fg.my.md.pv'
alias vim.pv='fg.vim.pv'
alias vim.my.pv='fg.my.vim.pv'
alias cpp-all='fg.cpp-all'
alias cpp-all.pv='fg.cpp-all.pv'
alias make.pv='fg.make.pv'
alias cmake.pv='fg.cmake.pv'

function cmake() {
	command cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 "$@"
}

function rgrep() {
	# to expand alias
	local _=$(viminfo-ls | xargs-grep $@ | pecovim)
}

# [find で指定のフォルダを除外するには \- それマグで！]( http://takuya-1st.hatenablog.jp/entry/2015/12/16/213246 )
function find() {
	$(command which find) "$@" -not -iwholename '*/.git/*'
}

alias jagrep="grep -P '\p{Hiragana}'"

# 確認くん
#global_ip() { curl http://www.ugtop.com/spill.shtml 2>&1 | nkf -w | grep -A 2 "IP" |grep font | grep "size=+" | sed -e 's/^\(.\+\)>\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)<\(.\+\)/\2/g'; }# [Linux コマンドでグローバルIPを調べる方法 - weblog of key_amb]( http://keyamb.hatenablog.com/entry/2014/01/17/195038 )
alias global_ip='curl ifconfig.moe || curl ifconfig.io'

# swap file
function swap() {
	[[ $# != 2 ]] && echo "Usage: swap <file1> <file2>" && return 1
	# TODO: use mktemp
	local b1=$(basename $1)
	local _l=$_l"mv $1 /tmp/"
	[[ $? != 0 ]] && echo "err:$_l" && return 1
	mv "$1" "/tmp/"

	local _l=$_l"mv $2 $1"
	mv "$2" "$1"
	[[ $? != 0 ]] && echo "err:$_l" && return 1

	local _l=$_l"mv /tmp/$1 $2"
	mv "/tmp/$b1" "$2"
	[[ $? != 0 ]] && echo "err:$_l" && return 1
}

# 改行コード変換
alias CR2LF='sed "s/\r/\n/g"'
alias remove-blank-line='awk "NF > 0"'

alias cl='clear'
alias t='touch'

alias ty='type'
alias wh='which'

alias cmake-touch='touch CMakeLists.txt'

# webcat
function _webcat() {
	# go get -u github.com/umaumax/gonetcat
	gonetcat localhost $WEBCAT_PORT
}
function webcat() {
	# go get -u github.com/umaumax/gocat
	# screen clear and clear font
	gocat -prefix='\x1b[2J\x1b[1;1H\033[0m' -suffix='# END\n' | _webcat "$@"
}
function webcatd() {
	gotty $(which gechota) -p=$WEBCAT_PORT &
}

# 2nd arg is symbolic link: default
function mdlink() {
	[[ $# == 0 ]] && echo "$0 <target> [<link name>]" && return 1
	local file_path="$1"
	# 	local abspathdir=$(cd $(dirname $file_path) && pwd)
	local abspathfile="${PWD%/}/$file_path"
	local link_name=$2
	[[ -z $link_name ]] && local link_name=$abspathfile
	function trim_prefix() { echo ${1##$2}; }
	function trim_suffix() { echo ${1%%$2}; }
	echo $link_name $HOME
	local link_name=$(trim_prefix "$link_name" "$HOME/")
	local link_name=$(trim_suffix "$link_name" "/.")
	local link_name=$(echo $link_name | sed 's:/:-:g')
	[[ ! -e $file_path ]] && echo "$file_path does not exist!" && return 2
	echo ln -sf "$abspathfile" "$MDLINK/$link_name"
	ln -sf "$abspathfile" "$MDLINK/$link_name"
}

# NOTE: wrap stdin each line
function sand() {
	[[ $# -ge 2 ]] && echo "$0 <string>" && return
	local B=${1:-\"}
	local E
	[[ $B == \( ]] && local E=")"
	[[ $B == \[ ]] && local E="]"
	[[ $B == \< ]] && local E=">"
	[[ $B == \{ ]] && local E="}"
	[[ $B == \" ]] && local B=\\\"
	local E=${E:-$B}
	[[ $B == "\\" ]] && local B="\\\\"
	[[ $E == \" ]] && local E=\\\"
	[[ $E == "\\" ]] && local E="\\\\"
	awk '{printf "'$B'%s'$E'\n", $0}'
}
# NOTE: print string which fill terminal line
function line() {
	local C=${1:-=}
	seq -f "$C" -s '' $(($(tput cols) / $(printf "%s" "$C" | wc -m)))
	echo ''
}
function hr() { printf '%*s\n' "${2:-$(tput cols)}" '' | tr ' ' "${1:--}"; }

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
# FYI: c2a0: [treeコマンドの出力をsedでパイプしてHTML化 \- Qiita]( https://qiita.com/narupo/items/b677a1de3af7837c749f )
function tree() {
	local COLOR_OPT=()
	[[ ! -p /dev/stdout ]] && local COLOR_OPT=(-C)
	command tree -a -I "\.git" "${COLOR_OPT[@]}" "$@" | sed "s/$(echo -e "\xc2\xa0")/ /g"
}

# onlyd for zsh
alias wtty='() { curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Tokyo}" }'
alias weather.tokyo.en='wtty'
alias weather.tokyo.ja='() { curl -H "Accept-Language: ja" wttr.in/"${1:-Tokyo}" }'
alias moon='() { curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Tokyo}" } moon'

# auto zstyle ':prezto:load' pmodule function
# e.g.
# zploadadd homebrew osx git rails syntax-highlighting history-substring-search
# zploadadd ssh tmux rsync archive
# [sed でシンボリックリンクのファイルを書き換えると、実体ファイルに変わる – Tower of Engineers]( https://toe.bbtower.co.jp/20160915/136/ )
cmdcheck gsed && function zploadadd() {
	[[ $# == 0 ]] && echo "$0 zstyle.pmodule names..." && return
	for package in $@; do
		sed -i --follow-symlinks -e '/^zstyle.*pmodule \\$/a '\'$package\'' \\' ~/.zpreztorc
	done
}

function lambda() {
	local COLOR_RED="\e[91m"
	local COLOR_GREEN="\e[92m"
	local COLOR_YELLOW="\e[93m"
	local COLOR_BLUE="\e[94m"
	local COLOR_END="\e[m"
	# `inet `: mac
	# `inet addr:`: ubuntu
	alias ifconfig_color_filter="
	perl -pe 's/^(\w)+/${COLOR_BLUE}"'$&'"${COLOR_END}/g' | \
	perl -pe 's/(?<=inet )(\d+\.){3}\d+(\/\d+)?/${COLOR_YELLOW}"'$&'"${COLOR_END}/g' | \
	perl -pe 's/(?<=inet addr:)(\d+\.){3}\d+(\/\d+)?/${COLOR_YELLOW}"'$&'"${COLOR_END}/g' | \
	perl -pe 's/(?![0f:]{17})([\da-f]{2}:){5}[\da-f]+/${COLOR_GREEN}"'$&'"${COLOR_END}/g' | \
	perl -pe 's/(([\da-f]{4})?:){2,7}[\da-f]+(\/\d+)?/${COLOR_RED}"'$&'"${COLOR_END}/g'"
	alias ifconfig='ifconfig | ifconfig_color_filter'
	cmdcheck ifconfig && alias ifc='ifconfig'
} && lambda

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
cmdcheck stop || alias stop='kill -TSTP'

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
function color-tmux() {
	for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"; done | xargs
}

function xargs-printf() {
	while read line || [ -n "${line}" ]; do
		printf "$@" $line
	done
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
function gsync-gshare() {
	# NOTE: zsh cd message stdout
	# NOTE: gsync  message stderr
	local _=$(gshare && gsync 1>&2)
}
function gsync() {
	local ID=$1
	[[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
	[[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'" && return 1
	echo "ID:$ID"
	echo "# downloading..."
	gdrive sync download $ID .
	echo "# uploading..."
	gdrive sync upload . $ID
}
function gsync-download() {
	local ID=$1
	[[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
	[[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'" && return 1
	echo "ID:$ID"
	echo "# downloading..."
	gdrive sync download $ID .
}
function gsync-upload() {
	local ID=$1
	[[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
	[[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'" && return 1
	echo "ID:$ID"
	echo "# uploading..."
	gdrive sync upload . $ID
}

if [[ -s "${ZDOTDIR:-$HOME}/.local.zshrc" ]]; then
	source "${ZDOTDIR:-$HOME}/.local.zshrc"
fi

# ---- bash ----
# ---- zsh ----

setopt clobber
SAVEHIST=100000
[[ -x $(which direnv) ]] && eval "$(direnv hook zsh)"

if [[ $ZSH_NAME == zsh ]]; then
	# [zshの個人的に便利だと思った機能（suffix alias、略語展開） - Qiita]( http://qiita.com/matsu_chara/items/8372616f52934c657214 )
	alias -s txt='cat'
	alias -s rb='ruby'
	alias -s py='python3' # for python2 and python3
	alias -s php='php -f'
	alias -s gp='gnuplot'
	alias -s {gz,tar,zip,rar,7z}='unarchive' # preztoのarchiveモジュールのコマンド(https://github.com/sorin-ionescu/prezto/tree/master/modules)

	# option for completion
	setopt magic_equal_subst              # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
	setopt GLOB_DOTS                      # 明確なドットの指定なしで.から始まるファイルをマッチ
	zstyle ':completion:*' use-cache true # apt-getとかdpkgコマンドをキャッシュを使って速くする
	setopt list_packed                    # 保管結果をできるだけ詰める
	setopt rm_star_wait                   # rm * を実行する前に確認
	setopt numeric_glob_sort              # 辞書順ではなく数字順に並べる。
fi

# 実行したプロセスの消費時間がn秒以上かかったら
# 自動的に消費時間の統計情報をstderrに出力する。
REPORTTIME=10

## [[zsh]改行のない行が無視されてしまうのはzshの仕様だった件 · DQNEO起業日記]( http://dqn.sakusakutto.jp/2012/08/zsh_unsetopt_promptcr_zshrc.html )
## preztoや他のライブラリとの兼ね合いで効かなくなるので注意(次のzsh command hookで対応)
#unsetopt promptcr

# NOTE: macのiTermでは必要ない
# [シェルでコマンドの実行前後をフックする - Hibariya]( http://note.hibariya.org/articles/20170219/shell-postexec.html )
if [[ $(uname) == "Linux" ]]; then
	# to prevent `Vimを使ってくれてありがとう` at tab
	function precmd_function() {
		set-dirname-title
	}
	autoload -Uz add-zsh-hook
	add-zsh-hook precmd precmd_function
fi

# FYI: [あるファイルを削除するだけでディスク使用率が100％になる理由 \- Qiita]( https://qiita.com/nacika_ins/items/d614b933034137ed42f6 )
function show-all-files-which-processes-grab() {
	lsof |
		grep REG |
		grep -v "stat: No such file or directory" |
		grep -v DEL |
		awk '{if ($NF=="(deleted)") {x=3;y=1} else {x=2;y=0}; {print $(NF-x) "  " $(NF-y) } }' |
		sort -n -u
}

# edit clipboard
function cedit() {
	local tmpfile=$(mktemp '/tmp/cedit.tmp.orderfile.XXXXX')
	p >"$tmpfile"
	VIM_FAST_MODE='on' vim "$tmpfile" && cat "$tmpfile" | c
	[[ -e $tmpfile ]] && rm -f $tmpfile
}

function c() {
	if [[ $# == 0 ]]; then
		_c
	else
		cat $1 | _c
	fi
}

# global aliases
alias -g PV="| pecovim"
alias -g WC="| wc"
alias -g L="| less"

# [How to remove ^\[, and all of the escape sequences in a file using linux shell scripting \- Stack Overflow]( https://stackoverflow.com/questions/6534556/how-to-remove-and-all-of-the-escape-sequences-in-a-file-using-linux-shell-sc )
alias drop-without-ascii='sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"'
alias remove-without-ascii='drop-without-ascii'

alias remove-ansi="perl -MTerm::ANSIColor=colorstrip -ne 'print colorstrip(\$_)'"
alias drop-color="remove-ansi"
alias drop-ansi="remove-ansi"
alias filter-ansi="remove-ansi"
alias filter-color="remove-ansi"
alias monokuro="remove-ansi"
alias mono-color="remove-ansi"
alias term-cols='tput cols'
alias term-lines='tput lines'

# NOTE: 動作が遅い
# nずれのシーザ暗号を解く(lookによる簡易テスト機能つき)
function solve_caesar_cipher() {
	local dict_path="/usr/share/dict/words"
	local input=($(cat))
	for i in $(seq 1 25); do
		local output=()
		printf "[%2d]:" $i
		local output=($(echo $input | tr "$(printf %${i}sa-z | tr ' ' '🍣')" a-za-z | tr "$(printf %${i}sA-Z | tr ' ' '🍣')" A-ZA-Z))
		# check?
		local n=0
		local n_no_hit=0
		for word in "${output[@]}"; do
			# NOTE: ある程度以上の文字数の単語のみを検索対象とする
			if [[ ${#word} -ge 4 ]]; then
				local n=$((n + 1))
				# 文章に含まれている余計な記号の削除
				word=$(echo $word | sed -E 's/\.|,//g')
				look $word >/dev/null
				# or
				# 				cat $dict_path | grep "^${word}$" >/dev/null
				local n_no_hit=$((n_no_hit + $?))
			fi
		done
		local n_hit=$((n - n_no_hit))
		printf "(%3d/%3d):" $n_hit $n
		# more than 50%?
		if [[ $n_hit -gt $((n / 2)) ]]; then
			echo -n $GREEN
		fi
		echo $output
		echo -n $DEFAULT
	done
}

alias date-for-file='date +"%Y-%m-%d_%k-%M-%S"'

alias sum="awk '{for(i=1;i<=NF;i++)sum+=\$i;} END{print sum}'"
alias sum-all='sum'
alias sum-col="awk '{for(i=1;i<=NF;i++)sum[i]+=\$i;} END{for(i in sum)printf \"%d \", sum[i]; print \"\"}'"
alias sum-line="awk '{sum=0; for(i=1;i<=NF;i++)sum+=\$i; print sum}'"
alias awk-sum='sum'
alias awk-sum-all='sum'
alias awk-sum-col='sum-col'
alias awk-sum-line='sum-line'

if [[ $(uname) == "Linux" ]]; then
	alias ps-cpu='ps aux --sort -%cpu'
	alias ps-mem='ps aux --sort -rss'
elif [[ $(uname) == "Darwin" ]]; then
	alias ps-cpu='ps aux -r'
	alias ps-mem='ps aux -m'
fi

# FYI: [文字を中央寄せで表示するスクリプト \- Qiita]( https://qiita.com/april418/items/1c44d3bd13647183deae )
function text_center() {
	local columns=$(tput cols)
	local line=
	if [ -p /dev/stdin ]; then
		while IFS= read -r line || [ -n "$line" ]; do
			printf "%*s\n" $(((${#line} + columns) / 2)) "$line"
		done </dev/stdin
	else
		line="$@"
		printf "%*s\n" $(((${#line} + columns) / 2)) "$line"
	fi
}

function display_center() {
	function max_length() {
		local length=
		local max_length=0
		local line=
		if [ -p /dev/stdin ]; then
			while IFS= read -r line || [ -n "$line" ]; do
				length=${#line}
				if [ $length -gt $max_length ]; then
					max_length=$length
				fi
			done </dev/stdin
			echo $max_length
		else
			line="$@"
			echo ${#line}
		fi
	}
	function with_indent() {
		local length="$1"
		local line=
		local indent=
		local i=
		for ((i = 0; i < length; i++)); do
			indent="$indent "
		done
		if [ -p /dev/stdin ]; then
			while IFS= read -r line || [ -n "$line" ]; do
				echo "${indent}${line}"
			done </dev/stdin
		else
			shift
			line="$@"
			echo "${indent}${#line}"
		fi
	}
	local columns=$(tput cols)
	local length=$(echo "$@" | max_length)
	echo "$@" | with_indent "$(((columns - length) / 2))"
}

# [bashでポモドーロタイマー作ったった \- Qiita]( https://qiita.com/imura81gt/items/61ff64db8e767ecbbb9d )
function pomodoro() {
	clear
	local i=${1:-$((25 * 60))}
	# 	figlet "ready?" | sand "$GREEN" | text_center
	# 	read Wait

	while :; do
		clear
		figlet "Pomodoro Timer" | sand "$YELLOW" | text_center
		(figlet $(printf "%02d : %02d" $((i/60)) $((i % 60))) | sand "$BLUE" | text_center)
		: $((i -= 1))
		sleep 1
		if [ $i -eq 0 ]; then
			# NOTE: picture is chicken
			cmdcheck notify && notify -t "Pomodoro" --icon https://icondecotter.jp/data/16709/1401284346/169a75762480f56cd2d282afedd93568.png -m "Finish!"

			echo -n "Pomodoro[P],Short break[S], Long break[L]?> "
			read WAIT
			case "${WAIT:0:1}" in
			'P' | 'p')
				i=$((25 * 60))
				;;
			'S' | 's')
				i=$((5 * 60))
				;;
			'L' | 'l')
				i=$((15 * 60))
				;;
			*)
				echo "Didn't match anything"
				echo "Pomodoro Start!"
				i=$((25 * 60))
				;;
			esac
			clear
			figlet $(printf "%02d : %02d" $((i/60)) $((i % 60)))
		fi
	done
}
# [edouard\-lopez/progress\-bar\.sh: Simple & sexy progress bar for \`bash\`, give it a duration and it will do the rest\.]( https://github.com/edouard-lopez/progress-bar.sh )
function progress-bar-blue() {
	echo -ne $BLUE
	progress-bar "$@"
	echo -e $DEFAULT
}
function progress-bar() {
	local duration=${1}

	function already_done() { for ((done = 0; done < $elapsed; done++)); do printf "▇"; done; }
	function remaining() { for ((remain = $elapsed; remain < $duration; remain++)); do printf " "; done; }
	function percentage() { printf "| %s%%" $(((($elapsed) * 100) / ($duration) * 100/100)); }
	function clean_line() { printf "\r"; }

	for ((elapsed = 1; elapsed <= $duration; elapsed++)); do
		already_done
		remaining
		percentage
		sleep 1
		clean_line
	done
	clean_line
}

cmdcheck say && function mississippi() {
	local n=${1:-9999}
	local start=$(date +%s)
	for i in $(seq 1 $n); do
		say "$i mississippi"
		local end=$(date +%s)
		echo -n "\r$((end - start)) sec"
	done
}

# ---- don't add code here by your hand
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# ---- don't add code here by your hand

[[ -e ~/.zsh/.peco.zshrc ]] && source ~/.zsh/.peco.zshrc
[[ -e ~/.zsh/.windows.zshrc ]] && source ~/.zsh/.windows.zshrc
[[ -e ~/.zsh/.bindkey.zshrc ]] && source ~/.zsh/.bindkey.zshrc
# NOTE: run after source .fzf.zsh to avoid overwrite ^R zsh keybind
[[ -e ~/.zsh/.zplug.zshrc ]] && source ~/.zsh/.zplug.zshrc
[[ -e ~/.zsh/.nugget.zshrc ]] && source ~/.zsh/.nugget.zshrc
[[ -e ~/.zsh/.ros.zshrc ]] && source ~/.zsh/.ros.zshrc

# ---------------------

# FYI: [~/.bashrcは何も出力してはいけない（するならエラー出力に） - None is None is None]( http://doloopwhile.hatenablog.com/entry/2014/11/04/124725 )
if [[ $ZSH_NAME == zsh ]]; then
	cd .
fi
[[ -n $DEBUG_MODE ]] && (which zprof >/dev/null 2>&1) && zprof
