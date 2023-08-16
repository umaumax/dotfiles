# HINT: if you want to record login time uncomment next line
# DEBUG_MODE='ON'
[[ -n $DEBUG_MODE ]] && zmodload zsh/zprof && zprof

_NO_CMD=''
function doctor() {
  [[ -z _NO_CMD ]] && echo "You are be in good health!" && return
  echo "# These commands are missing..."
  echo $_NO_CMD | sed 's/^://' | tr ':' '\n' | sort | uniq
}
function cmdcheck() {
  [[ $# == 0 ]] && echo "$0 <cmd>" && return
  # typeset -g -A cmdcheck_cache
  local cmd
  cmd=$1
  # if [[ -n "${cmdcheck_cache[(i)$cmd]}" ]]; then
  # return ${cmdcheck_cache[$cmd]}
  # fi
  type "$cmd" >/dev/null 2>&1
  local code=$?
  # cmdcheck_cache[$cmd]=$code
  [[ $code != 0 ]] && _NO_CMD="$_NO_CMD:$1"
  return $code
}

# FYI: [chpwd内のlsでファイル数が多い場合に省略表示する - Qiita]( https://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059 )
function ls_abbrev() {
  if [[ ! -r $PWD ]]; then
    return
  fi
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-aCF' '--color=always')
  local LS_COLORS_="$LS_COLORS"
  if type exa >/dev/null 2>&1; then
    cmd_ls='exa'
    opt_ls=('-a' '--color=always')
    LS_COLORS_=""
  else
    case "${OSTYPE}" in
      freebsd* | darwin*)
        if type gls >/dev/null 2>&1; then
          cmd_ls='gls'
        else
          # -G : Enable colorized output.
          opt_ls=('-aCFG')
        fi
        ;;
    esac
  fi

  local ls_result
  ls_result=$(LS_COLORS="$LS_COLORS_" CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [[ $ls_lines -gt 10 ]]; then
    echo "$ls_result" | head -n 5
    echo "${YELLOW}...${DEFAULT}"
    echo "$ls_result" | tail -n 5
    echo "${YELLOW}$(command ls -1 -A | wc -l | tr -d ' ') files exist${DEFAULT}"
  else
    echo "$ls_result"
  fi
}

if cmdcheck tmux; then
  function tmux-ls-format() {
    # in tmux ls -F
    # can't use custom time format, shell, attribute
    # [Formats · tmux/tmux Wiki]( https://github.com/tmux/tmux/wiki/Formats#summary-of-modifiers )
    # [tmux\(1\) \- Linux manual page]( https://man7.org/linux/man-pages/man1/tmux.1.html#FORMATS )
    local color_command=(cat)
    type >/dev/null 2>&1 cgrep && color_command=(cgrep '(.*:)(\(.*\)) - (\(.*\)) ([^ ]*)(\[[ 0-9]*\])')
    timeout 1 tmux ls -F "#{p64:session_name}:(#{t:session_last_attached}) - (#{t:session_created}) [#{p-3;s/%//:pane_id}]" \
      | sed -E 's/\([A-Z][a-z]* /(/g' \
      | sed -E 's:\(Jan :(01/:g' \
      | sed -E 's:\(Feb :(02/:g' \
      | sed -E 's:\(Mar :(03/:g' \
      | sed -E 's:\(Apr :(04/:g' \
      | sed -E 's:\(May :(05/:g' \
      | sed -E 's:\(Jun :(06/:g' \
      | sed -E 's:\(Jul :(07/:g' \
      | sed -E 's:\(Aug :(08/:g' \
      | sed -E 's:\(Sep :(09/:g' \
      | sed -E 's:\(Oct :(10/:g' \
      | sed -E 's:\(Nov :(11/:g' \
      | sed -E 's:\(Dec :(12/:g' \
      | sed -E 's/[0-9]+:[0-9]+:[0-9]+ //g' \
      | sed -E 's:/ ([0-9]):/0\1:g' \
      | sed -E 's:\(([0-9]*/[0-9]*) ([0-9]*)\):(\2/\1):g' \
      | sort -k2 -r -t':' \
      | "${color_command[@]}"
  }
fi

# ---- WARN ---- print current status for pseudo ealry startup ----
# FYI: [~/.bashrcは何も出力してはいけない（するならエラー出力に） - None is None is None]( http://doloopwhile.hatenablog.com/entry/2014/11/04/124725 )
function login_init() {
  # cd .
  ls_abbrev
  if [[ ! -n "$TMUX" ]] && [[ -n $SSH_TTY ]] && cmdcheck tmux; then
    local tmux_ls
    # NOTE: this timeout is used for freezed tmux server (tmux client doesn't accept signals e.g. c-c)
    tmux_ls=$(tmux-ls-format 2>/dev/null)
    [[ $? == 0 ]] && echo "${PURPLE}[tmux ls]${DEFAULT}" && echo "$tmux_ls"
  fi
}
if [[ $ZSH_NAME == zsh ]]; then
  login_init
fi
# ---- WARN ---- print current status for pseudo ealry startup ----

# NOTE: 現在のwindowsのmy setting(MSYS2)ではログインシェルの変更に不具合があるため(bash経由でzshを呼び出しているため，zshrcからzprofileを呼ぶ必要がある)
if [[ $OS == Windows_NT ]]; then
  test -r ~/.zprofile && source ~/.zprofile
fi

# auto compile
# NOTE: 関数内のalias展開に影響するため，compile前後の動作を確かめる必要がある
# -nt: file1 is newer than file2? (used modified time)
# zsh_compile_files=(~/.zshrc ~/.zprofile ~/.zlogin ~/.zlogout $(ls ~/.zsh/.*.zshrc) $(ls ~/.zsh/*/*.zsh))
# for src in "${zsh_compile_files[@]}"; do
#   [[ -e $src ]] && ([[ ! -e $src.zwc ]] || [[ ${src} -nt $src.zwc ]]) && zcompile $src
# done

# Prezto settings
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  # NOTE: backup $LS_COLORS
  _LS_COLORS="$LS_COLORS"
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
  # overwrite prompt setting
  if [[ -n "$SSH_TTY" ]]; then
    PS1='%F{3}[SSH] %F{4}${_prompt_sorin_pwd}%(!. %B%F{1}#%f%b.)${editor_info[keymap]} '
  fi
  export LS_COLORS="$_LS_COLORS" && unset _LS_COLORS
else
  # NOTE: install zprezto
  if cmdcheck git; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    echo "${BLUE}[HINT]${DEFAULT} exec /bin/zsh -l"
  fi
fi

if [[ -f /.dockerenv ]]; then
  # NOTE: to avoid 表示の乱れ (don't use sorin)
  # type >/dev/null 2>&1 prompt && prompt kylewest
  # function check_last_exit_code() {
  # local LAST_EXIT_CODE=$?
  # if [[ $LAST_EXIT_CODE -ne 0 ]]; then
  # local EXIT_CODE_PROMPT=' '
  # EXIT_CODE_PROMPT+="%F{166}$LAST_EXIT_CODE"
  # echo "$EXIT_CODE_PROMPT"
  # fi
  # }
  # RPROMPT='$(check_last_exit_code)'
  PS1='%F{3}(docker) %F{4}${_prompt_sorin_pwd}%(!. %B%F{1}#%f%b.)${editor_info[keymap]} '
  [[ $LC_CTYPE == "ja_JP.UTF-8" ]] && PS1='🐳 %F{4}${_prompt_sorin_pwd}%(!. %B%F{1}#%f%b.)${editor_info[keymap]} '
fi

unalias scp 2>/dev/null

# NOTE: maybe zprezto define below function
# slit () {
# awk "{ print ${(j:,:):-\$${^@}} }"
# }

unset -f slit 2>/dev/null
# NOTE: space区切りでの並べ替え
function reorder() {
  [[ $# -lt 1 ]] && echo "$(basename "$0") [1st_col_no 2nd_col_no...]" && return 1
  eval 'awk "{ print ${(j:,:):-\$${^@}} }"'
}

[[ -z $_PS1 ]] && _PS1="$PS1"
PROMPT_COLS_BOUNDARY=48

export HISTSIZE=100000

function traverse_path_list() {
  local dirpath=$(perl -MCwd -e 'print Cwd::abs_path shift' ${1:-$PWD})
  while true; do
    echo $dirpath
    [[ "$dirpath" == "/" ]] && break
    local dirpath="$(dirname $dirpath)"
  done
}

# NOTE: save and load setting of original pwd alias
function source() {
  if ! alias pwd >/dev/null 2>&1; then
    builtin source "$@"
    return
  fi

  local pwd_tmp=$(alias pwd)
  unalias pwd
  builtin source "$@"
  local exit_code=$?
  eval alias $pwd_tmp
  return $exit_code
}

# ----------------
# 環境変数を`export`するときには`-`は使用不可ではあるが、`env`で設定する際には問題ないので使用可能(alias -sでのbash起動時に自動的に関数化され、環境変数から消える)
# [shell script - what is the zsh equivalent of bash's export -f - Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/59360/what-is-the-zsh-equivalent-of-bashs-export-f )
# 関数をexportする(e.g. ./piyo.sh内で使用可能とする)

_export_funcs=()
function exportf() {
  [[ $# == 0 ]] && echo "Usage: $0 [func name]" && return 1
  ! declare -f "$1" >/dev/null && echo "$1 is not function" && return 1
  [[ -n $BASH ]] && export -f "$1" && return 0

  local func="$(whence -f $1 | sed -e "s/$1 //")"
  local _export_func="BASH_FUNC_${1}%%=$func"
  _export_funcs=($_export_funcs $_export_func)
}

# suffix alias
# ファイルの拡張子によって実行するコマンドを自動判別する
# to export zsh function to bash
## envで環境変数に一時的に登録してbashを実行するとそれが環境変数としてとりこまれる(exportでは"%%"で弾かれる)
## [bash - 環境変数から関数を取得する機能のセキュリティ強化 - 気ままなブログ]( http://d.hatena.ne.jp/entree/20140928/1411885652 )
## [shell script - what is the zsh equivalent of bash's export -f - Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/59360/what-is-the-zsh-equivalent-of-bashs-export-f )
## 一定の規則(e.g. "BASH_FUNC_piyo%%=( { echo piyo;})")で環境変数に指定すると関数として実行される
## あくまで拡張子がないといけないため、中身がshellの疑似実行ファイルに対しては無効なので、注意
# [[ $ZSH_NAME == zsh ]] && alias -s {sh,bash}='env "${_export_funcs[@]}" bash'
# ----------------

exportf cmdcheck

# [iandeth. - bashにて複数端末間でコマンド履歴(history)を共有する方法]( http://iandeth.dyndns.org/mt/ian/archives/000651.html )
function share_history() {
  history -a # .bash_historyに前回コマンドを1行追記
  history -c # 端末ローカルの履歴を一旦消去
  history -r # .bash_historyから履歴を読み込み直す
}
if [[ -n $BASH ]]; then
  PROMPT_COMMAND='share_history'
  shopt -u histappend
fi
if [[ $ZSH_NAME == zsh ]]; then
  # NOTE: how to check
  # setopt | grep 'xxx'

  setopt hist_ignore_dups
  setopt share_history

  # NOTE: these options are enabled
  ## 補完候補を一覧表示
  #   setopt auto_list
  ## =command を command のパス名に展開する
  #   setopt equals
  ## --prefix=/usr などの = 以降も補完
  #   setopt magic_equal_subst

  # FYI: [zshでオプション一覧の出力を分かりやすくする \- Qiita]( https://qiita.com/mollifier/items/26c67347734f9fcda274 )
  function showoptions() {
    set -o | sed -e 's/^no\(.*\)on$/\1  off/' -e 's/^no\(.*\)off$/\1  on/'
  }
fi

function sudoenable() {
  sudo -n true >/dev/null 2>&1 || sudo true
}

alias functions-list='functions | grep "() {" | grep -v -E "^\s+" | grep -v -E "^_" | sed "s/() {//g"'

[[ -f ~/dotfiles/.tools.bashrc ]] && source ~/dotfiles/.tools.bashrc

# NOTE: source bellow file to unalias git commands
[[ -f ~/.zsh/.prezto.git.init.zshrc ]] && source ~/.zsh/.prezto.git.init.zshrc

function command_not_found_handler() {
  # NOTE: this handler called in zle mode
  if false && cmdcheck img2sixel && [[ $(uname) == "Darwin" ]]; then
    mkdir -p ~/.cache/zsh/
    local cache_not_found_img_dirpath="$HOME/.cache/zsh/not_found_img"
    mkdir -p "$cache_not_found_img_dirpath"

    local urls=(
      'https://stickershop.line-scdn.net/stickershop/v1/sticker/13903692/android/sticker.png;compress=true' # gopher
      'https://s3.amazonaws.com/gt7sp-prod/decal/60/71/57/6269111907238577160_1.png' # kaiba
    )
    local index=$((${#0} % ${#urls} + 1)) # 1~ for zsh
    local cache_not_found_img_filepath="$cache_not_found_img_dirpath/$index.img"
    if [[ ! -f "$cache_not_found_img_filepath" ]]; then
      if [[ $index == 1 ]]; then
        wget "${urls[$index]}" -O "$cache_not_found_img_filepath"
      else
        wget "${urls[$index]}" -O download.img
        convert download.img -fuzz 20% -alpha on -fill 'rgba(255, 0, 0, 0.5)' -opaque '#000' tmp.img
        magick tmp.img -background none -gravity center -extent '%[fx:w*1.1]x0' "$cache_not_found_img_filepath"
      fi
    fi
    if [[ -f "$cache_not_found_img_filepath" ]]; then
      img2sixel -I "$cache_not_found_img_filepath"
      echo ''
    fi
  fi
  echo 1>&2 -n "${YELLOW}👻ヽ(*゜д゜)ノ$DEFAULT"
  echo 1>&2 "not found ${RED}'$0'${DEFAULT}"
  if cmdcheck thefuck; then
    echo 1>&2 "Maybe you can find true command by typing ${PURPLE}fuck${DEFAULT}!"
  fi
  return 404
}

# NOTE: [GitHub \- nvbn/thefuck: Magnificent app which corrects your previous console command\.]( https://github.com/nvbn/thefuck )
if cmdcheck thefuck; then
  # FYI: [Shell startup time · Issue \#859 · nvbn/thefuck]( https://github.com/nvbn/thefuck/issues/859 )
  # NOTE: lazy load
  function fuck() {
    unfunction fuck
    eval $(thefuck --alias fuck)
    command fuck
  }
fi

cmdcheck unbuffer || alias unbuffer='command'

local emsdk_dir="$HOME/local/emsdk"
if [[ -d "$emsdk_dir" ]]; then
  function emsdk-enable() {
    source "$emsdk_dir/emsdk_env.sh"
  }
fi

function safe-colorize() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
$(basename "$0") [--force] command [args...]
if command exists at '\$PATH', run that command, otherwise run only cat command
EOF
    return 1
  fi
  local force_flag=0
  if [[ "$1" == "--force" ]]; then
    force_flag=1
    shift
  fi
  local colorize_cmds=(ecat)
  if ! type >/dev/null 2>&1 "${colorize_cmds[1]}"; then
    colorize_cmds=(ccze -A -o nolookups)
    if ! type >/dev/null 2>&1 "${colorize_cmds[1]}"; then
      colorize_cmds=()
    fi
  else
    if [[ "$force_flag" == 1 ]]; then
      colorize_cmds=("${colorize_cmds[@]}" '--color=always')
    fi
  fi

  if { { [[ -t 1 ]] && [[ -t 2 ]]; } || [[ "$force_flag" == 1 ]]; } && [[ ${#colorize_cmds[@]} -gt 0 ]]; then
    "$@" |& "${colorize_cmds[@]}"
    local exit_code=${PIPESTATUS[0]:-$pipestatus[$((0 + 1))]}
    return $exit_code
  else
    "$@"
  fi
}

function safe-cat-pipe() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
$(basename "$0") command [args...]
if command exists at '\$PATH', run that command, otherwise run only cat command
EOF
    return 1
  fi
  local cmd="$1"
  if type >/dev/null 2>&1 "$cmd"; then
    "$@"
  else
    command cat
  fi
}

setopt clobber
SAVEHIST=100000
[[ -x $(which direnv) ]] && eval "$(direnv hook zsh)"

if [[ $ZSH_NAME == zsh ]]; then
  alias -s txt='cat'
  alias -s log='cat'
  alias -s rb='ruby'
  alias -s php='php -f'
  alias -s gp='gnuplot'
  alias -s {gz,tar,zip,rar,7z}='unarchive' # preztoのarchiveモジュールのコマンド(https://github.com/sorin-ionescu/prezto/tree/master/modules)

  # option for completion
  setopt magic_equal_subst              # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
  setopt GLOB_DOTS                      # 明確なドットの指定なしで.から始まるファイルをマッチ
  zstyle ':completion:*' use-cache true # apt-getとかdpkgコマンドをキャッシュを使って速くする
  setopt list_packed                    # 補完結果をできるだけ詰める
  # setopt rm_star_wait                   # rm * を実行する前に確認
  setopt numeric_glob_sort # 辞書順ではなく数字順に並べる。
  # NOTE: enable color file completion
  # NOTE: this eval is used to avoid shfmt error
  eval 'zstyle ":completion:*" list-colors "${(@s.:.)LS_COLORS}"'

  # enable tab completion even empty line
  zstyle ':completion:*' insert-tab false

  # force remove duplicate path
  typeset -U path cdpath fpath manpath

  setopt NO_BEEP
fi

# show statistcal time log when the command takes this value [sec]
REPORTTIME=10

## [[zsh]改行のない行が無視されてしまうのはzshの仕様だった件 · DQNEO起業日記]( http://dqn.sakusakutto.jp/2012/08/zsh_unsetopt_promptcr_zshrc.html )
## preztoや他のライブラリとの兼ね合いで効かなくなるので注意(次のzsh command hookで対応)
#unsetopt promptcr

# FYI: [シェルでコマンドの実行前後をフックする - Hibariya]( http://note.hibariya.org/articles/20170219/shell-postexec.html )
_pre_cmd=''
function zshaddhistory_hook() {
  local cmd=${1%%$'\n'}
  if [[ $(uname) == "Darwin" ]]; then
    # NOTE: to warn LD_PRELOAD at mac
    ({ printf '%s' $cmd | grep -s 'LD_PRELOAD'; } || [[ -n $LD_PRELOAD ]]) && echo "$RED THERE IS NO '"'$LD_PRELOAD'"' IN MAC. USE BELOW ENV!$DEFAULT" && echo "DYLD_FORCE_FLAT_NAMESPACE=1 DYLD_INSERT_LIBRARIES="
  fi

  # NOTE: maybe broken by multiple write
  # NOTE: <C-c> cause same history
  if [[ $_pre_cmd != $cmd ]]; then
    _pre_cmd=$cmd
    local date_str=$(date "+%Y/%m/%d %H:%M:%S")
    printf "%s@%s@%s@%s\n" "$date_str" "$TTY" "$(pwd)" "$cmd" >>~/.detail_history
  fi

  # conda environment has PS1 prefix
  if [[ -n "$CONDA_SHLVL" ]] && [[ "$CONDA_SHLVL" != 0 ]]; then
    :
  else
    # NOTE: auto replace PS1 depending on cols
    local cols=$(tput cols)
    if [[ $cols -le $PROMPT_COLS_BOUNDARY ]]; then
      # NOTE: %F{3}: YELLOW
      # NOTE: $'\n': new line
      PS1="$_PS1"$'\n%F{3}$%F{255} '
    else
      PS1="$_PS1"
    fi
  fi
}
function precmd_hook() {
  if [[ -n "$_RPROMPT" ]]; then
    RPROMPT="$_RPROMPT"
  fi
  cmdcheck cmdstack && cmdcheck cmdstack_len && [[ $(cmdstack_len) != 0 ]] && cmdstack
  # local cmd="$history[$((HISTCMD - 1))]"
  # NOTE: macのiTermでは必要ない(vimに関しては)
  # to prevent `Vimを使ってくれてありがとう` at tab
  type >/dev/null 2>&1 set-dirname-title && set-dirname-title
}
function preexec_hook() {
}

function re-prompt() {
  # redraw right prompt for clean terminal
  if [[ -n "$RPROMPT" ]]; then
    _RPROMPT="$RPROMPT"
  fi
  RPROMPT=''
  zle .reset-prompt
  zle .accept-line
}
zle -N accept-line re-prompt

autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory zshaddhistory_hook
add-zsh-hook precmd precmd_hook
add-zsh-hook preexec preexec_hook

if [[ $(uname) == "Darwin" ]]; then
  # disable to use binutils ar, ranlib, create symbolic link to default commands
  # FYI: [macでライブラリをビルドしてインストールするときはbinutilsに気をつける \- Qiita]( https://qiita.com/nagomiso/items/dc6021beb72d09f2128f )
  ln -sf /usr/bin/ar ~/local/bin/ar
  ln -sf /usr/bin/ranlib ~/local/bin/ranlib
fi

# NOTE: default key modeを変更するときには，一番最初に行う必要があるので注意
# NOTE: default emacs mode
# bindkey -e
# NOTE: set current mode as viins
# NOTE: ESC -> vicmd
bindkey -v

# for VSCode terminal
function source_if_exist() {
  local target="$1"
  [[ -f "$target" ]] && source "$target"
}

source_if_exist ~/.zsh/.function.zshrc
source_if_exist ~/.zsh/.docker.zshrc
source_if_exist ~/.zsh/.tmux.zshrc
source_if_exist ~/.zsh/.find.zshrc
source_if_exist ~/.zsh/.rust.zshrc
source_if_exist ~/.zsh/.gdb.zshrc

# NOTE: run after source .fzf.zsh to avoid overwrite ^R zsh keybind
source_if_exist ~/.zsh/.zplug.zshrc
# NOTE: run after compinit
source_if_exist ~/.zsh/.comp.zshrc

# NOTE: run after zplug to avoid overwrite keybind
source_if_exist ~/.zsh/.bindkey.zshrc
# NOTE: run after zsh-abbrev-alias plugin and bindkey
source_if_exist ~/.zsh/.abbrev.zshrc

source_if_exist ~/.zsh/.ros.zshrc
source_if_exist ~/.zsh/.peco.zshrc
source_if_exist ~/.zsh/.git.zshrc

source_if_exist "${ZDOTDIR:-$HOME}/.local.zshrc"

# ---------------------
[[ -n $DEBUG_MODE ]] && (which zprof >/dev/null 2>&1) && zprof
# ---- don't add code here by your hand
