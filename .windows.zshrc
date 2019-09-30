#!/usr/bin/env zsh
# windows setting
if [[ $OS == Windows_NT ]]; then
  # tmuxを起動するとx86_64のみになる
  # if [[ $MSYSTEM_CHOST == x86_64-pc-msys ]]; then
  if [[ -n $BASH ]]; then
    PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h (x_x)/(\[\e[35m\]$MSYSTEM\[\e[0m\]) \[\e[33m\]\w\[\e[0m\]\n\$ "
  else
    # zsh
    # NOTE:元から表示がずれるので、あえて全角文字を入れたらちょうどよくなった
    PROMPT=$(echo "\x1b[0m\x1b[01;32m[${USER}@${HOST%%.*}\x1b[0m\x1b"" ""\x1b[0m\x1b[01;35m (x_x)<($MSYSTEM)\x1b[0m\x1b"" ""\x1b[0m\x1b[01;33m"" "'%~'"\x1b[0m\x1b""\r\n"'★$ ')
    function simple_prompt() {
      PROMPT=$(echo "\x1b[0m\x1b"" ""\x1b[0m\x1b[01;33m"" "'%~'"\x1b[0m\x1b"'$ ')
    }
  fi
  export HISTFILE=${HOME}/.zsh_history
  export HISTSIZE=100000

  # NOTE: how about using windows native clip command?
  if [[ -e /dev/clipboard ]]; then
    alias p='(cat /dev/clipboard)'
    alias _c='(cat > /dev/clipboard)'
  else
    cmdcheck gopaste && alias p='gopaste'
    cmdcheck gocopy && alias _c='gocopy'
  fi

  ## windows ls color
  export LS_COLORS="di=01;36"
  alias ls='ls --color=auto --show-control-chars'

  alias cmd='winpty cmd'
  alias psh='winpty powershell'
  alias ipconfig='winpty ipconfig'
  alias ifconfig='winpty ipconfig'
  alias netstat='winpty netstat'
  alias netsh='winpty netsh'
  alias ping='winpty ping'
  alias ver='cmd.exe /c "ver"'
  alias winver='cmd.exe /c "winver" &'
  alias open='bash -c "cd \$0 && start ."'

  export PATH=~/go/bin:$PATH
  export WIN_HOME="/c/Users/$USER"

  alias fg.my.md='find "$WIN_HOME/Documents" -name "*.md" -print0 | xargs-grep-0'
  # NOTE:findでシンボリックリンクを仲介すると極端に挙動が遅くなる
  alias mdfind='_mdfind(){ find $WIN_HOME/Documents -name "*.md" -exec grep -n --color=auto "$@" {} + } && _mdfind'
  alias win-home='cd $WIN_HOME'
  alias winhome='cd $WIN_HOME'
  alias wcd='cd $WIN_HOME'
fi
