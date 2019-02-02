#!/usr/bin/env bash
set -ex

go get -u github.com/b4b4r07/gomi/...
go get -u github.com/jingweno/ccat
go get -u github.com/kentaro-m/md2confl
go get -u github.com/mattn/files
go get -u github.com/prasmussen/gdrive
go get -u github.com/yudai/gotty
go get -u github.com/zmb3/gogetdoc
go get -u github.com/monochromegane/the_platinum_searcher/...
if [[ $(uname) == "Darwin" ]]; then
	go get -u mvdan.cc/sh/cmd/shfmt
else
	# NOTE: go get failure at linux
	go_bin_path=$(echo "$GOPATH" | cut -d: -f1)/bin
	[[ ! -f "${go_bin_path}/shfmt" ]] && wget https://github.com/mvdan/sh/releases/download/v2.6.2/shfmt_v2.6.2_linux_amd64 -O "${go_bin_path}/shfmt" && chmod u+x "${go_bin_path}/shfmt"
fi
# FYI: [ターミナルで簡単にグラフを描くツール termeter \- Qiita]( https://qiita.com/atsaki/items/e7d2e53bac8ba6fdbce0 )
go get -u github.com/atsaki/termeter/cmd/termeter
go get -u github.com/mattn/typogrep

# for makefile linting
go get -u github.com/mrtazz/checkmake
# for markdown linting
go get -u github.com/errata-ai/vale

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
