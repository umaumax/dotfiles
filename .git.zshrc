#!/usr/bin/env zsh
# MEMO
# git-xxx系はaliasではなくfunctionとすること
# 下記のコマンドではaliasは実行できないため
# NOTE: e.g. bind git open to git-open function (not command)
function git() {
  local cmd="git-$1"
  if ! cmdcheck "$cmd"; then
    command git "$@"
    return
  fi
  shift 1
  "$cmd" "$@"
}

function git-count() {
  git rev-list --count HEAD
}

function git-update-dummy-alias() {
  local dummy_alias_filepath="$HOME/dotfiles/.dummy_alias.gitconfig"
  cat <<'EOF' >$dummy_alias_filepath
# NOTE: dummy alias list for zsh completion
#
[alias]
EOF
  {
    alias | grep '^git-' | sed -E 's/^(git-[^=]*)=.*$/\1/g'
    functions-list | grep '^git-'
  } | sort | uniq | sed -E 's/^git-(.*)$/'"$(printf '\t')"'\1 = :/g' >>~/dotfiles/.dummy_alias.gitconfig
}

alias gm='git mergetool'
alias merge='git mergetool'

alias gr='cd-git-root'
alias cdgr='cd-git-root'
# [ターミナルからカレントディレクトリのGitHubページを開く \- Qiita]( https://qiita.com/kobakazu0429/items/0dc93aeeb66e497f51ae )
function git-open() {
  is_git_repo_with_message || return
  local url=$(git-url "$@")
  if [[ -n $url ]]; then
    open "$url"
  else
    open $(git remote -v | head -n 1 | awk '{ print $2 }' | awk -F'[:]' '{ print $2 }' | awk -F'.git' '{ print "https://github.com/" $0 }')
  fi
}
alias git-alias-list='git alias | sed "s/^alias\.//g" | sed -e "s:^\([a-zA-Z0-9_-]* \):\x1b[35m\1\x1b[0m:g" | sort | '"awk '{printf \"%-38s = \", \$1; for(i=2;i<=NF;i++) printf \"%s \", \$i; print \"\";}'"
function git-ranking() {
  builtin history -r 1 | awk '{ print $2,$3 }' | grep '^git' | sort | uniq -c | awk '{com[NR]=$3;a[NR]=$1;sum=sum+$1} END{for(i in com) printf("%6.2f%% %s %s \n" ,(a[i]/sum)*100."%","git",com[i])}' | sort -gr | uniq | sed -n 1,30p | cat -n
}
function vim-git-modified() {
  is_git_repo_with_message || return
  vim -p $(git diff --name-only)
}
# NOTE: あるファイルを特定のcommitのファイルの状態にする
function git-revert-files() {
  is_git_repo_with_message || return
  local target=${1:-"HEAD^"}
  git diff --name-only HEAD "$target" | awk 'BEGIN{ print "# edit below commands and run by yourself" }{ printf "git checkout \"'"$target"'\" %s\n", $0}' | vim -
}
function git-restore-stash() {
  is_git_repo_with_message || return
  git fsck --unreachable | grep commit | cut -d' ' -f3 | xargs git log --merges --no-walk --grep=WIP
  echo '--------------------------------'
  echo '--------------------------------'
  echo "$RED If you want to restore commit, put below command! $DEFAULT"
  echo "$PURPLE git cherry-pick -n -m1 <commit id> $DEFAULT"
  echo '--------------------------------'
  echo '--------------------------------'
}
function _grep_if_file_exist() {
  local git_root_path="$(git rev-parse --show-toplevel)"
  local grep='grep'
  cmdcheck 'ggrep' && local grep='ggrep'
  awk 1 | while read LINE; do
    local filepath="$git_root_path/$LINE"
    [[ -e "$filepath" ]] && $grep -E '^[><=]{7}' -C 1 -H -n --color=always "$filepath"
  done
}
# FYI: [\[Git\]コンフリクトをよりスマートに解消したい！ \- Qiita]( https://qiita.com/m-yamazaki/items/62fc1f877c7ab315e0d8 )
function git-find-conflict() {
  is_git_repo_with_message || return
  local changed=$(git diff --cached --name-only)
  [[ -z "$changed" ]] && return

  # abs path
  local _home=$(echo $HOME | sed "s/\//\\\\\//g")
  #   local ret=$(echo $changed | xargs -L 1 -IXXX $grep -E '^[><=]{7}' -C 1 -H -n --color=always "$git_root_path/XXX" | sed "s/$_home/~/")
  local ret=$(echo $changed | _grep_if_file_exist | sed "s/$_home/~/")
  # rel path
  #   pushd $git_root_path >/dev/null 2>&1
  #   echo $changed | xargs -L 1 -IXXX $grep -E '^[><=]{7}' -C 1 -H -n --color=always XXX
  #   popd >/dev/null 2>&1

  ## If the egrep command has any hits - echo a warning and exit with non-zero status.
  if [[ -n $ret ]]; then
    echo $ret
    echo "${RED}WARNING: You have merge markers in the above files, lines. Fix them before committing.${DEFAULT}"
    return 1
  fi
}
function git-reload-local-hooks() {
  is_git_repo_with_message || return
  local git_templatedir=${1:-}
  [[ -n $git_templatedir ]] && [[ ! -d $git_templatedir ]] && echo "no such dir '$git_templatedir'" && return 1
  [[ -z $git_templatedir ]] && local git_templatedir="$(git rev-parse --show-toplevel)/.local$(basename $(git config init.templatedir))"
  [[ -n $git_templatedir ]] && [[ ! -d $git_templatedir ]] && echo "no local git_templatedir '$git_templatedir'" && local git_templatedir="$(git config init.templatedir | sed -e "s:^~/:$HOME/.local:g")"
  [[ -n $git_templatedir ]] && [[ ! -d $git_templatedir ]] && echo "no local git_templatedir '$git_templatedir'" && return 1
  git-reload-global-hooks "$git_templatedir"
}
function git-reload-global-hooks() {
  is_git_repo_with_message || return
  local git_templatedir=${1:-$(git config init.templatedir | sed -e "s:^~:$HOME:g")}
  [[ -z $git_templatedir ]] && echo 'no git_templatedir setings \n e.g. git config --global init.templatedir ~/.git_template/' && return 1
  [[ ! -d $git_templatedir ]] && echo "no such dir '$git_templatedir'" && return 1
  local git_hookdir="$git_templatedir/hooks"
  command cp -r "$git_hookdir/" "$(git rev-parse --show-toplevel)/.git/hooks"
}
# [Git フックの基本的な使い方 \- Qiita]( https://qiita.com/noraworld/items/c562de68a627ae792c6c#%E6%B3%A8%E6%84%8F%E7%82%B9%E3%81%BE%E3%81%A8%E3%82%81 )
function git-find-last-space() {
  local CAT='cat'
  # NOTE: maybe colout is slow
  cmdcheck colout && local CAT="colout '([^:]+):([0-9]+)' yellow,blue"
  git grep -e $'\t''$\| $' | eval $CAT | grep -e '\t''*$\| *$'
}
function git-find-last-space-vim() {
  local filelist=$(git-find-last-space)
  {
    echo '# original key mapping info'
    echo '# gf: open file'
    echo '# go: next'
    echo '# gi: back'
    echo ''
    echo $filelist
  } | command vim --cmd "let g:auto_lcd_basedir=0 | autocmd VimEnter * :execute ':w '.tempname() | :lcd $PWD" -
}

cmdcheck 'git-ls' && alias gls='git-ls'
# NOTE: 差分が少ないファイルから順番にdiffを表示
function git_diff() {
  is_git_repo_with_message || return

  local diff_cmd=${GIT_DIFF_CMD:-diff}
  # FYI: [\[git\]git diff \-\-stat でパスを省略しない方法 \- dackdive's blog]( https://dackdive.hateblo.jp/entry/2014/05/13/112549 )
  local files=($(git diff --stat --stat-width=9999 "$@" | awk '{ print $3 " "$4 " " $1}' | sort -n | grep -v '^changed' | cut -f3 -d' '))
  local tmpfile=$(mktemp '/tmp/git.tmp.orderfile.XXXXX')
  for file in "${files[@]}"; do
    [[ -f "$file" ]] && printf '%s\n' "$file" >>$tmpfile
  done
  git-at "$(git rev-parse --show-toplevel)" "$diff_cmd" -O${tmpfile} "$@"
  [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
}
alias gd='git_diff'
alias gdh='      gd HEAD'
alias gdhh='     gd HEAD~     HEAD'
alias gdhhh='    gd HEAD~~     HEAD~'
alias gdhhhh='   gd HEAD~~~    HEAD~~'
alias gdhhhhh='  gd HEAD~~~~   HEAD~~~'
alias gdhhhhhh=' gd HEAD~~~~~  HEAD~~~~'
alias gdhhhhhhh='gd HEAD~~~~~~ HEAD~~~~~'

alias gdc='       gd        --relative=.'
alias gdhc='      gdh       --relative=.'
alias gdhhc='     gdhh      --relative=.'
alias gdhhhc='    gdhhh     --relative=.'
alias gdhhhhc='   gdhhhh    --relative=.'
alias gdhhhhhc='  gdhhhhh   --relative=.'
alias gdhhhhhhc=' gdhhhhhh  --relative=.'
alias gdhhhhhhhc='gdhhhhhhh --relative=.'

alias gdw='gd --word-diff'
alias gdhw='gdh --word-diff'
alias gdhhw='gdhh --word-diff'
alias gdhhhw='gdhhh --word-diff'
alias gdhhhhw='gdhhhh --word-diff'
alias gdhhhhhw='gdhhhhh --word-diff'
alias gdhhhhhhw='gdhhhhhh --word-diff'
alias gdhhhhhhhw='gdhhhhhhh --word-diff'

alias gdcw='gdc --word-diff'
alias gdhcw='gdhc --word-diff'
alias gdhhcw='gdhhc --word-diff'
alias gdhhhcw='gdhhhc --word-diff'
alias gdhhhhcw='gdhhhhc --word-diff'
alias gdhhhhhcw='gdhhhhhc --word-diff'
alias gdhhhhhhcw='gdhhhhhhc --word-diff'
alias gdhhhhhhhcw='gdhhhhhhhc --word-diff'

alias gdst='git diff --staged'

alias ga='git add --all'
alias gc='git commit'
alias gadd='git add'
alias gap='git add -p'
alias gai='git add -i'
# this alias overwrite Ghostscript command
alias gs='git status'
alias gsall='git status --ignored --untracked-files'
alias gst='git status'
alias gstall='git status --ignored --untracked-files'
alias gsc='git status .'
alias gscall='git status --ignored --untracked-files .'
alias gstc='git status .'
alias gstcall='git status --ignored --untracked-files .'
alias gstp='git log HEAD...HEAD~ --stat'

alias glog='git log'
# NOTE: [git logでマージコミットの中の変更を表示する \- blog\.ton\-up\.net]( https://blog.ton-up.net/2013/11/11/git-log-merge-diff/ )
alias gstlog='git log --stat -c'
alias gstlogp='git log --stat -c -p'
alias glogst='git log --stat'
alias glogstat='git log --stat'
function git-add-peco() {
  local SELECTED_FILE_TO_ADD="$(git status --short | peco | awk -F ' ' '{print $NF}')"
  if [ -n "$SELECTED_FILE_TO_ADD" ]; then
    git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')
    git status
  fi
}

# git grep settings
alias gg='git_grep_root'
alias ggr='git_grep_root'
alias ggc='git_grep_current'
alias ggpv='ggpv_root'
alias ggpvr='ggpv_root'
# NOTE: you can use with -C option
alias ggpvc='ggpv_current'
function ggpv_root() {
  git_grep_root --color=always "$@" | pecovim
}
function ggpv_current() {
  if [[ $# == 0 ]]; then
    # NOTE: required 0.19.0~
    # [fzf/CHANGELOG\.md at master · junegunn/fzf]( https://github.com/junegunn/fzf/blob/master/CHANGELOG.md#0190 )
    local git_grep_cmd='git grep -n --color=always '
    # NOTE: eval is for joining query command not as a quoted word
    local ret
    ret=$(eval "$git_grep_cmd ''" | fzf --bind "change:reload: eval '$git_grep_cmd '{q} || true" --phony --print-query)
    [[ -z $ret ]] && return
    local query
    query=$(printf '%s' "$ret" | head -n 1)
    ggpv_current "$query"
    return
  fi
  git_grep_current --color=always "$@" | pecovim
}
function git_grep_root() { is_git_repo_with_message && git grep "$@" -- $(git rev-parse --show-toplevel); }
function git_grep_current() { is_git_repo_with_message && git grep "$@"; }

alias glpv='git_log_pecovim'
function git_log_pecovim() {
  is_git_repo_with_message || return 1
  pushd $(git rev-parse --show-toplevel) >/dev/null 2>&1
  echo -n $(git log --numstat --format= | sed 's/^[0-9\-]*\t[0-9\-]*\t//g' | awk '!a[$0]++' | pecovim)
  popd >/dev/null 2>&1
}

function git-log-grep() {
  if [[ $# == 0 ]]; then
    # NOTE: required 0.19.0~
    # [fzf/CHANGELOG\.md at master · junegunn/fzf]( https://github.com/junegunn/fzf/blob/master/CHANGELOG.md#0190 )
    local git_log_grep_cmd='git log --color=always --stat -S '
    # NOTE: eval is for joining query command not as a quoted word
    local ret
    ret=$(eval "$git_log_grep_cmd '.'" | fzf --bind "change:reload: eval '$git_log_grep_cmd '{q} || true" --phony --print-query)
    # ls | fzf --bind "change:reload: eval 'git log --color=always --stat -S '{q} || true" --phony --print-query --ansi
    [[ -z $ret ]] && return
    local query
    query=$(printf '%s' "$ret" | head -n 1)
    git-log-grep "$query"
    return
  fi
  # git log --color=always -p --stat -S "$@" | fzf
  git log --name-only -S "$@" | git-log-diff-peco
}

# FYI: [unicode \- grep: Find all lines that contain Japanese kanjis \- Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/65715/grep-find-all-lines-that-contain-japanese-kanjis )
alias gg-japanese='gg -P "[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]"'
alias ggr-japanese='ggr -P "[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]"'
alias ggc-japanese='ggc -P "[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]"'
function git-grep-japanese() { gg-japanese; }
function git-grep-japanese-root() { ggr-japanese; }
function git-grep-japanese-current() { ggc-japanese; }

function is_git_repo() { git rev-parse --is-inside-work-tree >/dev/null 2>&1; }
function is_git_repo_with_message() {
  local message=${1:-"${RED}no git repo here!${DEFAULT}"}
  is_git_repo
  local code=$?
  [[ $code != 0 ]] && echo "$message" >&2
  return $code
}
if cmdcheck tig; then
  alias ts='tig status'
  function tig() {
    if [[ $# == 0 ]]; then
      # NOTE: +5 means 'move to Changes not staged for commit line when no staged file'
      command tig status '+5'
      return
    fi
    command tig "$@"
  }
fi

#######################################
# Name: git-at
# Description: run git command without changing working directory
# Globals:
#   - None
# Output:
#   - git command result
# Arguments:
#   - <repo_dirpath> [commands]...
# Returns:
#   - git command exit code
#######################################
function git-at() {
  # is_git_repo_with_message || return
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
  $(basename "$0") <repo_dirpath> [commands]...
EOF
    return 1
  fi

  local repo_dir=$1
  shift
  local git_repo_dir="$(realpath $repo_dir)"
  local dot_git_dir="$(realpath $repo_dir/.git)"
  git --git-dir "$dot_git_dir" -C "$git_repo_dir" "$@"
}

# NOTE: ignore untracked-files
function git-status-check() {
  local repo_dir=$1
  git-at "$repo_dir" status -sb | grep -E -e '##.*\[ahead [0-9]+]' -e '^ ' >/dev/null 2>&1
  if [[ $? == 0 ]]; then
    return 1
  else
    return 0
  fi
}
function git-history-filter() {
  grep -v -e '/\.' -e 'go/3rd' -e '/dep/'
}
# NOTE: 過去にcdしたdirectoryをsortした後に順番にアクセスし，git statusを行う
function git-history() {
  # -r: Backslash  does not act as an escape character.  The backslash is considered to be part of the line. In particular, a backslash-newline pair can not be used as a line continuation.
  cdinfo | sort | git-history-filter | while IFS= read -r line || [[ -n "$line" ]]; do
    local git_repo_dir="$line"
    local dot_git_dir="$line/.git"
    if [[ -d "$dot_git_dir" ]]; then
      echo "${GREEN}[GIT_HISTORY][FOUND]: $git_repo_dir${DEFAULT}"
      if ! $(git-status-check "$git_repo_dir"); then
        git-at "$git_repo_dir" status
      fi
    fi
  done
}

alias git-find-repo='find-git-repo'
function find-git-repo() {
  local cmd=$0
  find-git-repo-help() {
    echo "$cmd "'[-maxdepth n] [base dir path]...' 1>&2
  }
  [[ $1 =~ ^(-h|-{1,2}help)$ ]] && find-git-repo-help && return 1
  local maxdepth=999
  if [[ $1 == '-maxdepth' ]]; then
    [[ $# == 1 ]] && find-git-repo-help && return 1
    maxdepth=$2
    shift 2
  fi
  local args=(${@})
  [[ $# -le 0 ]] && args=(".")
  local dirpath
  for dirpath in "${args[@]}"; do
    dirpath=$(printf '%s' "$dirpath" | sed "s:^~:$HOME:g")
    [[ ! -d $dirpath ]] && continue
    # NOTE: -follow: traverse symbolic link
    find "$dirpath" -maxdepth "$maxdepth" -follow -type d -name '.git' | sed 's:/\.git$::'
  done
}
alias git-find-repo-and-show-head-commit-hash-id='find-git-repo-and-show-head-commit-hash-id'
function find-git-repo-and-show-head-commit-hash-id() {
  find-git-repo | xargs -L 1 -IXXX bash -c "cd XXX && echo XXX && git rev-parse HEAD"
}

function git-repo-exec() {
  local base_dir=''
  while IFS= read -r git_repo || [[ -n "$git_repo" ]]; do
    echo "# $git_repo"
    git-at "$git_repo" "$@"
  done
}

# NOTE:
# find-git-repo -maxdepth 2 | git-repo-pipe-grep 'pch'
function git-repo-pipe-grep() {
  git-repo-exec --no-pager grep "$@"
}

function git-check-up-to-date() {
  local target=${1:-"."}
  # NOTE: for debug
  echo "[log][$target]"
  local ret
  ret=$(
    cd $(expand_home "$target") >/dev/null 2>&1
    git log "origin/master..master"
  ) || return
  if [[ -n $ret ]]; then
    echo "[log][$target log]"
    printf '%s\n' "$ret"
  fi
  ret=$(
    cd $(expand_home "$target") >/dev/null 2>&1
    git status --porcelain
  ) || return
  if [[ -n $ret ]]; then
    echo "[log][$target status] Changes not staged for commit:"
    printf '%s\n' "$ret"
  fi
}

function cdgit() {
  local git_dirs=('~/dotfiles' '~/git' '~/github.com' '~/local_git')
  local ret=$(find-git-repo "${git_dirs[@]}" | sed "s:^$HOME:~:" | peco | sed "s:^~:$HOME:g")
  [[ -n $ret ]] && cd $ret
}

function find-my-git-non-up-to-date-repo() {
  {
    echo '~/dotfiles'
    find ~/github.com -type d -maxdepth 1 -not -name 'vim' | tail -n +2
    find ~/github.com/chrome-extension -type d -maxdepth 1 | tail -n +2
    find -L ~/github.com/go -type d -maxdepth 1 | tail -n +2
    find ~/github.com/vim -type d -maxdepth 1 | tail -n +2
    # echo '~/local_git'
  } | find-git-non-up-to-date-repo-pipe
}

alias git-find-non-up-to-date-repo='find-git-non-up-to-date-repo'
function find-git-non-up-to-date-repo() {
  find-git-repo "$@" | find-git-non-up-to-date-repo-pipe
}
function find-git-non-up-to-date-repo-pipe() {
  local ccze="cat"
  cmdcheck ccze && ccze="ccze -A"
  while IFS= read -r line || [[ -n "$line" ]]; do
    git-check-up-to-date "$line" | eval $ccze
  done
}
# [Gitのルートディレクトリへ簡単に移動できるようにする関数]( https://qiita.com/ponko2/items/d5f45b2cf2326100cdbc )
function cd-git-root() {
  is_git_repo_with_message || return
  cd $(git rev-parse --show-toplevel)
}

function git-pull-all() {
  is_git_repo_with_message || return
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  for branch in $(git branch -r | grep -v HEAD); do
    # NOTE: remove e.g. 'origin/'
    local local_branch=${branch#*/}
    git checkout $local_branch
    git pull
  done
  git checkout $current_branch
}

cmdcheck diff-filter && alias git-filter='diff-filter -v file=<(git ls-files)'

function git-log-example-add-repo() {
  [[ -d ~/.git-logs ]] || return
  [[ $# -lt 1 ]] && echo "$(basename "$0") [repo url...]" && return 1
  pushd ~/.git-logs
  for repo in "$@"; do
    git clone "$repo"
    local basename=${repo##*/}
    (cd "$basename" && git log --pretty=oneline --abbrev-commit | sed 's/^[0-9a-zA-Z]* //g' | sort -f >"../$basename.log")
  done
  popd
}
function git-log-example-init() {
  mkdir -p ~/.git-logs
  git-log-example-add-repo "https://github.com/fatih/vim-go" "https://github.com/vim/vim"
}
function git-log-example-peco() {
  [[ -d ~/.git-logs/ ]] || return
  cat ~/.git-logs/*.log | peco
}

## git
alias gl='git graph'
alias glst='git graph-stat'

# [\`git remote add upstream\`を楽にする \| Tomorrow Never Comes\.]( http://blog.sgr-ksmt.org/2016/03/04/git_remote_add_upstream/ )
function git-remote-add-upstream() {
  if ! type jq >/dev/null 2>&1; then
    echo "'jq' is not installed." >&2
    return 1
  fi
  local repo=$(git config user.name)/$(basename $PWD)
  if [ $# -ge 1 ]; then
    local repo="$1"
  fi
  echo "repo: $repo"
  local upstream=$(curl -L "https://api.github.com/repos/$repo" | jq -r '.parent.full_name')
  if [ "$upstream" = "null" ]; then
    echo "upstream not found." >&2
    return 1
  fi
  echo git remote add upstream "git@github.com:${upstream}.git"
  git remote add upstream "git@github.com:${upstream}.git"
}

# NOTE: 現在のcommitにおける最新のtagを取得する
function git_tag_name() {
  local commit=$(git rev-parse HEAD)
  if [[ -n $commit ]]; then
    local desc=$(git describe --tags ${commit})
    if $(is_tag "$desc"); then
      git describe --tags ${commit} --abbrev=0
    fi
    return
  fi
}

function git_tag_message() {
  local name=$(git_tag_name)
  local msg=$(git tag -n10000 -l ${name})
  if [[ -n $msg ]]; then
    echo $msg
    local name_n=${#name}
    echo $(substr "$msg" $((name_n + 1)) ${#msg})
  fi
}

function is_tag() {
  local desc=$1
  echo -n "$desc" | perl -ne 'exit int($_ =~ /.+-[0-9]+-g[0-9A-Fa-f]{6,}$/)'
  return $?
}

function substr() { echo -n ${1:$2:${3:-${#1}}}; } #substr( str, pos[, len] )

function git-search-open() {
  open https://github.com/search
}

function git-comments() {
  # NOTE: see GITGLOSSARY(7) <pathspec>
  # NOTE: man 7 gitglossary
  #   git grep -E -e '(^|\s+)//' --and --not -e 'NOTE|TODO' -e '(^|\s+)#' --and --not -e 'NOTE|TODO' -- . ':!*.md' ':!*.txt' ':!*.log'
  #   git grep -E -e '(^|\s+)//' --and --not -e 'NOTE|TODO' -e '(^|\s+)#' --and --not -e 'NOTE|TODO' -- ':CMakeLists.txt'
  git grep -E -e '(^|\s+)//' --and --not -e 'NOTE|TODO|FYI|namespace|[Cc]opyright' -- ':*.cpp' ':*.hpp' ':*.cxx' '*.cc' ':*.c' ':*.h' ':*.go'
  git grep -E -e '(^|\s+)#' --and --not -e 'NOTE|TODO|FYI' -- ':*.python' ':*.sh' ':*rc' ':*.zsh' ':*.ninja'
  #   git grep -E -e '(^|\s+)#' --and --not -e 'NOTE|TODO|FYI' -- ':CMakeLists.txt'
}
function git-comments-todo() {
  git grep -E -e '(^|\s+)//' --and -e 'TODO' -e '(^|\s+)#' --and -e 'TODO' -- . ':!*.md'
}
function git-comments-note() {
  git grep -E -e '(^|\s+)//' --and -e 'NOTE' -e '(^|\s+)#' --and -e 'NOTE' -- . ':!*.md'
}
function git-comments-fix() {
  git grep -E -e '(^|\s+)//' --and -e 'FIX' -e '(^|\s+)#' --and -e 'FIX' -- . ':!*.md'
}

# NOTE: cpp private '_field' to 'field_'
function git-sed-rename-cpp-field() {
  git-sed 's/([^_A-Za-z0-9])_([A-Za-z0-9][_A-Za-z0-9]*)/\1\2_/g' ':*.hpp' ':*.cpp' ':*.cc' ':*.cxx' ':.c' ':*.h'
}

alias gg-comments='git-comments'
alias gg-comments-todo='git-comments-todo'
alias gg-comments-note='git-comments-note'

# FYI: [git branch の結果を時間順にソート: git branch \-\-sort=\-authordate \- Islands in the byte stream]( https://gfx.hatenablog.com/entry/2016/06/10/153747 )
function git-branch-old-to-new() {
  git branch --sort=authordate
}
function git-branch-new-to-old() {
  git branch --sort=-authordate
}

function gitdiffgrep() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
$(basename "$0") [grep options...]
e.g.
  git diff | $(basename "$0") -i func
EOF
    return 1
  fi
  grep '^[+-]' | bat -l diff --color=always | grep "$@"
}

function vimgit() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
$(basename $0) [commit hash] [files...]
open specific commit files by vim
  e.g.
    # choose commit hash intractive
    $(basename $0) README.md
    # open specific commit hash file
    $(basename $0) "HEAD~" README.md
    # open specific commit hash files
    $(basename $0) "HEAD~" README.md deploy.sh
EOF
    return 1
  fi

  local commit_hash=$1
  if git rev-parse --verify $commit_hash >/dev/null 2>&1; then
    # NOTE: use 1st arg as commit_hash
    shift
  else
    local commit_hash=$(_git-commit-peco "$@")
    git rev-parse --verify $commit_hash >/dev/null 2>&1 || return 1
  fi

  local tmpfile_list=()
  for filepath in "$@"; do
    [[ ! -e $filepath ]] && echo "No such file $filepath" 1>&2 && continue
    tmpfile_list=($tmpfile_list $(git show $commit_hash:$filepath 2>/dev/null | pipe_tmpfile $filepath))
  done
  vim -p ${tmpfile_list[@]}
}

function vimgitdiff() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
$(basename $0) [commit hash] [file]
compare different files by vimdiff
  e.g.
    # choose commit hash intractive
    $(basename $0) README.md
    # open specific commit hash file
    $(basename $0) "HEAD~" README.md
    # open specific commit hash files
EOF
    return 1
  fi
  local commit_hash=$1
  if git rev-parse --verify $commit_hash >/dev/null 2>&1; then
    # NOTE: use 1st arg as commit_hash
    shift
  else
    local commit_hash=$(_git-commit-peco "$@")
    git rev-parse --verify $commit_hash >/dev/null 2>&1 || return 1
  fi

  local filepath=$1
  [[ ! -e $filepath ]] && echo "No such file $filepath" 1>&2 && return 1
  local tmpfile=$(git show $commit_hash:$filepath 2>/dev/null | pipe_tmpfile $filepath)
  vimdiff $filepath $tmpfile
}

# NOTE: input pipe
# NOTE: output tmp filepath
function pipe_tmpfile() {
  [[ $# == 0 ]] && echo "$0 [filepath]" && return 0
  local filepath=$1
  # NOTE: 過去にも未来にも他のファイルにも重複しない名称
  local filepath_hash=$(echo "$filepath:$(date +%s%3N)" | md5sum | cut -d' ' -f1)

  # NOTE: at Ubuntu: mktemp: too few X's in template
  # requirements: XXX or more X (X{3,})
  local tmpfile=$(mktemp "/tmp/XXX.$filepath_hash.$(basename $filepath)")
  cat >$tmpfile
  echo "$tmpfile"
}

if $(cmdcheck fzf); then
  alias co='git checkout $(git branch -a | tr -d " " | fzf --height 100% --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")'
  function finder() {
    local ret=$(
      (
        echo '..'
        ls
      ) | fzf --height 100% --prompt "file >" --preview "[[ -d {} ]] && ls {}; [[ -f {} ]] && cat {}"
    )
    [[ -d $ret ]] && cd $ret
    [[ -f $ret ]] && cat $ret
  }
  function tigl() {
    git log --color --oneline | fzf --reverse --ansi --multi --preview 'git -c color.diff=always show {+1}'
  }
fi

alias vim_repo_local_gitignore='vim $(git rev-parse --show-toplevel)/.git/info/exclude'

function git-show-stashes() {
  is_git_repo_with_message || return
  local stash_no
  for stash in "$@"; do
    stash_no=${stash#stash@\{}
    stash_no=${stash_no%\}}
    stash_no=$((GIT_STASH_BASE + stash_no))
    [[ $stash_no =~ ^[0-9]+$ ]] && stash='stash@{'$stash_no'}'
    echo 1>&2 "${YELLOW}[LOG]${DEFAULT} ${GREEN}git stash show -p $stash${DEFAULT}"
    echo 1>&2 "# $stash"
    git stash show -p $stash
  done
}
# NOTE: merge conflictした場合には一部の情報が失われるので危険
function git-apply-stashes() {
  is_git_repo_with_message || return
  [[ $# -lt 1 ]] && echo "$(basename $0) stashes" && return 1
  git-show-stashes "$@" | git apply -3
}
alias git-force-stash-apply='git-stash-apply-force'

alias git-submodule-remove='git-remove-submodule'
function git-remove-submodule() {
  is_git_repo_with_message || return
  [[ $# -le 0 ]] && echo "$(basename $0) submodule file path" && return 1
  local submodule_path=$1
  git submodule deinit -f $submodule_path && git rm -f $submodule_path
}

function git-logs-HEAD() {
  cat "$(git rev-parse --show-toplevel)/.git/logs/HEAD"
}

# NOTE: for my forked project for golang
function go-get-fork() {
  [[ $# -lt 1 ]] && echo "$(basename $0) [https url]" && return 1
  local git_url="$1"
  local api_url=$(echo "$git_url" | sed -E 's:github.com:api.github.com/repos:' | sed -E 's/.git$//g')
  [[ -z $api_url ]] && return 1
  local fork_user_repo=$(curl "$api_url" | jq -r '.parent.full_name')
  [[ -z $fork_user_repo ]] && return 1
  git clone "$git_url" "${GOPATH#*:}/src/github.com/$fork_user_repo"
}

function git-rename() {
  git-find-rename "$@"
}
function git-rename-files() {
  git-find-rename "$@"
}
function git-find-rename() {
  is_git_repo_with_message || return
  if [[ $# == 0 ]] || [[ $1 =~ ^(-h|-{1,2}help)$ ]]; then
    echo "$0 <pattern> [PATH [PATH[...]]]" >&2
    echo 1>&2 " e.g. $0 's/src/dst/g'"
    return 1
  fi
  local rename_pattern="$1"
  shift
  {
    # NOTE: only file
    git ls-files "$@"
    # NOTE: only dir
    git ls-files "$@" | sed -e '/^[^\/]*$/d' -e 's/\/[^\/]*$//g' | sort | uniq
  } | FIND_RENAME_GIT_MV_CMD=1 find-rename-pipe "$rename_pattern"
}

function gstlogfiles() {
  local n=${1:-0}
  git show --pretty="format:" --name-status "HEAD~$n" | grep "^M" | cut -c3-
}
# git_root/abc/def/ -> abc/def
function git_root_rel_pwd() {
  local git_root="$(git rev-parse --show-toplevel)"
  printf '%s' "${PWD:$((${#git_root} + 1))}"
}
# git_root/abc/def/ -> ../..
function git_root_rel_pwd_rev() {
  git_root_rel_pwd | sed -E 's:([^/]+):..:g'
}

function git_remove_root_rel_pwd_prefix() {
  local prefix="$(git_root_rel_pwd)"
  [[ -n "$prefix" ]] && prefix="$prefix/"
  sed -E "s:^$prefix::"
}
function git_add_root_rel_pwd_rev_prefix() {
  local prefix="$(git_root_rel_pwd_rev)"
  [[ -n "$prefix" ]] && prefix="$prefix/"
  awk -v prefix="$prefix" '{printf "%s%s\n", prefix, $0;}'
}

function git-tmp-commit-force() {
  echo "${GREEN}# [git status]${DEFAULT}"
  git status
  echo "${BLUE}# [git add]${DEFAULT}"
  git add $(git rev-parse --show-toplevel) || return
  echo "${GREEN}# [git status]${DEFAULT}"
  git status
  echo "${PURPLE}# [git commit]${DEFAULT}"
  git commit -m '[WIP] TMP COMMIT ALTERNATIVE FOR STASH' || return
  echo -n "${YELLOW}"
  echo "# [git undo command]"
  echo 'git log --pretty=oneline --abbrev-commit "HEAD^..HEAD" && git reset --soft "HEAD^" && git reset'
  echo '# or'
  echo 'git-tmp-commit-force-undo'
  echo -n "${DEFAULT}"
}
function git-tmp-commit-force-undo() {
  git log --pretty=oneline --abbrev-commit "HEAD^..HEAD" && git reset --soft "HEAD^" && git reset
}

function git-wc() {
  git ls-files "$@" | while IFS= read -r filepath || [[ -n "$filepath" ]]; do
    [[ -f $filepath ]] && printf '%q\n' "$filepath"
  done | xargs wc
}
function dotfiles-wc() {
  git-wc ':*rc' ':*.vim'
}
function git-file-ranking() {
  is_git_repo_with_message || return
  local target=${1:-.}
  git log --name-only --pretty='' "$target" | awk 'map[$0]++{} END{for(k in map){print map[k],k;}}' | sort -nr
}

# FYI: [List all authors of a particular git project Using sort]( https://www.commandlinefu.com/commands/view/4519/list-all-authors-of-a-particular-git-project )
function git-is-my-repo() {
  is_git_repo_with_message || return
  [[ $(git shortlog -s | cut -c8-) == $(git config --get user.name) ]]
}
alias git-is-own-repo='git-is-my-repo'

function git-backup() {
  is_git_repo_with_message || return
  for ((i = 0; i < 10; i++)); do
    local backup_branch_name="$(git rev-parse --abbrev-ref HEAD)_$(date +'%Y%m%d')"
    if [[ $i -ge 1 ]]; then
      backup_branch_name="${backup_branch_name}_${i}"
    fi
    if git checkout -b "$backup_branch_name"; then
      if git checkout -; then
        echo "${GREEN}[CREATED]${DEFAULT} $backup_branch_name backup branch"
        return 0
      fi
    fi
  done
}

alias git-checkout-stash='git-stash-checkout'
function git-stash-checkout() {
  is_git_repo_with_message || return
  [[ $# -lt 1 ]] && echo "$(basename "$0") commit id or branch name and so on" && return 1
  git stash && git checkout "$@"
}

function git-stash-checkout-commit-peco() {
  is_git_repo_with_message || return
  git stash && git-checkout-commit-peco
}
function git-stash-checkout-branch-peco() {
  is_git_repo_with_message || return
  git stash && git-checkout-branch-peco
}
function git-stash-checkout-tag-peco() {
  is_git_repo_with_message || return
  git stash && git-checkout-tag-peco
}
function git-stash-rebase-peco() {
  is_git_repo_with_message || return
  git stash && git-rebase-peco
}

# 現在のbranchの分岐元のcommitを表示
function git-show-root-commit-from-master() {
  is_git_repo_with_message || return
  git show-branch --sha1-name master HEAD | tail -n 1 | grep -o '[0-9a-z]\+' | head -n 1
}
function git-rebase-root-commit-from-master() {
  is_git_repo_with_message || return
  local commit="$(git-show-root-commit-from-master)"
  git rebase -i "$commit^"
}
function git-checkout-root() {
  is_git_repo_with_message || return
  git checkout $(git rev-parse --show-toplevel)
}

function git-local-checkout() {
  is_git_repo_with_message || return
  [[ $# -lt 1 ]] && echo "$(basename "$0") branch" && return 1
  local branch=${1}
  local local_branch=${branch#remotes/}
  local_branch=${local_branch#origin/}
  git checkout $local_branch
}

function gerrit-push-review() {
  is_git_repo_with_message || return
  [[ $# -lt 2 ]] && echo "$(basename "$0") [local_sha] [remote_branch]" && return 1
  local local_sha="$1"
  local remote_branch="$2"
  git push origin "${local_sha}:refs/for/${remote_branch}"
}
function gerrit-push-review-haed-to-master() {
  is_git_repo_with_message || return
  gerrit-push-review HEAD master
}
function gerrit-push-review-peco-to-master() {
  is_git_repo_with_message || return
  local commit=$(_git-commit-peco)
  [[ -z $commit ]] && return 1

  hr '#'
  git show $commit --stat
  hr '#'

  echo "${RED}git push origin '${commit}:refs/for/master'${DEFAULT}"
  # NOTE: only for zsh
  echo -n "ok?(y/N): "
  read -q || return 1

  gerrit-push-review $commit master
}

function git-stash-as-patch() {
  is_git_repo_with_message || return
  [[ $# -lt 1 ]] && echo "$(basename "$0") patch_name" && return 1
  local patch_name=$1
  # NOTE: for non-blocking colot output
  git diff HEAD --color | grep --color=never . || return 1

  echo "[LOG] create $1"
  git diff HEAD >$1
  echo "[LOG] git stash save $1"
  git stash save "saved as $1"
  git status
}

function git-stash-unstaged-as-patch() {
  is_git_repo_with_message || return
  [[ $# -lt 1 ]] && echo "$(basename "$0") patch_name" && return 1
  local patch_name=$1
  # NOTE: for non-blocking colot output
  git diff --color | grep --color=never . || return 1

  echo "[LOG] create $1"
  git diff >$1
  echo "[LOG] git stash save $1"
  git stash save --keep-index "saved as $1"
  git status
}

function git-stash-staged-as-patch() {
  is_git_repo_with_message || return
  [[ $# -lt 1 ]] && echo "$(basename "$0") patch_name" && return 1
  local patch_name=$1
  # NOTE: for non-blocking colot output
  git diff --staged --color | grep --color=never . || return 1

  echo "[LOG] create $1"
  git diff --staged >$1
  echo "[LOG] git stash save $1"
  # FYI: [git stash \- Stashing only staged changes in git \- is it possible? \- Stack Overflow]( https://stackoverflow.com/questions/14759748/stashing-only-staged-changes-in-git-is-it-possible )
  git stash save --keep-index "tmp stash" && git stash save "saved as $1" && git stash apply 'stash@{1}' && { git stash show -p | git apply -R; } && git stash drop 'stash@{1}'
  git status
}

if cmdcheck jq; then
  function git-get-all-page() {
    if [[ $# -lt 1 ]]; then
      command cat <<EOF 1>&2
  $(basename "$0") base_query [start_page] [n]
    e.g. "https://api.github.com/users/\$git_user/repos"
EOF
      return 1
    fi
    local base_query=${1}
    local start_page=${2:-1}
    local n=${3:-9999}
    if printf '%s' "$query" | grep -q '?'; then
      base_query="${base_query}&per_page=100"
    else
      base_query="${base_query}?per_page=100"
    fi
    for ((i = 0; i < n; i++)); do
      local page=$((start_page + i))
      local query="${base_query}&page=$page"
      local output
      echo 1>&2 "[log] curl $query"
      output=$(curl "$query")
      if [[ $? != 0 ]] || [[ -z $output ]] || [[ $(printf '%s\n' "$output" | jq length) == 0 ]]; then
        break
      fi
      printf '%s\n' "$output"
    done
  }

  function git-get-repo-names() {
    if [[ $# -lt 1 ]]; then
      command cat <<EOF 1>&2
  $(basename "$0") user
EOF
    fi
    local git_user=$1
    git-get-all-page "https://api.github.com/users/$git_user/repos" | jq -r '.[].name'
  }
fi

if cmdcheck grip; then
  function git-preview() {
    grip "$@"
  }
fi

# FYI: [Git diff with line numbers \(Git log with line numbers\) \- Stack Overflow]( https://stackoverflow.com/questions/24455377/git-diff-with-line-numbers-git-log-with-line-numbers )
# git diff | ./git-lines.sh
function git-diff-lines() {
  gawk '
    match($0,"^diff --git a/(.*) b/.*$",a)                   {filepath=a[1];}
    match($0,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a) {left=a[1];right=a[2];next};
    /^(---|\+\+\+|[^-+ ])/ {print;next};
                           {line=substr($0,2)};
    /^-/                   {print filepath ":" "-" left++ ":" line;next};
    /^[+]/                 {print filepath ":" "+" right++ ":" line;next};
                           {print filepath ":" "(" left++ "," right++ "):"line}
'
}

function git-coverage-review-result() {
  local KEYWORD=${1:-PASS_COV}
  local COMMENT_STR='//'
  git diff | git-diff-lines | grep ':+' | grep "${KEYWORD}" | sed -E "s|${COMMENT_STR}[ ]*${KEYWORD}[^ ]*[ ]*||"
}

function git-coverage-review-result-csv() {
  git-coverage-review-result | awk -F':' '{printf "%s,%d,%d\n", $1,int($2),int($2)}'
}

function git-checkout-local() {
  local branch_name
  branch_name=$(git name-rev --name-only HEAD)
  if [[ ! $branch_name =~ ^remotes/origin/ ]]; then
    echo "${RED}current branch '$branch_name' is not remote branch${DEFAULT}"
    return 1
  fi
  local local_branch_name
  local_branch_name=${branch_name#remotes/origin/}
  git checkout -b "$local_branch_name"
}
