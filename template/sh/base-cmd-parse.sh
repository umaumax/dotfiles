#!/usr/bin/env bash
# [シェルスクリプト オプション解析テンプレート \- Qiita]( https://qiita.com/rita_cano_bika/items/9fcb2a61c6f360632541 )
VERSION='0.1'
for OPT in "$@"; do
	case "$OPT" in
	'-h' | '-help' | '--help')
		echo "help"
		exit 1
		;;
	'-version' | '--version')
		echo "version: $VERSION"
		exit 1
		;;
	'-option')
		# do something
		shift 1
		;;
	'--' | '-')
		shift 1
		param=("$@")
		break
		;;
	-*)
		echo "$0: 「$(echo $1 | sed 's/^-*//')」no options: confirm by '$0 -h'" 1>&2
		exit 1
		;;
	*)
		if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
			param=("${param[@]}" "$1")
			shift 1
		fi
		;;
	esac
done

for e in "${param[@]}"; do
	echo $e
done
