#!/usr/bin/env bash
# NOTE: for remote ssh
[ -f ~/.bashrc ] && source ~/.bashrc

PS1='\[\e[1;33m\]\u@\h \w ->\n\[\e[1;36m\]\$\[\e[m\] '

# [Bashでコマンド履歴から検索して実行する \- Qiita]( https://qiita.com/quwa/items/3a23c9dbe510e3e0f58e )
stty stop undef

function cmdcheck() { type "$1" >/dev/null 2>&1; }
cmdcheck vim && alias vi='vim'
