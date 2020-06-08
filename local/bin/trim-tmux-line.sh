#!/usr/bin/env bash

# for clean tmux select-line

function main() {
  # mainly for vim, zsh(prezto), gdb, and so on
  sed -E 's/^(.?.?[0-9]+ |\$ |# |.* ❯❯❯ |>>> |\(gdb\) )//' \
    | sed -E 's/(✘ [0-9]+)? *V([ 0-9a-zA-Z_/:-]|✱|◼|⬆|⬇|✭|✚ )*$//' | sed -E 's/ *[»↲]?$//' | tr -d '\n'
}

main "$@"

function test() {
  {
    echo "$ echo 1"
    echo "# echo 1"
    echo "  123 vim line"
    echo "~/path ❯❯❯ prezto"
    echo "~/path ❯❯❯ prezto ✘ 130  Vmaster"
    echo "~/path ❯❯❯ prezto ✘ 130  Vmaster:rebase-interactive"
    echo "[SSH] ~ ❯❯❯ prezto                                                                                                                                                                             V"
  } | main
}
