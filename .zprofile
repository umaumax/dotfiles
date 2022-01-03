# HINT: if you want to calclate login time uncomment next line
# DEBUG_MODE='ON'
[[ -n $DEBUG_MODE ]] && zmodload zsh/zprof && zprof

unset LANGUAGE
export LANG='ja_JP.UTF-8'

typeset -gU cdpath fpath mailpath path

path=(
  /usr/local/{bin,sbin}
  $path
)

fpath=(
  ~/local/share/zsh/site-functions
  ~/dotfiles/local/share/zsh/site-functions
  $fpath
)
mkdir -p ~/local/share/zsh/site-functions

export LESS='-F -g -i -M -R -S -w -X -z-4'
# for ubuntu
if [[ -e "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]]; then
  export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
fi

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

# ---- zsh ----
# ---- bash ----

function cmdcheck() {
  local cmd="$1"
  if type "$cmd" >/dev/null 2>&1; then
    :
  else
    local code=$?
    _NO_CMD="$_NO_CMD:$cmd"
    return $code
  fi
}

function prepend_path() {
  local p="$1"
  [[ -d "$p" ]] && export PATH="$p:$PATH"
}
function append_path() {
  local p="$1"
  export PATH="$PATH:$p"
}
function exist() {
  local file="$1"
  [[ -e "$file" ]]
}

#
# Editors
#

VIM=vim
cmdcheck nvim && VIM=nvim
export EDITOR=$VIM
export GIT_EDITOR=$VIM
export VISUAL=$VIM
export PAGER='less'
# [manをVimで見る]( https://rcmdnk.com/blog/2014/07/20/computer-vim/ )
# NOTE: both vim and nvim is available, but maybe vim is better (because of no readonly warning message)
export MANPAGER="/bin/sh -c \"col -b -x| VIM_MAN_FLAG=1 vim -R -c 'set ft=man nolist nonu noma' -\""

export LC_CTYPE="ja_JP.UTF-8" # mac default is "UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

# ----

# golang
mkdir -p ~/go
if [[ -d ~/go ]]; then
  append_path ~/go/bin
fi
# NOTE: for ubuntu apt-get
if [[ -d "$HOME/local/go" ]]; then
  append_path "$HOME/local/go/bin"
fi
# for Ubuntu16.04
if [[ -d "/usr/lib/go-1.10" ]]; then
  append_path /usr/lib/go-1.10/bin
fi
if [[ -d "/usr/lib/go" ]]; then
  append_path /usr/lib/go/bin
fi

if [[ -d "/snap/bin" ]]; then
  append_path /snap/bin
fi

# for mac
if [[ -e /usr/local/share/git-core/contrib/diff-highlight/diff-highlight ]]; then
  export GIT_DIFF_HIGHLIGHT='/usr/local/share/git-core/contrib/diff-highlight/diff-highlight'
fi
# for Ubuntu
if [[ -e /usr/share/doc/git/contrib/diff-highlight/diff-highlight ]]; then
  export GIT_DIFF_HIGHLIGHT='/usr/share/doc/git/contrib/diff-highlight/diff-highlight'
fi

# for .NET
append_path ~/.dotnet

# for pip
# [systemd\-path user\-binaries]( https://unix.stackexchange.com/questions/316765/which-distributions-have-home-local-bin-in-path )
append_path ~/.local/bin

# NOTE: disable brew analytics
export HOMEBREW_NO_ANALYTICS
export HOMEBREW_NO_AUTO_UPDATE=1

# for Apple M1 home brew
if [[ -e /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
  export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

  export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
fi

# set a higher priority compared to one which installed by brew
# for node version management 'n' command
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

export PATH=$HOME/.yarn/bin:$PATH

# python
## pyenv
export PYENV_ROOT="${HOME}/.pyenv"
export PATH=${PYENV_ROOT}/bin:$PATH
if cmdcheck pyenv; then
  exist ~/python/lib/ && export PYTHONPATH=$var
  # for blender add-ons
  [[ -d "/Applications/blender.app/Contents/Resources/2.78/scripts/addons" ]] && export PYTHONPATH="/Applications/blender.app/Contents/Resources/2.78/scripts/addons:PYTHONPATH"

  # NOTE: slow
  # NOTE: if you add --no-rehash (it will be a little faster)
  eval "$(pyenv init --no-rehash 2>&1)"

  # NOTE: for virtualenv
  # 	eval "$(pyenv virtualenv-init -)"
fi

# perl
if cmdcheck cpanm; then
  # NOTE: setting
  # cpanm install Reply
  # NOTE: perl repl
  # reply
  if [[ $(uname) == "Darwin" ]]; then
    append_path /usr/local/Cellar/perl/5.30.0/bin
  else
    export PERL_CPANM_OPT="--local-lib=$HOME/.cpanm"
    export PATH="$HOME/.cpanm/bin:$PATH"
    export PERL5LIB="$HOME/.cpanm/lib/perl5:$PERL5LIB"
  fi
fi

# NOTE: slow
# cmdcheck python3 && python3 -m site &>/dev/null && PATH="$PATH:$(python3 -m site --user-base)/bin"
# cmdcheck python2 && python2 -m site &>/dev/null && PATH="$PATH:$(python2 -m site --user-base)/bin"

# NOTE: for :ruby
# if cmdcheck rbenv; then
# append_path "$HOME/.rbenv/bin"
# NOTE: below is needed?
# eval "$(rbenv init -)"
# fi

# rust
append_path "$HOME/.cargo/bin"

if [[ $(uname) == "Darwin" ]]; then
  # add PATH for binutils(e.g. gobjdump)
  append_path /usr/local/opt/binutils/bin
fi

# linuxbrew
# FYI: [Linuxbrew \| The Homebrew package manager for Linux]( http://linuxbrew.sh/ )
if [[ ! -d ~/.linuxbrew ]] && [[ $(uname) == "Linux" ]]; then
  git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew
fi
if [[ -d ~/.linuxbrew ]]; then
  export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
  export PKG_CONFIG_PATH="$HOME/.linuxbrew/lib64/pkgconfig:$HOME/.linuxbrew/lib/pkgconfig:$PKG_CONFIG_PATH"
  # to avoid ~/.linuxbrew/lib/libxxx.so.x: no version information available (required by xxx)
  # export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"
fi
# NOTE: force alias to system pkg-config (the priority is higher than linuxbrew)
[[ -f ~/.linuxbrew/bin/pkg-config ]] && ln -sf /usr/bin/pkg-config ~/local/bin/pkg-config

# for easy color output
export BLACK=$'\e[30m'
export RED=$'\e[31m'
export GREEN=$'\e[32m'
export YELLOW=$'\e[33m'
export BLUE=$'\e[34m'
export PURPLE=$'\e[35m'
export LIGHT_BLUE=$'\e[36m'
export WHITE=$'\e[37m'
export GRAY=$'\e[90m'
export DEFAULT=$'\e[0m'

# brew install source-highlight
# cmdcheck src-hilite-lesspipe.sh && export LESSOPEN="| src-hilite-lesspipe.sh %s"
export MORE='--quit-if-one-screen -MR'
[[ -n $BASH ]] && export LESS='-R'

# grep: warning: GREP_OPTIONS is deprecated
# export GREP_OPTIONS='--color=auto'
export GREP_COLOR='4;1;31'
export GREP_COLORS='sl=0:cx=1;32:mt=1;31:ms=4;1;31:mc=1;31:fn=1;32:ln=34:bn=36:se=0;37'

unset LS_COLORS
# FYI: [sharkdp/vivid: A generator for LS\_COLORS with support for multiple color themes]( https://github.com/sharkdp/vivid )
# export LS_COLORS="$(vivid generate snazzy)"
# NOTE: disable because of too long output at env command
# export LS_COLORS='*~=0;38;2;102;102;102:mi=0;38;2;0;0;0;48;2;255;92;87:so=0;38;2;0;0;0;48;2;255;106;193:di=0;38;2;87;199;255:bd=0;38;2;154;237;254;48;2;51;51;51:no=0:fi=0:ex=1;38;2;255;92;87:cd=0;38;2;255;106;193;48;2;51;51;51:or=0;38;2;0;0;0;48;2;255;92;87:pi=0;38;2;0;0;0;48;2;87;199;255:ln=0;38;2;255;106;193:*.d=0;38;2;90;247;142:*.p=0;38;2;90;247;142:*.m=0;38;2;90;247;142:*.t=0;38;2;90;247;142:*.o=0;38;2;102;102;102:*.z=4;38;2;154;237;254:*.c=0;38;2;90;247;142:*.h=0;38;2;90;247;142:*.a=1;38;2;255;92;87:*.r=0;38;2;90;247;142:*.cr=0;38;2;90;247;142:*.ps=0;38;2;255;92;87:*.xz=4;38;2;154;237;254:*.go=0;38;2;90;247;142:*.so=1;38;2;255;92;87:*.gz=4;38;2;154;237;254:*.vb=0;38;2;90;247;142:*.kt=0;38;2;90;247;142:*.py=0;38;2;90;247;142:*.el=0;38;2;90;247;142:*.nb=0;38;2;90;247;142:*.hh=0;38;2;90;247;142:*.hs=0;38;2;90;247;142:*.md=0;38;2;243;249;157:*.cp=0;38;2;90;247;142:*.pl=0;38;2;90;247;142:*.la=0;38;2;102;102;102:*.ko=1;38;2;255;92;87:*.pm=0;38;2;90;247;142:*.bz=4;38;2;154;237;254:*.td=0;38;2;90;247;142:*.rm=0;38;2;255;180;223:*.jl=0;38;2;90;247;142:*css=0;38;2;90;247;142:*.gv=0;38;2;90;247;142:*.ui=0;38;2;243;249;157:*.sh=0;38;2;90;247;142:*.as=0;38;2;90;247;142:*.ml=0;38;2;90;247;142:*.ts=0;38;2;90;247;142:*.pp=0;38;2;90;247;142:*.rs=0;38;2;90;247;142:*.cc=0;38;2;90;247;142:*.cs=0;38;2;90;247;142:*.rb=0;38;2;90;247;142:*.hi=0;38;2;102;102;102:*.bc=0;38;2;102;102;102:*.ex=0;38;2;90;247;142:*.lo=0;38;2;102;102;102:*.js=0;38;2;90;247;142:*.7z=4;38;2;154;237;254:*.ll=0;38;2;90;247;142:*.fs=0;38;2;90;247;142:*.di=0;38;2;90;247;142:*.mn=0;38;2;90;247;142:*.bmp=0;38;2;255;180;223:*.sxw=0;38;2;255;92;87:*.lua=0;38;2;90;247;142:*.exs=0;38;2;90;247;142:*.swp=0;38;2;102;102;102:*.wma=0;38;2;255;180;223:*.vcd=4;38;2;154;237;254:*.bcf=0;38;2;102;102;102:*.mir=0;38;2;90;247;142:*.fsx=0;38;2;90;247;142:*.fls=0;38;2;102;102;102:*.hpp=0;38;2;90;247;142:*.m4v=0;38;2;255;180;223:*.ttf=0;38;2;255;180;223:*.pps=0;38;2;255;92;87:*.pas=0;38;2;90;247;142:*.out=0;38;2;102;102;102:*.pkg=4;38;2;154;237;254:*.yml=0;38;2;243;249;157:*.def=0;38;2;90;247;142:*.elm=0;38;2;90;247;142:*.sxi=0;38;2;255;92;87:*.tml=0;38;2;243;249;157:*.img=4;38;2;154;237;254:*.rst=0;38;2;243;249;157:*.dot=0;38;2;90;247;142:*.asa=0;38;2;90;247;142:*.csv=0;38;2;243;249;157:*.clj=0;38;2;90;247;142:*.pyc=0;38;2;102;102;102:*.tcl=0;38;2;90;247;142:*.pdf=0;38;2;255;92;87:*.otf=0;38;2;255;180;223:*.exe=1;38;2;255;92;87:*.dmg=4;38;2;154;237;254:*.ini=0;38;2;243;249;157:*.toc=0;38;2;102;102;102:*.pod=0;38;2;90;247;142:*.gvy=0;38;2;90;247;142:*.bbl=0;38;2;102;102;102:*.sty=0;38;2;102;102;102:*.pro=0;38;2;165;255;195:*.ind=0;38;2;102;102;102:*.sbt=0;38;2;90;247;142:*.png=0;38;2;255;180;223:*.hxx=0;38;2;90;247;142:*.fnt=0;38;2;255;180;223:*.php=0;38;2;90;247;142:*.pbm=0;38;2;255;180;223:*.flv=0;38;2;255;180;223:*.mkv=0;38;2;255;180;223:*.mli=0;38;2;90;247;142:*.cxx=0;38;2;90;247;142:*.pid=0;38;2;102;102;102:*.rtf=0;38;2;255;92;87:*.ppm=0;38;2;255;180;223:*.ipp=0;38;2;90;247;142:*.mp3=0;38;2;255;180;223:*.swf=0;38;2;255;180;223:*.wav=0;38;2;255;180;223:*.h++=0;38;2;90;247;142:*.xcf=0;38;2;255;180;223:*.ods=0;38;2;255;92;87:*.tar=4;38;2;154;237;254:*.dll=1;38;2;255;92;87:*.bz2=4;38;2;154;237;254:*.dox=0;38;2;165;255;195:*.kex=0;38;2;255;92;87:*.tsx=0;38;2;90;247;142:*.bak=0;38;2;102;102;102:*.txt=0;38;2;243;249;157:*TODO=1:*.rpm=4;38;2;154;237;254:*.xlr=0;38;2;255;92;87:*.zip=4;38;2;154;237;254:*.bin=4;38;2;154;237;254:*.tbz=4;38;2;154;237;254:*.csx=0;38;2;90;247;142:*.erl=0;38;2;90;247;142:*.iso=4;38;2;154;237;254:*.mid=0;38;2;255;180;223:*.mp4=0;38;2;255;180;223:*.ltx=0;38;2;90;247;142:*.fon=0;38;2;255;180;223:*.odt=0;38;2;255;92;87:*.inl=0;38;2;90;247;142:*.git=0;38;2;102;102;102:*.gif=0;38;2;255;180;223:*.inc=0;38;2;90;247;142:*.xls=0;38;2;255;92;87:*.xml=0;38;2;243;249;157:*.ps1=0;38;2;90;247;142:*.bat=1;38;2;255;92;87:*.dpr=0;38;2;90;247;142:*.odp=0;38;2;255;92;87:*.ogg=0;38;2;255;180;223:*.doc=0;38;2;255;92;87:*.bib=0;38;2;243;249;157:*.ilg=0;38;2;102;102;102:*.rar=4;38;2;154;237;254:*.ppt=0;38;2;255;92;87:*.mpg=0;38;2;255;180;223:*.svg=0;38;2;255;180;223:*.vob=0;38;2;255;180;223:*.vim=0;38;2;90;247;142:*.c++=0;38;2;90;247;142:*.epp=0;38;2;90;247;142:*.aux=0;38;2;102;102;102:*.awk=0;38;2;90;247;142:*.ics=0;38;2;255;92;87:*.mov=0;38;2;255;180;223:*.arj=4;38;2;154;237;254:*.htm=0;38;2;243;249;157:*.sql=0;38;2;90;247;142:*.ico=0;38;2;255;180;223:*.cgi=0;38;2;90;247;142:*.cpp=0;38;2;90;247;142:*.avi=0;38;2;255;180;223:*.idx=0;38;2;102;102;102:*.jpg=0;38;2;255;180;223:*.tex=0;38;2;90;247;142:*.bst=0;38;2;243;249;157:*.bag=4;38;2;154;237;254:*.fsi=0;38;2;90;247;142:*.cfg=0;38;2;243;249;157:*.com=1;38;2;255;92;87:*.kts=0;38;2;90;247;142:*.bsh=0;38;2;90;247;142:*.pgm=0;38;2;255;180;223:*hgrc=0;38;2;165;255;195:*.apk=4;38;2;154;237;254:*.tgz=4;38;2;154;237;254:*.nix=0;38;2;243;249;157:*.blg=0;38;2;102;102;102:*.deb=4;38;2;154;237;254:*.aif=0;38;2;255;180;223:*.xmp=0;38;2;243;249;157:*.wmv=0;38;2;255;180;223:*.log=0;38;2;102;102;102:*.jar=4;38;2;154;237;254:*.tmp=0;38;2;102;102;102:*.htc=0;38;2;90;247;142:*.tif=0;38;2;255;180;223:*.zsh=0;38;2;90;247;142:*.lock=0;38;2;102;102;102:*.dart=0;38;2;90;247;142:*.rlib=0;38;2;102;102;102:*.h264=0;38;2;255;180;223:*.bash=0;38;2;90;247;142:*.yaml=0;38;2;243;249;157:*.docx=0;38;2;255;92;87:*.flac=0;38;2;255;180;223:*.jpeg=0;38;2;255;180;223:*.epub=0;38;2;255;92;87:*.java=0;38;2;90;247;142:*.psm1=0;38;2;90;247;142:*.lisp=0;38;2;90;247;142:*.make=0;38;2;165;255;195:*.tbz2=4;38;2;154;237;254:*.orig=0;38;2;102;102;102:*.json=0;38;2;243;249;157:*.fish=0;38;2;90;247;142:*.conf=0;38;2;243;249;157:*.toml=0;38;2;243;249;157:*.xlsx=0;38;2;255;92;87:*.purs=0;38;2;90;247;142:*.mpeg=0;38;2;255;180;223:*.pptx=0;38;2;255;92;87:*.html=0;38;2;243;249;157:*.diff=0;38;2;90;247;142:*.hgrc=0;38;2;165;255;195:*.psd1=0;38;2;90;247;142:*.less=0;38;2;90;247;142:*.ipynb=0;38;2;90;247;142:*.swift=0;38;2;90;247;142:*.cache=0;38;2;102;102;102:*.toast=4;38;2;154;237;254:*.class=0;38;2;102;102;102:*.shtml=0;38;2;243;249;157:*.mdown=0;38;2;243;249;157:*.xhtml=0;38;2;243;249;157:*README=0;38;2;40;42;54;48;2;243;249;157:*.dyn_o=0;38;2;102;102;102:*passwd=0;38;2;243;249;157:*.patch=0;38;2;90;247;142:*.cabal=0;38;2;90;247;142:*.scala=0;38;2;90;247;142:*.cmake=0;38;2;165;255;195:*shadow=0;38;2;243;249;157:*.matlab=0;38;2;90;247;142:*.gradle=0;38;2;90;247;142:*.dyn_hi=0;38;2;102;102;102:*.flake8=0;38;2;165;255;195:*TODO.md=1:*.ignore=0;38;2;165;255;195:*COPYING=0;38;2;153;153;153:*LICENSE=0;38;2;153;153;153:*INSTALL=0;38;2;40;42;54;48;2;243;249;157:*.config=0;38;2;243;249;157:*.groovy=0;38;2;90;247;142:*Makefile=0;38;2;165;255;195:*Doxyfile=0;38;2;165;255;195:*setup.py=0;38;2;165;255;195:*.desktop=0;38;2;243;249;157:*.gemspec=0;38;2;165;255;195:*TODO.txt=1:*configure=0;38;2;165;255;195:*README.md=0;38;2;40;42;54;48;2;243;249;157:*.markdown=0;38;2;243;249;157:*.rgignore=0;38;2;165;255;195:*.cmake.in=0;38;2;165;255;195:*.fdignore=0;38;2;165;255;195:*.kdevelop=0;38;2;165;255;195:*COPYRIGHT=0;38;2;153;153;153:*CODEOWNERS=0;38;2;165;255;195:*INSTALL.md=0;38;2;40;42;54;48;2;243;249;157:*.scons_opt=0;38;2;102;102;102:*SConstruct=0;38;2;165;255;195:*README.txt=0;38;2;40;42;54;48;2;243;249;157:*.gitconfig=0;38;2;165;255;195:*SConscript=0;38;2;165;255;195:*.gitignore=0;38;2;165;255;195:*Dockerfile=0;38;2;243;249;157:*.gitmodules=0;38;2;165;255;195:*Makefile.am=0;38;2;165;255;195:*.synctex.gz=0;38;2;102;102;102:*LICENSE-MIT=0;38;2;153;153;153:*MANIFEST.in=0;38;2;165;255;195:*Makefile.in=0;38;2;102;102;102:*.travis.yml=0;38;2;90;247;142:*.fdb_latexmk=0;38;2;102;102;102:*appveyor.yml=0;38;2;90;247;142:*configure.ac=0;38;2;165;255;195:*.applescript=0;38;2;90;247;142:*CONTRIBUTORS=0;38;2;40;42;54;48;2;243;249;157:*.clang-format=0;38;2;165;255;195:*CMakeLists.txt=0;38;2;165;255;195:*.gitattributes=0;38;2;165;255;195:*CMakeCache.txt=0;38;2;102;102;102:*LICENSE-APACHE=0;38;2;153;153;153:*INSTALL.md.txt=0;38;2;40;42;54;48;2;243;249;157:*CONTRIBUTORS.md=0;38;2;40;42;54;48;2;243;249;157:*.sconsign.dblite=0;38;2;102;102;102:*requirements.txt=0;38;2;165;255;195:*CONTRIBUTORS.txt=0;38;2;40;42;54;48;2;243;249;157:*package-lock.json=0;38;2;102;102;102'

# NOTE: for bat
# FYI: bat --list-themes
export BAT_THEME=TwoDark

[[ $(uname) == "Darwin" ]] && export LSCOLORS=gxfxcxdxbxegexabagacad

# NOTE: X11が有効な場合にはクリップボードを使用可能とする(特にsshログイン時)
if [[ -z $DISPLAY ]]; then
  export DISPLAY=":0"
  xset q >/dev/null 2>&1 || unset DISPLAY
fi

# NOTE: tmux stores the server socket in a directory under TMUX_TMPDIR or /tmp if it is unset.
export TMUX_TMPDIR="$HOME/.tmux/tmp/"
mkdir -p "$TMUX_TMPDIR"

if [[ -s "${ZDOTDIR:-$HOME}/.local.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.local.zprofile"
fi

mkdir -p ~/local/bin
prepend_path ~/local/bin
cmdcheck nvim && [[ ! -f ~/local/bin/vim ]] && ln -s $(which nvim) ~/local/bin/vim

append_path ~/dotfiles/local/bin

export NEXTWORD_DATA_PATH=$HOME/.cache/nextword/nextword-data-large

function source_if_exist() {
  local target="$1"
  [[ -f "$target" ]] && source "$target"
}

source_if_exist ~/.fzf.zsh

# ----

[[ -n $BASH ]] && export HISTFILESIZE=100000
[[ -n $BASH && -f ~/.bashrc ]] && source ~/.bashrc
# ---- bash ----

[[ -n $DEBUG_MODE ]] && (which zprof >/dev/null 2>&1) && zprof
