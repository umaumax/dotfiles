#!/usr/bin/env zsh
! cmdcheck peco && return

if [[ $(uname) == "Linux" ]]; then
	# [Sample Usage · peco/peco Wiki]( https://github.com/peco/peco/wiki/Sample-Usage#peco--apt )
	function peco-apt() {
		if [ -z "$1" ]; then
			echo "Usage: peco-apt <initial search string> - select packages on peco and they will be installed"
		else
			sudo apt-cache search $1 | peco | awk '{ print $1 }' | tr "\n" " " | xargs -- sudo apt-get install
		fi
	}
fi

if [[ $(uname) == "Darwin" ]]; then
	# [Find the Wi\-Fi Network Password from Windows, Mac or Linux]( https://www.labnol.org/software/find-wi-fi-network-password/28949/ )
	function show-Wi-Fi-password() {
		local SSID=$(networksetup -listpreferredwirelessnetworks $(networksetup -listallhardwareports | grep -A1 Wi-Fi | sed -n 2,2p | sed 's/Device: //g') | peco | sed "s/^[ \t]*//")
		echo $SSID
		[[ -n $SSID ]] && security -i find-generic-password -wa "$SSID"
	}
fi

# [Couldn't get fzf to work without running sudo · Issue \#1146 · junegunn/fzf]( https://github.com/junegunn/fzf/issues/1146 )
# -> USE: pipe-EOF-do
# brew install fzf
# git clone https://github.com/junegunn/fzf.git
# git clone --depth 1 https://github.com/junegunn/fzf.git
# cd fzf
# ./install
# cp bin/fzf ~/local/bin/fzf
cmdcheck fzf && alias peco='fzf' && function fzf() {
	pipe-EOF-do command fzf --multi --no-mouse --ansi --reverse --bind='ctrl-x:cancel,btab:backward-kill-word,ctrl-g:jump,ctrl-f:backward-delete-char,ctrl-h:backward-char,ctrl-l:forward-char,shift-left:preview-page-up,shift-right:preview-page-down,shift-up:preview-up,shift-down:preview-down' $@
}
cmdcheck fzy && alias fzy='fzy -l $(($(tput lines)/2))'

function cat-C() {
	local file_path="${1%%:*}"
	local range=${2:-3}
	local line_no=$(($(echo "$1" | cut -d":" -f2)))

	local CAT='cat -n'
	local pre_line=0
	if cmdcheck bat; then
		local CAT='bat --color=always'
		local pre_line=3
	elif cmdcheck ccat; then
		local CAT='ccat -C=always'
		local pre_line=0
	fi

	eval $CAT $file_path | awk -v base=$line_no -v range=$range -v pre_line=$pre_line '(pre_line+base-range)<=NR && NR<=(pre_line+base+range)'
}
# force color cat
function fccat() {
	local CAT='cat'
	if cmdcheck bat; then
		local CAT='bat --color=always'
	elif cmdcheck ccat; then
		local CAT='ccat -C=always'
	fi
	eval $CAT $@
}
function pecocat() {
	local query=$(echo ${1:-} | clear_path)
	{
		if cmdcheck fzf; then
			local ls_force_color='ls --color=always -alh'
			[[ $(uname) == "Darwin" ]] && local ls_force_color='CLICOLOR_FORCE=1 ls -G -alh'

			local CAT='cat'
			if cmdcheck wcat; then
				local CAT='wcat'
				local range=$(echo "$(tput lines) * 6 / 10 / 2 - 1" | bc)
				# DONT USE `` in fzf --preview, becase parse will be fault when using ``. So, use $()
				# NOTE: 行数指定の場合で最初または最後の行の場合，指定のrangeだと表示が途切れて見えてしまう
				# NOTE: awk '%s:%s': 2番目を'%d'とすると明示的に0指定となるので，'%s'で空白となるように
				# NOTE: eval echo $filepath: extract ~ to $HOME
				pipe-EOF-do fzf --multi --ansi --reverse --preview 'F=$(eval echo $(echo {} | cut -d":" -f1)); FL=$(echo {} | awk "{ print \$1; }" | awk -F":" "{ printf \"%s:%s\\n\", \$1, \$2; }"; ); [[ -d $F ]] && '"$ls_force_color"' $F; [[ -f $F ]] && echo $FL:'"$range"' && '"$CAT"' $FL:'"$range"';' --preview-window 'down:60%' --query=$query
				return
			elif cmdcheck bat; then
				local CAT='bat --color=always'
			elif cmdcheck ccat; then
				local CAT='ccat -C=always'
			fi
			pipe-EOF-do fzf --multi --ansi --reverse --preview 'F=$(eval echo $(echo {} | cut -d":" -f1)); [[ -d $F ]] && '"$ls_force_color"' $F; [[ -f $F ]] && '"$CAT"' $F' --preview-window 'down:60%' --query=$query
		else
			peco
		fi
	} | sed -E 's/:([0-9]+):.*$/:\1/g'
}

alias pv='pecovim'
alias pvim='pecovim'
alias cpeco='command peco'
function pecovim() {
	pecocat "$@" | xargs-vim
}
# peco copy
alias pc='peco | c'
alias pecopy='peco | c'
alias cmdpeco='{ alias; functions-list; } | peco'
alias pe='peco'
alias hpeco='builtin history -nr 1 | command peco | tee /dev/tty | c'
alias apeco='alias | peco'
alias fpeco='find . -type f | peco'
alias fpecovim='find . -type f | pecovim'
alias fvim='find . -type f | pecovim'
# m: modified
alias gmvim='git status -s | cut -c4- | pecovim'
alias ftvim='pvft'
alias epeco='env | peco | tee /dev/tty | c'
alias peco-functions='local zzz(){ local f=`command cat`; functions $f } && print -l ${(ok)functions} | peco | zzz'
alias peco-dirs='cd `dirs -lv | peco | sed -r "s/[0-9]+\s*//g"`/.'
alias dirspeco='cd `dirs -lv | peco | sed -r "s/[0-9]+\s*//g"`/.'
alias peco-kill='local xxx(){ pgrep -lf $1 | peco | cut -d" " -f1 | xargs kill -KILL } && xxx'
# [最近 vim で編集したファイルを、peco で選択して開く \- Qiita]( https://qiita.com/Cside/items/9bf50b3186cfbe893b57 )
alias rvim="viminfo-ls | pecovim"
alias rgvim='rdvim $(git rev-parse --show-toplevel | homedir_normalization)'
alias grvim='rgvim'
alias rcvim='rdvim'
[[ -d ~/dotfiles/neosnippet/ ]] && alias neopeco='lsabs -f ~/dotfiles/neosnippet | pecovim'

function rdvim() {
	local wd=${1:-$(pwd)}
	viminfo-ls | grep -E '^'"$wd" | pecovim
}
# 選択したファイルが存在する場合にはそのディレクトリを取得し，'/'を加える
# 存在しない場合には空白となる
# 最終的に'./'を加えても動作は変更されない
# NOTE: echo ${~$(echo '~')} means expand '~'
alias rvcd="cd \${~\$(viminfo-ls | peco | sed 's:/[^/]*$::g' | sed 's:$:/:g')}./"
alias rcd="cd \$(command cat ~/.cdinfo | sort | uniq | peco | sed 's:$:/:g')./"
function cdpeco() {
	# NOTE: mac ok
	# 	if [[ -p /dev/stdin ]]; then
	# 		cd $(cat /dev/stdin | peco | sed 's:$:/:g')./
	# 	else
	# 		cd $(find . -type d | peco | sed 's:$:/:g')./
	# 	fi
	# 	return

	# NOTE: pipeの内容をそのまま受け取るには()or{}で囲む必要がある
	if [[ $(uname) == "Darwin" ]]; then
		{cd $({ [[ -p /dev/stdin ]] && cat || find . -type d; } | peco | sed 's:$:/:g')./}
	else
		{cd $({
			[[ -p /dev/stdin ]] && local RET=$(cat) || local RET=$(find . -type d)
			echo $RET
		} | peco | sed 's:$:/:g')./}
	fi
}
# [git ls\-tree]( https://qiita.com/sasaplus1/items/cff8d5674e0ad6c26aa9 )
# NOTE: only dir
alias cdg='gcd'
function gcd() {
	is_git_repo_with_message && cd "$(git ls-tree -dr --name-only --full-name --full-tree HEAD | sed -e "s|^|$(git rev-parse --show-toplevel)/|" | pecocat $*)"
}
# NOTE: includes file
alias cdgf='gfcd'
function gfcd() {
	is_git_repo_with_message && cd "$(dirname $(git ls-tree -r --name-only --full-name --full-tree HEAD | sed -e "s|^|$(git rev-parse --show-toplevel)/|" | pecocat $*))"
}

function _up() {
	dir="$PWD"
	while [[ $dir != / ]]; do
		echo $dir
		dir=${dir%/*}
		[[ $dir == '' ]] && break
	done
	echo /
}
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
	local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative))" --sort=-committerdate refs/heads/ refs/remotes/ refs/tags/ | sed -e "s/^refs\///g" | awk '{s=""; for(i=2;i<=NF;i++) s=s" "$i; printf "%-34s%+24s\n", $1, s;}' |
		fzf --reverse --ansi --multi --preview 'git log --oneline --decorate --graph --branches --tags --remotes --color | sed -E "s/^/ /g" | sed -E '"'"'/\(.*[^\/]'"'"'$(echo {} | cut -d" " -f1 | sed "s:/:.:g")'"'"'.*\)/s/^ />/g'"'"'' |
		awk '{print $1}')
	[[ -n $branch ]] && git checkout $branch
}

function _git-commit-peco() {
	# NOTE: escape {7} -> {'7'} to avoid fzf replacing
	gl --color | fzf "$@" --preview 'git show --stat -p --color $(echo {} | grep -o -E '"'"'^[ *|\\/_]+[0-9a-zA-Z]{'"'"'7'"'"'} '"'"' | grep -o -E '"'"'[0-9a-zA-Z]{'"'"'7'"'"'}'"'"')' | grep -o -E '^[ *|\\/_]+[0-9a-zA-Z]{7} ' | grep -o -E '[0-9a-zA-Z]{7}'
}
function git-commits-peco() {
	_git-commit-peco --multi
}
function git-rebase-peco() {
	local commit=$(_git-commit-peco)
	[[ -z $commit ]] && return 1
	git rebase -i "$commit^"
}
function git-cherry-pick-peco() {
	local commit=$(_git-commit-peco)
	[[ -z $commit ]] && return 1
	git cherry-pick "$commit"
}
function git-cherry-pick-peco-range() {
	local commits=($(git-commits-peco))
	[[ -z $commits ]] && return 1
	[[ ${#commits[@]} != 2 ]] && echo "choose two commit! not ${#commis[@]} ($commits)" && return 1
	local commit1=$(echo $commits | awk '{print $1}') # new
	local commit2=$(echo $commits | awk '{print $2}') # old

	git log "${commit2}^..${commit1}"
	hr '#'
	echo git cherry-pick "'${commit2}^..${commit1}'"

	# NOTE: only for zsh
	echo -n "ok?(y/N): "
	read -q || return 1

	git cherry-pick "${commit2}^..${commit1}"
}

function git-rename-to-backup-branch-peco() {
	local prefix='_'
	local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative))" --sort=-committerdate refs/heads/ refs/remotes/ refs/tags/ | sed -e "s/^refs\///g" | peco | awk '{print $1}')
	[[ -n $branch ]] && git rename {,$prefix}"$branch"
}

function cheat() {
	# below commands enable alias
	# for 高速vim起動
	# vim -u NONE -N
	export VIM_FAST_MODE='on'
	local cheat_root="$HOME/dotfiles/cheatsheets/"
	local _=$(grep -rns ".\+" $cheat_root | sed 's:'$cheat_root'::g' | peco | sed -r 's!^([^:]*:[^:]*):.*$!'$cheat_root'\1!g' | xargs-vim)
	unset VIM_FAST_MODE
}

# copy example file peco
function pecoexamples() {
	local root="$HOME/dotfiles/examples"
	local files=$(cd $root >/dev/null 2>&1 && find . -type f | grep -v README.md)
	[[ -z $files ]] && return
	local PECO="peco"
	cmdcheck fzf && cmdcheck ccat && local PECO="fzf --reverse --ansi --multi --preview 'ccat -C=always $root/{}'"
	local ret=$(echo "$files" | bash -c $PECO)
	[[ -z $ret ]] && return
	cp -i "$root/$ret" "$(basename $ret)" && echo "[COPY]: $ret"
}

function umountpeco() {
	local ret=$(mount | peco | sed 's/.* on//g' | awk '{print$1}')
	[[ -z $ret ]] && return
	if [[ $(uname) == "Darwin" ]]; then
		sudo diskutil unmount $ret
	else
		sudo umount $ret
	fi
}

# NOTE: peco google
function pecoole() {
	local ret=$(
		{
			for filepath in $(ls ~/dotfiles/urls/*.md); do
				echo -n $(basename $filepath) " "
			done
			echo ''
			echo '[dotfiles/urls at master · umaumax/dotfiles]( https://github.com/umaumax/dotfiles/tree/master/urls )'
			echo ''
			for filepath in $(ls ~/dotfiles/urls/*.md); do
				cat $filepath
				echo ""
			done
		} | awk '!/^$/{if (head!="") printf "%s : %s\n", head, $0; else head=$0} /^$/{head=""}' | peco
	)
	local url=$(echo $ret | grep -E -o "http[s]://[^ ]*")
	[[ -n $url ]] && open "$url"
}

function lnpeco() {
	[[ $# == 0 ]] && echo "$0 SYM_SRC_PATH" && return 1
	local SYM_SRC_PATH="$1"
	local SYM_SRC_NAME=$(basename $SYM_SRC_PATH)
	local TARGET_DIR=$(dirname $SYM_SRC_PATH)
	[[ -e $SYM_SRC_PATH ]] && [[ ! -L $SYM_SRC_PATH ]] && echo "'$SYM_SRC_PATH' is not symbolic link!" && return 1
	[[ ! -d $TARGET_DIR ]] && echo "'$TARGET_DIR' is not dir" && return 1

	local dst=$({
		printf "# current setting: "
		ls -l $SYM_SRC_PATH | env grep -o -E '[a-zA-Z0-9\-~/]* ->.*$'
		ls $TARGET_DIR
	} | peco)
	if [[ -n $dst ]]; then
		[[ ! -e $dst ]] && echo "No such file or directory '$dst'" && return 1
		if $(is_wd_owner_root $TARGET_DIR); then
			sudo bash -c "cd $TARGET_DIR && ln -snf $dst $SYM_SRC_NAME"
		else
			bash -c "cd $TARGET_DIR && ln -snf $dst $SYM_SRC_NAME"
		fi
		echo "[DONE] cd $TARGET_DIR && ln -snf $dst $SYM_SRC_NAME"
	fi
}

function is_wd_owner_root() {
	local TARGET_DIR="${1:-.}"
	if [[ $(uname) == "Darwin" ]]; then
		[[ $(stat -f "%u" $TARGET_DIR) == 0 ]]
		return
	fi
	[[ $(stat -c "%u" $TARGET_DIR) == 0 ]]
	return
}

function selhost() {
	local VAR_NAME=${1:-"TARGET_HOST"}
	local RET=$(sshconfig_host_hostname | peco | awk '{print $1}')
	export $VAR_NAME="$RET"
	echo "export ${YELLOW}${VAR_NAME}${DEFAULT}=${YELLOW}${RET}${DEFAULT}"
}

function pathcmdspeco() {
	pathcmds | peco
}

# TODO: USE WINDOW_ID not APP_NAME
cmdcheck wmctrl && cmdcheck wintoggle && function wintogglepeco() {
	local app_name=$(wmctrl -lx | grep -v 'N/A' | awk '{print$3}')
	[[ -z $app_name ]] && return 1
	wintoggle $app_name
}

if cmdcheck fzf; then
	alias icalc='calc'
	function calc() {
		: | fzf --ansi --multi --preview 'echo {q}"="; echo {q} | bc -l' --preview-window 'up:2' --height '1%' --print-query | bc -l
	}
	alias ipgrep='ppgrep'
	function ppgrep() {
		: | fzf --ansi --multi --preview '[[ -n {q} ]] && { pgrep -l {q}; echo "----"; pgrep -alf {q}; }' --preview-window 'down:70%' --height '80%' --print-query | xargs pgrep -l
	}
	# interactive tree
	function itree() {
		seq 1 100 | fzf --ansi --multi --preview 'tree -L {}'
	}
	function ilsof() {
		seq 0 65536 | fzf --ansi --multi --preview 'lsof -i :{}'
	}
	function isudolsof() {
		sudo echo >/dev/null 2>&1 && seq 0 65536 | fzf --ansi --multi --preview 'sudo lsof -i :{}'
	}
	# e.g. printf-check float 1234.5678
	function printf-check() {
		: | fzf --ansi --multi --preview 'echo printf "{q}" '"$*"'; printf "{q}" '"$*" --preview-window 'down:70%' --height '80%' --print-query
	}
	function git-log-file-find-peco() {
		local cmd='git log --color --follow --stat -- {q}'
		{
			echo '*md'
			echo '*cpp'
		} | _git-peco $cmd
	}
	function git-log-src-grep-peco() {
		local cmd='git log --color --stat -S $(echo {q} | awk "{print \$1}") -- $(echo {q} | awk "{print \$2}")'
		{
			echo 'function *zsh'
			echo 'print *cpp'
		} | _git-peco $cmd
	}
	function _git-peco() {
		[[ $# -le 0 ]] && echo "$0 [cmd]" && return 1
		local pipe_content=$(cat)
		local cmd=$1
		# NOTE: 1st line: input query
		# NOTE: 2nd line: selected query
		local ret=$(printf "%s" $pipe_content | fzf --query='*' --ansi --multi --preview $cmd --preview-window 'down:90%' --height '90%' --print-query | head -n 1)
		# NOTE: same output of preview-window
		if [[ -n $ret ]]; then
			local eval_cmd=$(printf '%s' $cmd | sed 's@{q}@'"'$ret'"'@g')
			eval $eval_cmd
			hr '#'
			echo $eval_cmd
		fi
	}
	alias gt='googletrans'
	function googletrans() {
		local port="12800"
		! cmdcheck gtrans && echo "REQUIRED: gtrans" && echo "pip install https://github.com/umaumax/gtrans/archive/master.tar.gz" && return 1
		pgrep -lf "gtrans -p" >/dev/null 2>&1 || nohup gtrans -p $port &
		: | fzf --ansi --multi --preview "echo {q}; curl -s 'localhost:$port/?text='\$(echo {q} | nkf -WwMQ | sed 's/=\$//g' | tr = % | tr -d '\n')" --preview-window 'up:2' --height '1%'
	}
	function test_bash_regexp() {
		[[ $# -le 0 ]] && echo "$0 [filepath]" && return 1
		local TARGET_FILE=$1
		{
			echo NOTE: start with "' '" means raw query!
			echo sample
			echo '(\.|\?)$'
		} | fzf --ansi --multi --preview 'echo {q} | grep ''^ \\+'' && QUERY={} || QUERY=$(echo {q} | awk ''{gsub(/^ +/,"")} {print $0}''); [[ -z $QUERY ]] && QUERY=".*"; echo "PAT=''$QUERY'' [[ xxx =~ \$PAT ]]"; echo; cat '"$TARGET_FILE"' | awk 1 | while read -r LINE; do; [[ $LINE =~ $QUERY ]] && echo "$LINE"; done' --print-query
	}
fi
