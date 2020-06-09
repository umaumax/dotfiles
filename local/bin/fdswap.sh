#!/usr/bin/env bash

function help() {
  local pid=${1:-"<pid>"}
  command cat <<EOF 1>&2
usage:
  $(basename "$0") $pid [fd:filepath]...
e.g.
  $(basename "$0") $pid 1:$(tty) 2:$(tty)
  $(basename "$0") $pid 1:/tmp/stdout.log 2:$/tmp/stderr.log
  $(basename "$0") $pid 1:- 2:$(tty) # skip set stdout
  $(basename "$0") $pid -n 1:$(tty) # dryrun
EOF
  if [[ $# == 1 ]]; then
    {
      echo
      echo "[fd list]"
      ls -l /proc/$pid/fd
    } 1>&2
  fi
}

function main() {
  if [[ $# -lt 1 ]]; then
    help
    return 1
  fi

  local pid=$1
  if [[ $# -lt 2 ]]; then
    help "$pid"
    return 1
  fi
  shift

  local tmpfile
  tmpfile=$(mktemp)
  local dryrun_mode=0
  {
    for arg in "$@"; do
      if [[ $arg == "-n" ]]; then
        dryrun_mode=1
        continue
      fi
      local fd=${arg%:*}
      local filepath=${arg##*:}
      if [[ "$fd" == "$filepath" ]]; then
        echo "invalid arg" 1>&2
        help
        return 1
      fi
      if [[ $filepath == "-" ]]; then
        continue
      fi
      mkdir -p "$(dirname $filepath)"
      echo "call close(${fd})"
      # 66: O_CREAT|O_RDWR
      echo "call open(\"${filepath}\", 66, 066)"
    done
    echo "detach"
    echo "quit"
  } >>"$tmpfile"

  if [[ $dryrun_mode == 0 ]]; then
    sudo gdb -q -p "$pid" --nx -x "$tmpfile"
  else
    local script=$(cat "$tmpfile" | awk '{l=l (NR==1?"":"\\n") $0}END{print l}')
    printf "%s\n" "echo '$script' | sudo gdb -q -p "$pid" --nx"
    # or
    # printf "echo %q | sudo gdb -q -p "$pid" --nx\n" "$script"
  fi
}

main "$@"
