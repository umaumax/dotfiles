if [[ "$OSTYPE" == darwin* ]]; then
	export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
	export LANG='en_US.UTF-8'
fi

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
# set -x # for debug
[[ $(uname) == 'Darwin' ]] && export _Darwin=1
[[ $(uname -a) =~ 'Ubuntu' ]] && export _Ubuntu=1
[[ $(uname) == 'Linux' ]] && export _Linux=1

function funccheck() { declare -f "$1" >/dev/null; }
function cmdcheck() { type "$1" >/dev/null 2>&1; }

#alias cmdcheck='type > /dev/null 2>&1'
#alias funccheck='declare -f > /dev/null'

append_any_path() { [[ -d "$2" ]] && export "$1"=$(eval echo '$'$1)":$2"; }
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

export LC_CTYPE="ja_JP.UTF-8" # mac default is "UTF-8"

# ----

# golang
if [[ -d ~/go ]]; then
	# go1.9~: If $GOPATH is not specified, $HOME/go will be used by default:
	export GOPATH=~/go/3rd:~/go/my
	append_path ~/go/3rd/bin
	append_path ~/go/my/bin
fi

# python
## pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH=${PYENV_ROOT}/bin:$PATH
if cmdcheck pyenv; then
	exist ~/python/lib/ && export PYTHONPATH=$var
	## for blender add-ons
	append_any_path PYTHONPATH /Applications/blender.app/Contents/Resources/2.78/scripts/addons
	eval "$(pyenv init -)"
fi

# c++
if [[ -d ~/cpp ]]; then
	CPPROOT=~/cpp
	append_path $CPPROOT/orig/bin
	append_path $CPPROOT/3rd/bin
	# export CPATH=$CPPROOT/include:$CPPROOT/include/HElib/src
	export CPATH=$CPPROOT/orig/include:$CPPROOT/3rd/include
	export LIBRARY_PATH=$CPPROOT/orig/lib:$CPPROOT/3rd/lib
	unset CPPROOT
fi

# clang(LLVM)
prepend_path /usr/local/bin
prepend_path ~/local/bin

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
export GRAY="\033[0;39m"
export DEFAULT="\033[0m"

export MORE='-R'
[[ -n $BASH ]] && export LESS='-R'

# grep: warning: GREP_OPTIONS is deprecated
# export GREP_OPTIONS='--color=auto'
export GREP_COLOR='4;1;31'
export GREP_COLORS='sl=0:cx=1;32:mt=1;31:ms=4;1;31:mc=1;31:fn=1;32:ln=34:bn=36:se=0;37'

# X11が有効な場合にはクリップボードを使用可能とする(特にsshログイン時)
[[ -n $_Ubuntu && -z $DISPLAY ]] && export DISPLAY=":0"

# cmdcheck micro && export EDITOR='micro' && export VISUAL=$EDITOR

if [[ -s "${ZDOTDIR:-$HOME}/.local.zprofile" ]]; then
	source "${ZDOTDIR:-$HOME}/.local.zprofile"
fi

# ----

[[ -n $BASH ]] && export HISTFILESIZE=100000
[[ -n $BASH && -f ~/.bashrc ]] && source ~/.bashrc
# ---- bash ----
