while read line || [ -n "${line}" ]; do
	echo ${line}
done < <(cat $filepath)
