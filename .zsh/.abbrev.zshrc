#!/usr/bin/env zsh

if ! type >/dev/null 2>&1 abbrev-alias; then
  return 1
fi

ZSH_ABBREV_ALIAS_NO_LAST_SPACE=1

# As specifications, if the alias ends with a space, the next command will also be checked whether aliases or not.
# alias sudo='sudo '

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
# abbrev-alias -c v='vim '
# abbrev-alias -c s='sudo '
# abbrev-alias -c a='sudo apt-get '
abbrev-alias -c sshdel='ssh-keygen-R-peco'
abbrev-alias -c tmuxs="tmux new -s '\%#'"

abbrev-alias -c g='git '
abbrev-alias -c gc='git checkout '
abbrev-alias -c gcb='git checkout -b '
abbrev-alias -c gp='git push '
abbrev-alias -c gpu='git push -u origin master'
abbrev-alias -c gpc='git push origin $(git symbolic-ref --short HEAD)'
abbrev-alias -c gpullc='git pull origin $(git symbolic-ref --short HEAD)'
abbrev-alias -c gco=" git checkout ."
abbrev-alias -c gcoc='git-checkout-commit-peco'
abbrev-alias -c gcob='git-checkout-branch-peco'
abbrev-alias -c gcl='git-checkout-local'
abbrev-alias -c gcol='git-checkout-local'
abbrev-alias -c gr='git-rebase-peco'
abbrev-alias -c gld='git-log-diff'
abbrev-alias -c gs='git stash'
abbrev-alias -c gsp='git stash pop'

# WARN: you must expand below commands with cursor
abbrev-alias -c gg="ggpvc '\%#'"
abbrev-alias -c ggr="ggpv '\%#'"

abbrev-alias -c ggv="ggpvc '\%#' -- '*.vim' '*.vimrc'"
abbrev-alias -c ggvim="ggpvc '\%#' -- '*.vim' '*.vimrc'"

abbrev-alias -c ggzsh="ggpvc '\%#' -- '*.zsh' '*.zshrc' '*.zshenv' '*.zshprofile' '*.zpreztorc'"
abbrev-alias -c ggsh="ggpvc '\%#' -- '*.sh' '*.bash_profile' '*.bashrc' '*.bashenv'"

abbrev-alias -c ggmd="ggpvc '\%#' -- '*.md' 'README.txt' 'readme.txt'"

abbrev-alias -c ggc="ggpvc '\%#' -- '*.cpp' '*.hpp' '*.c' '*.h' '*.cxx' '*.cc'"
abbrev-alias -c ggcpp="ggpvc '\%#' -- '*.cpp' '*.hpp' '*.c' '*.h' '*.cxx' '*.cc'"
abbrev-alias -c ggrs="ggpvc '\%#' -- '*.rs'"
abbrev-alias -c ggrust="ggpvc '\%#' -- '*.rs'"

abbrev-alias -c ggjs="ggpvc -E -e '^.{,500}$' --and -e '\%#' -- '*.js' '*.ts'"

abbrev-alias -c ggcs="ggpvc '\%#' -- '*.cs'"
abbrev-alias -c ggpy="ggpvc '\%#' -- '*.py'"

abbrev-alias -c ggkt="ggpvc '\%#' -- '*.kt'"
abbrev-alias -c ggkts="ggpvc '\%#' -- '*.kts'"

abbrev-alias -c ggmake="ggpvc '\%#' -- '*[M|m]akefile'"
abbrev-alias -c ggcmake="ggpvc '\%#' -- '*CMakeLists.txt' '*.cmake'"

abbrev-alias -c ggconfig="ggpvc '\%#' -- '.*' '*/.*' '*.config' '*/config/*'"

abbrev-alias -c ggtest="ggpvc '\%#' -- '*test*'"

abbrev-alias -c gglaunch="ggpvc '\%#' -- '*.launch'"

## find
abbrev-alias -c fn='find . -name "\%#"'
abbrev-alias -c fso='find . -name "*.so\%#"'
abbrev-alias -c fgpeco="findgrep '\%#' -- | pecocat"
abbrev-alias -c fgmd="findgrep '\%#' -- -type f \( -name '*.md' -o -name 'README.txt' -o -name 'readme.txt' \)"
abbrev-alias -c fgvim="findgrep '\%#' -- -type f \( -name '*.vim' -o -name '*.vimrc' \)"
abbrev-alias -c fgzsh="findgrep '\%#' -- -type f \( -name '*.zsh' -o -name '*.zshrc' -o -name '*.zshenv' -o -name '*.zshprofile' -o -name '*.zpreztorc' \)"
abbrev-alias -c fgsh="findgrep '\%#' -- -type f \( -name '*.sh' -o -name '*.bash_profile' -o -name '*.bashrc' -o -name '*.bashenv' \)"
abbrev-alias -c fgcpp="findgrep '\%#' -- -type f \( -name '*.c' -o -name '*.h' \)"
abbrev-alias -c fgcpp="findgrep '\%#' -- -type f \( -name '*.cpp' -o -name '*.hpp' -o -name '*.c' -o -name '*.h' -o -name '*.cc' -o -name '*.cxx' \)"
abbrev-alias -c fgcs="findgrep '\%#' -- -type f \( -name '*.cs' \)"
abbrev-alias -c fgpy="findgrep '\%#' -- -type f \( -name '*.py' \)"
abbrev-alias -c fgrs="findgrep '\%#' -- -type f \( -name '*.rs' \)"
abbrev-alias -c fgrust="findgrep '\%#' -- -type f \( -name '*.rs' \)"
abbrev-alias -c fggo="findgrep '\%#' -- -type f \( -name '*.go' \)"
abbrev-alias -c fgjs="findgrep '\%#' -- -type f \( -name '*.js' -o -name '*.ts' \) | awk 'length(\$0) < 512'"
abbrev-alias -c fgmake="findgrep '\%#' -- -type f \( -name 'Makefile' -o -name 'makefile' -o -name '*.mk' \)"
abbrev-alias -c fgcmake="findgrep '\%#' -- -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \)"
abbrev-alias -c fgconfig="findgrep '\%#' -- -type f \( -name '.*' -o -name '*.config' -o -path '*/config/*' \)"
abbrev-alias -c fgtest="findgrep '\%#' -- -type f \( -name '*test*' \)"
abbrev-alias -c fglaunch="findgrep '\%#' -- -type f \( -name '*.launch' \)"
abbrev-alias -c fgkt="findgrep '\%#' -- -type f \( -name '*.kt' \)"

abbrev-alias -c sn='sudo nerdctl '
abbrev-alias -c n='nerdctl '
abbrev-alias -c k='kubectl '
abbrev-alias -c kl='kubectl logs '
abbrev-alias -c kg='kubectl get '
abbrev-alias -c kd='kubectl describe '
abbrev-alias -c kgp='kubectl get pods '
abbrev-alias -c kgn='kubectl get nodes '
abbrev-alias -c kgs='kubectl get svc '
abbrev-alias -c kgi='kubectl get ingress '
abbrev-alias -c kdp='kubectl describe pods '
abbrev-alias -c kctx='kubectl ctx'
abbrev-alias -c kns='kubectl ns'
abbrev-alias -c ke='kubectl exec -it '

abbrev-alias -c gw='./gradlew '

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

abbrev-alias -g 'HEAD^'='HEAD\^'
abbrev-alias -g 'HEAD^^'='HEAD\^\^'
abbrev-alias -g 'HEAD^^^'='HEAD\^\^\^'
abbrev-alias -g 'HEAD^^^^'='HEAD\^\^\^'

abbrev-alias -f BRANCH="git symbolic-ref --short HEAD"
abbrev-alias -f BASEDIR='basename $PWD'
abbrev-alias -f LSPECO='ls | fzf'
