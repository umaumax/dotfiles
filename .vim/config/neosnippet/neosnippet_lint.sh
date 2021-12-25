#!/usr/bin/env bash

current_abs_directory_path=$(cd $(dirname $0) && pwd)
cd ${current_abs_directory_path%/}

BLACK=$'\e[30m' RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m' PURPLE=$'\e[35m' LIGHT_BLUE=$'\e[36m' WHITE=$'\e[37m' GRAY=$'\e[90m' DEFAULT=$'\e[0m'

git grep --color=always -e '^snippet' -e '$0' -e '${0' -- '*.snip' | awk '$1 ~ /snippet/{if(snippet!=""){print snippet; }snippet=$0} $1 !~ /snippet/{snippet=""}'
if [[ $? == 0 ]]; then
  echo "${GREEN}[OK]${DEFAULT}"
fi
