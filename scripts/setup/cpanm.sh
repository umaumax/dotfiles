#!/usr/bin/env bash

set -ex

# for perl reply command `reply`
cpanm install Reply

# for Reply [ReadLine]
if [[ $(uname) == "Darwin" ]]; then
  cpanm install Term::ReadLine::Gnu
fi
# for Reply [Autocomplete::Keywords]
cpanm install B::Keywords
cpanm install Reply::Plugin::Autocomplete::Keywords
