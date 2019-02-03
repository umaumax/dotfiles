# HINT: if you want to calclate login time uncomment next line
# DEBUG_MODE='ON'
[[ -n $DEBUG_MODE ]] && zmodload zsh/zprof && zprof

if [[ "$OSTYPE" == darwin* ]]; then
	export BROWSER='open'
fi

#
# Language
#

# FYI: [基本の復習: 優先順位は LANGUAGE, LC\_ALL, LC\_xxx, LANG の順 \- Qiita]( https://qiita.com/kitsuyui/items/4ee5bf1baa47553be477 )
if [[ -z "$LANG" ]]; then
	export LANG='en_US.UTF-8'
fi
export LANGUAGE=''
export LANG='ja_JP.UTF-8'
# if [[ -z "$LANGUAGE" ]]; then
# 	export LANGUAGE='en_US.UTF-8'
# fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
	/usr/local/{bin,sbin}
	$path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'
# ubuntu
[[ -e "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]] && export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"

# # Set the Less input preprocessor.
# # Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
#if (( $#commands[(i)lesspipe(|.sh)] )); then
#	export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
#fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
	export TMPDIR="/tmp/$LOGNAME"
	mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# ---- zsh ----
# ---- bash ----

funccheck() { declare -f "$1" >/dev/null; }
cmdcheck() {
	type "$1" >/dev/null 2>&1
	local code=$?
	[[ ! $code ]] && _NO_CMD="$_NO_CMD:$1"
	return $code
}

#alias cmdcheck='type > /dev/null 2>&1'
#alias funccheck='declare -f > /dev/null'

prepend_path() {
	local p="$1"
	[[ -d $p ]] && export PATH=$p:$PATH
}
append_path() {
	local p="$1"
	[[ -d $p ]] && export PATH=$PATH:$p
}
exist() {
	var=$1
	[[ -e $var ]]
}

#
# Editors
#

VIM=vim
cmdcheck nvim && VIM=nvim
export EDITOR=$VIM
export GIT_EDITOR=$VIM
export VISUAL=$VIM
export PAGER='less'
# [manをVimで見る]( https://rcmdnk.com/blog/2014/07/20/computer-vim/ )
# NOTE: both vim and nvim is available, but maybe vim is better (because of no readonly warning message)
export MANPAGER="/bin/sh -c \"col -b -x| VIM_MAN_FLAG=1 vim -R --cmd 'set ft=man' -c 'set nolist nonu noma' -\""

export LC_CTYPE="ja_JP.UTF-8" # mac default is "UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

# ----

# golang
mkdir -p ~/go/{3rd,my}/{bin,src,pkg}
if [[ -d ~/go ]]; then
	# go1.9~: If $GOPATH is not specified, $HOME/go will be used by default:
	export GOPATH=~/go/3rd:~/go/my
	append_path ~/go/3rd/bin
	append_path ~/go/my/bin
fi
# NOTE: for ubuntu
if [[ -d "/usr/lib/go-1.10" ]]; then
	append_path /usr/lib/go-1.10/bin
fi

# c++
mkdir -p ~/cpp/{3rd,orig}/{include,lib,src}
if [[ -d ~/cpp ]]; then
	CPPROOT=~/cpp
	append_path $CPPROOT/orig/bin
	append_path $CPPROOT/3rd/bin
	export CPATH=$CPPROOT/orig/include:$CPPROOT/3rd/include
	export LIBRARY_PATH=$CPPROOT/orig/lib:$CPPROOT/3rd/lib
	unset CPPROOT
fi

[[ -e /usr/local/share/git-core/contrib/diff-highlight/diff-highlight ]] && export GIT_DIFF_HIGHLIGHT='/usr/local/share/git-core/contrib/diff-highlight/diff-highlight'
[[ -e /usr/share/doc/git/contrib/diff-highlight/diff-highlight ]] && export GIT_DIFF_HIGHLIGHT='/usr/share/doc/git/contrib/diff-highlight/diff-highlight'

# clang(LLVM)
prepend_path /usr/local/bin
prepend_path ~/local/bin
# for pip
# [systemd\-path user\-binaries]( https://unix.stackexchange.com/questions/316765/which-distributions-have-home-local-bin-in-path )
append_path ~/.local/bin

# python
## pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH=${PYENV_ROOT}/bin:$PATH
if cmdcheck pyenv; then
	exist ~/python/lib/ && export PYTHONPATH=$var
	# for blender add-ons
	[[ -d "/Applications/blender.app/Contents/Resources/2.78/scripts/addons" ]] && export PYTHONPATH="/Applications/blender.app/Contents/Resources/2.78/scripts/addons:PYTHONPATH"

	# NOTE: slow
	# NOTE: if you add --no-rehash (it will be a little faster)
	eval "$(pyenv init -)"

	# NOTE: for virtualenv
	# 	eval "$(pyenv virtualenv-init -)"
fi

# NOTE: slow
# cmdcheck python3 && python3 -m site &>/dev/null && PATH="$PATH:$(python3 -m site --user-base)/bin"
# cmdcheck python2 && python2 -m site &>/dev/null && PATH="$PATH:$(python2 -m site --user-base)/bin"

# rust
append_path "$HOME/.cargo/bin"

# NOTE: disable brew analytics
export HOMEBREW_NO_ANALYTICS

# linuxbrew
# FYI: [Linuxbrew \| The Homebrew package manager for Linux]( http://linuxbrew.sh/ )
if [[ ! -d ~/.linuxbrew ]] && [[ $(uname) == "Linux" ]]; then
	git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
fi
if [[ -d ~/.linuxbrew ]]; then
	export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
	export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
	export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
	export PKG_CONFIG_PATH="$HOME/.linuxbrew/lib64/pkgconfig:$HOME/.linuxbrew/lib/pkgconfig:$PKG_CONFIG_PATH"
	export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"
fi

# for vim
# prepend_path /Applications/MacVim.app/Contents/bin/

# for color output
## easy color output
export BLACK="\033[0;30m"
export RED="\033[0;31m"
export GREEN="\033[0;32m"
export YELLOW="\033[0;33m"
export BLUE="\033[0;34m"
export PURPLE="\033[0;35m"
export LIGHT_BLUE="\033[0;36m"
export WHITE="\033[0;37m"
export GRAY="\033[0;90m"
export DEFAULT="\033[0m"

# brew install source-highlight
# cmdcheck src-hilite-lesspipe.sh && export LESSOPEN="| src-hilite-lesspipe.sh %s"
export MORE='--quit-if-one-screen -MR'
[[ -n $BASH ]] && export LESS='-R'

# grep: warning: GREP_OPTIONS is deprecated
# export GREP_OPTIONS='--color=auto'
export GREP_COLOR='4;1;31'
export GREP_COLORS='sl=0:cx=1;32:mt=1;31:ms=4;1;31:mc=1;31:fn=1;32:ln=34:bn=36:se=0;37'

# NOTE: for bat
# FYI: bat --list-themes
export BAT_THEME=TwoDark

[[ $(uname) == "Darwin" ]] && export LSCOLORS=gxfxcxdxbxegexabagacad

# NOTE: X11が有効な場合にはクリップボードを使用可能とする(特にsshログイン時)
if [[ -z $DISPLAY ]]; then
	export DISPLAY=":0"
	xset q >/dev/null 2>&1 || unset DISPLAY
fi

# NOTE: for my markdowns
export MDROOT="$HOME/md"
export MDLINK="$HOME/md/link"
[[ -d $MDROOT ]] && [[ ! -d $MDLINK ]] && mkdir -p $MDLINK

# cmdcheck micro && export EDITOR='micro' && export VISUAL=$EDITOR

if [[ -s "${ZDOTDIR:-$HOME}/.local.zprofile" ]]; then
	source "${ZDOTDIR:-$HOME}/.local.zprofile"
fi

# for tig edit vim command
mkdir -p ~/local/bin
cmdcheck nvim && [[ ! -f ~/local/bin/vim ]] && ln -s $(which nvim) ~/local/bin/vim

# ----

[[ -n $BASH ]] && export HISTFILESIZE=100000
[[ -n $BASH && -f ~/.bashrc ]] && source ~/.bashrc
# ---- bash ----

[[ -n $DEBUG_MODE ]] && (which zprof >/dev/null 2>&1) && zprof
