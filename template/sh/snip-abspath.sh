abspathdir=$(cd $(dirname $target) && pwd)
echo ${abspathdir%/}/$(basename $target)
