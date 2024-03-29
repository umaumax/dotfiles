#!/usr/bin/env bash
set -ex

go get -u github.com/b4b4r07/gomi/...
go get -u github.com/jingweno/ccat
go get -u github.com/mattn/files
go get -u github.com/prasmussen/gdrive
# go get -u github.com/yudai/gotty # build error
go get -u github.com/zmb3/gogetdoc
go get -u github.com/monochromegane/the_platinum_searcher/...
go get -u mvdan.cc/sh/cmd/shfmt

# FYI: [ターミナルで簡単にグラフを描くツール termeter \- Qiita]( https://qiita.com/atsaki/items/e7d2e53bac8ba6fdbce0 )
go get -u github.com/atsaki/termeter/cmd/termeter
go get -u github.com/mattn/typogrep

# for makefile linting
go get -u github.com/mrtazz/checkmake
# for markdown linting
# go get -u github.com/errata-ai/vale

# NOTE: binary editor
# go get -u github.com/itchyny/bed/cmd/bed

# FYI: [複数のコマンドを画面分割してwatchするwatchコマンド作った \- Qiita]( https://qiita.com/jiro4989/items/867b6f96184c9c80e30c )
go get -u github.com/jiro4989/vhwatch

# NOTE: for html parse
go get -u github.com/ericchiang/pup

# NOTE: csvdiff tool
go get -u github.com/aswinkarthik/csvdiff

# NOTE: json yaml diff tool
# go get -u github.com/homeport/dyff/cmd/dyff

# NOTE: for cron visualization
go get -u github.com/takumakanari/cronv/...

# NOTE: for markdown preview
go get -u github.com/romanyx/mdopen
# NOTE: for markdown cli output
# go get -u github.com/charmbracelet/glow

# NOTE: for json
go get -u github.com/tomnomnom/gron

# NOTE: for test
go get -u github.com/rakyll/gotest

# NOTE: for screensaver
go get -u github.com/ansoni/goquarium

# NOTE: for colorful csv output
go get -u github.com/nak1114/ccsv

# NOTE: for file rename
go get -u github.com/itchyny/mmv/cmd/mmv

# NOTE: for docker but I don't like this format rule...
# go get -u github.com/jessfraz/dockfmt

# NOTE: for nasm
go get -u github.com/yamnikov-oleg/nasmfmt

# NOTE: for stats (statistics command)
go get github.com/jweslley/stats-tools/...

go get -u github.com/high-moctane/nextword

# modern watch command
go get -u github.com/sachaos/viddy

# enhanced less command
go install github.com/noborus/ov@latest

# my tools
go get -u github.com/umaumax/gechota
go get -u github.com/umaumax/gms
go get -u github.com/umaumax/gocat
go get -u github.com/umaumax/golfix
go get -u github.com/umaumax/gonetcat
go get -u github.com/umaumax/fixedgrep
go get -u github.com/umaumax/cgrep/...
go get -u github.com/umaumax/terminal-truncate
go get -u github.com/umaumax/gogt/...
go get -u github.com/umaumax/joincat

# go get -v github.com/zquestz/s
# cd $GOPATH/src/github.com/zquestz/s
# make
# make install
