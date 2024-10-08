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
# NOTE: for toml formatter
cargo install taplo-cli

cargo install gitui


cargo install hwatch

# enhanced less command
type >/dev/null 2>&1 tspin || cargo install tailspin

# jnv is designed for navigating JSON, offering an interactive JSON viewer and jq filter editor.
cargo install jnv

# typo check command: typos
cargo install typos-cli

# NOTE: for adding lib dependency
cargo install cargo-binutils
cargo install cargo-docserver
cargo install cargo-edit
cargo install cargo-expand
cargo install cargo-feature
cargo install cargo-fix
cargo install cargo-license
cargo install cargo-tomlfmt
cargo install cargo-tree
cargo install cargo-audit

# any text to tree style converter
cargo install --git https://github.com/KoharaKazuya/forest

cargo install --git https://github.com/umaumax/ecat
cargo install --git https://github.com/umaumax/netlim
cargo install --git https://github.com/umaumax/hexgrep
cargo install --git https://github.com/umaumax/echoes

# NOTE: for Rust Language Server
rustup component add rls rust-analysis rust-src
