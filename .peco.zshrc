! cmdcheck peco && return

if [[ $(uname -a) =~ "Ubuntu" ]]; then
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

alias pv='pecovim'
alias pvim='pecovim'
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
	local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative))" --sort=-committerdate refs/heads/ refs/remotes/ refs/tags/ | sed -e "s/^refs\///g" | peco | awk '{print $1}')
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
