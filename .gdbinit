source ~/dotfiles/.config/gdb/.gdb-dashboard
# for stack-inspector command
source ~/dotfiles/.config/gdb/stack-inspector.py

# for telling python lib path to bundled gdb python
source ~/dotfiles/.config/gdb/init.py
source ~/dotfiles/.config/gdb/common.py
source ~/dotfiles/.config/gdb/rust.py
source ~/dotfiles/.config/gdb/pipe.py
source ~/dotfiles/.config/gdb/gdb-trace.py

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

# set print static-members off
# シンボリック形式のアドレス表示の際に、シンボルのソース・ファイル名と行番号を表示する
set print symbol-filename on

set charset UTF-8
#set charset ASCII

# C++の仮想関数テーブルを綺麗に表示する。
set print vtbl   on

# for c++
set print demangle on
set print asm-demangle on
set demangle-style auto

# 構造体のメンバを1行ずつ表示できる
set print pretty on

set verbose on

# quitコマンドで終了するときに確認しない
define hook-quit
  set confirm off
end

define local
  info args
  info locals
end
define lo
  local
end
define var
  if $argc == 0
    info variables
  end
  if $argc == 1
    info variables $arg0
  end
  if $argc > 1
    help var
  end
end
document var
Print all global and static variable names (symbols), or those matching REGEXP.
Usage: var <REGEXP>
end

define threads
  info threads
end
document threads
Print threads in target.
end

define th
  info threads
end

# NOTE: load $PWD/.gdbinit
set auto-load local-gdbinit

# for Ubuntu16.04
py import os; p=os.environ['HOME']+"/local/src/glibc-2.23"; os.path.exists(p) and (gdb.execute("dir {}".format(p)), print("\033[0;1;35m[src info automatically loaded] by 'dir {}'".format(p)))
# for Ubuntu18.04
py import os; p=os.environ['HOME']+"/local/src/glibc-2.27"; os.path.exists(p) and (gdb.execute("dir {}".format(p)), print("\033[0;1;35m[src info automatically loaded] by 'dir {}'".format(p)))

echo \033[0;1;33m[plugin commands list]\n\033[0m
echo \033[0;1;34m* stack-inspector\n\033[0m
echo \033[0;1;34m* pipe\n\033[0m
echo \033[0;1;34m* set-rust-substitute-path\n\033[0m
echo \033[0;1;34m* '\\C-x\\C-r': fzf history search\n\033[0m
echo \033[0;1;34m* '\\C-x\\C-x': fzf snippet search\n\033[0m
