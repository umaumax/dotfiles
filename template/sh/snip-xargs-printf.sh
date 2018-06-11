function xargs-printf() {
	while read line || [ -n "${line}" ]; do
		printf "$@" $line
	done
}
