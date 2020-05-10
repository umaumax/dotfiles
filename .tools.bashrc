#!/usr/bin/env bash

function clear_path() {
  local ret=$(cat | sed -E 's/:.*$//')
  local ret0=''
  while [[ $ret != $ret0 ]]; do
    local ret0=$ret
    local ret=$(echo $ret | sed -E 's://+:/:g' | sed -E 's:(([^/]*/)?\.\./|\./)::g')
  done
  echo -n "$ret"
}

# NOTE: for test
[[ $# -ge 1 ]] && eval "$@"
