#!/usr/bin/env bash
set -eux

if ! type >/dev/null 2>&1 rustup; then
  echo 'install rustup first!'
  echo 'e.g. brew install rustup; rustup-init; rustup toolchain add nightly; rustup install nightly'
  exit 1
fi

# NOTE: A command-line hex viewer
cargo install hexyl

# NOTE: Count your code, quickly.
cargo install tokei

# NOTE: for git diff color output
cargo install git-delta

# NOTE: rust repl
# command: evcxr
cargo install evcxr_repl

# NOTE: for binary grep
cargo install bingrep

# NOTE: for vim deoplete-rust
cargo +nightly install racer

# NOTE: for enhanced ps command
cargo install procs

# NOTE: for enhanced grep command
cargo install ripgrep

# NOTE: not working at Mac OS X
cargo install bandwhich

# cargo install gitui --version 0.10.1 # build error
# cargo install gitui --version 0.10.0 # build error
cargo install gitui --version 0.9.1

# NOTE: for adding lib dependency
# cargo add xxx
cargo install cargo-edit
# cargo-license
cargo install cargo-license
# cargo tree
cargo install cargo-tree
# cargo fix
cargo install cargo-fix
# cargo tomlfmt
cargo install cargo-tomlfmt
# cargo expand
cargo install cargo-expand
# cargo nm
cargo install cargo-binutils

cargo install cargo-docserver

# any text to tree style converter
cargo install --git https://github.com/KoharaKazuya/forest

cargo install --git https://github.com/umaumax/ecat

cargo install bat
cargo install exa

# typo check command: typos
cargo install typos-cli
