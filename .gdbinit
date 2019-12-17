source ~/dotfiles/.config/gdb/.gdb-dashboard
source ~/dotfiles/.config/gdb/stack-inspector.py
# for stack-inspector command

source ~/dotfiles/.config/gdb/pipe.py

alias -a exit = quit

# FYI: [gdbで効率的にデバッグするためのTips \- Qiita]( https://qiita.com/aosho235/items/e8efd18364408231062d )
set history save on
set history size 100000
set history filename ~/.gdb_history

# NOTE: disable --Type <return> to continue, or q <return> to quit--- / “debugging --
set pagination off

# NOTE: disable below output
# (gdb) p "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
# $6 = 'a' <repeats 30 times>
set print repeats 0


set charset UTF-8
#set charset ASCII

# for c++
set print demangle on

# 構造体のメンバを1行ずつ表示できる
set print pretty on

# quitコマンドで終了するときに確認しない
define hook-quit
  set confirm off
end

# NOTE: load $PWD/.gdbinit
set auto-load local-gdbinit

echo \033[0;1;33m[plugin commands list]\n\033[0;1;34m* stack-inspector\n\033[0m
