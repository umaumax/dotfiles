#!/usr/bin/env bash
set -eux

if ! type >/dev/null 2>&1 rustup; then
  echo 'install rustup first!'
  echo 'e.g. brew install rustup; rustup-init; rustup toolchain add nightly; rustup install nightly'
  exit 1
fi

cargo +nightly install racer
cargo install bat
cargo install bingrep
cargo install exa
cargo install git-delta
cargo install hexyl
cargo install hyperfine
cargo install procs
cargo install ripgrep
cargo install tokei

# NOTE: rust repl
# command: evcxr
cargo install evcxr_repl

# NOTE: not working at Mac OS X
cargo install bandwhich

# NOTE: for lua formatter
cargo install stylua

# cargo install gitui --version 0.10.1 # build error
# cargo install gitui --version 0.10.0 # build error
cargo install gitui --version 0.9.1

# typo check command: typos
cargo install typos-cli

# NOTE: for adding lib dependency
cargo install cargo-edit
cargo install cargo-license
cargo install cargo-tree
cargo install cargo-fix
cargo install cargo-tomlfmt
cargo install cargo-expand
cargo install cargo-binutils
cargo install cargo-docserver

# any text to tree style converter
cargo install --git https://github.com/KoharaKazuya/forest

cargo install --git https://github.com/umaumax/ecat

# NOTE: for Rust Language Server
rustup component add rls rust-analysis rust-src
