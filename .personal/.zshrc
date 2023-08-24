current_abs_directory_path=$(
  # disable original chpwd function
  chpwd() {}
  # use $PWD beacuse pwd might be user-defined alias
  cd $(dirname $0) && echo $PWD
)
cd ${PERSONAL_HOME:-${current_abs_directory_path%/}}

PERSONAL_HOME="$current_abs_directory_path"

export XDG_CONFIG_HOME=$PERSONAL_HOME/.config
export XDG_CACHE_HOME=$PERSONAL_HOME/.cache
export XDG_DATA_HOME=$PERSONAL_HOME/.local/share

function cmdcheck() { type >/dev/null 2>&1 "$@"; }
function doctor() {
  local cmds=("git" "vim" "tmux" "fzf" "nvim" "delta" "bat" "tig")
  for cmd in ${cmds[@]}; do
    if cmdcheck $cmd; then
      echo -n "✅"
    else
      echo -n "❌"
    fi
    echo $cmd
  done
}

function is_git_repo() { git rev-parse --is-inside-work-tree >/dev/null 2>&1; }
function is_git_repo_with_message() {
  local message=${1:-"${RED}no git repo here!${DEFAULT}"}
  is_git_repo
  local code=$?
  [[ $code != 0 ]] && echo "$message" >&2
  return $code
}
function gl() {
  is_git_repo_with_message || return
  local filepath="$1"
  if [[ -z $filepath ]]; then
    git graph --color=always $(git rev-list -g --all) | less +32k "-p\(HEAD"
  else
    local pattern="$(git log --pretty=%h -m -- "$filepath" | perl -pe "chomp if eof" | tr '\n' '|')"
    [[ -z "$pattern" ]] && echo "invalid filepath:$filepath" && return 1
    local less_pattern="$pattern"
    git-log-pattern "$pattern" "$less_pattern"
  fi
}
function git-log-pattern() {
  is_git_repo_with_message || return
  [[ $# -lt 1 ]] && echo "$(basename "$0") pattern [less_pattern]" && return 1
  local pattern="$1"
  local less_pattern="${2:-$pattern}"
  git log --oneline --decorate=yes --graph --color=always $(git rev-list -g --all) | grep -E -e "^" -e "$pattern" --color=always | less +32k -p"$less_pattern"
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

alias gcb='git checkout -b '
alias gp='git push '
alias gpc='git push origin $(git symbolic-ref --short HEAD)'
alias gpullc='git pull origin $(git symbolic-ref --short HEAD)'

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

alias gcob='git-checkout-branch-peco'
function git-checkout-branch-peco() {
  local branch=$(git-branch-peco)
  [[ -n $branch ]] && git checkout $branch
}
function git-branch-peco() {
  local options=(refs/heads/ refs/remotes/ refs/tags/)
  [[ $# -gt 0 ]] && options=("$@")
  local branch=$(git for-each-ref --format="%(refname:short) (%(authordate:relative)%(taggerdate:relative))" --sort=-committerdate "${options[@]}" | sed -e "s/^refs\///g" | awk '{s=""; for(i=2;i<=NF;i++) s=s" "$i; printf "%-34s%+24s\n", $1, s;}' \
    | fzf --no-sort --reverse --ansi --multi --preview 'git graph --color | sed -E "s/^/ /g" | sed -E '"'"'/\(.*[^\/]'"'"'$(echo {} | cut -d" " -f1 | sed "s:/:.:g")'"'"'.*\)/s/^ />/g'"'"'' \
    | awk '{print $1}')
  printf '%s' "$branch"
}

alias cdgr='cd-git-root'
function cd-git-root() {
  is_git_repo_with_message || return
  cd $(git rev-parse --show-toplevel)
}

alias gfvimc='git ls-files | pecovim'
alias gfvim='gfvimc'

alias pvim='pecovim'
alias cpeco='command peco'
function pecovim() {
  pecocat "$@" | expand_home | tee /dev/tty | xargs-vim
}

if cmdcheck tig; then
  function tig() {
    if [[ $# == 0 ]]; then
      set -- status '+5'
    fi
    command tig "$@"
  }
fi
