if ! cmdcheck tmux; then
  return
fi

alias tmux-name="tmux display-message -p '#S'"
alias tmux-reload-config='tmux source ~/.tmux.conf'
function is_in_tmux_with_message() {
  if [[ -n "$TMUX" ]]; then
    echo "${RED}Do not use this command in a tmux session.${DEFAULT}" 1>&2
    return 1
  fi
}
function is_not_in_tmux_with_message() {
  if [[ ! -n "$TMUX" ]]; then
    echo "${RED}Do not use this command outside of a tmux session.${DEFAULT}" 1>&2
    return 1
  fi
}
function tmux-resurrect-restore() {
  tmux new-session -s '____tmux-resurrect____' \; detach-client >/dev/null 2>&1
  # restore is ongoing at background
}
alias ta='tmux-attach'
alias tmuxa='tmux-attach'
function tmux-attach() {
  is_in_tmux_with_message || return
  local query=$(printf '%s' "${1:-}")
  local output
  output=$(tmux-ls-format) || return
  if [[ -z $output ]]; then
    # auto restore
    tmux-resurrect-restore
    echo "${PURPLE}tmux restore is ongoing at background${DEFAULT}"
    echo "${YELLOW}retry a little later!${DEFAULT}"
    echo "${YELLOW}maybe window name is fixed, run below command!${DEFAULT}"
    echo "${PURPLE}tmux set automatic-rename on${DEFAULT}"
    return 1
  fi
  local tag_id=$(echo $output | fzf --query=$query | cut -d : -f 1 | sed 's/ *$//')
  [[ -n $tag_id ]] && tmux a -t $tag_id
}
alias tmuxrename='tmux-rename-session'
function tmux-rename-session() {
  is_not_in_tmux_with_message || return
  local name
  local base_dirpath
  name=${1:-}
  if [[ -z $name ]]; then
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      base_dirpath="$(git rev-parse --show-toplevel)"
    else
      base_dirpath="$(pwd)"
    fi
    # NOTE: /xxx/yyy/zzz -> yyy/zzz
    name="$(basename $(dirname $base_dirpath))/$(basename $base_dirpath)"
  fi
  # NOTE: using '.' is forbidden at tmux session name
  tmux rename-session "${name//./_}"
}
# FYI: [tmux のアウトプットを適当なエディタで開く \- Qiita]( https://qiita.com/acro5piano/items/0563ab6ce432dbd76e50 )
alias tmuxe='tmux-edit-pane'
function tmux-edit-pane() {
  local tmpfile="$(mktemp "$(basename $0).$$.tmp.XXXXXX").log"
  tmux capture-pane -pS -32768 >$tmpfile
  tmux new-window -n:mywindow "vim $tmpfile"
}
# NOTE: return tmux pain id which has running process of given name
# e.g. tmux send-keys -t $(tgrep gdb) 'info' C-m
alias tmux-grep='tgrep'
function tgrep() {
  local process_name="${1:-.}"
  tmux list-panes -a -F '#D #{pane_pid}' | xargs -L1 bash -c '{ pgrep -l -P "$2" | grep -q '"$process_name"'; } && echo "$1"' --
}

if [[ -n "$TMUX" ]]; then
  function ssh() {
    tmux rename-window "ssh:${*//-/_}"
    command ssh "$@"
    tmux set-window-option automatic-rename "on" 1>/dev/null
  }

  function oressh() {
    tmux rename-window "ssh:${*//-/_}"
    command oressh "$@"
    tmux set-window-option automatic-rename "on" 1>/dev/null
  }

  function docker() {
    local title=""
    local exec_flag=0
    for arg in "$@"; do
      if [[ $arg == "exec" ]]; then
        exec_flag=1
      fi
      if [[ ${arg} =~ ^[0-9a-f]{12}$ ]]; then
        container_id="${arg}"
      fi
    done

    if [[ $exec_flag == 1 ]]; then
      if [[ -z "$container_id" ]]; then
        for arg in "$@"; do
          if ! [[ $arg =~ ^- ]]; then
            title=$(command docker ps --filter "name=^${arg}\$" --format="{{.Names}}({{.ID}})")
            if [[ -n "$title" ]]; then
              break
            fi
          fi
        done
      else
        title=$(command docker ps --filter "id=${container_id}" --format="{{.Names}}({{.ID}})")
      fi
    fi

    tmux rename-window "docker:${title}"
    command docker "$@"
    tmux set-window-option automatic-rename "on" 1>/dev/null
  }
fi
