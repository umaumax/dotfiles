#!/usr/bin/env bash
function main() {
	! type >/dev/null 2>&1 "terminal-truncate" && echo 1>&2 "install terminal-truncate" && return 1
	! type >/dev/null 2>&1 "joincat" && echo 1>&2 "install joincat" && return 1
	[[ $# -lt 2 ]] && echo "$(basename "$0") [filepath] [filepath]" && return 1
	local filepath_1="$1"
	local filepath_2="$2"

	local width="$(($(tput cols) / 2 - 2))"
	if [[ -n $FZF_PREVIEW_HEIGHT ]]; then
		width="$((width - 1))"
	fi
	# NOTE: paste command is not fit for fzf preview?
	# paste <(command cat "$filepath_1" | terminal-truncate -max="$width" -fill_space -fill_char="x") <(command cat "$filepath_2" | terminal-truncate -max="$width" -fill_space -fill_char="x")
	joincat -d=" | " <(command cat "$filepath_1" | terminal-truncate -max="$width" -fill_space) <(command cat "$filepath_2" | terminal-truncate -max="$width" -fill_space)
}
main "$@"
