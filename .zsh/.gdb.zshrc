if ! cmdcheck gdb; then
  return
fi

# NOTE: for disable copyright output
alias gdb='gdb -q'
alias sudo-gdb='sudo env PATH="$PATH" gdb -q'

if cmdcheck gdb-multiarch; then
  alias gdb='gdb-multiarch -q'
  alias sudo-gdb='sudo env PATH="$PATH" gdb-multiarch -q'
fi

cmdcheck rust-gdb && function rust-gdb() {
  # FYI: [rustのgdbでのdebugでsourceを出力したかった \- 雑なメモ書き]( https://hiroyukim.hatenablog.com/entry/2019/11/29/190235 )
  # auto apply rust substitute-path
  local debug_src_opt=()
  for arg in "$@"; do
    # search target exec filepath
    if [[ -x "$arg" ]]; then
      local debug_src=$(strings $arg | grep -o '^/rustc/[^/]\+/' | uniq)
      if [[ -n "$debug_src" ]]; then
        debug_src_opt=("${debug_src_opt[@]}" --eval-command "set substitute-path $debug_src $(rustc --print=sysroot)/lib/rustlib/src/rust/")
        break
      fi
    fi
  done

  local gdb_cmd="$(\where -p gdb | head -n1)"
  cmdcheck gdb-multiarch && gdb_cmd="$(\where -p gdb-multiarch | head -n1)"
  if [[ -z "$SUDO_GDB" ]]; then
    # NOTE: if RUST_GDB=gdb use /usr/bin/gdb, if you want to use e.g. ~/local/bin/gdb set full path of it
    RUST_GDB="${RUST_GDB:-$gdb_cmd}" command rust-gdb -q "$@" "${debug_src_opt[@]}"
  else
    sudo env PATH="$PATH" RUST_GDB="${RUST_GDB:-$gdb_cmd}" rust-gdb -q "$@" "${debug_src_opt[@]}"
  fi
} && alias sudo-rust-gdb='SUDO_GDB=1 rust-gdb'

function go-gdb() {
  local gdb_cmd="gdb"
  cmdcheck gdb-multiarch && gdb_cmd='gdb-multiarch'

  local GOROOT=$(go env GOROOT)
  local GO_GDB="${GO_GDB:-$gdb_cmd}"

  # NOTE: load automatically by .debug_gdb_script section
  if [[ -z "$SUDO_GDB" ]]; then
    ${GO_GDB} -q \
      --directory="$GOROOT" \
      -iex "add-auto-load-safe-path $GOROOT/src/runtime/runtime-gdb.py" \
      "$@"
  else
    sudo env PATH="$PATH" ${GO_GDB} -q \
      --directory="$GOROOT" \
      -iex "add-auto-load-safe-path $GOROOT/src/runtime/runtime-gdb.py" \
      "$@"
  fi
}
alias sudo-go-gdb='SUDO_GDB=1 go-gdb'
