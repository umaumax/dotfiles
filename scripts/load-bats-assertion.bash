#!/usr/bin/env bash
prefix=$HOME/.cache/bats/
mkdir -p "$prefix"
target="$prefix/bats-assertion"
if [[ ! -d $target ]]; then
  git clone https://github.com/thingsym/bats-assertion.git "$target"
fi
