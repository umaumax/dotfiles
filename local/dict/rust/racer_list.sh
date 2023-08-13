#!/usr/bin/env bash

# 0: no
# 1: std::xxx
# if -1: all
TRAVERSE_MAX_LEVEL=${TRAVERSE_MAX_LEVEL:-"-1"}

function get_list() {
  local code="use $1::"
  racer complete 1 $((${#code})) - <<<"$code" | grep 'MATCH' | sed -E 's/^MATCH ([^,]+),.*$/\1/' | grep -v '^std$' | grep -v '^realstd$'
  # or simply use below command?
  # racer complete std::io::B
}

function get_modules() {
  get_list "$1" | grep '^[a-z0-9_]*$'
}

# e.g. Struct, Enum, Function, Trait, Type, Const, ...
function get_not_modules() {
  get_list "$1" | grep -v '^[a-z0-9_]*$'
}

function traverse_modules() {
  local base_module="$1"
  local level
  level=$(echo "$base_module" | grep -o '::' | grep -c .)
  if [[ $TRAVERSE_MAX_LEVEL != -1 ]] && [[ $level -ge $TRAVERSE_MAX_LEVEL ]]; then
    return 1
  fi

  local modules
  modules=($(get_modules "$base_module"))
  for module in "${modules[@]}"; do
    local new_modules="$base_module::$module"
    echo "$new_modules"
    traverse_modules "$new_modules"
  done

  local others
  others=($(get_not_modules "$base_module"))
  for other in "${others[@]}"; do
    local tmp="$base_module::$other"
    echo "$tmp"
  done
}

function main() {
  traverse_modules "$1"
}
main "$@"
