#!/usr/bin/env bash

function help() {
  command cat <<EOF 1>&2
usage:
  $(basename "$0") [file]
  cat [file] | $(basename "$0")
EOF
}

function main() {
  if ! type >/dev/null 2>&1 addr2line; then
    echo 1>&2 "required: addr2line"
    return 1
  fi
  if [[ $# -gt 0 ]]; then
    if [[ $1 =~ ^(-h|-{1,2}help)$ ]]; then
      help
      return 1
    fi
    cat "$@" | main
    return
  fi

  # -r: Backslash  does not act as an escape character.  The backslash is considered to be part of the line. In particular, a backslash-newline pair can not be used as a line continuation.
  while IFS= read -r line || [[ -n "$line" ]]; do
    local filepath=""
    local addr=""
    if [[ $line =~ ^.*\(\+.*\)\[0x.*\]$ ]]; then
      filepath=$(echo $line | sed -E 's/\(.*//')
      addr=$(echo $line | sed -E 's/.*\(\+0x([0-9a-f]+)\).*/\1/')
    elif [[ $line =~ ^.*\(_.*\)\[0x.*\]$ ]]; then
      local symbol
      local symbol_addr
      local offset
      filepath=$(echo $line | sed -E 's/\(.*//')
      symbol=$(echo $line | sed -E 's/.*\((_.+)\+0x[0-9a-f]+\).*/\1/')
      offset=$(echo $line | sed -E 's/.*\(.+\+0x([0-9a-f]+)\).*/\1/')
      symbol_addr=$(nm -D $filepath | grep "${symbol}$" | cut -f1 -d" ")
      addr=$(printf "%x" $((0x$symbol_addr + 0x$offset)))
    fi

    if [[ -n $filepath ]] && [[ -n $addr ]]; then
      echo -n "$line "
      echo -n "${BLUE}"
      addr2line -e $filepath 0x$addr -f -C | tr '\n' ' '
      echo -n "${DEFAULT}"
      echo
    else
      echo $line
    fi
  done
}

main "$@"
