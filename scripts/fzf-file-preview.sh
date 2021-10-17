#!/usr/bin/env bash
line="$*"
F="$(printf '%s' "$line" | cut -d':' -f1)"
L="$(printf '%s' "$line" | awk -F':' "{print \$2}")"

if [[ -d "$F" ]]; then
  ls --color=always -alh "$F"
elif [[ -f "$F" ]]; then
  range=$(echo "$(tput lines) * 8 / 10 / 2 - 1" | bc)
  wcat "$F:$L:$range"
fi
