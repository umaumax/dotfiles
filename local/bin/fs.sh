#!/usr/bin/env bash

export READLINE_SEARCH_HISTORY_INPUT_FILEPATH=${READLINE_SEARCH_HISTORY_INPUT_FILEPATH:-~/dotfiles/snippets/gdb_snippet.txt}
export READLINE_SEARCH_HISTORY_OUTPUT_FILEPATH=${READLINE_SEARCH_HISTORY_OUTPUT_FILEPATH:-~/.config/gdb/.tmp.inputrc}
export READLINE_SEARCH_HISTORY_KEYBIND=${READLINE_SEARCH_HISTORY_KEYBIND:-'\C-b\C-z'}
if [[ ! -v READLINE_SEARCH_HISTORY_COMMAND ]]; then
  # NOTE: for comment(90: gray)
  GREY=$'\e[90m'
  DEFAULT=$'\e[0m'
  GREEN=$'\e[92m'
  READLINE_SEARCH_HISTORY_COMMAND="grep -v '^#' | sed -E 's/^([^]]*] *)/$GREEN\\1$DEFAULT/g' | sed -E 's/##(.*)$/$GREY##\\1$DEFAULT/' | awk 'NF' | fzf --ansi | sed -E 's/##.*$//' | sed -E 's/^[^]]*] *//g'"
fi
export READLINE_SEARCH_HISTORY_COMMAND="$READLINE_SEARCH_HISTORY_COMMAND"
f
