#!/usr/bin/env bash

input='c++11-headers.raw.txt'
output='c++11-headers.txt'

tmpfile='index.tmp.html'

: >"$output"
# -r: Backslash  does not act as an escape character.  The backslash is considered to be part of the line. In particular, a backslash-newline pair can not be used as a line continuation.
while IFS= read -r header || [[ -n "$header" ]]; do
	printf '%s' "$header # " | tee -a "$output"
	while :; do
		wget "https://ja.cppreference.com/w/cpp/header/$header" -O "$tmpfile"
		if [[ $? != 0 ]]; then
			sleep 5
			continue
		fi
		break
	done
	cat "$tmpfile" |
		# NOTE:
		# span.t-lc: オブジェクト, クラス
		# span.t-lines: 関数
		pup 'span.t-lc,span.t-lines text{}' |
		sed -E 's/ |\(.*\)//g' |
		sed -E 's/&lt;|&gt;|&amp;|&#34;|std:://g' |
		awk 'NF' | sort | uniq | tr '\n' ' ' | tee -a "$output"
	echo | tee -a "$output"
	sleep 3
done <$input

rm "$tmpfile"
