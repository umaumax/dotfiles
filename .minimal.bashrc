#!/usr/bin/env bash
# NOTE: for remote ssh
if [[ -r /etc/profile ]]; then source /etc/profile; fi
if [[ -r ~/.bash_profile ]]; then
	source ~/.bash_profile
elif [[ -r ~/.bash_login ]]; then
	source ~/.bash_login
elif [[ -r ~/.profile ]]; then
	source ~/.profile
fi

# NOTE: oressh use --rcfile (not login shell)
! shopt login_shell >/dev/null 2>&1 && [[ -f ~/.bashrc ]] && source ~/.bashrc

PS1='\[\e[1;33m\]\u@\h \w\n\[\e[1;36m\]\$\[\e[m\] '

# ignoredups,ignorespace
export HISTCONTROL=ignoreboth

# [Bashでコマンド履歴から検索して実行する \- Qiita]( https://qiita.com/quwa/items/3a23c9dbe510e3e0f58e )
# NOTE: change stop=^S keymap to stop=<undef>
stty stop undef

function cmdcheck() { type "$1" >/dev/null 2>&1; }
cmdcheck vim && alias vi='vim'

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
