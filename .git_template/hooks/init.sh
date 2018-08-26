#!/usr/bin/env bash
set -x
hook_script_name="multiple-git-hooks"

# hook_script_name is based on
# wget https://gist.githubusercontent.com/mjackson/7e602a7aa357cfe37dadcc016710931b/raw/095f93bba3adfdd8d6b62016c52eca15e05faaa9/multiple-git-hooks.sh -O "$hook_script_name"
# wget https://gist.githubusercontent.com/carlos-jenkins/89da9dcf9e0d528ac978311938aade43/raw/7e276cfcb5de155168913245ef49941f0900d25b/multihooks.py -O "$hook_script_name"

chmod u+x "$hook_script_name"
for filename in applypatch-msg commit-msg fsmonitor-watchman post-update pre-applypatch pre-commit pre-push pre-rebase pre-receive prepare-commit-msg update; do
	ln -sf "$hook_script_name" "$filename"
	mkdir -p "${filename}.d"
	touch "${filename}.d/.gitkeep"
done
