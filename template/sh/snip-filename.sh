dirname=${path%/*}
noext_filepath=${path%.*}

basename=${path##*/}
noext_filename=${basename%.*}
ext=${basename##*.}
