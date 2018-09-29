#!/usr/bin/env bash
echo -n "Password:🔑"
read -s sudo_pass || exit 1

expect -f - <<EOF
set timeout 5
spawn /bin/sh -c "sudo -k -p password: pwd"
expect "password:"; send "${sudo_pass}\n"
expect eof; exit
EOF
