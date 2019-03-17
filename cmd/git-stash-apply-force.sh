#!/usr/bin/env bash

BLACK=$'\e[30m' RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m' PURPLE=$'\e[35m' LIGHT_BLUE=$'\e[36m' WHITE=$'\e[37m' GRAY=$'\e[90m' DEFAULT=$'\e[0m'

function is_git_repo_with_message() {
	local message=${1:-"${RED}no git repo here!${DEFAULT}"}
	git rev-parse --is-inside-work-tree >/dev/null 2>&1
	local code=$?
	[[ $code != 0 ]] && echo "$message" >&2
	return $code
}
function git-show-stashes() {
	is_git_repo_with_message || return
	local stash_no
	for stash in "$@"; do
		stash_no=${stash#stash@\{}
		stash_no=${stash_no%\}}
		stash_no=$((GIT_STASH_BASE + stash_no))
		[[ $stash_no =~ ^[0-9]+$ ]] && stash='stash@{'$stash_no'}'
		echo 1>&2 "${YELLOW}[LOG]${DEFAULT} ${GREEN}git stash show -p $stash${DEFAULT}"
		echo 1>&2 "# $stash"
		git stash show -p $stash
	done
}
function git-apply-stashes() {
	is_git_repo_with_message || return
	[[ $# -lt 1 ]] && echo "$(basename $0) stashes" && return 1
	git-show-stashes "$@" | git apply -3
}
function main() {
	is_git_repo_with_message || return
	[[ $# -lt 1 ]] && echo "$(basename $0) [stash no...]" && return 1
	# NOTE: まず，これが正しく動作すれば全く問題ない
	if git-show-stashes "$@" | git apply; then
		echo "${YELLOW}[LOG][SUCCESS]${DEFAULT} ${GREEN} git stash apply $@${DEFAULT}"
		return
	fi
	return 1
	# WIP
	# NOTE: git applyではcommitの情報が残るため駄目?
	# git add -A
	# git commit --no-verify -m "[TMP][for FORCE APPLY] WIP on $(git rev-parse --abbrev-ref HEAD): $(git log --oneline HEAD | head -n 1)"
	# git-show-stashes "$@" | git apply -3
	# local exit_code=$?
	# echo "${YELLOW}[LOG]${DEFAULT} ${RED}Run next command after solve conflict!${DEFAULT}"
	# echo "${GREEN}git reset --soft 'HEAD^' && git reset${DEFAULT}"
	# return $exit_code

	# local output
	# echo ${YELLOW}[LOG]${DEFAULT} ${GREEN}git stash save "[TMP][for FORCE APPLY] WIP on $(git rev-parse --abbrev-ref HEAD): $(git log --oneline HEAD | head -n 1)${DEFAULT}"
	# output=$(git stash save "[TMP][for FORCE APPLY] WIP on $(git rev-parse --abbrev-ref HEAD): $(git log --oneline HEAD | head -n 1)")
	# exit_code=$?
	# [[ $exit_code != 0 ]] && return $exit_code
	# if [[ "$output" == "No local changes to save" ]]; then
	# git-show-stashes "$@" | git apply -3
	# else
	# {
	# git stash show -p "stash@{0}"
	# git stash drop 1>&2
	# # NOTE: previous stash increment stash number
	# # GIT_STASH_BASE=1 git-show-stashes "$@"
	# git-show-stashes "$@"
	# } | git apply -3
	# fi
}
main "$@"
