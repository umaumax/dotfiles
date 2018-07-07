lines=()
while read line || [ -n "${line}" ]; do
	lines+=("$line")
done < <(cat $filepath)

for line in "${lines[@]}"; do
	echo $line
done
