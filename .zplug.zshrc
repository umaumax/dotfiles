#!/usr/bin/env zsh
local USE_ZPLUG=0

if [[ $USE_ZPLUG == 0 ]]; then
  # NOTE: this redundant lambda function expression is for shfmt
  function lambda() {
    # git://の方ではproxyの設定が反映されないので，https://形式の方が無難
    local zshdir=~/.zsh
    [[ ! -e $zshdir ]] && mkdir -p $zshdir

    [[ ! -e $zshdir/zsh-completions ]] && git clone https://github.com/zsh-users/zsh-completions $zshdir/zsh-completions
    fpath=($zshdir/zsh-completions/src $fpath)

    function enable_zsh_plugin() {
      local giturl="$1"
      local reponame="$(basename "$giturl")"
      local source_target="$2"
      [[ ! -e "$zshdir/$reponame" ]] && git clone "$giturl" "$zshdir/$reponame"
      source "$zshdir/$reponame/$source_target"
    }
    enable_zsh_plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh"
    enable_zsh_plugin "https://github.com/zsh-users/zsh-history-substring-search" "zsh-history-substring-search.zsh"
    enable_zsh_plugin "https://github.com/umaumax/zsh-abbrev-alias" "abbrev-alias.plugin.zsh"

    # # NOTE: this plugin includes zsh-syntax-highlighting
    # # NOTE: below plugin maybe has bug? (manly at ubuntu?)
    # # enable_zsh_plugin "https://github.com/trapd00r/zsh-syntax-highlighting-filetypes" "zsh-syntax-highlighting-filetypes.zsh"
    # enable_zsh_plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"
    #
    # # NOTE: 補完の候補の灰色が見えにくくなるため，修正
    # # FYI: [zsh\-syntax\-highlighting/main\-highlighter\.zsh at 1e34c4aa0bcbdde5173aab15600784edf0a212fd · zsh\-users/zsh\-syntax\-highlighting]( https://github.com/zsh-users/zsh-syntax-highlighting/blob/1e34c4aa0bcbdde5173aab15600784edf0a212fd/highlighters/main/main-highlighter.zsh#L31 )
    # # FYI: [zsh\-syntax\-highlighting/main\.md at db6cac391bee957c20ff3175b2f03c4817253e60 · zsh\-users/zsh\-syntax\-highlighting]( https://github.com/zsh-users/zsh-syntax-highlighting/blob/db6cac391bee957c20ff3175b2f03c4817253e60/docs/highlighters/main.md )
    # ZSH_HIGHLIGHT_STYLES+=(
    # default 'fg=255'
    # # -v
    # single-hyphen-option 'fg=250'
    # # --version
    # double-hyphen-option 'fg=250'
    # # var=val
    # assign 'fg=111,bold'
    # redirection 'fg=magenta'
    # comment 'fg=240'
    # # | ; || && and so on...
    # commandseparator 'fg=magenta'
    # path 'underline'
    # # unknown options
    # command-substitution 'fg=magenta'
    # process-substitution 'fg=magenta'
    # command-substitution-delimiter 'fg=magenta'
    # process-substitution-delimiter 'fg=magenta'
    # )
    # # NOTE: default is only 'main'
    # # WARN: don't add cursor to avoid losing cursor
    # ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    # ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
    # # <() process-substitution?
    # # $() command-substitution?

    # NOTE: migration fast-syntax-highlighting from zsh-syntax-highlighting
    # NOTE: run below command only once
    # fast-theme q-jmnemonic
    enable_zsh_plugin "https://github.com/zdharma/fast-syntax-highlighting" "fast-syntax-highlighting.plugin.zsh"
    if { fast-theme -s | grep -v -q 'spa'; }; then
      echo "${PURPLE}force applying style${DEFAULT}"
      fast-theme 'spa'
    fi

    # NOTE: original version
    enable_zsh_plugin "https://github.com/hchbaw/zce.zsh" "zce.zsh"
    # NOTE: extended version
    enable_zsh_plugin "https://github.com/IngoHeimbach/zsh-easy-motion" "easy_motion.plugin.zsh"

    # NOTE: set variable before source
    EASY_ONE_REFFILE=~/dotfiles/snippets/snippet.txt
    EASY_ONE_KEYBIND='^x^x' # default "^x^x"
    # NOTE: for fzy(文字列の色が途中で変化するとその文字の色が初期化されてしまう)
    # EASY_ONE_FILTER_COMMAND="fzy"
    # EASY_ONE_FILTER_OPTS="-l $(($(tput lines) / 2))"
    # NOTE: for fzf
    EASY_ONE_FILTER_COMMAND="fzf"
    EASY_ONE_FILTER_OPTS=(--no-mouse --ansi --reverse --height 50% --query="'")
    enable_zsh_plugin "https://github.com/umaumax/easy-oneliner" "easy-oneliner.zsh"

    # [よく使うディレクトリをブックマークする zsh のプラグイン \- Qiita]( https://qiita.com/mollifier/items/46b080f9a5ca9f29674e )
    [[ ! -e $zshdir/cd-bookmark ]] && git clone https://github.com/mollifier/cd-bookmark.git $zshdir/cd-bookmark
    fpath=($zshdir/cd-bookmark $fpath)
    autoload -Uz cd-bookmark
    function cdb() {
      [[ $# -gt 0 ]] && cd-bookmark "$@" && return
      local tag=$(cd-bookmark | peco | cut -d'|' -f1)
      [[ -n $tag ]] && cd-bookmark "$tag"
    }

    function ln_if_noexist() {
      [[ $# -le 1 ]] && echo "$0 <src> <dst>" && return
      [[ -e $1 ]] && [[ ! -e $2 ]] && ln -s $1 $2
    }

    local zsh_completion_dir=''
    [[ $(uname) == "Darwin" ]] && local zsh_completion_dir='/usr/local/share/zsh/site-functions'
    [[ $(uname) == "Linux" ]] && local zsh_completion_dir="$HOME/.zsh/completion"
    # [docker コマンドの zsh autocompletion \- Qiita]( https://qiita.com/mickamy/items/daa2a0de5f34c9c59ad9 )
    if [[ $(uname) == "Darwin" ]]; then
      ln_if_noexist /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion "${zsh_completion_dir}/_docker"
      ln_if_noexist /Applications/Docker.app/Contents/Resources/etc/docker-machine.zsh-completion "${zsh_completion_dir}/_docker-machine"
      ln_if_noexist /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion "${zsh_completion_dir}/_docker-compose"
    elif [[ $(uname) == "Linux" ]]; then
      mkdir -p "$zsh_completion_dir"
      # [Command\-line completion \| Docker Documentation]( https://docs.docker.com/compose/completion/#zsh )
      # NOTE: you cat get docker-compose version by $(docker-compose version --short)
      [[ ! -e $zsh_completion_dir/_docker-compose ]] && curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/zsh/_docker-compose >$zsh_completion_dir/_docker-compose

      # NOTE: below setting is written in README.md
      [[ ! -e $zsh_completion_dir/_tig ]] && wget https://raw.githubusercontent.com/jonas/tig/master/contrib/tig-completion.zsh -O $zsh_completion_dir/_tig
      [[ ! -e $zsh_completion_dir/tig-completion.bash ]] && wget https://raw.githubusercontent.com/jonas/tig/master/contrib/tig-completion.bash -O $zsh_completion_dir/tig-completion.bash

      fpath=(~/.zsh/completion $fpath)
    fi

    # pip
    cmdcheck pip && [[ ! -e $zsh_completion_dir/_pip ]] && pip completion --zsh >$zsh_completion_dir/_pip
    [[ -e $zsh_completion_dir/_pip ]] && source $zsh_completion_dir/_pip && compctl -K _pip_completion pip2 && compctl -K _pip_completion pip3

    # NOTE: enbale zsh completion
    # [zshの起動が遅いのでなんとかしたい 2 \- Qiita]( https://qiita.com/vintersnow/items/c29086790222608b28cf )
    # NOTE: slow with security check
    #     autoload -Uz compinit && compinit -i
    # NOTE: fast(0.0x sec) without security check
    autoload -Uz compinit && compinit -C
  } && lambda
  return
fi

bindkey $EASY_ONE_KEYBIND easy-oneliner
# zplug
# NOTE: zplug影響下ではreloginができなくなる...，ため， zplugで大量に管理しない場合には上記のほうがおすすめ
[[ ! -e ~/.zplug ]] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
if [[ -e ~/.zplug ]]; then
  source ~/.zplug/init.zsh

  #   zplug "zplug/zplug", hook-build:'zplug --self-manage'

  # [b4b4r07/zsh\-history\-ltsv: Command history tool available on Zsh enhanced drastically]( https://github.com/b4b4r07/zsh-history-ltsv )
  zplug "b4b4r07/zsh-history-enhanced"
  if zplug check "b4b4r07/zsh-history-enhanced"; then
    #     ZSH_HISTORY_FILE="$HISTFILE"
    ZSH_HISTORY_FILTER="fzy:fzf:peco:percol"
    ZSH_HISTORY_KEYBIND_GET_BY_DIR="^r"
    ZSH_HISTORY_KEYBIND_GET_ALL="^r^a"
  fi

  # [b4b4r07/enhancd: A next\-generation cd command with an interactive filter]( https://github.com/b4b4r07/enhancd )
  # use: source ~/.zplug/repos/b4b4r07/enhancd/init.sh
  zplug "b4b4r07/enhancd", use:init.sh
  ENHANCD_FILTER="command peco"
  export ENHANCD_FILTER

  zplug "zsh-users/zsh-history-substring-search", hook-build:"__zsh_version 4.3"
  zplug "zsh-users/zsh-syntax-highlighting", defer:2
  zplug "zsh-users/zsh-completions"
  zplug "zsh-users/zsh-autosuggestions"
  zplug "umaumax/zsh-abbrev-alias"
  zplug 'Valodim/zsh-curl-completion'
  zplug "chrissicool/zsh-256color"
  zplug 'hchbaw/zce.zsh'
  zplug 'IngoHeimbach/zsh-easy-motion'

  # Install easy-oneliner (If fzf is already installed)
  zplug "b4b4r07/easy-oneliner", if:"which fzf"

  # TODO: add cd-bookmark setting

  # install conrifmation
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo
      zplug install
    fi
  fi

  # コマンドをリンクして、PATH に追加し、プラグインは読み込む
  #   zplug load --verbose
  zplug load

  autoload -Uz compinit && compinit -i
fi
