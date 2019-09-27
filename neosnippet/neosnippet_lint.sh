#!/usr/bin/env bash
current_abs_directory_path=$(cd $(dirname $0) && pwd)
cd ${current_abs_directory_path%/}

git grep --color=always -e '^snippet' -e '$0' -e '${0' -- '*.snip' | awk '$1 ~ /snippet/{if(snippet!=""){print snippet; }snippet=$0} $1 !~ /snippet/{snippet=""}'
