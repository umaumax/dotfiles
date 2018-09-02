#!/usr/bin/env bash

# bashの配列内の文字列で`'`を利用するときには，文字列を""で囲んでしまうとbash内に文字列を直接埋め込んだ動作とならないので注意

args=("arg1" "-opt='-*'")
cat <<EOF
args=("arg1" "-opt='-*'")
EOF
printf "%-16s" '${args[@]}' && ./argschecker.py ${args[@]}
printf "%-16s" '"${args[@]}"' && ./argschecker.py "${args[@]}"
printf "%-16s" '"$args"' && ./argschecker.py "$args"
printf "%-16s" '$args' && ./argschecker.py $args

echo

args=(arg1 -opt='.*')
cat <<EOF
args=(arg1 -opt='.*')
EOF
printf "%-16s" '${args[@]}' && ./argschecker.py ${args[@]}
printf "%-16s" '"${args[@]}"' && ./argschecker.py "${args[@]}"
printf "%-16s" '"$args"' && ./argschecker.py "$args"
printf "%-16s" '$args' && ./argschecker.py $args

# result

# args=("arg1" "-opt='-*'")
# ${args[@]}      ['./argschecker.py', 'arg1', "-opt='-*'"]
# "${args[@]}"    ['./argschecker.py', 'arg1', "-opt='-*'"]
# "$args"         ['./argschecker.py', 'arg1']
# $args           ['./argschecker.py', 'arg1']

# args=(arg1 -opt='.*')
# ${args[@]}      ['./argschecker.py', 'arg1', '-opt=.*']
# "${args[@]}"    ['./argschecker.py', 'arg1', '-opt=.*']
# "$args"         ['./argschecker.py', 'arg1']
# $args           ['./argschecker.py', 'arg1']
