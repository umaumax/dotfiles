#!/usr/bin/env zsh
! cmdcheck peco && return

if [[ $(uname) == "Linux" ]]; then
	# FYI: [Sample Usage · peco/peco Wiki]( https://github.com/peco/peco/wiki/Sample-Usage#peco--apt )
	function peco-apt() {
		if [[ -z "$1" ]]; then
			echo "Usage: peco-apt <initial search string> - select packages on peco and they will be installed"
			return 1
		fi
		sudoenable || return 1
		sudo apt-cache search $1 | peco | awk '{ print $1 }' | tr "\n" " " | xargs -- sudo apt-get install
	}
fi

if [[ $(uname) == "Darwin" ]]; then
	# FYI: [Find the Wi\-Fi Network Password from Windows, Mac or Linux]( https://www.labnol.org/software/find-wi-fi-network-password/28949/ )
	function show-Wi-Fi-password() {
		local SSID=$(networksetup -listpreferredwirelessnetworks $(networksetup -listallhardwareports | grep -A1 Wi-Fi | sed -n 2,2p | sed 's/Device: //g') | peco | sed "s/^[ \t]*//")
		[[ -n $SSID ]] && echo $SSID && security -i find-generic-password -wa "$SSID"
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
# FYI: [grep の結果をインタラクティブに確認する \- Qiita]( https://qiita.com/m5d215/items/013f466fb21f7d7f52d6 )
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
alias ranking_color_cat='cat'
# NOTE: green high rank, red low rank
# NOTE: Fの値を下げることで，色の変化までの文字数が増える(擬似的に1行は同じ色になる)
cmdcheck lolcat && alias ranking_color_cat='lolcat -F 0.005 -d 8 -f -S 1'

if cmdcheck cgrep; then
	function shell_color_filter() {
		cgrep '(\$)(\().*(\))' 28,28,28 |
			cgrep '(\$[a-zA-Z_0-9]*)' |
			cgrep '(\|)' 201 |
			cgrep '(\||)|(&&)' 90,198 |
			cgrep '(;)' 211,88,88 |
			cgrep '(^\[[^\]]*\])' 38 |
			cgrep '(\$\(|^\t*|\| *|; *|\|\| *|&& *)([a-zA-Z_][a-zA-Z_0-9.\-]*)' ,10 |
			cgrep '('"'"'[^'"'"']+'"'"')' 226 |
			cgrep '(#.*$)' 239
	}
else
	function shell_color_filter() {
		cat
	}
fi

[[ "$(uname -a)" =~ Ubuntu ]] && alias mdfind='locate'
function mdfindpeco() {
	mdfind | fzf
}

alias pc='peco | c'
alias pecopy='peco | c'
alias cmdpeco='{ alias; functions-list; } | peco'
alias pe='peco'
function hpeco() {
	local HPECO_NUM=${HPECO_NUM:-1}
	local ret=$(builtin history -nr $HPECO_NUM | shell_color_filter | fzf --query=$1)
	if [[ ! -o zle ]]; then
		printf '%s' "$ret"
	else
		print -z "$ret"
	fi
}
function hpecopy() {
	hpeco | tr -d '\n' | c
}
alias apeco='alias | peco'
alias envpeco='env | peco'
alias fpeco='find . -type f | peco'
alias fpecovim='find . -type f | pecovim'
alias fvim='find . -type f | pecovim'
# m: modified
alias gmvim='git status -s | cut -c4- | pecovim'
alias ftvim='pvft'
alias epeco='env | peco'
alias peco-functions='local zzz(){ local f=`command cat`; functions $f } && print -l ${(ok)functions} | peco | zzz'
alias peco-dirs='cd `dirs -lv | peco | sed -r "s/[0-9]+\s*//g"`/.'
alias dirspeco='cd `dirs -lv | peco | sed -r "s/[0-9]+\s*//g"`/.'
alias peco-kill='local xxx(){ pgrep -lf $1 | peco | cut -d" " -f1 | xargs kill -KILL } && xxx'
# [最近 vim で編集したファイルを、peco で選択して開く \- Qiita]( https://qiita.com/Cside/items/9bf50b3186cfbe893b57 )
alias rvim="viminfo-ls | ranking_color_cat | pecovim"
alias rgvim='rdvim $(git rev-parse --show-toplevel | homedir_normalization)'
alias grvim='rgvim'
alias rcvim='rdvim'
[[ -d ~/dotfiles/neosnippet/ ]] && alias neopeco='lsabs -f ~/dotfiles/neosnippet | pecovim'

function rdvim() {
	local wd=${1:-$(pwd)}
	viminfo-ls | grep -E '^'"$wd" | ranking_color_cat | pecovim
}
# 選択したファイルが存在する場合にはそのディレクトリを取得し，'/'を加える
# 存在しない場合には空白となる
# 最終的に'./'を加えても動作は変更されない
# NOTE: echo ${~$(echo '~')} means expand '~'
alias rvcd="cd \${~\$(viminfo-ls | ranking_color_cat | peco | sed 's:/[^/]*$::g' | sed 's:$:/:g')}./"
alias rcd="cd \$(command cat ~/.cdinfo | sort | uniq | ranking_color_cat | peco | sed 's:$:/:g')./"
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
alias pft='find-time-sortr | ranking_color_cat | fzf | awk "{print \$9}"'
alias pftr='find-time-sort | ranking_color_cat | fzf | awk "{print \$9}"'
alias pvft='find-time-sortr | ranking_color_cat | fzf | awk "{print \$9}" | xargs-vim'
alias pvftr='find-time-sort | ranking_color_cat | fzf | awk "{print \$9}" | xargs-vim'

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

function git-branch-peco() {
	local options=(refs/heads/ refs/remotes/ refs/tags/)
	[[ $# -gt 0 ]] && options=("$@")
	local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative)%(taggerdate:relative))" --sort=-committerdate "${options[@]}" | sed -e "s/^refs\///g" | awk '{s=""; for(i=2;i<=NF;i++) s=s" "$i; printf "%-34s%+24s\n", $1, s;}' |
		fzf --reverse --ansi --multi --preview 'git graph-with-date-and-author --color | sed -E "s/^/ /g" | sed -E '"'"'/\(.*[^\/]'"'"'$(echo {} | cut -d" " -f1 | sed "s:/:.:g")'"'"'.*\)/s/^ />/g'"'"'' |
		awk '{print $1}')
	printf '%s' "$branch"
}
function git-checkout-branch-peco() {
	local branch=$(git-branch-peco)
	[[ -n $branch ]] && git checkout $branch
}
function git-tag-peco() {
	git-branch-peco "refs/tags/"
}
function git-checkout-tag-peco() {
	local tag=$(git-tag-peco)
	[[ -n $tag ]] && git checkout $tag
}

function git-log-peco() {
	_git-commit-peco --multi
}
function _git-commit-peco() {
	# NOTE: escape {7} -> {'7'} to avoid fzf replacing
	git graph-with-date-and-author --color | fzf "$@" --preview 'git show --stat -p --color $(echo {} | grep -o -E '"'"'^[ *|\\/_]+[0-9a-zA-Z]{'"'"'7'"'"'} '"'"' | grep -o -E '"'"'[0-9a-zA-Z]{'"'"'7'"'"'}'"'"')' | grep -o -E '^[ *|\\/_]+[0-9a-zA-Z]{7} ' | grep -o -E '[0-9a-zA-Z]{7}'
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
# NOTE: select 1 or 2 commits by peco -> return commit range by given range text
function git-commits-range-peco() {
	local range_text=${1:-".."}

	local commits=($(git-commits-peco))
	[[ -z $commits ]] && return 1
	[[ ${#commits[@]} -gt 2 ]] && echo "${RED}choose one commit or two commits! not ${#commis[@]} ($commits)${DEFAULT}" 1>&2 && return 1
	local commit1=$(echo $commits | awk '{print $1}') # new
	local commit2=$(echo $commits | awk '{print $2}') # old
	[[ -z $commit2 ]] && local commit2=$commit1

	echo "${commit2}${range_text}${commit1}"
}
function git-cherry-pick-peco-range() {
	local commits_range=$(git-commits-range-peco '^..')
	[[ -z $commits_range ]] && return 1
	git log $commits_range
	hr '#'
	echo git cherry-pick "'$commits_range'"

	# NOTE: only for zsh
	echo -n "ok?(y/N): "
	read -q || return 1

	git cherry-pick $commits_range
}
function git-checkout-commit-peco() {
	local commit=$(_git-commit-peco)
	[[ -z $commit ]] && return 1
	git checkout "$commit"
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
	local cheat_root="$HOME/dotfiles/cheatsheets/"
	local _=$(
		export VIM_FAST_MODE='on'
		grep -rns -v -e '^$' -e '^----' -e '```' $cheat_root --color=always | sed 's:'$cheat_root'::g' | peco | sed -r 's!^([^:]*:[^:]*):.*$!'$cheat_root'\1!g' | xargs-vim
	)
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
		} | awk '!/^$/{if (head!="") printf "%s : %s\n", head, $0; else head=$0} /^$/{head=""} {fflush();}' | bat -l markdown --color=always --plain --unbuffered | fzf --query="'"
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
	function manpeco() {
		local args=($(man -k . | fzf --query="'"${1} | cut -d' ' -f1 | sed -E -e 's/(.*)\(([0-9a-zA-Z]+)\)/\2 \1/g' -e 's/,//g'))
		[[ ${#args[@]} == 2 ]] && man "${args[@]}"
	}
	alias icalc='calc'
	function calc() {
		: | fzf --ansi --multi --preview 'echo {q}"="; echo {q} | bc -l' --preview-window 'up:2' --height '1%' --print-query | bc -l
	}
	alias ipgrep='ppgrep'
	function ppgrep() {
		: | fzf --ansi --multi --preview '[[ -n {q} ]] && { pgrep -l {q}; echo "----"; pgrep -alf {q}; }' --preview-window 'down:70%' --height '80%' --print-query | xargs pgrep -l
	}
	# interactive tree
	alias pecotree='itree'
	alias treepeco='itree'
	function itree() {
		seq 1 100 | fzf --ansi --multi --preview 'tree -L {}'
	}
	alias lsofpeco='ilsof'
	alias pecolsof='ilsof'
	function ilsof() {
		seq 0 65536 | fzf --ansi --multi --preview 'lsof -i :{}'
	}
	alias lsofsudopeco='isudolsof'
	alias pecosudolsof='isudolsof'
	function isudolsof() {
		sudoenable || return 1
		seq 0 65536 | fzf --ansi --multi --preview 'sudo lsof -i :{}'
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
	function opendoc() {
		local doc_list=(
			'cmake~3.9'
			'c'
			'cpp'
			'docker~17'
			'go'
			'git'
			'gcc~7'
			'gcc~7_cpp'
			'homebrew'
			'markdown'
			'python~3.6'
			'python~2.7'
		)
		local ret=$(for doc_list in ""${doc_list[@]}""; do
			echo $doc_list
		done | fzf)
		local base_url='http://docs.w3cub.com'
		[[ -n $ret ]] && open "$base_url/$ret"
	}
	alias pecols='lspeco'
	function lspeco() {
		local ls_force_color='ls --color=always'
		[[ $(uname) == "Darwin" ]] && ls_force_color='CLICOLOR_FORCE=1 ls -G'
		eval $ls_force_color | pecocat
	}
	if cmdcheck gomi; then
		alias pecogomi='gomipeco'
		function gomipeco() {
			for target in $(lspeco); do
				gomi "$target"
			done
		}
	fi
	alias pecorm='rmpeco'
	function rmpeco() {
		local ret=$(
			{
				for target in $(lspeco); do
					printf '%q ' "$target"
				done
			}
		)
		[[ -n $ret ]] && print -z ' rm -rf '"$ret"
	}
	alias git-repo-peco='peco-git-repo'
	function peco-git-repo() {
		local dirpath=$(find-git-repo | fzf)
		[[ -n $dirpath ]] && cd "$dirpath"
	}
fi
