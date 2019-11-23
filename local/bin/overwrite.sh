#!/usr/bin/env zsh

function overwrite_pipe() {
  # -r: Backslash  does not act as an escape character.  The backslash is considered to be part of the line. In particular, a backslash-newline pair can not be used as a line continuation.
  while IFS= read -r file || [[ -n "$file" ]]; do
    if [[ ! -f "$file" ]]; then
      echo 1>&2 "[overwrite][error] not found file($file)"
      continue
    fi
    local tmp_file="$(mktemp)"
    if cat "$file" | "$@" >"$tmp_file"; then
      command mv "$tmp_file" "$file"
    else
      echo 1>&2 "[overwrite][error] failed with exit code($?)"
    fi
  done < <(cat)
}

function overwrite() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
  # arg version
    $(basename "$0") filepath... -- [filter args]

  # pipe version
    ls filepath... | $(basename "$0") [filter args]

    ls filepath... | $(basename "$0") expand -t 2 # tab to 2 spaces
    git ls-files -- '*.vim' | overwrite expand -t 2
EOF
    return 1
  fi
  if [[ -p /dev/stdin ]]; then
    overwrite_pipe "$@"
  else
    local files=()
    for arg in "$@"; do
      shift
      if [[ "$arg" == '--' ]]; then
        break
      fi
      files=("${files[@]}" "$arg")
    done
    for file in "$files"; do
      printf '%s\n' "$file"
    done | overwrite_pipe "$@"
  fi
}

overwrite "$@"
