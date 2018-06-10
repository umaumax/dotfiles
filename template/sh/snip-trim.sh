function trim_prefix() { echo ${1##$2}; }
function trim_suffix() { echo ${1%%$2}; }
function trim() { local tmp="${1##$2}" && echo ${tmp%%$2}; }
