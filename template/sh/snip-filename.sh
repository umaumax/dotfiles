dirpath=$(dirname $filepath)
noext_filepath=${filepath%.*}

basename=${filepath##*/}
noext_filename=${basename%.*}
ext=${basename##*.}
