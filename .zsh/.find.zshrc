alias find-time-sort='find . -not -iwholename "*/.git/*" -type f -print0 | xargs -0 ls -altr'
alias find-time-sortr='find . -not -iwholename "*/.git/*" -type f -print0 | xargs -0 ls -alt'
alias find-dotfiles='find . -name ".*" -not -name ".git" | sed "s:\./\|^\.$::g" | grep .'

alias find-orig-files="find . -name '*.orig'"
alias find-orig-files-and-delete="find . -name '*.orig' -delete"

function find-rename-pipe() {
  # if ! type >/dev/null 2>&1 rename; then
  # echo 1>&2 'Not found rename command!'
  # return 1
  # fi
  # if ! type >/dev/null 2>&1 tac; then
  # echo 1>&2 'Not found tac command!'
  # return 1
  # fi
  if [[ $# -lt 1 ]]; then
    echo "
$(basename $0) <rename sed pattern>
# e.g.
find . | $(basename $0) 's///g'
{ git ls-files | sed -e '/^[^\/]*$/d' -e 's/\/[^\/]*$//g' | sort | uniq; git ls-files } | $(basename $0) 's///g'
"
    return 1
  fi
  local rename_pattern="$1"
  local mv_cmds=(mv)
  [[ -n $FIND_RENAME_GIT_MV_CMD ]] && mv_cmds=(git mv)
  # NOTE: rename command version: find . -name "*test*" | tac | xargs -L 1 -I{} rename -v 's:^(.*/)test([^/]*)$:$1XXXXXXXX$2:' '{}'
  # NOTE: tacを噛ませる意味として，先に深い階層のファイルのbasenameを置換する，その後，ディレクトリのbasenameを置換するということをファイルのリストアップを終了してから行うため
  # NOTE: findの代わりに幅優先探索のbfsでも特に問題ない
  LANG=C sort -r | uniq | while IFS= read -r target_path || [[ -n "$target_path" ]]; do
    local dirpath=$(dirname "$target_path")
    local target_name=$(basename "$target_path")
    local new_target_name=$(printf '%s' "$target_name" | sed -E "$rename_pattern")
    if [[ "$target_name" != "$new_target_name" ]]; then
      "${mv_cmds[@]}" -v "$dirpath/$target_name" "$dirpath/$new_target_name" || return
    fi
  done
}

function cat-find() {
  [[ $1 == "" ]] && echo "set file reg? e.g.) $0 '*.txt'" && return
  find . -name "$1" -exec awk '{ if (FNR==1) print "####################\n",FILENAME,"\n####################"; print $0}' {} +
}

# NOTE: grepに対して任意のオプションを渡せる状態?
function xargs-grep-0() {
  [[ $# == 0 ]] && echo 'grep_keyword' && return
  local keyword=(${@:1})
  local grep_cmd='grep'
  local color_opt='--color=auto'
  cmdcheck fzf && color_opt='--color=always'
  cmdcheck ggrep && local grep_cmd='ggrep'
  # NOTE: to prevent xargs from quitting on error
  # NOTE: e.g. symbolic link no exist error
  xargs -0 -L 1 -IXXX sh -c "find "'"$@"'" -exec $grep_cmd $color_opt -H -n \"${keyword[@]}\" {} +" '' XXX
}
function xargs-grep() {
  [[ $# == 0 ]] && echo 'grep_keyword' && return
  local keyword=(${@:1})
  local grep_cmd='grep'
  local color_opt='--color=auto'
  cmdcheck fzf && color_opt='--color=always'
  cmdcheck ggrep && local grep_cmd='ggrep'
  # NOTE: to prevent xargs from quitting on error
  xargs -L 1 -IXXX sh -c "find "'"$@"'" -exec $grep_cmd $color_opt -I -H -n \"${keyword[@]}\" {} +" '' XXX
}
# そもそもfindとgrepの引数を同時に指定すること自体がおかしいので，仕様を見直すべき
function fgrep() {
  [[ $# == 1 ]] && echo '[root_dir_path] grep_keyword' && return
  local find_name="$1"
  local root='.'
  local keyword=(${@:2})
  if [[ $# -ge 3 ]]; then
    local root="$2"
    local keyword=(${@:3})
  fi
  find $root -type f -name $find_name -print0 | xargs-grep-0 ${keyword[@]}
}
# FIX: merge below and above function
function fgrep2() {
  [[ $# == 2 ]] && echo '[root_dir_path] grep_keyword' && return
  local find_name1="$1"
  local find_name2="$2"
  local root='.'
  local keyword=(${@:3})
  if [[ $# -ge 4 ]]; then
    local root="$3"
    local keyword=(${@:4})
  fi
  find $root -type f \( -name $find_name1 -o -name $find_name2 \) -print0 | xargs-grep-0 ${keyword[@]}
}
function findgrep() {
  local filter_option=''
  local default_argn="$#"
  local end_offset=0
  local grep_args=()
  for arg in "$@"; do
    if [[ $arg == "--" ]]; then
      grep_args=(${@:1:$end_offset})
      shift $(($end_offset + 1))
      break
    fi
    ((end_offset++))
  done
  if [[ "$end_offset" == "$default_argn" ]]; then
    echo 2>&1 '<find args> -- <grep args>'
    return 1
  fi
  # NOTE: "$@" is args of find command

  local grep_cmd='grep'
  local color_opt='--color=auto'
  cmdcheck fzf && color_opt='--color=always'
  cmdcheck ggrep && local grep_cmd='ggrep'
  find . "$@" -type f -exec $grep_cmd $color_opt -I -H -n "${grep_args[@]}" {} +
}

alias fg.vim='fgrep "*.vim"'
[[ $(uname) == "Darwin" ]] && alias fg.my.vim='find "$HOME/.vim/config/" "$HOME/.vimrc" "$HOME/.local.vimrc" "$HOME/vim/" \( -type f -o -type l \) \( -name "*.vim" -o -name "*.vimrc" \) -print0 | xargs-grep-0'
[[ $(uname) == "Linux" ]] && alias fg.my.vim='find "$HOME/.vim/config/" "$HOME/.vimrc" "$HOME/.local.vimrc"              \( -type f -o -type l \) \( -name "*.vim" -o -name "*.vimrc" \) -print0 | xargs-grep-0'
alias fg.3rd.vim='find "$HOME/.vim/plugged/" -type f -name "*.vim" -print0 | xargs-grep-0'
alias fg.go='find "." \( -not -name "bindata_assetfs.go" -not -iwholename "*/vendor/*" \) -type f -name "*.go" -print0 | xargs-grep-0'
alias fg.my.go='find $( echo $GOPATH | cut -d":" -f2) \( -not -name "bindata_assetfs.go" -not -iwholename "*/vendor/*" \) -type f -name "*.go" -print0 | xargs-grep-0'
alias fg.3rd.go='find $( echo $GOPATH | cut -d":" -f1) \( -not -name "bindata_assetfs.go" -not -iwholename "*/vendor/*" \) -type f -name "*.go" -print0 | xargs-grep-0'
alias fg.py='fgrep "*.py"'
alias fg.sh='fgrep "*.sh"'
alias fg.cpp='fgrep "*.c[cpx][px]"'
alias fg.hpp='fgrep2 "*.h" "*.hpp"'
alias fg.c='fgrep "*.c"'
alias fg.h='fgrep "*.h"'
alias fg.ch='fgrep "*.[ch]"'
alias fg.cpp='fgrep2 "*.[ch][cpx][px]" "*.[ch]"'
alias fg.md='fgrep "*.md"'
alias fg.my.md='find "$HOME/md" -name "*.md" -print0 | xargs-grep-0'
alias f.make='find . \( -name "[mM]akefile" -o -name "*.mk" \)'
alias fg.make='f.make -print0 | xargs-grep-0'
alias f.cmake='find . \( \( -name "CMakeLists.txt" -o -name "*.cmake" \) -not -iwholename "*build*" \)'
alias fg.cmake='f.cmake -print0 | xargs-grep-0'
alias f.readme='find . \( \( -iname readme*.txt -o -iname readme*.md -o -iname readme*.mkd \) -not -iwholename "*build*" \)'
alias fg.readme='f.readme -print0 | xargs-grep-0'

alias rf='sudo find / \( -not -iwholename "$HOME/*" -not -iwholename "/var/lib/docker/*" \)'
alias hf='find ~'

function fg.vim.pv() { local _=$(fg.vim "$@" | pecovim); }
function fg.my.vim.pv() { local _=$(fg.my.vim "$@" | pecovim); }
function fg.3rd.vim.pv() { local _=$(fg.3rd.vim "$@" | pecovim); }
function fg.go.pv() { local _=$(fg.go "$@" | pecovim); }
function fg.my.go.pv() { local _=$(fg.my.go "$@" | pecovim); }
function fg.3rd.go.pv() { local _=$(fg.3rd.go "$@" | pecovim); }
function fg.py.pv() { local _=$(fg.py "$@" | pecovim); }
function fg.sh.pv() { local _=$(fg.sh "$@" | pecovim); }
function fg.cpp.pv() { local _=$(fg.cpp "$@" | pecovim); }
function fg.hpp.pv() { local _=$(fg.hpp "$@" | pecovim); }
function fg.c.pv() { local _=$(fg.c "$@" | pecovim); }
function fg.h.pv() { local _=$(fg.h "$@" | pecovim); }
function fg.ch.pv() { local _=$(fg.ch "$@" | pecovim); }
function fg.cpp.pv() { local _=$(fg.cpp "$@" | pecovim); }
function fg.md.pv() { local _=$(fg.md "$@" | pecovim); }
function fg.my.md.pv() { local _=$(fg.my.md "$@" | pecovim); }
function f.make.pv() { local _=$(f.make "$@" | pecovim); }
function fg.make.pv() { local _=$(fg.make "$@" | pecovim); }
function f.cmake.pv() { local _=$(f.cmake "$@" | pecovim); }
function fg.cmake.pv() { local _=$(fg.cmake "$@" | pecovim); }
function f.readme.pv() { local _=$(f.readme "$@" | pecovim); }
function fg.readme.pv() { local _=$(fg.readme "$@" | pecovim); }

alias md.pv='fg.md.pv'
alias md.my.pv='fg.my.md.pv'
alias vim.pv='fg.vim.pv'
alias vim.my.pv='fg.my.vim.pv'
alias cpp.pv='fg.cpp.pv'
alias make.pv='fg.make.pv'
alias cmake.pv='fg.cmake.pv'
alias readme.pv='fg.readme.pv'

# FYI: [find で指定のフォルダを除外するには \- それマグで！]( http://takuya-1st.hatenablog.jp/entry/2015/12/16/213246 )
# WARN: ただの検索では除外されるが，特殊なオプションを使用する場合には無効になるので，注意
# OK: find . -not -iwholename '*/.git/*' -ls
# NG: find . -ls -not -iwholename '*/.git/*'
function find() {
  if [[ $# == 0 ]]; then
    set -- '.'
  fi
  # NOTE: target is for rust
  command find "$@" -not -iwholename '*/.git/*' -not -iwholename '*/target/rls/*' -not -iwholename '*/target/debug/*' -not -iwholename '*/target/arm-*/*'
}

# NOTE: A breadth-first version of the UNIX find command
# FYI: [tavianator/bfs: A breadth\-first version of the UNIX find command]( https://github.com/tavianator/bfs )
if cmdcheck bfs; then
  alias f='bfs'
  function bfs() {
    # NOTE: bfsはoptionの順番は問わないので，こちらのほうが都合が良い
    command bfs -not -iwholename '*/.git/*' "$@"
  }
fi

alias jagrep="grep -P '\p{Hiragana}'"

alias grep-camelcase="grep -E '([a-z]{1,}[A-Z][a-z]{0,}){1,}'"
alias grep-camelcase-filter="grep -E '([a-z]{1,}[A-Z][a-z]{0,}){1,}' -o"

cmdcheck semgrep && function semgrep() {
  local args=(${@})
  local lang_flag=0
  for arg in "${args[@]}"; do
    if [[ "$arg" =~ ^(-l|--lang) ]]; then
      lang_flag=1
    fi
  done
  # auto lang detection
  if [[ $lang_flag == 0 ]]; then
    local lang=$(git-lang-detection)
    args=("${args[@]}" "--lang=$lang")
  fi

  command semgrep "${args[@]}"
}

alias rvgrep="rgrep"
function rgrep() {
  [[ $# -lt 1 ]] && echo "$(basename $0) keyword" && return 1
  # to expand alias
  local _=$(viminfo-ls | sed "s:^~:$HOME:g" | xargs-grep $@ | pecovim)
}
