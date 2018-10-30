# NOTE: for remote ssh
[ -f ~/.bashrc ] && source ~/.bashrc

function cmdcheck() { type "$1" >/dev/null 2>&1; }
cmdcheck vim && alias vi='vim'
