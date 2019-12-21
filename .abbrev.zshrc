#!/usr/bin/env zsh

if ! type >/dev/null 2>&1 abbrev-alias; then
  return 1
fi

ZSH_ABBREV_ALIAS_NO_LAST_SPACE=1

# abbrev-alias -g A="| awk '{\%#}'"
# abbrev-alias -g S="| sed -E 's/\%#//g'"
# abbrev-alias -g G="| grep -E "
# abbrev-alias -g L="| less "
# abbrev-alias -g P="| peco "
# abbrev-alias -g F="| fzf "
# abbrev-alias -g C="| c"
# abbrev-alias -g gh="'HEAD\%#'"
# abbrev-alias -g R=" rm -rf "
# abbrev-alias -g rmf=" rm -rf "
# abbrev-alias -g pipe="| "
# abbrev-alias -g H="~/"

# WARN: find -type d
# abbrev-alias -g d='./'
# abbrev-alias -g ex="./"
# abbrev-alias -g exd="./."
# abbrev-alias -g GC=" git checkout ."
# abbrev-alias -g D='.'
# abbrev-alias -g HAT="'HEAD^' "
abbrev-alias -g STASH="'stash@{\%#}'"
# abbrev-alias -g hat='^'

# exec, run
abbrev-alias -g E='$(\%#)'
abbrev-alias -g N='>/dev/null '
# abbrev-alias -g STD='>/dev/null 2>&1 '
# abbrev-alias -g gpp='g++ '
# abbrev-alias -g c11='-std=c++11 '
# abbrev-alias -g std='-std=c++11 '
# abbrev-alias -g aout='./a.out '
# abbrev-alias -g rmd='README.md'

# NOTE: expand only head of prompt (no head of after pipe or start with space)
abbrev-alias -c v='vim '
abbrev-alias -c s='sudo '
# abbrev-alias -c a='sudo apt-get '
abbrev-alias -c sshdel='ssh-keygen-R-peco'
abbrev-alias -c tmuxs="tmux new -s '\%#'"

abbrev-alias -c g='git '
abbrev-alias -c gp='git push '
abbrev-alias -c gco=" git checkout ."
abbrev-alias -c gcoc='git-checkout-commit-peco'
abbrev-alias -c gcob='git-checkout-branch-peco'
abbrev-alias -c gr='git-rebase-peco'
abbrev-alias -c gld='git-log-diff'
abbrev-alias -c gs='git stash'
abbrev-alias -c gsp='git stash pop'

# WARN: you must expand below commands with cursor
abbrev-alias -c gg="ggpvc '\%#'"
abbrev-alias -c ggr="ggpv '\%#'"

abbrev-alias -c ggv="ggpvc '\%#' -- '*.vim'"
abbrev-alias -c ggvim="ggpvc '\%#' -- '*.vim'"

abbrev-alias -c ggzsh="ggpvc '\%#' -- '*.zshrc' '*.zsh' '*.zshprofile' '*.zpreztorc'"

abbrev-alias -c ggmd="ggpvc '\%#' -- '*.md'"

abbrev-alias -c ggc="ggpvc '\%#' -- '*.cpp' '*.hpp' '*.c' '*.h' '*.cxx' '*.cc'"
abbrev-alias -c ggcpp="ggpvc '\%#' -- '*.cpp' '*.hpp' '*.c' '*.h' '*.cxx' '*.cc'"

abbrev-alias -c ggmake="ggpvc '\%#' -- '*[M|m]akefile'"
abbrev-alias -c ggcmake="ggpvc '\%#' -- '*/CMakeLists.txt' '*.cmake'"

abbrev-alias -c ggconfig="ggpvc '\%#' -- '*/.*' '*.config' '*.config' '*/config/*'"

abbrev-alias -c ggtest="ggpvc '\%#' -- '*test*'"

abbrev-alias -c gglaunch="ggpvc '\%#' -- '*.launch'"

abbrev-alias -c ctk='catkin_'
abbrev-alias -c ctkm='catkin_make '
abbrev-alias -c ctmk='catkin_make '
abbrev-alias -c ctt='catkin_test_results '
abbrev-alias -c ctkt='catkin_test_results '

# abbrev-alias -c b='brew '
# abbrev-alias -g tst='tig stash'
# abbrev-alias -g gcm='git commit '
# abbrev-alias -g grb='git rebase '
# abbrev-alias -g gcp='git cherry-pick '
abbrev-alias -g pick='cherry-pick '
abbrev-alias -g cherry='cherry-pick '

# for miss type
abbrev-alias -g gti='git '
abbrev-alias -g tgi='tig '
abbrev-alias -g ehco='echo '
abbrev-alias -g gpp='g++ '
abbrev-alias -g sduo='sudo '
abbrev-alias -g sl='ls '
abbrev-alias -g chekcout='checkout '
abbrev-alias -g staus='status '
abbrev-alias -g @wd='pwd'

# [zsh の exntended\_glob と HEAD^^^ を共存させる。 \- 冬通りに消え行く制服ガールは✖夢物語にリアルを求めない。 \- subtech]( http://subtech.g.hatena.ne.jp/cho45/20080617/1213629154 )
abbrev-alias -g 'HEAD^'='HEAD\^'
abbrev-alias -g 'HEAD^^'='HEAD\^\^'
abbrev-alias -g 'HEAD^^^'='HEAD\^\^\^'
abbrev-alias -g 'HEAD^^^^'='HEAD\^\^\^'

abbrev-alias -f BRANCH="git symbolic-ref --short HEAD"
abbrev-alias -f BASEDIR='basename $PWD'
abbrev-alias -f LSPECO='ls | fzf'
