#!/usr/bin/env bash
# add below command to crontab file and run cmd `crontab <crontab file path>`
# e.g.
# */5 * * * * $HOME/xxx/daemon.sh

# default $PATH is /bin:/usr/bin
PATH=/usr/sbin:/usr/local/bin/:$PATH

app_name='xxx'
app_cmd_path="xxx"

cd $(dirname $0)
logfile="$HOME/.log/$app_name.log"
logdir=$(dirname $logfile)
[[ ! -e "$logdir" ]] && mkdir -p "$logdir"

type $app_cmd_path >/dev/null 2>&1
[[ $? != 0 ]] && echo "$(date) no $app_cmd_path command" >>$logfile 2>&1 && exit 1

# process detection by port
# lsof -i:$port >/dev/null 2>&1
# process detection by port
pgrep -x "$(basename $app_cmd_path)" >/dev/null 2>&1
[[ $? == 0 ]] && exit 0 # running now

echo "$(date) [start]" >>$logfile
$app_cmd_path >>$logfile 2>&1 &
