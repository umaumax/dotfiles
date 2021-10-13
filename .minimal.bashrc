#!/usr/bin/env bash

# NOTE: for remote ssh
if [[ -r /etc/profile ]]; then
  source /etc/profile
fi
if [[ -r ~/.bash_profile ]]; then
  source ~/.bash_profile
elif [[ -r ~/.bash_login ]]; then
  source ~/.bash_login
elif [[ -r ~/.profile ]]; then
  source ~/.profile
fi

# NOTE: oressh use --rcfile option (which does not execute as login shell)
! shopt login_shell >/dev/null 2>&1 && [[ -f ~/.bashrc ]] && source ~/.bashrc

shopt -s autocd
shopt -s dotglob

PS1='\[\e[1;33m\]\u@\h \w\n\[\e[1;36m\]\$\[\e[m\] '

# ignoredups,ignorespace
export HISTCONTROL=ignoreboth

# NOTE: disable ^S keymap
stty stop undef

function cmdcheck() { type "$1" >/dev/null 2>&1; }
if cmdcheck vim; then
  alias vi='vim'
else
  alias vim='vi'
fi

! cmdcheck tree && function tree() {
  pwd
  find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'
}

alias fix-terminal='stty sane; resize; reset'

alias grep='grep --color=auto'

alias h='history'
alias cl='clear'

if [[ $(uname) == "Darwin" ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias l='ls'
alias ll='lsal'
alias lsal='ls -al'
alias lsalt='ls -alt'
alias lsaltr='ls -altr'

alias type='type -a'

alias qq='exit'
alias qqq='exit'
alias qqqq='exit'
