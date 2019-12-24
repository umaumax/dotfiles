#!/usr/bin/env bash

function colorlize() {
  perl -pe "s/^(\w)+/\x1b[38;5;38m$&\x1b[0m/g"
}
function escape() {
  local ret
  ret="$(printf %q "$(cat)")"
  [[ $ret == "''" ]] && return
  printf '%s' "$ret"
}
# NOTE: default setting is for gdb
READLINE_SEARCH_HISTORY_INPUT_FILEPATH=${READLINE_SEARCH_HISTORY_INPUT_FILEPATH:-~/.gdb_history}
READLINE_SEARCH_HISTORY_OUTPUT_FILEPATH=${READLINE_SEARCH_HISTORY_OUTPUT_FILEPATH:-~/.config/gdb/.tmp.inputrc}
READLINE_SEARCH_HISTORY_KEYBIND=${READLINE_SEARCH_HISTORY_KEYBIND:-'\C-b\C-z'}
READLINE_SEARCH_HISTORY_COMMAND=${READLINE_SEARCH_HISTORY_COMMAND:-'fzf --ansi'}
[[ ! -d $READLINE_SEARCH_HISTORY_OUTPUT_FILEPATH ]] && mkdir -p "$(dirname "$READLINE_SEARCH_HISTORY_OUTPUT_FILEPATH")"

cat "$READLINE_SEARCH_HISTORY_INPUT_FILEPATH" | awk '!a[$0]++' | perl -e 'print reverse<>' | colorlize \
  | eval "${READLINE_SEARCH_HISTORY_COMMAND}" \
  | echo '"'"$READLINE_SEARCH_HISTORY_KEYBIND"'": "'"$(escape)"'"' >"$READLINE_SEARCH_HISTORY_OUTPUT_FILEPATH"
