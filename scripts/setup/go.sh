#!/usr/bin/env bash
set -e

go get -u github.com/b4b4r07/gomi/...
go get -u github.com/jingweno/ccat
go get -u github.com/kentaro-m/md2confl
go get -u github.com/mattn/files
go get -u github.com/prasmussen/gdrive
go get -u github.com/yudai/gotty
go get -u github.com/zmb3/gogetdoc
go get -u mvdan.cc/sh/cmd/shfmt
# FYI: [ターミナルで簡単にグラフを描くツール termeter \- Qiita]( https://qiita.com/atsaki/items/e7d2e53bac8ba6fdbce0 )
go get -u github.com/atsaki/termeter/cmd/termeter

# my tools
go get -u github.com/umaumax/gechota
go get -u github.com/umaumax/gms
go get -u github.com/umaumax/gocat
go get -u github.com/umaumax/golfix
go get -u github.com/umaumax/gonetcat

# go get -v github.com/zquestz/s
# cd $GOPATH/src/github.com/zquestz/s
# make
# make install
