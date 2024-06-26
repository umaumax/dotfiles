#!/usr/bin/env zsh
alias bindkey_events_list='bindkey -L'
alias bindkey_default_events_list='zsh -c "bindkey"'
function bindkey_default_all_events_list() {
  # NOTE: show only default events
  zsh -c 'zle -all'
  echo 1>&2 ''
  echo 1>&2 'If you want to know more, please access below page!'
  echo 1>&2 '[18 Zsh Line Editor \(zsh\)]( http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets )'
}

bindkey -M vicmd '^A' beginning-of-line
bindkey -M vicmd '^E' end-of-line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M vicmd "^X^A" backward-kill-line
bindkey -M vicmd "^X^E" kill-line

# NOTE: vicmd mode prezto format
zstyle ':prezto:module:editor:info:keymap:alternate' format ' %B%F{white}❮%f%b%B%F{magenta}❮%f%b%B%F{blue}❮%f%b'

# FYI: [hchbaw/zce\.zsh: \# zsh EasyMotion/ace\-jump\-mode]( https://github.com/hchbaw/zce.zsh )
# jump to any character at current command line
bindkey "^G" zce

# FYI: [IngoHeimbach/zsh\-easy\-motion: Vim's easy\-motion for zsh]( https://github.com/IngoHeimbach/zsh-easy-motion )
# e.g. ' '+{b, B, w, W, e, E, ge, gE, f, F, t, T, c}
# WARN: not working?
# NOTE: register vicmd 'space' as prefix of vi-easy-motion plugin
bindkey -M vicmd 'h' vi-easy-motion

function _set_buffer() {
  local cmd=${1:-}
  # NOTE: to avoid show unnecessary completion
  zle kill-buffer
  zle reset-prompt
  BUFFER="${cmd}"
  CURSOR=$#BUFFER
  zle -R -c # refresh
  _zle_refresh_cmd_color
}
function _set_only_LBUFFER() {
  if [[ -z "$BUFFER" ]]; then
    LBUFFER="$1"
  fi
}

function gen_PROMPT_2_text() {
  local PROMPT_texts=("$@")
  local n=${#PROMPT_texts[@]}
  for ((i = 1; i <= n; i++)); do local terminfo_down_sc="${terminfo_down_sc}$terminfo[cud1]"; done
  for ((i = 1; i <= n; i++)); do local terminfo_down_sc="${terminfo_down_sc}$terminfo[cuu1]"; done
  local terminfo_down_sc="${terminfo_down_sc}$terminfo[sc]$terminfo[cud1]"
  local PROMPT_2
  if cmdcheck terminal-truncate; then
    PROMPT_2=$(
      for text in "${PROMPT_texts[@]}"; do
        printf "%s\n" "$text"
      done | terminal-truncate -max=$(tput cols) -tab=4
    )
  else
    for text in "${PROMPT_texts[@]}"; do
      # NOTE: $terminfo[cud1] = '\n'
      local PROMPT_2="${PROMPT_2}${text}$terminfo[cud1]"
    done
  fi
  echo "%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}"
}
function show_PROMPT_2_text_by_array() {
  # FYI: [dotfiles/\.zshrc at master · asmsuechan/dotfiles]( https://github.com/asmsuechan/dotfiles/blob/master/.zshrc )
  # FYI: man 5 terminfo
  # NOTE: reserve space under prompt
  # NOTE: echo $terminfo[cud1] x  (the number of output lines + 1) times
  # NOTE: echo $terminfo[cuu1] x  (the number of output lines + 1) times
  # NOTE: save cursor position
  # NOTE: $terminfo[sc]
  # NOTE: move under prompt
  # NOTE: $terminfo[cud1]
  # NOTE: repeat { output a line with $terminfo[cud1] }
  # NOTE: restore cursor position
  # NOTE: terminfo[rc]
  # NOTE: I don't know why wrap %{, %}
  local PROMPT_texts=("$@")
  local PROMPT_2=$(gen_PROMPT_2_text "${PROMPT_texts[@]}")
  # cmdcheck terminal-truncate && PROMPT_2=$(printf '%s' "$PROMPT_2" | terminal-truncate -max=$(tput cols) -tab=8)
  local _PROMPT=$PROMPT
  PROMPT="${PROMPT_2}$PROMPT"
  zle reset-prompt
  PROMPT=$_PROMPT
}
function cat_PROMPT_2_text() {
  _IFS=$IFS
  IFS=$'\r\n'
  PROMPT_text=($(command cat))
  IFS=$_IFS
  show_PROMPT_2_text_by_array "${PROMPT_text[@]}"
}

if cmdcheck fzf && cmdcheck bat && cmdcheck cgrep && cmdcheck fixedgrep && cmdcheck terminal-truncate; then
  # NOTE: for 0~9 key
  AUTO_PROMPT_LIST_MAX=10
  _AUTO_PROMPT_LIST_RAW_CMD=()
  function _AUTO_PROMPT_LIST_SETUP() {
    local keyword=$1
    local output=$(builtin history -r 1 | fixedgrep -max=$AUTO_PROMPT_LIST_MAX " $keyword" 2>/dev/null)
    _AUTO_PROMPT_LIST_RAW_CMD=()
    for hist_no in $(printf '%s' "$output" | grep -o '^[ 0-9]*' | grep -o '[0-9]*'); do
      _AUTO_PROMPT_LIST_RAW_CMD=($_AUTO_PROMPT_LIST_RAW_CMD "${history[$hist_no]}")
    done

    get_cursor_pos | read -r rows cols
    local lbuffer_length=${#LBUFFER}
    local comp_list_indent=$((cols - lbuffer_length - 3))

    export _AUTO_PROMPT_LIST_WITH_COLOR=$(
      {
        # echo -e "${GRAY}[history]${DEFAULT}"
        # NOTE: grep is to late, ag is faster than grep
        printf '%s' "$output" | sed -E 's/^[ 0-9]+[\* ][ ]//' | cgrep '(^.*$)' 8 | cgrep -F "$keyword" 'magenta+hu' \
          | awk '{printf "%'"${comp_list_indent}"'d: %s\n", NR, $0}'
      }
    )
  }

  _auto_show_prompt_pre_keyword=''
  function _auto_show_prompt() {
    if cmdcheck cgrep && cmdcheck fixedgrep; then
      # NOTE: 最大n個分の引数の履歴
      # local arg_max=4
      # local keyword=$(echo -n ${LBUFFER} | cut -d' ' -f -$arg_max | sed -E 's/[|;&].*$//' | sed -E 's/ *$//')
      local keyword=$(echo -n ${LBUFFER} | sed -E 's/ *$//')
      # NOTE: if the first keyword is updated
      if [[ $_auto_show_prompt_pre_keyword != $keyword ]] && [[ -n $keyword ]]; then
        _AUTO_PROMPT_LIST_SETUP "$keyword"
        _auto_show_prompt_pre_keyword=$keyword
      fi
      printf '%s%s' "$_AUTO_PROMPT_LIST_WITH_COLOR" "$p_buffer_stack" | cat_PROMPT_2_text
    fi

    if cmdcheck abbrev-alias; then
      zle __abbrev_alias::magic_abbrev_expand
    else
      LBUFFER+=' '
    fi
    _zle_refresh_cmd_color
  }
  bindkey ' ' _auto_show_prompt && zle -N _auto_show_prompt

  # ----

  ORIG_CMD_STACK=()
  function cmdstack() {
    if [[ $# == 1 ]]; then
      local n=$1
      [[ "$n" == 0 ]] && echo 1>&2 'REQUIRED: 1,2,3...' && return 1
      if [[ "$n" -le ${#ORIG_CMD_STACK[@]} ]]; then
        if [[ ! -o zle ]]; then
          printf '%s' "${ORIG_CMD_STACK[$n]}"
        else
          print -z "${ORIG_CMD_STACK[$n]}"
        fi
      else
        cmdstack
        return 1
      fi
      return
    fi
    local CAT='cat'
    cmdcheck bat && CAT="bat --color=always -l=bash --plain"
    {
      echo "# [cmdstack] select:'^X^P', delete last cmd:cmdstack_delete"
      local i=1
      for CMD in "${ORIG_CMD_STACK[@]}"; do
        printf '[%s]| %s\n' "$i" "$CMD"
        ((i++))
      done
    } | eval $CAT # | perl -pe "chomp if eof"
  }
  # NOTE: number is how many stack not stack number
  function cmdstack_delete() {
    local n=${1:-1}
    [[ $n -le 0 ]] && return 1
    [[ $n -gt ${#ORIG_CMD_STACK} ]] && return 1
    # FYI: [shell \- Remove entry from array \- Stack Overflow]( https://stackoverflow.com/questions/3435355/remove-entry-from-array )
    # NOTE: this eval prevent shfmt parse error
    eval 'ORIG_CMD_STACK=("${(@)ORIG_CMD_STACK[1,$n-1]}" "${(@)ORIG_CMD_STACK[$n+1,$#ORIG_CMD_STACK]}")'
  }
  function cmdstack_shift() {
    local n=${1:-1}
    shift $n ORIG_CMD_STACK
  }
  function cmdstack_len() {
    echo "${#ORIG_CMD_STACK[@]}"
  }
  function _orig_command_push() {
    local CURRENT_CMD=$(printf "%s" "$BUFFER" | perl -pe "chomp if eof")
    [[ -n $CURRENT_CMD ]] && ORIG_CMD_STACK=("$CURRENT_CMD" "${ORIG_CMD_STACK[@]}")
    zle kill-buffer
    zle -R -c # refresh
    echo ''
    cmdstack
    zle reset-prompt
  }
  zle -N _orig_command_push
  bindkey '^P' _orig_command_push

  function _pecocmdstack() {
    # cmdstack | sed -n '2,$p' | sed -e '$d'
    cmdstack | sed -n '2,$p' | {
      # NOTE: 候補の数によって，fzfを使用しない
      read -r LINE1
      [[ -z $LINE1 ]] && return
      read -r LINE2
      [[ -z $LINE2 ]] && { printf '%s\n' "$LINE1" | remove-ansi; } && return
      {
        printf '%s\n' "$LINE1"
        printf '%s\n' "$LINE2"
        command cat /dev/stdin
      } | fzf --height '20%'
    } | grep -o '^\[[0-9]\]*' | sed 's/\[\|\]//g'
  }
  alias pecocmdstack='pecocmdstack_pop'
  function pecocmdstack_apply() {
    local ret=$(_pecocmdstack)
    [[ -z $ret ]] && return 1
    cmdstack $ret
  }
  function _pecocmdstack_apply() {
    # NOTE: if you call function inner $(), [[ ! -o zle ]] works well
    local ret="$(_pecocmdstack)"
    if [[ -z $ret ]]; then
      _set_buffer ""
      return 1
    fi
    _set_buffer "$(cmdstack $ret)"
  }
  function pecocmdstack_pop() {
    local ret=$(_pecocmdstack)
    [[ -z $ret ]] && return 1
    cmdstack $ret
    cmdstack_delete $ret
  }
  function _pecocmdstack_pop() {
    # NOTE: if you call function inner $(), [[ ! -o zle ]] works well
    local ret="$(_pecocmdstack)"
    if [[ -z $ret ]]; then
      _set_buffer ""
      return 1
    fi
    _set_buffer "$(cmdstack $ret)"
    cmdstack_delete $ret
  }
  zle -N _pecocmdstack_apply
  bindkey '^X^P' _pecocmdstack_apply
fi

function _edit_splitted_command_line() {
  eval 'words=("${(z)BUFFER}")'
  BUFFER=$(
    for word in "${words[@]}"; do
      printf '%s\n' "$word"
    done | perl -pe "chomp if eof"
  )

  # FYI: [zsh/edit\-command\-line at master · zsh\-users/zsh]( https://github.com/zsh-users/zsh/blob/master/Functions/Zle/edit-command-line )
  # edit-command-line
  eval "$(
    cat <<'EOF'
() {
  exec </dev/tty

  # Compute the cursor's position in bytes, not characters.
  setopt localoptions nomultibyte noksharrays

  (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2]

  # Open the editor, placing the cursor at the right place if we know how.
  local editor=( "${(@Q)${(z)${VISUAL:-${EDITOR:-vi}}}}" )
  case $editor in
    (*vim*)
      integer byteoffset=$(( $#PREBUFFER + $#LBUFFER + 1 ))
      "${(@)editor}" -c "normal! ${byteoffset}go" -- $1;;
    (*emacs*)
      local lines=( "${(@f):-"$PREBUFFER$LBUFFER"}" )
      "${(@)editor}" +${#lines}:$((${#lines[-1]} + 1)) $1;;
    (*) "${(@)editor}" $1;;
  esac

  (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1]

  # Replace the buffer with the editor output.
  # print -Rz - "$(<$1)"
  OUTPUT="$(<$1)"
} =(<<<"$PREBUFFER$BUFFER")

# zle send-break		# Force reload from the buffer stack
EOF
  )"
  BUFFER=""
  print -Rz - "$(printf '%s' "$OUTPUT" | tr '\n' ' ')"
  zle send-break
}
# NOTE: S: means 'S'plitted
bindkey '^XS' _edit_splitted_command_line && zle -N _edit_splitted_command_line
bindkey '^X^S' _edit_splitted_command_line && zle -N _edit_splitted_command_line

function _vicmd_insert_strs() {
  CURSOR=$((CURSOR + 1))
  _insert_strs "$@"
}
function _insert_strs() {
  local str=$1
  local n=${2:-$#1}
  # NOTE: echo "(press ") -> echo ""
  # NOTE: echo '(press ') -> echo ''
  # NOTE: echo `(press `) -> echo ``
  if [[ "${LBUFFER[-1]}" == "${str[@]:0:((0 + 1))}" && "${str[@]:0:((0 + 1))}" == "${str[@]:1:((1 + 1))}" ]]; then
    str="${str[@]:0:((0 + 1))}"
  fi
  local BUFFER_="${LBUFFER}${str}${RBUFFER}"
  local CURSOR_=$CURSOR
  # NOTE: to avoid show unnecessary completion
  zle kill-buffer
  BUFFER="$BUFFER_"
  # NOTE: don't use below command because this cause mono color
  # CURSOR=$((CURSOR_ + 1))
  CURSOR=$((CURSOR_))
  for i in $(seq $n); do
    zle forward-char
  done
  zle -R -c # refresh
}
bindkey '"' _double_quotes && zle -N _double_quotes && function _double_quotes() { _insert_strs '""' 1; }
bindkey "'" _single_quotes && zle -N _single_quotes && function _single_quotes() { _insert_strs "''" 1; }
bindkey "\`" _exec_quotes && zle -N _exec_quotes && function _exec_quotes() { _insert_strs '``' 1; }
bindkey "^X^O" _exec2_quotes && zle -N _exec2_quotes && function _exec2_quotes() { _insert_strs '$()' 2; }
bindkey "(" _paren && zle -N _paren && function _paren() { _insert_strs '()' 1; }
bindkey "{" _brace && zle -N _brace && function _brace() { _insert_strs '{}' 1; }
bindkey "[" _bracket && zle -N _bracket && function _bracket() { _insert_strs '[]' 1; }
bindkey "/" _slash && zle -N _slash && function _slash() {
  # change `/` -> ~/
  if [[ "${LBUFFER[-1]}" == "\`" ]]; then
    if [[ "${RBUFFER[1]}" == "\`" ]]; then
      zle delete-char
    fi
    zle backward-delete-char
    _insert_strs "~/"
    return
  fi
  _insert_strs "/"
}

bindkey '^B' _nothing_to_do && zle -N _nothing_to_do && function _nothing_to_do() { :; }
bindkey '^N' _nothing_to_do && zle -N _nothing_to_do && function _nothing_to_do() { :; }
bindkey '^|' _nothing_to_do && zle -N _nothing_to_do && function _nothing_to_do() { :; }

# NOTE: git show $| git-commits-peco [enter]
# NOTE: cat $| ls -a | grep zsh [enter]
bindkey '^M' _accept_line && zle -N _accept_line && function _accept_line() {
  local BUFFER_="$BUFFER"
  local REPL_CMD="${BUFFER##* $| }"
  if [[ "$REPL_CMD" == "$BUFFER" ]]; then
    zle accept-line
    return
  fi
  local ret
  CMD=${REPL_CMD%% *}
  ! type >/dev/null 2>&1 $CMD && echo "❌ not found '$CMD'"$'\a' && zle reset-prompt && return
  ret="$(eval "$REPL_CMD")"
  # NOTE: my not found handler return code
  if [[ $? == $((404 - 256)) ]]; then
    :
  else
    LBUFFER_="${BUFFER%$|*}"
    BUFFER_="${LBUFFER_}""$(printf '%s' "$ret" | tr '\n' ' ')"
  fi
  refresh "$BUFFER_"
}

function refresh() {
  local new_buffer="${1:-$BUFFER}"
  zle kill-buffer
  zle kill-whole-line
  zle accept-line
  print -z "$new_buffer"
  zle end-of-buffer-or-history
}

bindkey "^F" backward-delete-char
bindkey "^D" delete-char

bindkey "^H" backward-char
# bindkey "^K" up-line-or-history
# bindkey "^J" down-line-or-history
bindkey "^K" history-substring-search-up
bindkey "^J" history-substring-search-down
bindkey "^L" forward-char

# NOTE: below option enables to move multi-line even if end-of-buffer
# WARN: zsh-history-substring-search command are disabled
# up and down
# bindkey "^[OA" up-line-or-history
# bindkey "^[OB" down-line-or-history
# zsh-history-substring-search command
# bindkey "^[OA" history-substring-search-up
# bindkey "^[OB" history-substring-search-down

# NOTE: sfhit + up
bindkey '^[[1;2A' beginning-of-buffer-or-history
# NOTE: sfhit + down
bindkey '^[[1;2B' end-of-buffer-or-history

# NOTE: shift + left
bindkey '^[[1;2D' emacs-backward-word
# NOTE: shift + right
bindkey '^[[1;2C' emacs-forward-word
bindkey -M vicmd '^[[1;2D' emacs-backward-word
bindkey -M vicmd '^[[1;2C' emacs-forward-word

bindkey '^X^A' backward-kill-line
bindkey '^X^E' kill-line

function _zle_refresh_cmd_color() {
  zle backward-char
  zle forward-char
}

function _add_prefix_to_line() {
  BUFFER="$1$BUFFER"
  CURSOR=$((CURSOR + ${#1}))
  _zle_refresh_cmd_color
}
function _change_no_history_log() {
  _add_prefix_to_line " "
}
zle -N _change_no_history_log
bindkey "^X " _change_no_history_log
bindkey "^X^ " _change_no_history_log

function _insert_sudo() { _add_prefix_to_line 'sudo '; }
zle -N _insert_sudo
# bindkey "^S" _insert_sudo

# benefix command by context
function _context_based_util() {
  function _help() {
    command cat <<EOF

---- context base util key bind help ----
    e.g.
      press <C-o> after below cursor
      a|A : fzf file/directory search
      b|B : choose branch
      c|C : choose commit
      f|F : fzf file search
      d|D : fzf directory search
      h|H : help
EOF
  }
  local output
  case "${LBUFFER[-1]}" in
    [aA])
      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        output=$({
          git ls-files $(git rev-parse --show-toplevel)
          git ls-files $(git rev-parse --show-toplevel) | sed -e '/^[^\/]*$/d' -e 's/\/[^\/]*$//g' | awk '!a[$0]++'
        } | LANG=C sort | fzf --multi | tr '\n' ' ')
      else
        output=$(find . | fzf --multi | tr '\n' ' ')
      fi
      ;;
    [bB])
      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        output=$(git-branch-peco)
      else
        :
      fi
      ;;
    [cC])
      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        output=$(commits)
      else
        :
      fi
      ;;
    [fF])
      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        output=$(git ls-files $(git rev-parse --show-toplevel) | fzf --multi | tr '\n' ' ')
      else
        output=$(find . -type f | fzf --multi | tr '\n' ' ')
      fi
      ;;
    [dD])
      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        output=$(git ls-files $(git rev-parse --show-toplevel) | sed -e '/^[^\/]*$/d' -e 's/\/[^\/]*$//g' | awk '!a[$0]++' | fzf --multi | tr '\n' ' ')
      else
        output=$(find . -type d | fzf --multi | tr '\n' ' ')
      fi
      ;;
    *) _help ;;
  esac
  if [[ -n "$output" ]]; then
    zle backward-delete-char
    _insert_strs "$output"
  else
    refresh
  fi
}
zle -N _context_based_util
bindkey "^O" _context_based_util

# NOTE: delete RBUFFER
bindkey "^S" kill-line

# function _insert_git() { _add_prefix_to_line 'git '; }
# zle -N _insert_git
# bindkey "^G" _insert_git

function _search_history() { _set_only_LBUFFER "$(HPECO_NUM=${HPECO_NUM:--1000} hpeco \'$LBUFFER)"; }
function _search_full_history() { _set_only_LBUFFER "$(HPECO_NUM=1 hpeco \'$LBUFFER)"; }
zle -N _search_history
zle -N _search_full_history
# NOTE: overwrite default fzf history search setting
bindkey "^R" _search_history
bindkey "^X^H" _search_full_history
bindkey "^X^R" fzf-history-widget

# F:fix
bindkey '^X^F' edit-command-line
bindkey '^XF' edit-command-line
# L:line
bindkey '^X^L' edit-command-line
bindkey '^XL' edit-command-line
# E: default keymapping of bash readline
bindkey '^X^E' edit-command-line
bindkey '^XE' edit-command-line
# NOTE: edit clipboard
# function _cedit() { cedit; }
# zle -N _cedit
# bindkey "^X^V" _cedit
# bindkey "^X^O" _cedit

# NOTE: copy and paste
# e.g. mv xxx [press here!]
bindkey "^X^V" copy-prev-shell-word

# function _insert_cd_home() { _set_only_LBUFFER 'cd ~/'; }
# zle -N _insert_cd_home
# bindkey "^X^H" _insert_cd_home

# function _insert_run_secret_dotfile() { _set_only_LBUFFER './.'; }
# zle -N _insert_run_secret_dotfile
# bindkey "^X." _insert_run_secret_dotfile

# function _insert_exec() { _set_only_LBUFFER './'; }
# zle -N _insert_exec
# bindkey "^X^E" _insert_exec

# function _no_history_rm() { _set_only_LBUFFER ' rm '; }
# zle -N _no_history_rm
# bindkey "^X^R" _no_history_rm

function _copy_command() {
  printf '%s' "$BUFFER" | perl -pe "chomp if eof" | c
  # 履歴には実行するまで登録されず、コマンドを消した状態で、ここでこれを実行すると意図するコマンドとはずれた結果となることが頻発したので、コマンドを消去しないように変更
  # zle kill-buffer
  zle -R -c # refresh
  echo ''
  if cmdcheck bat; then
    {
      echo "📋[clipboard]"
      printf '%s\n' "$(p)"
    } | bat --color=auto -l=bash --plain --paging=never
  else
    echo "📋[clipboard]"
    printf '%s\n\n' "$(p)"
  fi
  zle reset-prompt
}
zle -N _copy_command
# yank
bindkey '^Y' _copy_command

function _paste_command() { _insert_strs "$(p)"; }
function _vicmd_paste_command() { _vicmd_insert_strs "$(p)"; }
zle -N _paste_command
zle -N _vicmd_paste_command
bindkey '^V' _paste_command

# ctrl + shift + v
bindkey "$(echo -n "\xc2\x96")" _paste_command

bindkey -M vicmd 'p' _vicmd_paste_command
bindkey -M vicmd 'P' _paste_command

function _goto_middle_of_line() {
  CURSOR=$#BUFFER
  CURSOR=$((CURSOR / 2))
  zle -R -c # refresh
}
zle -N _goto_middle_of_line
bindkey '^X^M' _goto_middle_of_line

function _goto_line_n() {
  local n=${1:-1}
  CURSOR=$#BUFFER
  CURSOR=$((CURSOR / 11 * n))
  zle -R -c # refresh
}
# for ((i = 1; i <= 10; i++)); do
# zle -N _goto_line_$i
# bindkey '^X'"$(($i % 10))" _goto_line_$i
# eval "function _goto_line_$i() { _goto_line_n $i; }"
# done
function _select_prompt_list_n() {
  local n=${1:-1}
  local cmd="$_AUTO_PROMPT_LIST_RAW_CMD[$n]"
  if [[ -n $cmd ]]; then
    _set_buffer "${cmd} "
    # # NOTE: to avoid show unnecessary completion
    # zle kill-buffer
    # BUFFER="${cmd} "
    # CURSOR=$#BUFFER
    # zle -R -c # refresh
    # _zle_refresh_cmd_color
  fi
}
for ((i = 1; i <= 10; i++)); do
  zle -N _select_prompt_list_$i
  bindkey '^X'"$(($i % 10))" _select_prompt_list_$i
  eval "function _select_prompt_list_$i() { _select_prompt_list_n $i; }"
done

# FYI: [最近のzshrcとその解説 \- mollifier delta blog]( http://mollifier.hatenablog.com/entry/20090502/p1 )
# quote previous word in single or double quote
autoload -U modify-current-argument
_quote-previous-word-in-single() {
  modify-current-argument '${(qq)${(Q)ARG}}'
  zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey '^X'"'" _quote-previous-word-in-single
bindkey '^Xs' _quote-previous-word-in-single
bindkey '^X^S' _quote-previous-word-in-single

_quote-previous-word-in-double() {
  modify-current-argument '${(qqq)${(Q)ARG}}'
  zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^X"' _quote-previous-word-in-double
bindkey '^Xd' _quote-previous-word-in-double
bindkey '^X^D' _quote-previous-word-in-double

_modify-previous-word-to-uppercase() {
  modify-current-argument '${(U)${(Q)ARG}}'
  zle vi-forward-blank-word
}
zle -N _modify-previous-word-to-uppercase
bindkey '^Xu' _modify-previous-word-to-uppercase
bindkey '^XU' _modify-previous-word-to-uppercase
bindkey '^X^U' _modify-previous-word-to-uppercase

_modify-previous-word-paren() {
  modify-current-argument '(${(Q)ARG})'
  zle vi-forward-blank-word
}
zle -N _modify-previous-word-paren
bindkey '^X(' _modify-previous-word-paren
bindkey '^X)' _modify-previous-word-paren

# FYI: [keyboard shortcuts \- How to configure Ctrl\+w as delete word in zsh \- Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/250690/how-to-configure-ctrlw-as-delete-word-in-zsh )
function my-backward-delete-word() {
  # NOTE: default WORDCHARS=*?_-.[]~&;!#$%^(){}<>
  WORDCHARS='$-_' zle backward-delete-word
}
zle -N my-backward-delete-word
# shift+tab
bindkey '^[[Z' my-backward-delete-word
bindkey -M vicmd '^[[Z' my-backward-delete-word

function my-backward-delete-word-extend() {
  # NOTE: delete full filepath
  WORDCHARS="${WORDCHARS}/" zle backward-delete-word
}
zle -N my-backward-delete-word-extend
# ctrl+x + delete
bindkey '^X^?' my-backward-delete-word-extend
bindkey -M vicmd '^X^?' my-backward-delete-word-extend

# NOTE: delete and shift delete
# bindkey "^?" backward-delete-char

# function _peco-select-history() {
# BUFFER="$(builtin history -nr 1 | command peco | tr -d '\n')"
# CURSOR=$#BUFFER
# zle -R -c # refresh
# }
# zle -N _peco-select-history
# bindkey '^X^P' _peco-select-history

# function peco-select-history() {
# local tac
# if which tac >/dev/null; then
# tac="tac"
# else
# tac="tail -r"
# fi
# local query="$LBUFFER"
# local opts=("--query" "$LBUFFER")
# [[ -z $query ]] && local opts=()
# BUFFER=$(builtin history -nr 1 |
# eval $tac |
# command peco "${opts[@]}")
# CURSOR=$#BUFFER
# zle clear-screen
# }
# zle -N peco-select-history
# bindkey '^X^O' peco-select-history

# while using vim -> C-z -> back to zsh -> Ctrl-z or fg -> back to vim
function fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

function fgpeco() {
  local job_n
  job_n=$(jobs | wc -l | tr -d ' ')
  if [[ $job_n == 0 ]]; then
    echo 1>&2 "# of background jobs is 0"
    return
  fi
  local job
  job=$(jobs | awk -F "suspended" "{print $1 $2}" | sed -e "s/\-//g" -e "s/\+//g" -e "s/\[//g" -e "s/\]//g" | grep -v pwd | fzf | awk "{print $1}")
  if [[ -z "$(printf '%s' "$job" | grep -v grep | grep -e 'suspended' -e 'interrupt' -e 'running')" ]]; then
    echo 1>&2 "# of background suspended/interrupt/running jobs is 0"
    return 1
  fi
  fg "%${job}"
}

####
# FYI: [Plugins: vi\-mode: extra vi\-like bindings, vi\-like commands clipboard by alx741 · Pull Request \#3616 · robbyrussell/oh\-my\-zsh]( https://github.com/robbyrussell/oh-my-zsh/pull/3616/commits/0f6e49b455e498bd051d1d18d62dec4e6872d3e8 )
# Allow Copy/Paste with the system clipboard
# behave as expected with vim commands ( y/p/d/c/s )

function cutbuffer() {
  # NOTE: original widget call?
  zle .$WIDGET
  echo $CUTBUFFER | c
  # NOTE: refresh visual mode highlight
  _zle_refresh_cmd_color
}

zle_cut_widgets=(
  vi-backward-delete-char
  vi-change
  vi-change-eol
  vi-change-whole-line
  vi-delete
  vi-delete-char
  vi-kill-eol
  vi-substitute
  vi-yank
  vi-yank-eol
)
for widget in $zle_cut_widgets; do
  # NOTE: widget alias?
  zle -N $widget cutbuffer
done

function putbuffer() {
  zle copy-region-as-kill "$(p)"
  zle .$WIDGET
}

zle_put_widgets=(
  vi-put-after
  vi-put-before
)
for widget in $zle_put_widgets; do
  zle -N $widget putbuffer
done

bindkey -M visual 'v' vi-yank

# FYI: [zsh zle \- List of zsh bindkey commands \- Stack Overflow]( https://stackoverflow.com/questions/18042685/list-of-zsh-bindkey-commands )

local p_buffer_stack=""
local -a buffer_stack_arr

function make_p_buffer_stack() {
  if [[ ! $#buffer_stack_arr > 0 ]]; then
    p_buffer_stack=""
    return
  fi
  p_buffer_stack="%F{cyan}<stack:$buffer_stack_arr>%f"
}

function show_buffer_stack() {
  local cmd_str_len=$#LBUFFER
  [[ cmd_str_len > 10 ]] && cmd_str_len=10
  buffer_stack_arr=("[$LBUFFER[1,${cmd_str_len}]]" $buffer_stack_arr)
  make_p_buffer_stack
  zle push-line-or-edit
  zle reset-prompt
}

function check_buffer_stack() {
  [[ $#buffer_stack_arr > 0 ]] && shift buffer_stack_arr
  make_p_buffer_stack
}

# zle -N show_buffer_stack
# bindkey "^S" show_buffer_stack
# add-zsh-hook precmd check_buffer_stack
#
# bindkey "^P" push-line-or-edit
# bindkey "^O" get-line

# RPROMPT='${p_buffer_stack}'

# NOTE: for test only
function _bindkey_test() {
}
# bindkey '' _bindkey_test && zle -N _bindkey_test
