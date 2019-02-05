abbrev-alias -g A="| awk '{\%#}'"
abbrev-alias -g S="| sed -E 's/\%#//g'"
abbrev-alias -g G="| grep -E "
abbrev-alias -g L="| less "
abbrev-alias -g P="| peco "
abbrev-alias -g F="| fzf "
abbrev-alias -g C="| c"
abbrev-alias -g H="'HEAD\%#'"
abbrev-alias -g R=" rm -rf "
abbrev-alias -g rmf=" rm -rf "
abbrev-alias -g pipe="| "
abbrev-alias -g HOME="~/"
# WARN: find -type d
# abbrev-alias -g d='./'
abbrev-alias -g ex="./"
abbrev-alias -g exd="./."
abbrev-alias -g GC=" git checkout ."
abbrev-alias -g D='.'
abbrev-alias -g HAT="'HEAD^' "
abbrev-alias -g STASH="'stash@{\%#}'"
abbrev-alias -g hat='^'
# exec, run
abbrev-alias -g E='$(\%#)'
abbrev-alias -g N='>/dev/null '
abbrev-alias -g STD='>/dev/null 2>&1 '
abbrev-alias -g gpp='g++ '
abbrev-alias -g c11='-std=c++11 '
abbrev-alias -g std='-std=c++11 '
abbrev-alias -g aout='./a.out '
abbrev-alias -g rmd='README.md'

abbrev-alias -g g='git '
abbrev-alias -g apt='sudo apt-get '
abbrev-alias -g b='brew '
abbrev-alias -g l='ls '
abbrev-alias -g v='vim '
abbrev-alias -g tst='tig stash'
abbrev-alias -g gcm='git commit '
abbrev-alias -g grb='git rebase '
abbrev-alias -g gcp='git cherry-pick '
abbrev-alias -g pick='cherry-pick '
abbrev-alias -g cherry='cherry-pick '

# for miss type
abbrev-alias -g gti='git '
abbrev-alias -g tgi='tig '
abbrev-alias -g ehco='echo '
abbrev-alias -g sl='ls '
abbrev-alias -g chekcout='checkout '

abbrev-alias -f B="git symbolic-ref --short HEAD"
abbrev-alias -f dir='basename $PWD'
