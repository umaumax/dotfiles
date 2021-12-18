if ! cmdcheck cargo; then
  return
fi

function cargo() {
  local cmd="cargo-$1"
  if ! cmdcheck "$cmd"; then
    command cargo "$@"
    return
  fi
  # don't run below command
  # We need to pass the same command.
  # shift 1
  # cargo hoge arg1 => cargo-hoge hoge arg1
  "$cmd" "$@"
}
function cargo-tmp() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
usage: $(basename "$0") tmp [OPTIONS] <path>
EOF
    return 1
  fi
  if [[ $# -lt 2 ]]; then
    cargo new --help
    return 1
  fi
  # drop 1st arg(tmp)
  shift 1
  tmpd
  cargo new "$@"
  local exit_code="$?"
  if [[ "$exit_code" == 0 ]]; then
    for arg in "$@"; do
      if [[ -d "$arg" ]]; then
        cd "$arg"
        break
      fi
    done
  fi
  return "$exit_code"
}
function cargo-decl() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
usage: $(basename "$0") <source code>

e.g.
cargo decl 'use ecat::config; config::Config'
EOF
    return 1
  fi
  if [[ $# -lt 2 ]]; then
    cargo new --help
    return 1
  fi
  # drop 1st arg
  shift 1

  local SRC_CODE="$1"
  racer find-definition 1 "${#SRC_CODE}" "$(\pwd | sed -E 's:/[^/]+:../:g')" <(printf '%s' "${SRC_CODE}")
}

function cargo-package-name() {
  shift 1
  cargo metadata --format-version=1 --no-deps | jq '.packages[].name' -r | sed 's/-/_/g'
}
function cargo-func-graph() {
  shift 1
  local pkgname="$(cargo package-name)"
  RUSTFLAGS="--emit=llvm-bc" cargo build

  LLVM_LINK="llvm-link-12"
  local out="./target/debug/deps/${pkgname}.bc"
  if $LLVM_LINK "./target/debug/deps/${pkgname}"-*.bc -o "$out"; then
    rust-llvm-bc-to-graph "$out" "func-graph.svg"
  else
    return 1
  fi
}

function rust-llvm-bc-to-graph() {
  # e.g. ./deps/x2trace-628954abd329ae66.bc
  local target="$1"
  local output="$2"

  if [[ $# -lt 2 ]]; then
    command cat <<EOF 1>&2
description: generate LLVM IR(bitcode) file to graphviz svg file
usage: $(basename "$0") <target_bitcode_filepath> <output_svg_filepath>
EOF
    return 1
  fi

  OPT="opt-12"
  # if you use --callgraph-dot-filename-prefix=raw, raw.callgraph.dot is created at current directory
  $OPT -dot-callgraph "$target" -analyze
  local tmpfile="${target}.callgraph.dot.tmp"
  cat "${target}.callgraph.dot" | rustfilt \
    | sed -E 's/"\{/"/; s/}"/"/' \
    | sed -E '/label/ s/\{/\\{/g; /label/ s/\}/\\}/g; /label/ s/</\\</g; /label/ s/>/\\>/g' \
    | sed '/digraph "Call graph/a rankdir=LR;' \
      >"$tmpfile"

  prune "$tmpfile" $(
    cat "$tmpfile" \
      | awk '/label=/{if (match($0, /label=".*"/)) {m=substr($0, RSTART+length("label=\""), RLENGTH-length("label=\"")-length("\"")); if (match(m, /^std::|^core::| as |^llvm|^cpp_demangle|^alloc|^__rust/)){print $1}}}' \
      | awk '{printf "-n '%s' ", $0 }'
  ) -N style=invisible 2> >(grep -v Warning) \
    | gvpr -c 'N[$.degree==0]{delete(root, $)} N[$!=NULL]{ if(hasAttr($, "style")&&aget($, "style")=="invisible"){ delete(root, $); }}' \
    | dot -Tsvg -o "$output"
}
