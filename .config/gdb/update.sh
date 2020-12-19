#!/usr/bin/env bash

current_abs_directory_path=$(cd $(dirname $0) && pwd)
cd ${current_abs_directory_path%/}

git wget https://github.com/cyrus-and/gdb-dashboard/blob/master/.gdbinit -O .gdb-dashboard
git wget https://github.com/sharkdp/stack-inspector/blob/master/stack-inspector.py
git wget https://github.com/umaumax/gdb-hook/blob/master/gdb-trace.py
