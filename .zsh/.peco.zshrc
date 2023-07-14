#!/usr/bin/env zsh
! cmdcheck peco && return

if [[ $(uname) == "Linux" ]]; then
  # FYI: [Sample Usage · peco/peco Wiki]( https://github.com/peco/peco/wiki/Sample-Usage#peco--apt )
  function peco-apt() {
    if [[ -z "$1" ]]; then
      echo "Usage: peco-apt <initial search string> - select packages on peco and they will be installed"
      return 1
    fi
    sudoenable || return 1
    sudo apt-cache search $1 | peco | awk '{ print $1 }' | tr "\n" " " | xargs -- sudo apt-get install
  }
fi

if [[ $(uname) == "Darwin" ]]; then
  # FYI: [Find the Wi\-Fi Network Password from Windows, Mac or Linux]( https://www.labnol.org/software/find-wi-fi-network-password/28949/ )
  function show-Wi-Fi-password() {
    local SSID=$(networksetup -listpreferredwirelessnetworks $(networksetup -listallhardwareports | grep -A1 Wi-Fi | sed -n 2,2p | sed 's/Device: //g') | peco | sed "s/^[ \t]*//")
    [[ -n $SSID ]] && echo $SSID && security -i find-generic-password -wa "$SSID"
  }
fi

cmdcheck fzf && alias peco='fzf' && function fzf() {
  if [[ -p /dev/stdin ]]; then
    # [Couldn't get fzf to work without running sudo · Issue \#1146 · junegunn/fzf]( https://github.com/junegunn/fzf/issues/1146 )
    # -> USE: pipe-EOF-do or fzf --sync
    # NOTE: --no-hscroll: Disable horizontal scroll
    pipe-EOF-do command fzf -0 --multi --no-mouse --ansi --reverse --no-hscroll --bind='ctrl-x:cancel,btab:backward-kill-word,ctrl-g:jump,ctrl-f:backward-delete-char,ctrl-h:backward-char,ctrl-l:forward-char,shift-left:preview-page-up,shift-right:preview-page-down,shift-up:preview-up,shift-down:preview-down' "$@"
  else
    command fzf $@
  fi
}
cmdcheck fzy && alias fzy='fzy -l $(($(tput lines)/2))'

function cat-C() {
  local file_path="${1%%:*}"
  local range=${2:-3}
  local line_no=$(($(echo "$1" | cut -d":" -f2)))

  local CAT='cat -n'
  local pre_line=0
  if cmdcheck bat; then
    local CAT='bat --color=always'
    local pre_line=3
  elif cmdcheck ccat; then
    local CAT='ccat -C=always'
    local pre_line=0
  fi

  eval $CAT $file_path | awk -v base=$line_no -v range=$range -v pre_line=$pre_line '(pre_line+base-range)<=NR && NR<=(pre_line+base+range)'
}
# force color cat
function fccat() {
  local CAT='cat'
  if cmdcheck bat; then
    local CAT='bat --color=always'
  elif cmdcheck ccat; then
    local CAT='ccat -C=always'
  fi
  eval $CAT $@
}

# NOTE: input lines
# e.g.
# README.md                            : filename
# README.md:10                         : filename:line_no
# README.md:10: int add(int a, int b); : filename:line_no:line_content
function pecocat() {
  local query=$(printf '%s' "${1:-}" | clear_path)
  # NOTE: extract ~ to $HOME
  # NOTE: for grep -A or -B, -C options -line number-
  expand_home | sed -E -e 's/-((\x1b\[[0-9;]*[mK])+[0-9]+(\x1b\[[0-9;]*[mK])+)-/:\1:/' -e 's/(^[^:]+)-([0-9]+)-/\1:\2:/' | {
    if cmdcheck fzf; then
      local ls_force_color='ls --color=always -alh'
      [[ $(uname) == "Darwin" ]] && local ls_force_color='CLICOLOR_FORCE=1 ls -G -alh'
      cmdcheck exa && ls_force_color='LS_COLORS= exa -h --git -al --color=always'

      local CAT='cat'
      if cmdcheck wcat; then
        local CAT='wcat'
        local range=$(echo "$(tput lines) * 6 / 10 / 2 - 1" | bc)
        # NOTE: Don't use `` in fzf --preview, becase parse will be fault when using ``. So, use $()
        # NOTE: 行数指定の場合で最初または最後の行の場合，指定のrangeだと表示が途切れて見えてしまう
        # NOTE: awk '%s:%s': 2番目を'%d'とすると明示的に0指定となるので，'%s'で空白となるように
        fzf --multi --ansi --reverse --preview 'F="$(printf '"'"'%s'"'"' {} | cut -d":" -f1)"; L="$(printf '"'"'%s'"'"' {} | awk -F":" "{print \$2}")"; [[ -d "$F" ]] && '"$ls_force_color"' "$F"; [[ -f "$F" ]] && '"$CAT"' "$F:$L":'"$range"';' --preview-window 'down:60%' --query=$query
        return
      elif cmdcheck bat; then
        local CAT='bat --color=always'
      elif cmdcheck ccat; then
        local CAT='ccat -C=always'
      fi
      fzf --multi --ansi --reverse --preview 'F="$(printf '"'"'%s'"'"' {} | cut -d":" -f1)"; [[ -d "$F" ]] && '"$ls_force_color"' "$F"; [[ -f "$F" ]] && '"$CAT"' "$F"' --preview-window 'down:60%' --query=$query
    else
      peco
    fi
  } | sed -E -e 's/:([0-9]+):.*$/:\1/g' -e 's/ +:.*$//g'
}
function pecogrep() {
  local GREP_CMD='grep'
  cmdcheck ggrep && GREP_CMD='ggrep'
  # NOTE: empty '' is for all match when run without args
  xargs "$GREP_CMD" -s -n --color=always "$@" '' | pecocat
}

alias pvim='pecovim'
alias cpeco='command peco'
function pecovim() {
  pecocat "$@" | expand_home | tee /dev/tty | xargs-vim
}
# peco copy
alias ranking_color_cat='cat'
# NOTE: green high rank, red low rank
# NOTE: Fの値を下げることで，色の変化までの文字数が増える(擬似的に1行は同じ色になる)
cmdcheck lolcat && alias ranking_color_cat='lolcat -F 0.005 -d 8 -f -S 1'

if cmdcheck cgrep; then
  function shell_color_filter() {
    cgrep '(\$)(\().*(\))' 28,28,28 \
      | cgrep '(\$[a-zA-Z_0-9]*)' \
      | cgrep '(\|)' 201 \
      | cgrep '(\||)|(&&)' 90,198 \
      | cgrep '(;)' 211,88,88 \
      | cgrep '(^\[[^\]]*\])' 38 \
      | cgrep '(\$\(|^\t*|\| *|; *|\|\| *|&& *)([a-zA-Z_][a-zA-Z_0-9.\-]*)' ,10 \
      | cgrep '('"'"'[^'"'"']+'"'"')' 226 \
      | cgrep '(#.*$)' 239
  }
else
  function shell_color_filter() {
    cat
  }
fi

[[ "$(uname -a)" =~ Ubuntu ]] && alias mdfind='locate'

alias pecopy='peco | c'
alias allcmdspeco="allcmds | cgrep '(/.*/)([^/]*$)|(.*)=(.*)' 242,69,190,202 | fzf | to_prompt"
alias cmdpeco='{ alias; functions-list; } | peco | to_prompt'
alias prompt-pipe='to_prompt'
function to_prompt() {
  if [[ ! -o zle ]]; then
    command cat
  else
    print -z "$(command cat)"
  fi
}
function hpeco() {
  local HPECO_NUM=${HPECO_NUM:-1}
  # --no-sort: hight priority to history order
  builtin history -nr $HPECO_NUM | shell_color_filter | fzf --query=$1 --no-sort | to_prompt
}
function hpecopy() {
  hpeco | tr -d '\n' | c
}
alias dpeco='find . -type d | peco'
alias fpeco='find . -type f | peco'
alias fpecovim='find . -type f | pecovim'
alias fvim='find . -type f | pecovim'
# m: modified
alias gmvim='git status -s | cut -c4- | pecovim'
alias ftvim='pvft'
alias peco-functions='local zzz(){ local f=`command cat`; functions $f } && print -l ${(ok)functions} | peco | zzz'
function dirspeco() {
  local output
  output=$(dirs -lv | peco | sed -r "s/[0-9]+\s*//g")
  [[ -n $output ]] && cd "$output"
}
function pecokill() {
  pgrep -lf ${1:-.} | peco | cut -d" " -f1 | xargs kill -KILL
}

function rvim() {
  local n=${1:-}
  VIMINFO_LS_N="$n" viminfo-ls | expand_home | ranking_color_cat | pecovim
}
alias rgvim='rdvim $(git rev-parse --show-toplevel | homedir_normalization)'
alias grvim='rgvim'
alias rcvim='rdvim'
[[ -d ~/dotfiles/.vim/config/neosnippet ]] && alias neopeco='lsabs -f ~/dotfiles/.vim/config/neosnippet | pecovim'

function rdvim() {
  local wd=${1:-$(pwd)}
  viminfo-ls | grep -E '^'"$wd" | ranking_color_cat | pecovim
}

# 最終的に'./'を加えても動作は変更されない
# NOTE: echo ${~$(echo '~')} means expand '~' at zsh
function rvcd() {
  local n=${1:-}
  cd "$(VIMINFO_LS_N="$n" viminfo-ls | ranking_color_cat | peco | sed 's:/[^/]*$::g' | sed 's:$:/:g' | sed 's:^~:'$HOME':')./"
}
function rcd() {
  local n=${1:-}
  cd "$(CDINFO_N="$n" cdinfo | ranking_color_cat | peco | sed 's:$:/:g')./"
}
alias lcdpeco='ls | cdpeco'
function cdpeco() {
  # NOTE: mac ok
  #   if [[ -p /dev/stdin ]]; then
  #     cd $(cat /dev/stdin | peco | sed 's:$:/:g')./
  #   else
  #     cd $(find . -type d | peco | sed 's:$:/:g')./
  #   fi
  #   return

  local basedir=${1:-.}

  # NOTE: pipeの内容をそのまま受け取るには()or{}で囲む必要がある
  if [[ $(uname) == "Darwin" ]]; then
    { cd "$({ [[ -p /dev/stdin ]] && cat || find "$basedir" -type d; } | pecocat | sed 's:$:/:g')./"; }
  else
    {
      cd "$({
        [[ -p /dev/stdin ]] && local RET=$(cat) || local RET=$(find "$basedir" -type d)
        echo $RET
      } | pecocat | sed 's:$:/:g')./"
    }
  fi
}
alias bropeco='find .. -type d -maxdepth 1 | cdpeco'
alias sispeco='bropeco'
alias brocd='bropeco'
alias cdbro='bropeco'
alias siscd='bropeco'
alias cdsis='bropeco'

# [git ls\-tree]( https://qiita.com/sasaplus1/items/cff8d5674e0ad6c26aa9 )
# NOTE: only dir
alias cdg='gcd'
function gcd() {
  is_git_repo_with_message || return
  local target=$(git ls-tree -dr --name-only --full-name --full-tree HEAD | git_add_root_rel_pwd_rev_prefix | pecocat $*)
  [[ -z $target ]] && return
  cd "$target"
}
# NOTE: includes file
alias cdgf='gfcd'
function gfcd() {
  is_git_repo_with_message || return
  local target=$(git ls-tree -r --name-only --full-name --full-tree HEAD | git_add_root_rel_pwd_rev_prefix | pecocat $*)
  [[ -z $target ]] && return
  cd "$(dirname "$target")"
}

function fcd() {
  local target=$(find . -type d | pecocat $*)
  [[ -z $target ]] && return
  cd "$(dirname "$target")"
}

function _up() {
  local dir="$PWD"
  while [[ $dir != "/" ]]; do
    printf '%s\n' "$dir"
    dir=${dir%/*}
    [[ -z $dir ]] && break
  done
  echo "/"
}
function up() {
  local dir=$(_up | peco)
  [[ -z $dir ]] && return 1
  cd "$dir"
}

alias peco-ls='ls -al | peco | awk "{print \$9}"'
alias peco-lst='ls -alt | peco | awk "{print \$9}"'
alias peco-lstr='ls -altr | peco | awk "{print \$9}"'
alias pls='peco-ls'
alias plst='peco-lstr'
alias plstr='peco-lst'
alias pvls='peco-ls | xargs-vim'
alias pvlst='peco-lstr | xargs-vim'
alias pvlstr='peco-lst | xargs-vim'
alias pf='fpeco'
alias pft='find-time-sortr | ranking_color_cat | fzf --no-sort | awk "{print \$9}"'
alias pftr='find-time-sort | ranking_color_cat | fzf --no-sort | awk "{print \$9}"'
alias pvft='find-time-sortr | awk "{printf \"%-48s :%s %s %s\n\", \$9, \$6, \$7, \$8;}" | ranking_color_cat | pecovim'
alias pvftr='find-time-sort | awk "{printf \"%-48s :%s %s %s\n\", \$9, \$6, \$7, \$8;}" | ranking_color_cat | pecovim'

function git-branch-peco() {
  local options=(refs/heads/ refs/remotes/ refs/tags/)
  [[ $# -gt 0 ]] && options=("$@")
  local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative)%(taggerdate:relative))" --sort=-committerdate "${options[@]}" | sed -e "s/^refs\///g" | awk '{s=""; for(i=2;i<=NF;i++) s=s" "$i; printf "%-34s%+24s\n", $1, s;}' \
    | fzf --no-sort --reverse --ansi --multi --preview 'git graph --color | sed -E "s/^/ /g" | sed -E '"'"'/\(.*[^\/]'"'"'$(echo {} | cut -d" " -f1 | sed "s:/:.:g")'"'"'.*\)/s/^ />/g'"'"'' \
    | awk '{print $1}')
  printf '%s' "$branch"
}
alias branch_checkout='git-checkout-branch-peco'
function git-checkout-branch-peco() {
  local branch=$(git-branch-peco)
  [[ -n $branch ]] && git checkout $branch
}
function git-tag-peco() {
  git-branch-peco "refs/tags/"
}
function git-checkout-tag-peco() {
  local tag=$(git-tag-peco)
  [[ -n $tag ]] && git checkout $tag
}

function git-log-peco() {
  GIT_COMMIT_PECO_OPT="--multi" _git-commit-peco
}
# NOTE: args: files for filtering log
function _git-commit-peco() {
  # NOTE: escape {7} -> {'7'} to avoid fzf replacing
  git graph --color "$@" | fzf "$GIT_COMMIT_PECO_OPT" --preview 'git show --stat -p --color $(echo {} | grep -o -E '"'"'^[ *|\\/_]+[0-9a-zA-Z]{'"'"'7'"'"'}'"'"' | grep -o -E '"'"'[0-9a-zA-Z]{'"'"'7'"'"'}'"'"')' | grep -o -E '^[ *|\\/_]+[0-9a-zA-Z]{7}' | grep -o -E '[0-9a-zA-Z]{7}'
}
alias commit='git-commits-peco'
alias commits='git-commits-peco'
function git-commits-peco() {
  GIT_COMMIT_PECO_OPT="--multi" _git-commit-peco
}
function git-rebase-peco() {
  local commit=$(_git-commit-peco)
  [[ -z $commit ]] && return 1
  if [[ $# == 0 ]]; then
    set -- '-i'
  fi
  git rebase "$commit^" "$@"
}

function git-change-commit-message-rebase-peco() {
  local commit=$(_git-commit-peco)
  [[ -z $commit ]] && return 1
  # commit sha characters must be 7
  local sed_command='sed'
  type >/dev/null 2>&1 gsed && sed_command='gsed'
  git -c "sequence.editor=f() { $sed_command -i 's/^pick $commit/reword $commit/' \$1; }; f" rebase -i "$commit^"
}

function git-split-commit-rebase-peco() {
  local commit=$(_git-commit-peco)
  [[ -z $commit ]] && return 1
  # commit sha characters must be 7
  local sed_command='sed'
  type >/dev/null 2>&1 gsed && sed_command='gsed'
  git -c "sequence.editor=f() { $sed_command -i 's/^pick $commit/edit $commit/' \$1; }; f" rebase -i "$commit^" || return 1
  echo
  echo "${PURPLE}[LOG] uncommitted below commit${DEFAULT}"
  echo "${PURPLE}[LOG] create commits and git rebase --continue${DEFAULT}"
  echo
  git log --pretty=oneline --abbrev-commit "HEAD^..HEAD" && git reset --soft "HEAD^" && git reset
}

function git-cherry-pick-peco() {
  local commit=$(_git-commit-peco)
  [[ -z $commit ]] && return 1
  git cherry-pick "$commit"
}
# NOTE: select 1 or 2 commits by peco -> return commit range by given range text
function git-commits-range-peco() {
  local range_text=${1:-".."}

  local commits=($(git-commits-peco))
  [[ -z $commits ]] && return 1
  [[ ${#commits[@]} -gt 2 ]] && echo "${RED}choose one commit or two commits! not ${#commis[@]} ($commits)${DEFAULT}" 1>&2 && return 1
  local commit1=$(echo $commits | awk '{print $1}') # new
  local commit2=$(echo $commits | awk '{print $2}') # old
  [[ -z $commit2 ]] && local commit2=$commit1

  echo "${commit2}${range_text}${commit1}"
}
function git-diff-peco-range() {
  local commits_range=$(git-commits-range-peco '^..')
  [[ -z $commits_range ]] && return 1
  git diff "$commits_range"
  echo "$YELLOW"
  echo 1>&2 "# ---- command ----"
  echo 1>&2 "git diff '$commits_range'"
  echo 1>&2 "# ---- command ----"
  echo "$DEFAULT"
}
function git-format-patch-peco-range() {
  local commits_range=$(git-commits-range-peco '^..')
  [[ -z $commits_range ]] && return 1
  git format-patch "$commits_range" "$@"
  echo "$YELLOW"
  echo 1>&2 "# ---- command ----"
  echo 1>&2 "git format-patch '$commits_range'" "$@"
  echo 1>&2 "# ---- command ----"
  echo "$DEFAULT"
}
function git-cherry-pick-peco-range() {
  local commits_range=$(git-commits-range-peco '^..')
  [[ -z $commits_range ]] && return 1
  git log $commits_range
  hr '#'
  echo git cherry-pick "'$commits_range'"

  # NOTE: only for zsh
  echo -n "ok?(y/N): "
  read -q || return 1

  git cherry-pick $commits_range
}
alias commit_checkout='git-checkout-commit-peco'
function git-checkout-commit-peco() {
  local commit=$(_git-commit-peco)
  [[ -z $commit ]] && return 1
  git checkout "$commit"
}

function git-rename-to-backup-branch-peco() {
  local prefix='_'
  local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative))" --sort=-committerdate refs/heads/ refs/remotes/ refs/tags/ | sed -e "s/^refs\///g" | peco | awk '{print $1}')
  [[ -n $branch ]] && git rename {,$prefix}"$branch"
}

function git-reflog-commit-id() {
  function color_filter() { command cat; }
  cmdcheck cgrep && function color_filter() { cgrep '([0-9a-zA-Z]+) (HEAD@{[0-9]+})(: [^:]+: )(.*)$' 'green,yellow,default,magenta'; }
  git reflog | color_filter | fzf --no-sort | cut -d" " -f1
}
function git-reset-hard-peco() {
  is_git_repo_with_message || return
  local commit=$(git-reflog-commit-id)
  [[ -z $commit ]] && return 1

  git show --stat "$commit"
  # NOTE: only for zsh
  echo -n "${RED}git reset --hard '$commit' ok?${DEFAULT}(y/N): "
  read -q || return 1

  git reset --soft "$commit"
}
function git-reset-soft-peco() {
  is_git_repo_with_message || return
  local commit=$(git-reflog-commit-id)
  [[ -z $commit ]] && return 1

  git show --stat "$commit"
  # NOTE: only for zsh
  echo -n "git reset --soft '$commit' ok?(y/N): "
  read -q || return 1

  git reset --soft "$commit"
}

# CHEATSHEAT_ROOT="$HOME/dotfiles/cheatsheets/"
# if [[ -d $CHEATSHEAT_ROOT ]]; then
# function cheat() {
# local _=$(
# export VIM_FAST_MODE='on'
# grep -rns -v -e '^$' -e '^----' -e '```' $CHEATSHEAT_ROOT --color=always | sed 's:'$CHEATSHEAT_ROOT'::g' | peco | sed -r 's!^([^:]*:[^:]*):.*$!'$CHEATSHEAT_ROOT'\1!g' | xargs-vim
# )
# }
# fi

# copy example file peco
function pecoexamples() {
  local root="$HOME/dotfiles/examples"
  local files=$(cd $root >/dev/null 2>&1 && find . -type f | grep -v README.md)
  [[ -z $files ]] && return
  local PECO="peco"
  cmdcheck fzf && cmdcheck ccat && local PECO="fzf --reverse --ansi --multi --preview 'ccat -C=always $root/{}'"
  local ret=$(echo "$files" | bash -c $PECO)
  [[ -z $ret ]] && return
  cp -i "$root/$ret" "$(basename $ret)" && echo "[COPY]: $ret"
}

function umountpeco() {
  local filepathes=($(mount | peco | sed 's/.* on//g' | awk '{print$1}'))
  for filepath in "${filepathes[@]}"; do
    if [[ $(uname) == "Darwin" ]]; then
      # NOTE: if mounted by normal user, you can unmount without sudo
      if ! umount "$filepath"; then
        if ! sudo diskutil unmount "$filepath"; then
          echo 1>&2 "${RED}try\n umount -f '$filepath'${DEFAULT}"
        fi
      fi
    else
      sudo umount "$filepath"
    fi
    [[ $? == 0 ]] && echo "'$filepath' umount success"
  done
}

function lnpeco() {
  [[ $# == 0 ]] && echo "$0 SYM_SRC_PATH" && return 1
  local SYM_SRC_PATH="$1"
  local SYM_SRC_NAME=$(basename $SYM_SRC_PATH)
  local TARGET_DIR=$(dirname $SYM_SRC_PATH)
  [[ -e $SYM_SRC_PATH ]] && [[ ! -L $SYM_SRC_PATH ]] && echo "'$SYM_SRC_PATH' is not symbolic link!" && return 1
  [[ ! -d $TARGET_DIR ]] && echo "'$TARGET_DIR' is not dir" && return 1

  local dst=$({
    printf "# current setting: "
    ls -l $SYM_SRC_PATH | env grep -o -E '[a-zA-Z0-9\-~/]* ->.*$'
    ls $TARGET_DIR
  } | peco)
  if [[ -n $dst ]]; then
    [[ ! -e $TARGET_DIR/$dst ]] && echo "No such file or directory '$TARGET_DIR/$dst'" && return 1
    if $(is_wd_owner_root $TARGET_DIR); then
      { sudo -n true >/dev/null 2>&1 || sudo true; } && sudo bash -c "cd $TARGET_DIR && ln -snf $dst $SYM_SRC_NAME"
    else
      bash -c "cd $TARGET_DIR && ln -snf $dst $SYM_SRC_NAME"
    fi
    [[ $? == 0 ]] && echo "[DONE] cd $TARGET_DIR && ln -snf $dst $SYM_SRC_NAME"
  fi
}

function is_wd_owner_root() {
  local TARGET_DIR="${1:-.}"
  if [[ $(uname) == "Darwin" ]]; then
    [[ $(stat -f "%u" $TARGET_DIR) == 0 ]]
    return
  fi
  [[ $(stat -c "%u" $TARGET_DIR) == 0 ]]
  return
}

function selhost() {
  local VAR_NAME=${1:-"TARGET_HOST"}
  local RET=$(sshconfig_host_hostname | peco | awk '{print $1}')
  export $VAR_NAME="$RET"
  echo "export ${YELLOW}${VAR_NAME}${DEFAULT}=${YELLOW}${RET}${DEFAULT}"
}

function pathcmdspeco() {
  pathcmds | peco
}

# TODO: USE WINDOW_ID not APP_NAME
cmdcheck wmctrl && cmdcheck wintoggle && function wintogglepeco() {
  local app_name=$(wmctrl -lx | grep -v 'N/A' | awk '{print$3}')
  [[ -z $app_name ]] && return 1
  wintoggle $app_name
}

if cmdcheck fzf; then
  #######################################
  # Name: manpeco
  # Description: man(1) commandual fuzzy finder
  # Globals:
  #   - None
  # Arguments:
  #   - None
  # Returns:
  #   - None
  #######################################
  # Darwin output: man -k
  # zshoptions(1)            - zsh options
  # Ubuntu output: man -k
  # zshoptions (1)       - zsh options
  function manpeco() {
    local args=($(man -k . | fzf --query="'"${1} | perl -ne '@col=split(/ - /); print("$col[0]\n");' | sed -E -e 's/(.*)\(([0-9]+)\)/\2 \1/g' -e 's/,//g'))
    [[ ${#args[@]} == 2 ]] && man "${args[@]}"
  }
  alias icalc='calc'
  function calc() {
    echo ' ' | fzf --ansi --multi --preview 'echo {q}"="; echo {q} | bc -l' --preview-window 'up:2' --height '1%' --print-query | bc -l
  }
  alias ipgrep='ppgrep'
  function ppgrep() {
    echo ' ' | fzf --ansi --multi --preview '[[ -n {q} ]] && { pgrep -l {q}; echo "----"; pgrep -alf {q}; }' --preview-window 'down:70%' --height '80%' --print-query | xargs pgrep -l
  }
  # interactive tree
  alias pecotree='itree'
  alias treepeco='itree'
  function itree() {
    seq 1 100 | fzf --ansi --multi --preview 'tree -L {}'
  }
  alias lsofpeco='ilsof'
  alias pecolsof='ilsof'
  function ilsof() {
    seq 0 65536 | fzf --ansi --multi --preview 'lsof -i :{}'
  }
  alias lsofsudopeco='isudolsof'
  alias pecosudolsof='isudolsof'
  function isudolsof() {
    sudoenable || return 1
    seq 0 65536 | fzf --ansi --multi --preview 'sudo lsof -i :{}'
  }
  # e.g. printf-check float 1234.5678
  function printf-check() {
    echo ' ' | fzf --ansi --multi --preview 'echo printf "{q}" '"$*"'; printf "{q}" '"$*" --preview-window 'down:70%' --height '80%' --print-query
  }
  function git-log-file-find-peco() {
    local cmd='git log --color --follow --stat -- {q}'
    {
      echo '*md'
      echo '*cpp'
    } | _git-peco $cmd
  }
  function git-log-src-grep-peco() {
    local cmd='git log --color --stat -S $(echo {q} | awk "{print \$1}") -- $(echo {q} | awk "{print \$2}")'
    {
      echo 'function *zsh'
      echo 'print *cpp'
    } | _git-peco $cmd
  }
  function _git-peco() {
    [[ $# -le 0 ]] && echo "$0 [cmd]" && return 1
    local pipe_content=$(cat)
    local cmd=$1
    # NOTE: 1st line: input query
    # NOTE: 2nd line: selected query
    local ret=$(printf "%s" $pipe_content | fzf --query='*' --ansi --multi --preview $cmd --preview-window 'down:90%' --height '90%' --print-query | head -n 1)
    # NOTE: same output of preview-window
    if [[ -n $ret ]]; then
      local eval_cmd=$(printf '%s' $cmd | sed 's@{q}@'"'$ret'"'@g')
      eval $eval_cmd
      hr '#'
      echo $eval_cmd
    fi
  }
  alias gt='googletrans'
  cmdcheck gogt-fzf && alias gt='gogt-fzf'
  function googletrans() {
    local port="12800"
    ! cmdcheck gtrans && echo "REQUIRED: gtrans" && echo "pip install https://github.com/umaumax/gtrans/archive/master.tar.gz" && return 1
    pgrep -lf "gtrans -p" >/dev/null 2>&1 || nohup gtrans -p $port &
    echo ' ' | fzf --ansi --multi --preview "echo {q}; curl -s 'localhost:$port/?text='\$(echo {q} | nkf -WwMQ | sed 's/=\$//g' | tr = % | tr -d '\n')" --preview-window 'up:2' --height '1%'
  }
  function test_bash_regexp() {
    [[ $# -le 0 ]] && echo "$0 [filepath]" && return 1
    local TARGET_FILE=$1
    {
      echo NOTE: start with "' '" means raw query!
      echo sample
      echo '(\.|\?)$'
    } | fzf --ansi --multi --preview 'echo {q} | grep ''^ \\+'' && QUERY={} || QUERY=$(echo {q} | awk ''{gsub(/^ +/,"")} {print $0}''); [[ -z $QUERY ]] && QUERY=".*"; echo "PAT=''$QUERY'' [[ xxx =~ \$PAT ]]"; echo; cat '"$TARGET_FILE"' | awk 1 | while read -r LINE; do; [[ $LINE =~ $QUERY ]] && echo "$LINE"; done' --print-query
  }
  alias docpeco='opendoc'
  alias pecodoc='opendoc'
  function opendoc() {
    local doc_list=(
      'cmake~3.12'
      'c'
      'cpp'
      'docker~17'
      'go'
      'git'
      'gcc~7'
      'gcc~7_cpp'
      'homebrew'
      'markdown'
      'python~3.6'
      'python~2.7'
      'rust'
    )
    local ret=$(for doc_list in ""${doc_list[@]}""; do
      echo $doc_list
    done | fzf)
    local base_url='http://docs.w3cub.com'
    [[ -n $ret ]] && open "$base_url/$ret"
  }
  function lspeco() {
    local ls_force_color='ls --color=always'
    [[ $(uname) == "Darwin" ]] && ls_force_color='CLICOLOR_FORCE=1 ls -G'
    eval $ls_force_color -A ${1:-.} | pecocat
  }
  # NOTE: lsの結果から特定のファイル/ディレクトリを除外する
  alias pecolsex='lsexpeco'
  function lsexpeco() {
    local ls_force_color='ls --color=always'
    [[ $(uname) == "Darwin" ]] && ls_force_color='CLICOLOR_FORCE=1 ls -G'
    {
      eval $ls_force_color -A ${1:-.} | pecocat
      ls -A ${1:-.}
    } | sort | uniq -u
  }
  if cmdcheck gomi; then
    alias pecogomi='gomipeco'
    function gomipeco() {
      for target in $(lspeco ${1:-.}); do
        gomi "$target"
      done
    }
  fi
  if cmdcheck jq; then
    alias pecojq='jqpeco'
    function jqpeco() {
      local input_filepath=${1:-}
      if [[ -p /dev/stdin ]]; then
        local tmpfile=$(mktemp "$(basename $0).$$.tmp.XXXXXX")
        cat /dev/stdin >"$tmpfile"
        input_filepath="$tmpfile"
      fi
      cat "$input_filepath" | fzf --ansi --multi --preview "cat '$input_filepath' | jq -C {q}" --preview-window 'down:70%' --height '80%' --print-query
      [[ -e "$tmpfile" ]] && rm -f "$tmpfile"
    }
  fi
  function rmpeco() {
    local ret=$(
      {
        if [[ ! -p /dev/stdin ]]; then
          lspeco ${1:-.}
        else
          # WARN: input must be abspath or true relative path
          pecocat
        fi
      } | {
        # -r: Backslash  does not act as an escape character.  The backslash is considered to be part of the line. In particular, a backslash-newline pair can not be used as a line continuation.
        while IFS= read -r LINE || [[ -n "$LINE" ]]; do
          printf "'%s' " "$LINE"
        done
      }
    )
    [[ -n $ret ]] && print -z ' rm -rf '"$ret"
  }
  alias git-repo-peco='peco-git-repo'
  function peco-git-repo() {
    local dirpath=$(find-git-repo | fzf)
    [[ -n $dirpath ]] && cd "$dirpath"
  }
  cmdcheck sedry && function sedcheck() {
    local input_filepath=${1:-}
    local args=("$@")
    if [[ -p /dev/stdin ]]; then
      local tmpfile=$(mktemp "$(basename $0).$$.tmp.XXXXXX")
      cat /dev/stdin >"$tmpfile"
      args=("$@" "$tmpfile")
    else
      [[ $# -lt 1 ]] && echo "$(basename $0) [filepath]..." && return 1
    fi

    local SED='sed'
    type >/dev/null 2>&1 gsed && SED='gsed'
    {
      echo 's/hoge/fuga/g'
      echo '1iSAMPLE'
      echo '1aSAMPLE'
    } | fzf --ansi --multi --preview 'echo '"$SED"' -E {q}; SEDRY_SED='"$SED"' sedry -E {q} '"${args[@]}" --preview-window 'down:70%' --height '80%' --print-query
    [[ -e "$tmpfile" ]] && rm -f "$tmpfile"
  }
  if cmdcheck buku; then
    alias bukupeco='bookpeco'
    function bookpeco() {
      local keyword=${1:-}
      local urls=($(buku -p | awk '{printf "%s", $0; } (NR%4==0){print ""}' | grep "$keyword" | fzf --query="'" | grep -o -E 'https?://[^ ]*'))
      for url in "${urls[@]}"; do
        echo "open $url"
        open "$url"
      done
      # NOTE: Auto-import bookmarks from your browser(s).
      # buku --ai
    }
  fi
  alias sshdelpeco='ssh-keygen-R-peco'
  function ssh-keygen-R-peco() {
    local ret=$({
      # NOTE: start with '|1|' is hashed host info
      command cat ~/.ssh/known_hosts | grep -v '^|1|' | sed -E 's/^([^, ]*),?([^, ]*) .*$/\1\t\2/g'
      sshconfig_host_hostname | awk '{printf "%-32s # %s\n",$2,$1}'
    } | fzf)
    [[ -z $ret ]] && return 1
    # -r: Backslash  does not act as an escape character.  The backslash is considered to be part of the line. In particular, a backslash-newline pair can not be used as a line continuation.
    printf '%s' "$ret" | while IFS= read -r LINE || [[ -n "$LINE" ]]; do
      local hostname=$(printf '%s' "$LINE" | awk '{ print $1; }')
      ssh-keygen -F "$hostname" >/dev/null 2>&1
      if [[ $? != 0 ]]; then
        hostname=$(dig +short $(ssh -G "$hostname" | grep "^hostname" | cut -d' ' -f2))
        ssh-keygen -F "$hostname"
        if [[ $? != 0 ]]; then
          continue
        fi
      fi
      ssh-keygen -R "$hostname"
    done
  }
fi

alias gfvc='gfvimc'
# function gfvimc() {
# is_git_repo_with_message || return
# git ls-files | pecovim
# }
alias gfvimc='git ls-files | pecovim'
alias gfv='gfvimc'
# function gfvim() {
# is_git_repo_with_message || return
# git ls-files $(git rev-parse --show-toplevel) | pecovim
# }
alias gfvim='gfvimc'
alias gfvimr='git ls-files $(git rev-parse --show-toplevel) | pecovim'

# alias git-status-tabvim='vim -p `git status -s | -e "^ M" -e "^A" | cut -c4-`'
# alias git-status-allvim='git-status-tabvim'
# alias gsttabvim='git-status-tabvim'
# alias git-status-pecovim='git status -s | -e "^ M" -e "^A" | cut -c4- | pecovim'
# alias vim-git-modified='git-status-pecovim'
# alias gst-pecovim='git-status-pecovim'
# alias gstpv='git-status-pecovim'
# alias gstvim='git-status-pecovim'

alias gstvim='git status -s | grep -e "^ M" -e "^A" | cut -c4- | pecovim'
alias gstvimm='git status -s | grep -e "^ M" | cut -c4- | pecovim'
alias gstvima='git status -s | grep -e "^A" | cut -c4- | pecovim'
alias gsttabvim='vim -p `gstvim`'
alias gsttabvimm='vim -p `gsttabvimm`'
alias gsttabvima='vim -p `gsttabvima`'

alias gedit='gstlogvims'
function gstlogvims() {
  is_git_repo_with_message || return
  local num=${1:-5}
  {
    git status -s | grep -e "^ M" -e "^A" | cut -c4-
    for ((i = 0; i < $num; i++)); do
      printf ': '
      git log -n 1 --oneline --color=always "HEAD~$i"
      gstlogfiles "$i"
    done
  } | git_add_root_rel_pwd_rev_prefix | pecovim
}

function gstlogvim() {
  is_git_repo_with_message || return
  gstlogfiles "$@" | git_add_root_rel_pwd_rev_prefix | pecovim
}
function gstlogallvim() {
  is_git_repo_with_message || return
  local prefix="$(git_root_rel_pwd_rev)"
  [[ -n "$prefix" ]] && prefix="$prefix/"
  git log HEAD --pretty="" --name-only | awk '!a[$0]++' | git_add_root_rel_pwd_rev_prefix | ranking_color_cat | pecovim
}

function git-ls-time() {
  is_git_repo_with_message || return
  local target=${1:-.}
  # git log --name-only --pretty=':%ai' "$target" | sed -E 's/ \+[0-9]+//' | git_remove_root_rel_pwd_prefix | awk '/^:/{date=$0;} ! /^:/{ a[$0]++; if($0!=""&&a[$0]==1) printf "%-48s %s\n", $0, date}'
  # FYI: [git log \- how to git log with date\-time and file names in one line \- Stack Overflow]( https://stackoverflow.com/questions/32893773/how-to-git-log-with-date-time-and-file-names-in-one-line )
  git log --pretty=%x0a%ci --name-only "$target" \
    | awk '
     /^$/        { dateline=!dateline; next }
     dateline    { date=$0; next }
     !seen[$0]++ { printf "%-48s :%s\n", $0,date }
' | git_remove_root_rel_pwd_prefix
}
function gftvim() {
  is_git_repo_with_message || return
  git-ls-time | ranking_color_cat | pecovim
}

function git-grep-time() {
  is_git_repo_with_message || return
  local ls_find_args=(.)
  local i=1
  for arg in "$@"; do
    [[ $arg == '--' ]] && ls_find_args=(${@:$i})
    ((i++))
  done
  # NOTE: first commitの方からの走査であるが，実際には通常の出力の逆がほしい
  # [[ -n $GIT_GREP_TIME_REVERSE ]] && ls_find_args=(--reverse "${ls_find_args[@]}")
  # NOTE: 初回カウントをtime orderの基準とする
  # 2回目以降は連想配列に保存し，ENDでprintする
  {
    git log --name-only --pretty='' "${ls_find_args[@]}" | awk '!a[$0]++' | {
      if [[ -n $GIT_GREP_TIME_REVERSE ]]; then
        tac
      else
        command cat
      fi
    } | git_remove_root_rel_pwd_prefix
    git grep --color=always "$@"
    # NOTE: 色付きにするとファイル名の一致ができなくなるため，除去
  } | awk -F":" 'BEGIN{idx=0;}{file=gensub(/\033\[[0-9]*m/, "", "g", $1); c=++cnt[file];if(c==1){idx++;files[idx]=file;}if(c>=2){m[file][c]=$0;}} END{for(i=1;i<=idx;i++){file=files[i]; for(j=2;j<=cnt[file];j++){printf "%s\n",m[file][j];}}}'
}
function git-grep-time-reverse() {
  GIT_GREP_TIME_REVERSE=1 git-grep-time "$@"
}
function git-grep-time-pecovim() {
  is_git_repo_with_message || return
  git-grep-time "$@" | pecovim
}
function git-grep-time-color-pecovim() {
  is_git_repo_with_message || return
  git-grep-time "$@" | remove-ansi | ranking_color_cat | pecovim
}
function git-grep-time-reverse-pecovim() {
  is_git_repo_with_message || return
  git-grep-time-reverse "$@" | pecovim
}
function git-grep-time-reverse-color-pecovim() {
  is_git_repo_with_message || return
  git-grep-time-reverse "$@" | remove-ansi | ranking_color_cat | pecovim
}

function git-typo-peco-vim() {
  is_git_repo_with_message || return
  # FYI: [mattn/typogrep]( https://github.com/mattn/typogrep )
  if ! type >/dev/null 2>&1 typogrep; then
    echo 1>&2 "Not found typogrep"
    echo 1>&2 "go get github.com/mattn/typogrep"
    return 1
  fi
  typogrep $(git ls-files) | pecovim
}

function git-add-force-peco() {
  is_git_repo_with_message || return
  git ls-files -o | pecocat | while IFS= read -r filepath || [[ -n "$filepath" ]]; do
    echo -n "$YELLOW"
    printf '# git add -f %s\n' "$filepath"
    echo -n "$DEFAULT"
    git add -f "$filepath"
  done
}
function git-file-ranking-peco() {
  is_git_repo_with_message || return
  local target=${1:-.}
  git-file-ranking "$target" | ranking_color_cat | fzf --no-sort
}

function git-log-diff-current() {
  is_git_repo_with_message || return
  git-log-diff .
}
function git-log-diff() {
  is_git_repo_with_message || return
  local target=($1)
  git log --name-only "${target[@]}" | git-log-diff-peco
}
function git-log-diff-peco() {
  local query=""
  # NOTE: 選択しているcommit_hashがinitial commit hashの場合の例外処理がない

  # fot fzf ~0.18.0
  # awk '{str=$0;} /^commit/{commit_hash=substr($2, 0, 7); str="\033[33m"$0"\033[0m"} /^ +/{str="\033[35m"$0"\033[0m"}!/^commit/ && !/^Author:/ && !/^Date:/ && !/^ +/ && NF {str=sprintf("%-40s\033[90m:%s\033[0m", $0, commit_hash);} NF>0 {printf "%s\n", str;}' \
  # | fzf --multi --ansi --reverse --preview 'cd "$(git rev-parse --show-toplevel)"; commit_hash=$(echo {} | cut -d":" -f2); filepath=$(echo {} | cut -d":" -f1 | sed -E "s/ +$//"); fullpath="$filepath"; [[ -n "$commit_hash" ]] && [[ -e "$fullpath" ]] && git diff --color "${commit_hash}~" "${commit_hash}" "$filepath"' --preview-window 'right:70%' --query="$query" | awk -F':' '{printf "%s:%s\n",$2,$1}'

  # fot fzf 0.19.0~
  # NOTE: $(printf "%s" {q}) means split query
  awk '{str=$0;} /^commit/{commit_hash=substr($2, 0, 7); str="\033[33m"$0"\033[0m"} /^ +/{str="\033[35m"$0"\033[0m"}!/^commit/ && !/^Author:/ && !/^Date:/ && !/^ +/ && NF {str=sprintf("%-40s\033[90m:%s\033[0m", $0, commit_hash);} NF>0 {printf "%s\n", str;}' \
    | fzf --phony --multi --ansi --reverse --preview 'cd "$(git rev-parse --show-toplevel)"; commit_hash=$(echo {} | cut -d":" -f2); filepath=$(echo {} | cut -d":" -f1 | sed -E "s/ +$//"); fullpath="$filepath"; [[ -n "$commit_hash" ]] && [[ -e "$fullpath" ]] && git diff --color "${commit_hash}~" "${commit_hash}" "$filepath" | { q={q}; [[ -n $q ]] && grep -C 3 --color=always $(printf "%s" {q} | tr " " "\n" | awk "{printf \"-e %s \", \$1}") || cat }' --preview-window 'right:70%' --query="$query" | awk -F':' '{printf "%s:%s\n",$2,$1}'
}

alias git-diff-peco="git-show-peco"
function git-show-peco() {
  is_git_repo_with_message || return
  local commit=$(_git-commit-peco)
  [[ -z $commit ]] && return 1
  git show "$commit"
}

alias color_peco_ansi='ansi_color_peco'
alias color_peco_ansi256='ansi_color_256_peco'
alias color_peco_hex256='hex_color_256_peco'
alias color_peco_hexfull='hex_color_full_peco'
function ansi_color_peco() {
  cat ~/dotfiles/local/dict/color/ansi_color.txt | fzf --no-sort | cut -d':' -f2
}
function ansi_color_256_peco() {
  cat ~/dotfiles/local/dict/color/ansi_color_256.txt | fzf --no-sort | cut -d':' -f2
}
function hex_color_256_peco() {
  cat ~/dotfiles/local/dict/color/ansi_color_256.txt | fzf --no-sort | cut -d':' -f3
}
function hex_color_full_peco() {
  cat ~/dotfiles/local/dict/color/color_full.txt | fzf --no-sort | cut -d':' -f3
}

alias vimbackuppeco='vim-backup-peco'
function vim-backup-peco() {
  [[ $# -lt 1 ]] && echo "$(basename "$0") filepath" && return 1
  local filepath="$1"
  local absfilepath="$(abspath_raw "$filepath")"
  local filename="$(basename "$filepath")"
  local dirpath="$(dirname "$absfilepath")"
  local vim_backup_tmpdir="$HOME/.vim/tmp/"
  find "$vim_backup_tmpdir/$dirpath" -name "[0-9][0-9][0-9][0-9].${filename}" -maxdepth 1 | LANG=C sort -r | pecodiff "$filepath" | xargs-vim
}

function pecodiff() {
  [[ $# -lt 1 ]] && echo "$(basename "$0") filepath" && return 1
  local filepath="$1"
  local diff_cmd='diff'
  type >/dev/null 2>&1 icdiff && diff_cmd='icdiff -U 1 --line-numbers --cols='$(tput cols)
  fzf --multi --ansi --reverse --preview "$diff_cmd '$filepath' {}" --preview-window 'down:80%'
}

alias git-file-history='git-file-log-cat'
function git-file-log-cat() {
  ! type >/dev/null 2>&1 bat && echo 1>&2 "install bat" && return 1
  [[ $# -lt 1 ]] && echo "$(basename "$0") filepath" && return 1
  local filepath="$1"
  local ext=${filepath##*.}
  # git log --color=always --oneline "$filepath" | fzf --multi --ansi --reverse --preview "git cat-file -p \$(echo {} | cut -c-7):'$filepath' | bat --color=always -l '$ext'" --preview-window 'down:80%'
  git log --color=always --oneline "$filepath" | fzf --multi --ansi --reverse --preview "splitcat <(git diff --color=always HEAD \$(echo {} | cut -c-7) '$filepath') <(git cat-file -p \$(echo {} | cut -c-7):'$filepath' | bat -p --color=always -l '$ext')" --preview-window 'down:80%'
}

# FYI: [Longest common prefix of two strings in bash \- Stack Overflow]( https://stackoverflow.com/questions/6973088/longest-common-prefix-of-two-strings-in-bash )
function get_common_prefix() {
  local string1="$1"
  local string2="$2"
  printf "%s\n%s\n" "$string1" "$string2" | sed -e 'N;s/^\(.*\).*\n\1.*$/\1/'
}
function get_common_filepath_prefix() {
  local string1="$1"
  local string2="$2"
  echo $(dirname $(printf "%s\n%s\n" "$string1" "$string2" | sed -e 'N;s/^\(.*\).*\n\1.*$/\1/')".")"/"
}
function cmakedirs() {
  for dir in $(traverse_path_list $PWD); do
    for build_dir in $(find "$dir" -maxdepth 1 -name '*build*'); do
      local common_filepath_prefix=$(get_common_filepath_prefix "$build_dir/" "$PWD/")
      local rel_pwd="${PWD:${#common_filepath_prefix}}"
      # NOTE: for another build dir (e.g. build and build-arm)
      rel_pwd=${rel_pwd#*build*/}
      [[ -d "$dir/$rel_pwd" ]] && [[ "$dir/$rel_pwd" != "$PWD" ]] && echo "${GRAY}${dir}/${GREEN}${rel_pwd}${DEFAULT}"
      [[ -d "$build_dir/$rel_pwd" ]] && [[ "$build_dir/$rel_pwd" != "$PWD" ]] && echo "${GRAY}${build_dir}/${GREEN}${rel_pwd}${DEFAULT}"
    done
    # NOTE: for color
  done | awk '!a[$0]++' | grep --color=always -e '^' -e 'build'
}
function cdcmake() {
  local ret=$(cmakedirs)
  [[ -z $ret ]] && return 1
  printf '%s' "$ret" | FZF_DEFAULT_OPTS="--height '30%'" cdpeco
}

alias errno='errnopeco'
alias pecoerrno='errnopeco'
function errnopeco() {
  bat --color=always -p ~/dotfiles/local/dict/cpp/errno.hpp | fzf
}

function cmake-find-modules() {
  # NOTE: ext may be rst(reStructuredText)?
  cmake --help-module-list | grep -e '^Find' | sed 's/Find//' | fzf --preview='cmake --help-module Find{} | bat --color=always -p -l md' --preview-window='right:80%'
}

function git-clone-peco() {
  local target
  target=$(history | cut -c8- | grep '^git clone' | fzf --query="'")
  [[ -z $target ]] && return
  printf '%s' "$target"
  eval "$target"
}

function get_arm_neon_header() {
  local cache_dir="$HOME/.cache/dotfiles/"
  mkdir -p "$cache_dir"
  if [[ ! -e "$cache_dir/arm_neon.h" ]]; then
    wget https://raw.githubusercontent.com/gcc-mirror/gcc/master/gcc/config/aarch64/arm_neon.h -O "$cache_dir/arm_neon.h"
  fi
  printf '%s' "$cache_dir/arm_neon.h"
  return 0
}

alias arm_neon_peco='peco_arm_neon'
function peco_arm_neon() {
  local arm_neon_header=$(get_arm_neon_header)
  {
    # NOTE: type
    cat $arm_neon_header | grep "^typedef"
    # NOTE: funcs
    cat $arm_neon_header | grep -A 3 "__extension__" | grep -v '\--' | sed -e 's/__extension__ extern __inline //g' | sed 's/__attribute__ ((__always_inline__, __gnu_inline__, __artificial__))//g' | awk -v n=4 -v delim=" " 'NR%n!=1{printf "%s", delim;} {printf "%s", $0;} NR%n==0{printf "\n";}' | sed -E -e 's/__extension__ extern __inline //' -e 's/__attribute__ //' -e 's/\(\(__always_inline__, __gnu_inline__, __artificial__\)\) //' -e 's/[ \t]+/ /g' -e 's/ *\{$//g' | grep -v '^[ \t{]' | grep -v 'funcsuffix'
  } | fzf
}

# NOTE: before using below function, run 'gtags -v'
# shellの補完として利用する方法もある
# global calc[TAB]
function global_func_prefix() {
  local function_prefix="$1"
  if [[ -z "$function_prefix" ]]; then
    function_prefix="$(global -c | fzf --query "'")"
    if [[ -z "$function_prefix" ]]; then
      return 1
    fi
  fi
  global -x "^$function_prefix" | awk '{printf "%s:%d\n", $3, $2}' | pecovim
}

# FYI: [Examples · junegunn/fzf Wiki]( https://github.com/junegunn/fzf/wiki/examples#processes )
# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
alias killpeco='fkill'
function fkill() {
  local pid
  local sinal_num
  signal_num=${1:-9}
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m -q "'" | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m -q "'" | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    printf '%s' "$pid" | xargs kill "-${signal_num}"
  fi
}

if cmdcheck jq; then
  # NOTE: this wrapper is used for avoiding 'Argument list too long' error
  # NOTE: output keep include ansi color codes
  function wrap_fzf_preview() {
    if [[ ! -p /dev/stdin ]]; then
      command cat <<'EOF'
wrap_fzf_preview [fzf options]...
  e.g. echo -e "abc\ndef\00xyz" | wrap_fzf_preview
EOF
      return 1
    fi
    local json_tmpfilepath=$(mktemp).json
    local input_tmpfilepath=$(mktemp).log
    tee "$input_tmpfilepath" | ruby -r json -0ne 'BEGIN{d=[]}; d.push($_[0...-1]); END{puts JSON.pretty_generate(d)}' >"$json_tmpfilepath"
    local ret
    ret=$(cat "$input_tmpfilepath" | perl -0ne 'BEGIN{$i=0} printf "%s[%3d]%s:%s",$ENV{GRAY}, $i,$ENV{DEFAULT}, $_; $i++' \
      | command fzf --ansi --read0 --print0 --preview "$(
        cat <<EOF
    id=\$(echo {} | head -n 1 | sed -E 's/^\[ *([\s0-9]+)].*$/\1/')
    cat "$json_tmpfilepath" | jq -r ".[\$id]"
EOF
      )" "$@")
    [[ -z $ret ]] && return

    local ids=($(printf '%s' "$ret" | perl -0ne 'if($_ =~ /^.*?\[ *([0-9]+)\]:/){ printf "%s\n", $1;}'))
    for id in "${ids[@]}"; do
      cat "$json_tmpfilepath" | jq -r ".[$id]"
    done
  }
fi

if cmdcheck copyq; then
  # FYI: [hluk/CopyQ: Clipboard manager with advanced features]( https://github.com/hluk/CopyQ )
  # FYI: [Command Line — CopyQ documentation]( https://copyq.readthedocs.io/en/latest/command-line.html )
  alias clipeco='clippeco'
  function clippeco() {
    local n
    local max=${1:-30}
    local tab=${COPYQ_TAB:-'&clipboard'}
    n=$(copyq eval -- "tab('$tab'); max=$max; if (max<0) max=size(); for(i=1; i<=max; i++) print(str(read(i-1)) + '\0');" | perl -0ne 'BEGIN{$count=0} $_ =~ s/\n/\\n/g; printf("[%3d]:%s", $count,$_); $count++' | tr '\0' '\n' | bat -l js --plain --color always --theme "zenburn" | fzf --query="'" | sed -E 's/^\[[ ]*([0-9]+)\]:.*$/\1/g')
    [[ -z $n ]] && return
    echo 1>&2 "${YELLOW}[log] copy copyq['$n']${DEFAULT}"
    copyq tab "$tab" read "$n" | tee >(bat -l js --plain --color always --theme "zenburn" >/dev/stderr) | c
  }
  function copyq_remove() {
    local n
    local tab=${COPYQ_TAB:-'&clipboard'}
    items=($(copyq eval -- "tab('$tab'); for(i=1; i<=size(); i++) print(str(read(i-1)) + '\0');" | perl -0ne 'BEGIN{$count=0} $_ =~ s/\n/\\n/g; printf("[%3d]:%s", $count,$_); $count++' | tr '\0' '\n' | bat -l js --plain --color always --theme "zenburn" | fzf --query="'" --multi | sed -E 's/^\[[ ]*([0-9]+)\]:.*$/\1/g' | tac))
    [[ -z $items ]] && return
    for n in "${items[@]}"; do
      echo -n "${YELLOW}[log] remove copyq['$n']${DEFAULT}: " 1>&2
      copyq tab "$tab" read "$n" 1>&2
      echo 1>&2 ''
      copyq tab "$tab" remove "$n" 1>&2
    done
  }
  function copyq_init() {
    copyq config command_history_size 10000 # default: 100, max: 10000
    copyq config maxitems 10000             # default: 200, max: 10000
  }
  function copyq_clean() {
    copyq removetab "&clipboard"
  }
fi

if cmdcheck tmux; then
  alias tmuxh='tmux-history'
  function tmux-history() {
    if [[ ! -n "$TMUX" ]]; then
      echo 1>&2 'not in tmux'
      return 1
    fi
    # | perl -0pe "s/^()(.*)(❯)(❯)(❯) ([^ ]*)/${BLUE}\$2 ${RED}\$3${YELLOW}\$4${GREEN}\$5 ${PURPLE}\$6${DEFAULT}/g" \
    # NOTE: -e: with ansi color, -p: output is stdout, -NUMBER: negative line number for rollback start line
    local history_limit=$(tmux show-options -g history-limit | cut -d' ' -f2)
    [[ -z $history_limit ]] && history_limit='10000'
    tmux capture-pane -epS "-${history_limit}" \
      | perl -ne "$(
        cat <<'EOF'
BEGIN {
  $flag=0;
  $line="";
  @lines=();
}
if ($_ =~ /^.*❯.*❯.*❯/) {
  if ($flag ne 0) {
    push(@lines, $line);
  }
  $line = $_;
  $flag = 1;
} elsif ($flag eq 1) {
  $line .= $_;
}
END {
  foreach $val (reverse(@lines)) {
    printf "%s\0", $val;
  }
}
EOF
      )" \
      | wrap_fzf_preview --multi --no-mouse --no-hscroll --preview-window 'down:70%' --query="'" \
        --bind='ctrl-x:cancel,btab:backward-kill-word,ctrl-g:jump,ctrl-f:backward-delete-char,ctrl-h:backward-char,ctrl-l:forward-char,shift-left:preview-page-up,shift-right:preview-page-down,shift-up:preview-up,shift-down:preview-down' \
      | remove-ansi | remove_terminal_extra_string
  }
  alias tmuxhvim='tmux-history-vim'
  function tmux-history-vim() {
    local ret
    ret=$(tmux-history)
    if [[ -z $ret ]]; then
      return
    fi
    printf '%s' "$ret" | pipevim $(mktemp).log
  }
fi

function cargo-crate-local-history() {
  ls ~/.cargo/registry/src/github.com-1ecc6299db9ec823/ | sed -E 's/-[0-9]+\.[0-9]+\.[0-9]+$//' | uniq
}

function cargo-crate-local() {
  cargo metadata --format-version=1 --no-deps | jq '.packages[].dependencies[].name' -r
}

if cmdcheck cargo-add; then
  function cargo-adds() {
    cargo-add-fzf "$@"
  }
  function cargo-add-fzf() {
    local ret
    ret=$({
      cat <<EOF
tokio --features full
serde --features derive
serde_json
serde_yaml
serde_derive

ansi_term
anyhow
atty
byteorder
bytes
clap
cpp_demangle
crossbeam
crossbeam-channel
csv
derive_builder
dirs
env_logger
image
log
num
num-derive
num-traits
opencv
parse-size
prost
prost-derive
regex
snap
structopt
strum
strum_macros
thiserror
webp

tonic --features compression
tonic-build --features compression
redis --features tokio-comp --features streams
EOF
      cargo-crate-local-history
    } | awk '!a[$0]++' | fzf)
    if [[ -z $ret ]]; then
      return
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
      bash -c "cargo add $line"
    done < <(printf '%s' "$ret")
  }
  function cargo-add-features() {
    local ret
    ret=$(cargo metadata --format-version=1 --no-deps | jq '.packages[].dependencies[] | { name:.name, features:.features }' -r -c -C | fzf)
    if [[ -z $ret ]]; then
      return
    fi
    local crate_name=$(printf '%s' "$ret" | jq '.name' -r)
    if type >/dev/null 2>&1 cargo-feature; then
      cargo feature "$crate_name"
      echo '^hoge: remove hoge feature'
      print -z "cargo feature $crate_name "
    else
      local crate_features=$(printf '%s' "$ret" | jq '.features | @tsv' -r)
      local crate_features_flag_text=$(printf '%s' "$crate_features" | sed -E 's/^|\t|$/ --features=/g')

      print -z "cargo add ${crate_name}${crate_features_flag_text}"
    fi
  }

  function cargo-rm-fzf() {
    local ret
    ret=$(cargo-crate-local | fzf)
    if [[ -z $ret ]]; then
      return
    fi
    cargo rm "$(printf '%s' "$ret" | xargs)"
  }
fi
if cmdcheck rustup; then
  function rustup-toolchain-switch() {
    local ret
    ret=$(rustup toolchain list | fzf)
    if [[ -z $ret ]]; then
      return
    fi
    local toolchain=$(printf '%s' "$ret" | sed 's/ (default)//')
    rustup default "$toolchain"
  }
fi

function ctest-peco() {
  local test_name
  test_name=$(ctest -N | grep '^  Test' | fzf | sed -E 's/^ *Test #[0-9]+: *//g')
  if [[ -z $test_name ]]; then
    return
  fi
  printf '%s' "ctest . -V -R $test_name" | to_prompt
}

function act-job() {
  [[ $1 =~ ^(-h|-{1,2}help)$ ]] && echo "$0 "'[event(push, pull_request, ...)]' && return 1

  local job_name
  local output
  local event="$1"
  output=$(act -l $event)
  if [[ $? != 0 ]]; then
    printf '%s' "$output"
    return 1
  fi
  job_name=$(printf '%s' "$output" | fzf | grep -v '^Stage' | awk '{ print $2 }')
  if [[ -z $job_name ]]; then
    return
  fi
  printf '%s' "act -j $job_name" | to_prompt
}
