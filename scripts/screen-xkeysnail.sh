#!/usr/bin/env bash
echo -n "Password:🔑"
read -s sudo_pass || exit 1
echo ""
# -k: --reset-timestamp
# -S: --stdin
echo $sudo_pass | sudo -k -S echo >/dev/null
[[ $? != 0 ]] && exit 1

name='xkeysnail'
screen -dmS "$name" /bin/bash -c "echo $sudo_pass | sudo -S xkeysnail ~/.config/xkeysnail/config.py"
