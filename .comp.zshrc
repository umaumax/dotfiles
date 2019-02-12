#!/usr/bin/env zsh

# FYI
# [zsh\-completions/zsh\-completions\-howto\.org at master · zsh\-users/zsh\-completions]( https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org )
# [zsh の補完関数の自作導入編]( https://gist.github.com/mitukiii/4954559 )

# NOTE: copy completion
cmdcheck oressh && compdef oressh=ssh
cmdcheck clip-share && compdef clip-share=ssh
cmdcheck autosshpass && compdef autosshpass=ssh
cmdcheck autoscppass && compdef autoscppass=scp
cmdcheck autorsyncpass && compdef autorsyncpass=rsync
cmdcheck autooresshpass && compdef autooresshpass=ssh
cmdcheck sshpass && compdef sshpass=ssh

function _color() {
	compadd $(
		cat <<EOF
BLACK
RED
GREEN
YELLOW
BLUE
PURPLE
LIGHT_BLUE
WHITE
GRAY
DEFAULT
EOF
	)
}
function color() {
	[[ $# -lt 1 ]] && echo "$0 [COLOR]" && exit 1
	eval echo -en \$$1
}
compdef _color color

function cls() {
	echo ${1:-.} | tee $(tty) | c
}
compdef cls=ls
function cpwd() {
	echo $(pwd)/$1 | tee $(tty) | c
}
compdef cpwd=ls
function cbasedirname() {
	basedirname | tee $(tty) | c
}
compdef cbasedirname=ls
function chost() {
	echo $1 | tee $(tty) | c
}
compdef chost=ssh
