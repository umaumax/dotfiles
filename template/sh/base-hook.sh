#!/usr/bin/env bash
hook_cmd_path="$0"
hook_cmd=$(basename "$hook_cmd_path")

BLACK="\033[0;30m" RED="\033[0;31m" GREEN="\033[0;32m" YELLOW="\033[0;33m" BLUE="\033[0;34m" PURPLE="\033[0;35m" LIGHT_BLUE="\033[0;36m" WHITE="\033[0;37m" GRAY="\033[0;39m" DEFAULT="\033[0m"
function echo() { command echo -e "$@"; }

if [[ -n $ENV_HOGEHOGE ]] && [[ $1 == 'HOGEHOGE' ]]; then
	echo "${PURPLE}[INFO][DISABLE] $hook_cmd $* ${DEFAULT}"
	echo "${YELLOW}[INFO][how to enable] unset ENV_HOGEHOGE${DEFAULT}"
	exit 0
fi

next_hook_cmd=$(for i in $(command which -a "$hook_cmd"); do ! [[ "$i" == "$hook_cmd_path" ]] && echo "$i" && break; done)

$next_hook_cmd "$@"
