abbrev-alias -g A="| awk '{\%#}'"
abbrev-alias -g S="| sed -E 's/\%#//g'"
abbrev-alias -g G="| grep -E "
abbrev-alias -g L="| less "
abbrev-alias -g P="| peco "
abbrev-alias -g F="| fzf "
abbrev-alias -g C="| c"
abbrev-alias -g H="'HEAD\%#'"
abbrev-alias -g R=" rm -rf "
abbrev-alias -g pipe="| "
abbrev-alias -g home="~/"
abbrev-alias -g ex="./"
abbrev-alias -g exd="./."
abbrev-alias -g GC=" git checkout ."
abbrev-alias -g D='.'
abbrev-alias -g HAT="'HEAD^' "
abbrev-alias -g STASH="'stash@{\%#}'"
abbrev-alias -g hat='^'

abbrev-alias -g g='git '
abbrev-alias -g s='sudo '
abbrev-alias -g apt='sudo apt-get '
abbrev-alias -g b='brew '
abbrev-alias -g l='ls '
abbrev-alias -g v='vim '

# for miss type
abbrev-alias -g gti='git '

abbrev-alias -f B="git symbolic-ref --short HEAD"
