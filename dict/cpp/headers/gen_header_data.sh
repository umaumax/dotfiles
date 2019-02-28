#!/usr/bin/env bash

input='c++11-headers.raw.txt'
output='c++11-headers.txt'

: >"$output"
# -r: Backslash  does not act as an escape character.  The backslash is considered to be part of the line. In particular, a backslash-newline pair can not be used as a line continuation.
while IFS= read -r header || [[ -n "$header" ]]; do
	printf '%s' "$header # " | tee -a "$output"
	curl "https://ja.cppreference.com/w/cpp/header/$header" |
		pup 'span.t-lines text{}' |
		sed -E 's/ |\(.*\)//g' |
		sed -E 's/&lt;|&gt;|&amp;|&#34;|std:://g' |
		awk 'NF' | tr '\n' ' ' | tee -a "$output"
	echo | tee -a "$output"
done <$input
