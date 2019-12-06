#!/usr/bin/env bash
set -eux

# NOTE: A command-line hex viewer
cargo install hexyl

# NOTE: rust repl
# command: evcxr
cargo install evcxr_repl

# NOTE: for vim deoplete-rust
cargo +nightly install racer
