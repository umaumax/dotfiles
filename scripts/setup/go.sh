#!/usr/bin/env bash
set -e

go get -u github.com/mattn/files
go get -u mvdan.cc/sh/cmd/shfmt

# FYI: [ターミナルで簡単にグラフを描くツール termeter \- Qiita]( https://qiita.com/atsaki/items/e7d2e53bac8ba6fdbce0 )
go get -u github.com/atsaki/termeter/cmd/termeter

# my tools
go get -u github.com/umaumax/golfix
