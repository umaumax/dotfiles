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
cmdcheck fzf && alias peco='pipe-EOF-do fzf --ansi --reverse' && alias fzf='pipe-EOF-do fzf --ansi --reverse'
cmdcheck fzy && alias fzy='fzy -l $(($(tput lines)/2))'

function pecocat() {
	if cmdcheck fzf; then
		local CAT='cat'
		if cmdcheck bat; then
			local CAT='bat --color=always'
		elif cmdcheck ccat; then
			local CAT='ccat -C=always'
		fi
		pipe-EOF-do fzf --ansi --reverse --preview 'F=`echo {} | cut -d":" -f1`; [[ -d $F ]] && ls $F; [[ -f $F ]] && '"$CAT"' $F'
	else
		peco
	fi
}

alias pv='pecovim'
alias pvim='pecovim'
alias cpeco='command peco'
alias pecovim='pecocat | xargs-vim'
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
alias gvim='git status -s | cut -c4- | pecovim'
alias gmvim='git status -s | cut -c4- | pecovim'
alias ftvim='pvft'
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
function cdpeco() {
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
alias gcd='cd "$(git ls-tree -dr --name-only --full-name --full-tree HEAD | sed -e "s|^|`git rev-parse --show-toplevel`/|" | peco)"'
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
	local PECO="peco"
	cmdcheck fzf && local PECO="fzf --reverse --ansi --multi --preview 'git log --oneline --decorate --graph --branches --tags --remotes --color'"
	local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative))" --sort=-committerdate refs/heads/ refs/remotes/ refs/tags/ | sed -e "s/^refs\///g" | bash -c $PECO | awk '{print $1}')
	[[ -n $branch ]] && git checkout $branch
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

if cmdcheck fzf; then
	function calc() {
		: | fzf --ansi --multi --preview 'echo {q}"="; echo {q} | bc -l' --preview-window 'up:2' --height '1%' --print-query | bc -l
	}
	function ppgrep() {
		: | fzf --ansi --multi --preview '[[ -n {q} ]] && { pgrep -l {q}; echo "----"; pgrep -alf {q}; }' --preview-window 'down:70%' --height '80%' --print-query | xargs pgrep -l
	}
fi
