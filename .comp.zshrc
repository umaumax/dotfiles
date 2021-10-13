#!/usr/bin/env zsh

# NOTE: copy completion
cmdcheck oressh && compdef oressh=ssh
cmdcheck clip-share && compdef clip-share=ssh
cmdcheck autosshpass && compdef autosshpass=ssh
cmdcheck autoscppass && compdef autoscppass=scp
cmdcheck autorsyncpass && compdef autorsyncpass=rsync
cmdcheck autooresshpass && compdef autooresshpass=ssh
cmdcheck sshpass && compdef sshpass=ssh

cmdcheck rust-gdb && compdef rust-gdb=gdb

function zsh_comp_file_list() {
  # NOTE: e.g. /usr/local/share/zsh/functions
  echo $fpath | tr ' ' '\n' | xargs -L 1 -I{} find {} -maxdepth 1 -name '_*'
}

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
  [[ $# -lt 1 ]] && echo "$0 [COLOR]" && return 1
  eval echo -en "\${${1}}${1}"
}
compdef _color color

function cls() {
  echo -n ${1:-.} | tee $(tty) | c
}
compdef cls=ls
function cpwd() {
  echo -n $(pwd)/$1 | tee $(tty) | c
}
compdef cpwd=ls
function cbasedirname() {
  basedirname | tee $(tty) | c
}
compdef cbasedirname=ls
function chost() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
$(basename "$0") <press tab key to comp host by sshconfig>
EOF
    return 1
  fi
  echo -n $1 | tee $(tty) | c
}
compdef chost=ssh

function _fifocat() {
  local tmp_dirpath="${TMPDIR}/tmp-fifo-dir"
  _files -W "$tmp_dirpath"
}
compdef _fifocat fifocat

function _screen() {
  local cur prev
  cur=${words[CURRENT]}
  prev=${words[CURRENT - 1]}
  if [[ "$prev" == '-r' ]] || [[ "$prev" == '-s' ]]; then
    compadd $(
      # get current screen session list
      screen -ls | grep '^'$'\t' | awk '{print $1}'
    )
    return
  fi
  _arguments \
    -r'[attach session]' \
    -ls'[list]' \
    -dmS'[daemon]' \
    -s'[select session]' \
    -X'[screen command]'
}
compdef _screen screen
