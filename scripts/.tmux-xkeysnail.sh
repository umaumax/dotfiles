#!/usr/bin/env bash
echo -n "Password:🔑"
read -s sudo_pass || exit 1
echo ""
# -k: --reset-timestamp
# -S: --stdin
echo $sudo_pass | sudo -k -S -p '' echo >/dev/null
[[ $? != 0 ]] && exit 1

name='xkeysnail'
tmux new-session -s $name \; \
	send-keys "echo $sudo_pass | sudo -p '' -S xkeysnail ~/.config/xkeysnail/config.py" Enter \; \
	detach-client >/dev/null 2>&1
