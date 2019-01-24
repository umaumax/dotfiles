function cmdcheck() { type >/dev/null 2>&1 "$@"; }
# e.g.
cmdcheck 'xxx' && alias x='xxx'
! cmdcheck 'yyy' && echo "'yyy' is required" && exit 1
