# NOTE: 現在のwindowsのmy settingではログインシェルの変更に不具合があるため(bash経由でzshを呼び出しているため，zshrcからzprofileを呼ぶ必要がある)
if [[ $OS == Windows_NT ]]; then
	test -r ~/.zprofile && source ~/.zprofile
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
# default 10000?
export HISTSIZE=100000

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
	# NOTE: howt to check
	# setopt | grep 'xxx'

	# history
	setopt hist_ignore_dups
	# 	unset share_history
	# シェルのプロセスごとに履歴を共有
	setopt share_history

	## 補完候補を一覧表示
	# 	setopt auto_list
	## =command を command のパス名に展開する
	# 	setopt equals
	## --prefix=/usr などの = 以降も補完
	# 	setopt magic_equal_subst
fi

# ----

# git
git_aliases=(gCa gCe gCl gCo gCt gFb gFbc gFbd gFbf gFbl gFbm gFbp gFbr gFbs gFbt gFbx gFf gFfc gFfd gFff gFfl gFfm gFfp gFfr gFfs gFft gFfx gFh gFhc gFhd gFhf gFhl gFhm gFhp gFhr gFhs gFht gFhx gFi gFl gFlc gFld gFlf gFll gFlm gFlp gFlr gFls gFlt gFlx gFs gFsc gFsd gFsf gFsl gFsm gFsp gFsr gFss gFst gFsx gR gRa gRb gRl gRm gRp gRs gRu gRx gS gSI gSa gSf gSi gSl gSm gSs gSu gSx gb gbD gbL gbM gbR gbS gbV gbX gba gbc gbd gbl gbm gbr gbs gbv gbx gc gcF gcO gcP gcR gcS gcSF gcSa gcSf gcSm gca gcam gcd gcf gcl gcm gco gcp gcr gcs gd gdc gdi gdk gdm gdu gdx gf gfa gfc gfcr gfm gfr gg ggL ggi ggl ggv ggw giA giD giI giR giX gia gid gii gir giu gix gl glb glc gld glg glo gm gmC gmF gma gmt gp gpA gpF gpa gpc gpf gpp gpt gr gra grc gri grs gs gsL gsS gsX gsa gsd gsl gsp gsr gss gsw gsx gwC gwD gwR gwS gwX gwc gwd gwr gws gwx)
for e in ${git_aliases[@]}; do
	cmdcheck $e && unalias $e
done
alias gr='git-root'
# [ターミナルからカレントディレクトリのGitHubページを開く \- Qiita]( https://qiita.com/kobakazu0429/items/0dc93aeeb66e497f51ae )
alias git-open="open \$(git remote -v | head -n 1 | awk '{ print \$2 }' | awk -F'[:]' '{ print \$2 }' | awk -F'.git' '{ print \"https://github.com/\" \$1 }')"
alias git-alias='git alias | sed "s/^alias\.//g" | sed -e "s:^\([a-zA-Z0-9_-]* \):\x1b[35m\1\x1b[0m:g" | sort | '"awk '{printf \"%-38s = \", \$1; for(i=2;i<=NF;i++) printf \"%s \", \$i; print \"\";}'"
function git-ranking() {
	builtin history -r 1 | awk '{ print $2,$3 }' | grep '^git' | sort | uniq -c | awk '{com[NR]=$3;a[NR]=$1;sum=sum+$1} END{for(i in com) printf("%6.2f%% %s %s \n" ,(a[i]/sum)*100."%","git",com[i])}' | sort -gr | uniq | sed -n 1,30p | cat -n
}

cmdcheck tac || alias tac='tail -r'

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
alias gd='git_diff'
# NOTE: 差分が少ないファイルから順番にdiffを表示
function git_diff() {
	local diff_cmd='cdiff'
	[[ $# -ge 1 ]] && local diff_cmd="$1"
	local files=($(git diff --stat | awk '{ print $3 " "$4 " " $1}' | sort -n | grep -v '^changed' | cut -f3 -d' '))
	tmpfile=$(mktemp '/tmp/git.tmp.orderfile.XXXXX')
	for e in "${files[@]}"; do
		echo $e >>$tmpfile
	done
	git $diff_cmd -O$tmpfile "${files[@]}"
	[[ -e $tmpfile ]] && rm -f $tmpfile
}
alias gdh='git diff HEAD'
alias gdhh='git diff HEAD~'
alias gdhhh='git diff HEAD~~'
alias gdhhhh='git diff HEAD~~~'
alias gdhhhhh='git diff HEAD~~~~'
alias gdhhhhhh='git diff HEAD~~~~~'
alias ga='git add --all'
alias gadd='git add'
# this alias overwrite Ghostscript command
alias gs='git status'
alias gst='git status'
alias glog='git log'
function git-add-peco() {
	local SELECTED_FILE_TO_ADD="$(git status --short | peco | awk -F ' ' '{print $NF}')"
	if [ -n "$SELECTED_FILE_TO_ADD" ]; then
		git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')
		git status
	fi
}

cmdcheck ccze && alias='ccze -A'

# delete all file without starting . prefix at 'build' dir
cmdcheck 'cmake' && function cmake-clean() {
	[[ ! $(basename $PWD) =~ ^build ]] && echo "cwd is not cmake build dir '^build'" && return 1
	find . -maxdepth 1 -not -name '.*' -exec rm -r {} +
}

alias basedirname='basename $PWD'
alias find-git-repo="find . -name '.git' | sed 's:/.git$::g'"
alias find-time-sort='find . -not -iwholename "*/.git/*" -type f -print0 | xargs -0 ls -altr'
alias find-time-sortr='find . -not -iwholename "*/.git/*" -type f -print0 | xargs -0 ls -alt'
alias find-dotfiles='find . -name ".*" -not -name ".git" | sed "s:\./\|^\.$::g" | grep .'

function git-check-up-to-date() {
	target='.'
	[[ $# -ge 1 ]] && target="$1"
	# NOTE: for supressing of chpwd()
	ret=$(bash -c "cd \"$target\" && git log origin/master..master")
	if [[ $ret != "" ]]; then
		echo "[$target]"
		echo $ret
	fi
	ret=$(bash -c "cd \"$target\" && git status --porcelain")
	if [[ $ret != "" ]]; then
		echo "[$target] Changes not staged for commit:"
		echo $ret
	fi
}
function find-git-non-up-to-date-repo() {
	local ccze="cat"
	cmdcheck ccze && ccze="ccze -A"
	while read line || [ -n "${line}" ]; do
		git-check-up-to-date "$line" | eval $ccze
	done < <(find-git-repo)
}
# [Gitのルートディレクトリへ簡単に移動できるようにする関数]( https://qiita.com/ponko2/items/d5f45b2cf2326100cdbc )
function git-root() {
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		cd $(git rev-parse --show-toplevel)
	fi
}

# [ソートしないで重複行を削除する]( https://qiita.com/arcizan/items/9cf19cd982fa65f87546 )
alias uniq-without-sort='awk "!a[\$0]++"'

cmdcheck diff-filter && alias git-filter='diff-filter -v file=<(git ls-files)'

# cd
alias ho='\cd ~'
alias home='\cd ~'
alias dl='cd ~/Downloads/'
alias downloads='cd ~/Downloads/'
alias desktop='cd ~/Desktop/'

[[ -d ~/local/bin ]] && alias local-bin='cd ~/local/bin'
[[ -d ~/github.com ]] && alias github='cd ~/github.com'
[[ -d ~/chrome-extension ]] && alias chrome-extension='cd ~/chrome-extension'
[[ -d ~/dotfiles/cheatsheets ]] && alias cheatsheets='cd ~/dotfiles/cheatsheets'
[[ -d ~/dotfiles/snippets ]] && alias snippetes='cd ~/dotfiles/snippets'
[[ -d ~/dotfiles/template ]] && alias template='cd ~/dotfiles/template'
[[ -d ~/dotfiles/.config/gofix ]] && alias gofixdict='cd ~/dotfiles/.config/gofix'
[[ -d ~/gshare ]] && alias gshare='cd ~/gshare'
[[ -d ~/.config ]] && alias config='cd ~/.config'

[[ -e ~/dotfiles/.gitconfig ]] && alias vigc='vim ~/dotfiles/.gitconfig'
[[ -e ~/dotfiles/.gitconfig ]] && alias vimgc='vim ~/dotfiles/.gitconfig'
[[ -e ~/.gitignore ]] && alias vigi='vim ~/.gitignore'
[[ -e ~/.gitignore ]] && alias vimgi='vim ~/.gitignore'

[[ -n $_Darwin ]] && alias vim-files='pgrep -alf vim | grep "^[0-9]* vim"'
[[ -n $_Ubuntu ]] && alias vim-files='pgrep -al vim'

alias vp='cdvproot'
alias vpr='cdvproot'
alias vproot='cdvproot'
alias cdv='cdvproot'
alias cdvp='cdvproot'
alias cdvproot='cd $VIM_PROJECT_ROOT'

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
if [[ -n $_Darwin ]]; then
	export LSCOLORS=gxfxcxdxbxegexabagacad
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

	alias gvim='mvim'
	alias mvim='mvim --remote-tab-silent'

	function code() {
		VSCODE_CWD="$PWD"
		open -n -b "com.microsoft.VSCode" --args $*
	}

	# NOTE: 何も設定をしないと表示がくずれるため
	cmdcheck ccze && alias ccze='ccze -A'
fi

function mvim() {
	[[ $# == 1 ]] && [[ $1 == "--remote-tab-silent" ]] && $(command which mvim) && return $?
	$(command which mvim) $@
}

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
	# [How can I get a list of all repositories and PPAs from the command line into an install script? \- Ask Ubuntu]( https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an )
	alias add-apt-repository-list="grep -r --include '*.list' '^deb ' /etc/apt/ | sed -re 's/^\/etc\/apt\/sources\.list((\.d\/)?|(:)?)//' -e 's/(.*\.list):/\[\1\] /' -e 's/deb http:\/\/ppa.launchpad.net\/(.*?)\/ubuntu .*/ppa:\1/'"
	alias dpkg-list='sudo dpkg -l'
	function dpkg-executable-list() {
		[[ $# == 0 ]] && echo '<package name>' && return 1
		dpkg -L $1 | executable_filter
	}

	# [Sample Usage · peco/peco Wiki]( https://github.com/peco/peco/wiki/Sample-Usage#peco--apt )
	function peco-apt() {
		if [ -z "$1" ]; then
			echo "Usage: peco-apt <initial search string> - select packages on peco and they will be installed"
		else
			sudo apt-cache search $1 | peco | awk '{ print $1 }' | tr "\n" " " | xargs -- sudo apt-get install
		fi
	}
	function xdotool-infos() {
		[[ $# == 0 ]] && echo "$0 <class>" && return 1
		xdotool search --class "$1" | xargs -L 1 sh -c 'printf "# $0"; xwininfo -id $0'
	}

	alias os_ver='cat /etc/os-release | grep VERSION_ID | grep -o "[0-9.]*"'
fi

pipe-EOF-do() {
	local v=$(cat)
	echo $v | ${@}
}

alias kaiba='echo "ヽ(*ﾟдﾟ)ノ"'
alias gopher='echo "ʕ ◔ ϖ ◔ ʔ"'

# window path -> unix path
alias w2upath='sed "s:\\\:/:g"'
alias w2p='p|w2upath|c'

alias git-diff='git diff --color-words'
alias git-log-peco='cat ~/.git-logs/*.log | peco'

alias relogin='exec $SHELL -l'

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

# [Couldn't get fzf to work without running sudo · Issue \#1146 · junegunn/fzf]( https://github.com/junegunn/fzf/issues/1146 )
# -> USE: pipe-EOF-do
# brew install fzf
# git clone https://github.com/junegunn/fzf.git
# git clone --depth 1 https://github.com/junegunn/fzf.git
# cd fzf
# ./install
# cp bin/fzf ~/local/bin/fzf
cmdcheck fzf && alias peco='pipe-EOF-do fzf --ansi --reverse' && alias fzf='pipe-EOF-do fzf --ansi --reverse'
cmdcheck fzy && alias fzy='fzy -l $(($(tput lines)/2))'

# NOTE:googler
# NOTE:peco
# alias pvim="xargs -L 1 -IXXX sh -c 'vim \$1 < /dev/tty' - 'XXX'"
alias pv='pecovim'
alias pvim='pecovim'
alias pipevim='vim -'
# alias g='googler -n 5'
alias xargs-vim='_xargs-vim -'
# alias viminfo-ls="egrep '^>' ~/.viminfo | cut -c3- | perl -E 'say for map { chomp; \$_ =~ s/^~/\$ENV{HOME}/e; -f \$_ ? \$_ : () } <STDIN>'"
alias viminfo-ls="cat ~/.vim_edit_log | grep -v '^$' | awk '!a[\$0]++' | tac"
if cmdcheck peco; then
	alias cpeco='command peco'
	alias pecovim='peco | xargs-vim'
	# peco copy
	alias pc='peco | c'
	alias pecopy='peco | c'
	alias pe='peco'
	alias hpeco='builtin history -nr 1 | command peco | tee /dev/tty | c'
	alias apeco='alias | peco'
	alias fpeco='find . -type f | peco'
	alias fpecovim='find . -type f | pecovim'
	alias fvim='find . -type f | pecovim'
	alias epeco='env | peco | tee /dev/tty | c'
	alias peco-functions='local zzz(){ local f=`command cat`; functions $f } && print -l ${(ok)functions} | peco | zzz'
	alias peco-dirs='cd `dirs -lv | peco | sed -r "s/[0-9]+\s*//g"`/.'
	alias dirspeco='cd `dirs -lv | peco | sed -r "s/[0-9]+\s*//g"`/.'
	alias peco-kill='local xxx(){ pgrep -lf $1 | peco | cut -d" " -f1 | xargs kill -KILL } && xxx'
	# [最近 vim で編集したファイルを、peco で選択して開く \- Qiita]( https://qiita.com/Cside/items/9bf50b3186cfbe893b57 )
	# 	alias rvim="viminfo-ls | peco | tee /dev/tty | xargs -o vim"
	# 	alias rvim="viminfo-ls | peco | tee /dev/tty | xargs sh -c 'vim \$1 < /dev/tty' -"
	alias rvim="viminfo-ls | peco | tee /dev/tty | xargs-vim"
	# 選択したファイルが存在する場合にはそのディレクトリを取得し，'/'を加える
	# 存在しない場合には空白となる
	# 最終的に'./'を加えても動作は変更されない
	# NOTE: echo ${~$(echo '~')} means expand '~'
	alias rvcd="cd \${~\$(viminfo-ls | peco | sed 's:/[^/]*$::g' | sed 's:$:/:g')}./"
	alias rcd="cd \$(command cat ~/.cdinfo | sort | uniq | peco | sed 's:$:/:g')./"
	alias cdpeco="cd \$(find . -type d | peco | sed 's:$:/:g')./"
	# [git ls\-tree]( https://qiita.com/sasaplus1/items/cff8d5674e0ad6c26aa9 )
	alias gcd='cd "$(git ls-tree -dr --name-only --full-name --full-tree HEAD | sed -e "s|^|`git rev-parse --show-toplevel`/|" | peco)"'
	alias up='cd `_up | peco`/.'

	alias peco-ls='ls -al | peco | awk "{print \$9}"'
	alias peco-lst='ls -alt | peco | awk "{print \$9}"'
	alias peco-lstr='ls -altr | peco | awk "{print \$9}"'
	alias pls='peco-ls'
	alias plst='peco-lstr'
	alias plstr='peco-lst'
	alias pvls='peco-ls | xargs-vim'
	alias pvlst='peco-lstr | xargs-vim'
	alias pvlstr='peco-lst | xargs-vim'
	alias pf='fpeco'
	alias pft='find-time-sortr | peco | awk "{print \$9}"'
	alias pftr='find-time-sort | peco | awk "{print \$9}"'
	alias pvft='find-time-sortr | peco | awk "{print \$9}" | xargs-vim'
	alias pvftr='find-time-sort | peco | awk "{print \$9}" | xargs-vim'
fi
alias rvgrep="viminfo-ls | xargs-grep"

alias ls-non-dotfiles="find . -name '*' -maxdepth 1 | sed 's:^\./::g' | grep -E -v '\..*'"

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

function git-checkout-branch-peco() {
	local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative))" --sort=-committerdate refs/heads/ refs/remotes/ refs/tags/ | sed -e "s/^refs\///g" | peco | awk '{print $1}')
	[[ -n $branch ]] && git checkout $branch
}

# # <C-R>
# # [pecoる]( https://qiita.com/tmsanrinsha/items/72cebab6cd448704e366 )
# function _peco-select-history() {
# 	# historyを番号なし、逆順、最初から表示。
# 	# 順番を保持して重複を削除。
# 	# カーソルの左側の文字列をクエリにしてpecoを起動
# 	# \nを改行に変換
# 	BUFFER="$(builtin history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
# 	CURSOR=$#BUFFER # カーソルを文末に移動
# 	zle -R -c       # refresh
# }
# zle -N _peco-select-history
# bindkey '^R' _peco-select-history

# <C-X><C-S>
function _peco-snippets() {
	local color_cmd=('cat')
	# 	cmdcheck ccat && cmdcheck fzf && color_cmd=('ccat' '--color=always')
	BUFFER=$(grep -sv "^#" ~/dotfiles/snippets/* | ${color_cmd[@]} | sed 's:'$HOME/dotfiles/snippets/'::g' | command peco --query "$LBUFFER" | sed -r 's!^[^:]*:!!g')
	CURSOR=$#BUFFER
	zle -R -c # refresh
}
zle -N _peco-snippets
bindkey '^x^s' _peco-snippets

function peco-select-history() {
	local tac
	if which tac >/dev/null; then
		tac="tac"
	else
		tac="tail -r"
	fi
	local query="$LBUFFER"
	local opts=("--query" "$LBUFFER")
	[[ -z $query ]] && local opts=()
	BUFFER=$(builtin history -nr 1 |
		eval $tac |
		command peco "${opts[@]}")
	CURSOR=$#BUFFER
	zle clear-screen
}
zle -N peco-select-history
bindkey '^o' peco-select-history

function cheat() {
	# below commands enable alias
	# for 高速vim起動
	# vim -u NONE -N
	export VIM_FAST_MODE='on'
	local cheat_root="$HOME/dotfiles/cheatsheets/"
	local _=$(grep -rns ".\+" $cheat_root | sed 's:'$cheat_root'::g' | peco | sed -r 's!^([^:]*:[^:]*):.*$!'$cheat_root'\1!g' | xargs-vim)
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

# for python(3.3~) venv activation
cmdcheck python && alias activate='source bin/activate' # <-> deactivate
cmdcheck ninja && alias ncn='ninja -t clean && ninja'

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
		local container_id=$(docker ps | peco | awk '{print $1}')
		[[ -n $container_id ]] && docker exec -it $container_id /bin/bash
	}
	function docker-start-and-attach() {
		local container_id=$(docker ps -a | peco | awk '{print $1}')
		[[ -n $container_id ]] && docker start $container_id && docker attach $container_id
	}
	function docker-remove-container() {
		local container_id=$(docker ps -a | peco | awk '{print $1}')
		[[ -n $container_id ]] && docker rm $container_id
	}
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

alias ds='cd ~/dotfiles'
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
alias vimpluginstall="vim -c ':PlugInstall' ''"
alias vimplugupdate="vim -c ':PlugUpdate' ''"
alias vimplugupgrade="vim -c ':PlugUpgrade' ''"
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
alias fpath='echo $fpath | tr " " "\n"'

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
	functions-list
}
alias functions-list='functions | grep "() {" | grep -v -E "^\s+" | grep -v -E "^_" | sed "s/() {//g"'

# get abs path
# [bash で ファイルの絶対パスを得る - Qiita](http://qiita.com/katoy/items/c0d9ff8aff59efa8fcbb)
function abspath() {
	if [[ -n $_Darwin ]]; then
		_home=$(echo $HOME | sed "s/\//\\\\\//g")
		abspathdir=$(sh -c "cd $(dirname $1) && pwd | sed \"s/$_home/~/\"")
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
# brew install coreutils
cmdcheck gtimeout && alias timeout='gtimeout'

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

if $(cmdcheck pbcopy && cmdcheck pbpaste); then
	if cmdcheck nkf; then
		alias _c='nkf -w | pbcopy'
		alias p='pbpaste | nkf -w'
		alias udec='nkf -w --url-input'
		alias uenc='nkf -WwMQ | tr = %'
		alias overwrite-utf8='nkf -w --overwrite'
	else
		alias _c='pbcopy'
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

clean-cdinfo() {
	local tmpfile=$(mktemp)
	command cp ~/.cdinfo "$tmpfile"
	cat "$tmpfile" | sort | uniq | awk '{if(system("test -f " "\""$0"\"")) print $0}' >~/.cdinfo
	rm -f "$tmpfile"
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
[[ -n $_Darwin ]] && alias fg.my.vim='find "$HOME/.vim/config/" "$HOME/.vimrc" "$HOME/.local.vimrc" "$HOME/vim/" \( -type f -o -type l \) \( -name "*.vim" -o -name "*.vimrc" \) -print0 | xargs-grep-0'
[[ -n $_Ubuntu ]] && alias fg.my.vim='find "$HOME/.vim/config/" "$HOME/.vimrc" "$HOME/.local.vimrc"              \( -type f -o -type l \) \( -name "*.vim" -o -name "*.vimrc" \) -print0 | xargs-grep-0'
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
function fg.go.my.pv() { local _=$(fg.my.go "$@" | pecovim); }
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
alias md.my.pv='fg.md.my.pv'
alias vim.pv='fg.vim.pv'
alias vim.my.pv='fg.vim.my.pv'
alias cpp-all='fg.cpp-all'
alias cpp-all.pv='fg.cpp-all.pv'
alias make.pv='fg.make.pv'
alias cmake.pv='fg.cmake.my'

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
	[[ -z $link_name ]] && link_name=$abspathfile
	function trim_prefix() { echo ${1##$2}; }
	function trim_suffix() { echo ${1%%$2}; }
	echo $link_name $HOME
	link_name=$(trim_prefix "$link_name" "$HOME/")
	link_name=$(trim_suffix "$link_name" "/.")
	link_name=$(echo $link_name | sed 's:/:-:g')
	[[ ! -e $file_path ]] && echo "$file_path does not exist!" && return 2
	echo ln -sf "$abspathfile" "$MDLINK/$link_name"
	ln -sf "$abspathfile" "$MDLINK/$link_name"
}

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
	awk '{printf "'$B'%s'$E'\n", $0}'
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
	for package in $@; do
		gsed -i --follow-symlinks -e '/^zstyle.*pmodule \\$/a '\'$package\'' \\' ~/.zpreztorc
	done
}

{
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
}

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

# [\`git remote add upstream\`を楽にする \| Tomorrow Never Comes\.]( http://blog.sgr-ksmt.org/2016/03/04/git_remote_add_upstream/ )
git-remote-add-upstream() {
	if ! type jq >/dev/null 2>&1; then
		echo "'jq' is not installed." >&2
		return 1
	fi
	local repo=$(git config user.name)/$(basename $PWD)
	if [ $# -ge 1 ]; then
		local repo="$1"
	fi
	echo "repo: $repo"
	local upstream=$(curl -L "https://api.github.com/repos/$repo" | jq -r '.parent.full_name')
	if [ "$upstream" = "null" ]; then
		echo "upstream not found." >&2
		return 1
	fi
	echo git remote add upstream "git@github.com:${upstream}.git"
	git remote add upstream "git@github.com:${upstream}.git"
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
function gsync-download() {
	local ID=$1
	[[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
	[[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'"
	echo "ID:$ID"
	echo "# downloading..."
	gdrive sync download $ID .
}
function gsync-upload() {
	local ID=$1
	[[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
	[[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'"
	echo "ID:$ID"
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
	# 	alias -s py='python' # for python2 and python3
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

# 実行したプロセスの消費時間が3秒以上かかったら
# 自動的に消費時間の統計情報を表示する。
# stderrに出力
REPORTTIME=10

## [[zsh]改行のない行が無視されてしまうのはzshの仕様だった件 · DQNEO起業日記]( http://dqn.sakusakutto.jp/2012/08/zsh_unsetopt_promptcr_zshrc.html )
## preztoや他のライブラリとの兼ね合いで効かなくなるので注意(次のzsh command hookで対応)
#unsetopt promptcr

# [シェルでコマンドの実行前後をフックする - Hibariya]( http://note.hibariya.org/articles/20170219/shell-postexec.html )
if [[ -n $_Ubuntu ]]; then
	# to prevent `Vimを使ってくれてありがとう` at tab
	function precmd_function() {
		set-dirname-title
	}
	autoload -Uz add-zsh-hook
	add-zsh-hook precmd precmd_function
fi

[[ -e ~/.zplug.zshrc ]] && source ~/.zplug.zshrc

# windows setting
if [[ $OS == Windows_NT ]]; then
	# tmuxを起動するとx86_64のみになる
	# if [[ $MSYSTEM_CHOST == x86_64-pc-msys ]]; then
	if [[ -n $BASH ]]; then
		PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h (x_x)/(\[\e[35m\]$MSYSTEM\[\e[0m\]) \[\e[33m\]\w\[\e[0m\]\n\$ "
	else
		# zsh
		# NOTE:元から表示がずれるので、あえて全角文字を入れたらちょうどよくなった
		PROMPT=$(echo "\x1b[0m\x1b[01;32m[${USER}@${HOST%%.*}\x1b[0m\x1b"" ""\x1b[0m\x1b[01;35m (x_x)<($MSYSTEM)\x1b[0m\x1b"" ""\x1b[0m\x1b[01;33m"" "'%~'"\x1b[0m\x1b""\r\n"'★$ ')
		function simple_prompt() {
			PROMPT=$(echo "\x1b[0m\x1b"" ""\x1b[0m\x1b[01;33m"" "'%~'"\x1b[0m\x1b"'$ ')
		}
	fi
	export HISTFILE=${HOME}/.zsh_history
	export HISTSIZE=100000

	# NOTE: how about using windows native clip command?
	if [[ -e /dev/clipboard ]]; then
		alias p='(cat /dev/clipboard)'
		alias _c='(cat > /dev/clipboard)'
	else
		cmdcheck gopaste && alias p='gopaste'
		cmdcheck gocopy && alias _c='gocopy'
	fi

	## windows ls color
	export LS_COLORS="di=01;36"
	alias ls='ls --color=auto --show-control-chars'

	alias cmd='winpty cmd'
	alias psh='winpty powershell'
	alias ipconfig='winpty ipconfig'
	alias ifconfig='winpty ipconfig'
	alias netstat='winpty netstat'
	alias netsh='winpty netsh'
	alias ping='winpty ping'
	alias ver='cmd.exe /c "ver"'
	alias winver='cmd.exe /c "winver" &'
	alias open='bash -c "cd \$0 && start ."'

	export PATH=~/go/bin:$PATH
	export WIN_HOME="/c/Users/$USER"

	alias fg.my.md='find "$WIN_HOME/Documents" -name "*.md" -print0 | xargs-grep-0'
	# NOTE:findでシンボリックリンクを仲介すると極端に挙動が遅くなる
	alias mdfind='_mdfind(){ find $WIN_HOME/Documents -name "*.md" -exec grep -n --color=auto "$@" {} + } && _mdfind'
	alias win-home='cd $WIN_HOME'
	alias winhome='cd $WIN_HOME'
	alias wcd='cd $WIN_HOME'
fi

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

alias remove-ansi="perl -MTerm::ANSIColor=colorstrip -ne 'print colorstrip(\$_)'"
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
alias sum-y="awk '{for(i=1;i<=NF;i++)sum[i]+=\$i;} END{for(i in sum)printf \"%d \", sum[i]; print \"\"}'"
