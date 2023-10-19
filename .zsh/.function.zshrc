# NOTE: or use: perl -e 'print reverse<>'
cmdcheck tac || alias tac='tail -r'

if cmdcheck exa; then
  alias exa='LS_COLORS= exa -h --color-scale --git --time-style iso'
  alias l='exa --sort=name'
  alias la='exa -al --sort=name'
  alias lat='exa --sort modified --sort oldest -alt modified'
  alias latr='exa --sort modified --sort oldest -alrt modified'
  unalias ls >/dev/null 2>&1
  function ls() {
    if [[ $# == 0 ]]; then
      LS_COLORS= exa -h
    else
      LS_COLORS_='*~=0;38;2;102;102;102:mi=0;38;2;0;0;0;48;2;255;92;87:so=0;38;2;0;0;0;48;2;255;106;193:di=0;38;2;87;199;255:bd=0;38;2;154;237;254;48;2;51;51;51:no=0:fi=0:ex=1;38;2;255;92;87:cd=0;38;2;255;106;193;48;2;51;51;51:or=0;38;2;0;0;0;48;2;255;92;87:pi=0;38;2;0;0;0;48;2;87;199;255:ln=0;38;2;255;106;193:*.d=0;38;2;90;247;142:*.p=0;38;2;90;247;142:*.m=0;38;2;90;247;142:*.t=0;38;2;90;247;142:*.o=0;38;2;102;102;102:*.z=4;38;2;154;237;254:*.c=0;38;2;90;247;142:*.h=0;38;2;90;247;142:*.a=1;38;2;255;92;87:*.r=0;38;2;90;247;142:*.cr=0;38;2;90;247;142:*.ps=0;38;2;255;92;87:*.xz=4;38;2;154;237;254:*.go=0;38;2;90;247;142:*.so=1;38;2;255;92;87:*.gz=4;38;2;154;237;254:*.vb=0;38;2;90;247;142:*.kt=0;38;2;90;247;142:*.py=0;38;2;90;247;142:*.el=0;38;2;90;247;142:*.nb=0;38;2;90;247;142:*.hh=0;38;2;90;247;142:*.hs=0;38;2;90;247;142:*.md=0;38;2;243;249;157:*.cp=0;38;2;90;247;142:*.pl=0;38;2;90;247;142:*.la=0;38;2;102;102;102:*.ko=1;38;2;255;92;87:*.pm=0;38;2;90;247;142:*.bz=4;38;2;154;237;254:*.td=0;38;2;90;247;142:*.rm=0;38;2;255;180;223:*.jl=0;38;2;90;247;142:*css=0;38;2;90;247;142:*.gv=0;38;2;90;247;142:*.ui=0;38;2;243;249;157:*.sh=0;38;2;90;247;142:*.as=0;38;2;90;247;142:*.ml=0;38;2;90;247;142:*.ts=0;38;2;90;247;142:*.pp=0;38;2;90;247;142:*.rs=0;38;2;90;247;142:*.cc=0;38;2;90;247;142:*.cs=0;38;2;90;247;142:*.rb=0;38;2;90;247;142:*.hi=0;38;2;102;102;102:*.bc=0;38;2;102;102;102:*.ex=0;38;2;90;247;142:*.lo=0;38;2;102;102;102:*.js=0;38;2;90;247;142:*.7z=4;38;2;154;237;254:*.ll=0;38;2;90;247;142:*.fs=0;38;2;90;247;142:*.di=0;38;2;90;247;142:*.mn=0;38;2;90;247;142:*.bmp=0;38;2;255;180;223:*.sxw=0;38;2;255;92;87:*.lua=0;38;2;90;247;142:*.exs=0;38;2;90;247;142:*.swp=0;38;2;102;102;102:*.wma=0;38;2;255;180;223:*.vcd=4;38;2;154;237;254:*.bcf=0;38;2;102;102;102:*.mir=0;38;2;90;247;142:*.fsx=0;38;2;90;247;142:*.fls=0;38;2;102;102;102:*.hpp=0;38;2;90;247;142:*.m4v=0;38;2;255;180;223:*.ttf=0;38;2;255;180;223:*.pps=0;38;2;255;92;87:*.pas=0;38;2;90;247;142:*.out=0;38;2;102;102;102:*.pkg=4;38;2;154;237;254:*.yml=0;38;2;243;249;157:*.def=0;38;2;90;247;142:*.elm=0;38;2;90;247;142:*.sxi=0;38;2;255;92;87:*.tml=0;38;2;243;249;157:*.img=4;38;2;154;237;254:*.rst=0;38;2;243;249;157:*.dot=0;38;2;90;247;142:*.asa=0;38;2;90;247;142:*.csv=0;38;2;243;249;157:*.clj=0;38;2;90;247;142:*.pyc=0;38;2;102;102;102:*.tcl=0;38;2;90;247;142:*.pdf=0;38;2;255;92;87:*.otf=0;38;2;255;180;223:*.exe=1;38;2;255;92;87:*.dmg=4;38;2;154;237;254:*.ini=0;38;2;243;249;157:*.toc=0;38;2;102;102;102:*.pod=0;38;2;90;247;142:*.gvy=0;38;2;90;247;142:*.bbl=0;38;2;102;102;102:*.sty=0;38;2;102;102;102:*.pro=0;38;2;165;255;195:*.ind=0;38;2;102;102;102:*.sbt=0;38;2;90;247;142:*.png=0;38;2;255;180;223:*.hxx=0;38;2;90;247;142:*.fnt=0;38;2;255;180;223:*.php=0;38;2;90;247;142:*.pbm=0;38;2;255;180;223:*.flv=0;38;2;255;180;223:*.mkv=0;38;2;255;180;223:*.mli=0;38;2;90;247;142:*.cxx=0;38;2;90;247;142:*.pid=0;38;2;102;102;102:*.rtf=0;38;2;255;92;87:*.ppm=0;38;2;255;180;223:*.ipp=0;38;2;90;247;142:*.mp3=0;38;2;255;180;223:*.swf=0;38;2;255;180;223:*.wav=0;38;2;255;180;223:*.h++=0;38;2;90;247;142:*.xcf=0;38;2;255;180;223:*.ods=0;38;2;255;92;87:*.tar=4;38;2;154;237;254:*.dll=1;38;2;255;92;87:*.bz2=4;38;2;154;237;254:*.dox=0;38;2;165;255;195:*.kex=0;38;2;255;92;87:*.tsx=0;38;2;90;247;142:*.bak=0;38;2;102;102;102:*.txt=0;38;2;243;249;157:*TODO=1:*.rpm=4;38;2;154;237;254:*.xlr=0;38;2;255;92;87:*.zip=4;38;2;154;237;254:*.bin=4;38;2;154;237;254:*.tbz=4;38;2;154;237;254:*.csx=0;38;2;90;247;142:*.erl=0;38;2;90;247;142:*.iso=4;38;2;154;237;254:*.mid=0;38;2;255;180;223:*.mp4=0;38;2;255;180;223:*.ltx=0;38;2;90;247;142:*.fon=0;38;2;255;180;223:*.odt=0;38;2;255;92;87:*.inl=0;38;2;90;247;142:*.git=0;38;2;102;102;102:*.gif=0;38;2;255;180;223:*.inc=0;38;2;90;247;142:*.xls=0;38;2;255;92;87:*.xml=0;38;2;243;249;157:*.ps1=0;38;2;90;247;142:*.bat=1;38;2;255;92;87:*.dpr=0;38;2;90;247;142:*.odp=0;38;2;255;92;87:*.ogg=0;38;2;255;180;223:*.doc=0;38;2;255;92;87:*.bib=0;38;2;243;249;157:*.ilg=0;38;2;102;102;102:*.rar=4;38;2;154;237;254:*.ppt=0;38;2;255;92;87:*.mpg=0;38;2;255;180;223:*.svg=0;38;2;255;180;223:*.vob=0;38;2;255;180;223:*.vim=0;38;2;90;247;142:*.c++=0;38;2;90;247;142:*.epp=0;38;2;90;247;142:*.aux=0;38;2;102;102;102:*.awk=0;38;2;90;247;142:*.ics=0;38;2;255;92;87:*.mov=0;38;2;255;180;223:*.arj=4;38;2;154;237;254:*.htm=0;38;2;243;249;157:*.sql=0;38;2;90;247;142:*.ico=0;38;2;255;180;223:*.cgi=0;38;2;90;247;142:*.cpp=0;38;2;90;247;142:*.avi=0;38;2;255;180;223:*.idx=0;38;2;102;102;102:*.jpg=0;38;2;255;180;223:*.tex=0;38;2;90;247;142:*.bst=0;38;2;243;249;157:*.bag=4;38;2;154;237;254:*.fsi=0;38;2;90;247;142:*.cfg=0;38;2;243;249;157:*.com=1;38;2;255;92;87:*.kts=0;38;2;90;247;142:*.bsh=0;38;2;90;247;142:*.pgm=0;38;2;255;180;223:*hgrc=0;38;2;165;255;195:*.apk=4;38;2;154;237;254:*.tgz=4;38;2;154;237;254:*.nix=0;38;2;243;249;157:*.blg=0;38;2;102;102;102:*.deb=4;38;2;154;237;254:*.aif=0;38;2;255;180;223:*.xmp=0;38;2;243;249;157:*.wmv=0;38;2;255;180;223:*.log=0;38;2;102;102;102:*.jar=4;38;2;154;237;254:*.tmp=0;38;2;102;102;102:*.htc=0;38;2;90;247;142:*.tif=0;38;2;255;180;223:*.zsh=0;38;2;90;247;142:*.lock=0;38;2;102;102;102:*.dart=0;38;2;90;247;142:*.rlib=0;38;2;102;102;102:*.h264=0;38;2;255;180;223:*.bash=0;38;2;90;247;142:*.yaml=0;38;2;243;249;157:*.docx=0;38;2;255;92;87:*.flac=0;38;2;255;180;223:*.jpeg=0;38;2;255;180;223:*.epub=0;38;2;255;92;87:*.java=0;38;2;90;247;142:*.psm1=0;38;2;90;247;142:*.lisp=0;38;2;90;247;142:*.make=0;38;2;165;255;195:*.tbz2=4;38;2;154;237;254:*.orig=0;38;2;102;102;102:*.json=0;38;2;243;249;157:*.fish=0;38;2;90;247;142:*.conf=0;38;2;243;249;157:*.toml=0;38;2;243;249;157:*.xlsx=0;38;2;255;92;87:*.purs=0;38;2;90;247;142:*.mpeg=0;38;2;255;180;223:*.pptx=0;38;2;255;92;87:*.html=0;38;2;243;249;157:*.diff=0;38;2;90;247;142:*.hgrc=0;38;2;165;255;195:*.psd1=0;38;2;90;247;142:*.less=0;38;2;90;247;142:*.ipynb=0;38;2;90;247;142:*.swift=0;38;2;90;247;142:*.cache=0;38;2;102;102;102:*.toast=4;38;2;154;237;254:*.class=0;38;2;102;102;102:*.shtml=0;38;2;243;249;157:*.mdown=0;38;2;243;249;157:*.xhtml=0;38;2;243;249;157:*README=0;38;2;40;42;54;48;2;243;249;157:*.dyn_o=0;38;2;102;102;102:*passwd=0;38;2;243;249;157:*.patch=0;38;2;90;247;142:*.cabal=0;38;2;90;247;142:*.scala=0;38;2;90;247;142:*.cmake=0;38;2;165;255;195:*shadow=0;38;2;243;249;157:*.matlab=0;38;2;90;247;142:*.gradle=0;38;2;90;247;142:*.dyn_hi=0;38;2;102;102;102:*.flake8=0;38;2;165;255;195:*TODO.md=1:*.ignore=0;38;2;165;255;195:*COPYING=0;38;2;153;153;153:*LICENSE=0;38;2;153;153;153:*INSTALL=0;38;2;40;42;54;48;2;243;249;157:*.config=0;38;2;243;249;157:*.groovy=0;38;2;90;247;142:*Makefile=0;38;2;165;255;195:*Doxyfile=0;38;2;165;255;195:*setup.py=0;38;2;165;255;195:*.desktop=0;38;2;243;249;157:*.gemspec=0;38;2;165;255;195:*TODO.txt=1:*configure=0;38;2;165;255;195:*README.md=0;38;2;40;42;54;48;2;243;249;157:*.markdown=0;38;2;243;249;157:*.rgignore=0;38;2;165;255;195:*.cmake.in=0;38;2;165;255;195:*.fdignore=0;38;2;165;255;195:*.kdevelop=0;38;2;165;255;195:*COPYRIGHT=0;38;2;153;153;153:*CODEOWNERS=0;38;2;165;255;195:*INSTALL.md=0;38;2;40;42;54;48;2;243;249;157:*.scons_opt=0;38;2;102;102;102:*SConstruct=0;38;2;165;255;195:*README.txt=0;38;2;40;42;54;48;2;243;249;157:*.gitconfig=0;38;2;165;255;195:*SConscript=0;38;2;165;255;195:*.gitignore=0;38;2;165;255;195:*Dockerfile=0;38;2;243;249;157:*.gitmodules=0;38;2;165;255;195:*Makefile.am=0;38;2;165;255;195:*.synctex.gz=0;38;2;102;102;102:*LICENSE-MIT=0;38;2;153;153;153:*MANIFEST.in=0;38;2;165;255;195:*Makefile.in=0;38;2;102;102;102:*.travis.yml=0;38;2;90;247;142:*.fdb_latexmk=0;38;2;102;102;102:*appveyor.yml=0;38;2;90;247;142:*configure.ac=0;38;2;165;255;195:*.applescript=0;38;2;90;247;142:*CONTRIBUTORS=0;38;2;40;42;54;48;2;243;249;157:*.clang-format=0;38;2;165;255;195:*CMakeLists.txt=0;38;2;165;255;195:*.gitattributes=0;38;2;165;255;195:*CMakeCache.txt=0;38;2;102;102;102:*LICENSE-APACHE=0;38;2;153;153;153:*INSTALL.md.txt=0;38;2;40;42;54;48;2;243;249;157:*CONTRIBUTORS.md=0;38;2;40;42;54;48;2;243;249;157:*.sconsign.dblite=0;38;2;102;102;102:*requirements.txt=0;38;2;165;255;195:*CONTRIBUTORS.txt=0;38;2;40;42;54;48;2;243;249;157:*package-lock.json=0;38;2;102;102;102'
      [[ $(uname) == "Darwin" ]] && LS_COLORS="$LS_COLORS_" command ls -Gh "$@"
      [[ $(uname) == "Linux" ]] && LS_COLORS="$LS_COLORS_" command ls --color=auto -h "$@"
    fi
  }
  function treelist() {
    find . -type d | xargs exa --color=always | awk '/.*:/{printf "\n\033[38;2;87;199;255m%s ",$0} !/.*:/ && !/.\[38;2;87;199;255m.*/{printf "%s ",$0}'
  }
else
  [[ $(uname) == "Darwin" ]] && alias ls='ls -Gh'
  [[ $(uname) == "Linux" ]] && alias ls='ls --color=auto -h'
  alias l='ls'
  alias la='ls -al'
  alias lat='ls -alt'
  alias latr='ls -altr'
fi

alias ll='la'
alias lll='la'
alias lal='la'
alias lalt='lat'
alias laltr='latr'
alias lsa='la'
alias lsal='lal'
alias lsat='lat'
alias lsatr='latr'
alias lsalt='lalt'
alias lsaltr='laltr'
alias lllt='lsalt'
alias llltr='lsaltr'
alias lsnew='lsaltr'
alias lsold='lsalt'
alias newls='lsneww'
alias oldls='lsold'
alias new='lsnew'
alias old='lsold'
unalias lt

# NOTE: ls abspath
# -d: only directory
# -f: only file
function lsabs() {
  local args=()
  function get_n() {
    local n=$(($1 + 1))
    shift
    eval echo \$${n}
  }
  function arg_n() { get_n ${1:-0} "${args[@]}"; }
  local file_type=""
  for OPT in "$@"; do
    case $OPT in
      '-d' | '-f')
        local file_type=$OPT
        ;;
      *)
        local args=("${args[@]}" $1)
        ;;
    esac
    shift
  done
  local arg=$(arg_n 0)
  local dirpath=$(abspath_raw ${arg:-$PWD})

  local options=()
  [[ -n $file_type ]] && local options=(-type ${file_type#-})
  find $dirpath -maxdepth 1 "${options[@]}"
}
alias absls='lsabs'

# NOTE: windowsの処理が重いので，処理を省略
if [[ $OS == Windows_NT ]]; then
  [[ -f ~/.zsh/.windows.zshrc ]] && source ~/.zsh/.windows.zshrc
  return
fi

if [[ -n $WSLENV ]]; then
  [[ -f ~/.zsh/.wsl.zshrc ]] && source ~/.zsh/.wsl.zshrc
fi

function expand_home() {
  if [[ $# == 0 ]]; then
    perl -pe 's/(^~\/+)|(^~$)/$ENV{HOME}\//'
    # NOTE: for ansi color code (e.g. lolcat color output is inserted at between each chars)
    # perl -pe 's/(^(\e\[(\d+;)*\d+m)*~((\e\[(\d+;)*\d+m)*\/)+)|(^~$)/\2$ENV{HOME}\//'
  else
    for arg in "$@"; do
      printf '%s\n' "$arg" | expand_home
    done
  fi
}
# show user home dir as `~`
function homedir_normalization() {
  if [[ $# == 0 ]]; then
    sed 's:'"$(printf '%s' "$HOME" | sed "s/\//\\\\\//g")"':~:'
  else
    for arg in "$@"; do
      printf '%s\n' "$arg" | homedir_normalization
    done
  fi
}

function file-line-filter() {
  if [[ $# == 0 ]] || [[ $1 =~ ^(-h|-{1,2}help)$ ]]; then
    cat <<EOF
e.g.
seq 1 9 | '"$0 "'<(echo "4\\n3\\n1")

seq 1 9 | sed -n '4p; 3p; 1p;'
EOF
    return 1
  fi
  local filter_file="$1"
  perl -e 'my %hash; open(my $fh, "<", @ARGV[0]); while (my $line = <$fh>) { $hash{$line} += 1; }; close $fh; while (<STDIN>) { print $_ if exists($hash{$_}); }' "$filter_file"
}

# e.g. <(echo 1), =(echo 1), $(echo | psub)
function psub() {
  local tmpfilepath=$(mktemp)
  if [[ -p /dev/stdin ]]; then
    command cat >$tmpfilepath
    printf '%s' "$tmpfilepath"
  else
    return 1
  fi
}

# how to install
# pip3 install https://github.com/umaumax/AnsiToImg/archive/master.tar.gz
cmdcheck ansitoimg && function ansitoimg() {
  COLUMNS=$COLUMNS command ansitoimg "$@"
}

# NOTE: -o nolookups: speedup
cmdcheck ccze && alias ccze='ccze -A -o nolookups'

# NOTE: delete all file without starting . prefix at 'build' dir
cmdcheck 'cmake' && function cmake-clean() {
  [[ ! $(basename $PWD) =~ build ]] && echo "${RED}[WARN]${DEFAULT}current wd may be not cmake build dir" && return 1
  # -f option is for rm: remove write-protected regular file
  find . -maxdepth 1 -not -name '.*' -exec rm -rf {} +
}

alias basedirname='basename $PWD'

alias uniq-without-sort='awk "!a[\$0]++"'

alias vars='typeset'

alias home='cd ~'
alias dl='cd ~/Downloads/'
alias downloads='cd ~/Downloads/'
alias desktop='cd ~/Desktop/'

[[ -d ~/git ]] && alias cdgit='cd ~/git' && alias git-repo='cdgit' && alias ghome='cdgit' && alias devgit='cdgit'
[[ -d ~/local/bin ]] && alias local-bin='cd ~/local/bin'
[[ -d ~/github.com ]] && alias github='cd ~/github.com'
[[ -d ~/gitlab.com ]] && alias gitlab='cd ~/gitlab.com'
[[ -d ~/github.com/cpp-examples ]] && alias cpp-examples='cd ~/github.com/cpp-examples'
[[ -d ~/chrome-extension ]] && alias chrome-extension='cd ~/chrome-extension'
[[ -d ~/gshare ]] && alias gshare='cd ~/gshare' && alias vigshare='tabvim ~/gshare/*.md' && alias vimshare='vishare'
[[ -d ~/.config ]] && alias config='cd ~/.config'

[[ -d ~/dotfiles/.config/gofix ]] && alias gofixdict='cd ~/dotfiles/.config/gofix'
[[ -d ~/dotfiles/.git_template/hooks ]] && alias githooks='cd ~/dotfiles/.git_template/hooks'
[[ -d ~/dotfiles/.vim/config/neosnippet ]] && alias neosnippet='cd ~/dotfiles/.vim/config/neosnippet'
[[ -d ~/dotfiles/snippets ]] && alias snippetes='cd ~/dotfiles/snippets'
[[ -d ~/dotfiles/template ]] && alias template='cd ~/dotfiles/template'

[[ -f ~/dotfiles/local/snippets/snippet.txt ]] && alias visnippetes='vim ~/dotfiles/local/snippets/snippet.txt'
[[ -f ~/dotfiles/.gitconfig ]] && alias vigc='vim ~/dotfiles/.gitconfig' && alias vimgc='vigc'

[[ -f ~/.gitignore ]] && alias vigi='vim ~/.gitignore'
[[ -f ~/.gitignore ]] && alias vimgi='vim ~/.gitignore'

if [[ -d ~/.vim/plugged ]]; then
  alias vim3rdplug='cd ~/.vim/plugged'
  alias 3rdvim='vim3rdplug'
  function vimpluglink() {
    local opt='-s'
    if [[ $1 == '-f' ]] || [[ $1 == '--force' ]]; then
      opt='-sf'
      shift 1
    fi
    if [[ $1 =~ ^(-h|-{1,2}help)$ ]] || [[ $# -lt 1 ]]; then
      command cat <<EOF 1>&2
    $(basename "$0") [-f(--force)] <dirpath>...
EOF
      return 1
    fi

    for dirpath in "$@"; do
      local abspathdir=$(abspath_raw "$dirpath")
      local src_link_dirpath="$HOME/.vim/plugged/"
      local dst_link_dirpath="$abspathdir/$dir"
      echo "[log]" ln "$opt" "$dst_link_dirpath" "$src_link_dirpath"
      ln "$opt" "$dst_link_dirpath" "$src_link_dirpath"
    done
  }
  function vimplugunlink() {
    if [[ $1 =~ ^(-h|-{1,2}help)$ ]] || [[ $# -lt 1 ]]; then
      command cat <<EOF 1>&2
    $(basename "$0") <dirpath>...
EOF
      return 1
    fi
    for dirpath in "$@"; do
      unlink "$dirpath"
    done
  }
fi

[[ $(uname) == "Darwin" ]] && alias vim-files='pgrep -alf vim | grep "^[0-9]* [n]vim"'
[[ $(uname) == "Linux" ]] && alias vim-files='pgrep -al vim'

[[ -d ~/.vscode/extensions/ ]] && alias vscode-extensions='cd ~/.vscode/extensions/'

cmdcheck tig && alias t='tig'

alias mk='mkcd'
function mkcd() {
  if [[ $# -le 0 ]]; then
    echo "${RED} $0 [directory path]${DEFAULT}" 1>&2
    return 1
  fi
  local dirpath=$1
  if [[ -d $dirpath ]]; then
    echo "'$dirpath' already exists" 1>&2
    return 1
  fi
  mkdir -p "$dirpath" && cd "$_"
}

alias clear-by-ANSI='echo -n "\x1b[2J\x1b[1;1H"'
alias fix-terminal='stty sane; resize; reset'
alias clear-terminal=' fix-terminal'

alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias uuuu='cd ../../../..'
alias uuuuu='cd ../../../../..'
alias 1u='u'
alias 2u='uu'
alias 3u='uuu'
alias 4u='uuuu'
alias 5u='uuuuu'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias history='history 1'
function history_ranking() {
  builtin history -n 1 | grep -e "^[^#]" | awk '{ print $1 }' | LANG=C sort | uniq -c | LANG=C sort
}
alias h='history'
alias hgrep='h | grep'
alias envgrep='env | grep'

# 年号コマンド
alias era='echo H$(($(date +"%y") + 12)); echo R$(($(date +"%y") - 18))'

# for vim typo
alias q!='exit'
alias qq='exit'
alias :q='exit'
alias :q!='exit'
alias qqq='exit'
alias qqqq='exit'
alias quit='exit'

alias type='type -af'

function crontab() {
  [[ $@ =~ -[iel]*r ]] && echo "${RED}'r' NOT ALLOWED!${DEFAULT}" && return 1
  command crontab "$@"
}

################
####  Mac   ####
################
if [[ $(uname) == "Darwin" ]]; then
  alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
  alias sysinfo='system_profiler SPSoftwareDataType'
  alias js='osascript -l JavaScript'
  alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
  alias vmrun='/Applications/VMware Fusion.app/Contents/Library/vmrun'

  # FYI: [Set the Desktop Background for all of your open Spaces in Mountain Lion]( https://gist.github.com/willurd/5829224 )
  function set-background-image() {
    if [[ $# -lt 1 ]]; then
      echo "$(basename "$0") <image filepath>"
      return 1
    fi
    local image_filepath
    image_filepath="$1"
    if [[ ! -f "$image_filepath" ]]; then
      echo 1>&2 "not found: '$image_filepath'"
      return 1
    fi
    sqlite3 "$HOME/Library/Application Support/Dock/desktoppicture.db" "update data set value = '$image_filepath'" && killall Dock
  }

  # browser
  alias safari='open -a /Applications/Safari.app'
  alias firefox='open -a /Applications/Firefox.app'
  alias chrome='open -a /Applications/Google\ Chrome.app'

  # image
  #   alias imgshow='qlmanage -p "$@" >& /dev/null'
  alias imgsize="mdls -name kMDItemPixelWidth -name kMDItemPixelHeight"

  # [osx - Concisely starting Mac OS apps from the command line - Ask Different](http://apple.stackexchange.com/questions/4240/concisely-starting-mac-os-apps-from-the-command-line)
  # alias skim='open -a Skim'

  # brew
  alias cellar='cd /usr/local/Cellar'

  # base64
  alias b64e='base64'
  alias b64d='base64 -D'
  # [UTF-8-MACをUTF-8に変換する - Qiita]( http://qiita.com/youcune/items/badaec55af6bbae9aca8 )
  alias mactext='p | nkf -w --ic=utf8-mac | c'
  # [MacOSXでstraceが欲しいけどdtrace意味わからん→dtruss使おう]( https://qiita.com/hnw/items/269f8eb44614556bd6bf )
  alias strace='sudo dtruss -f sudo -u $(id -u -n)'

  # FYI: [macos \- Command\-line alias for Visual Studio Code on OS X with CSH? \- Stack Overflow]( https://stackoverflow.com/questions/31178895/command-line-alias-for-visual-studio-code-on-os-x-with-csh )
  function vscode() {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
  }

  function open() {
    # -n: for avoiding below message
    # The application cannot be opened for an unexpected reason, error=Error Domain=NSOSStatusErrorDomain Code=-600 "procNotFound: no eligible process with specified descriptor" UserInfo={_LSLine=379, _LSFunction=_LSAnnotateAndSendAppleEventWithOptions}
    command open -n "$@"
  }
fi

function vscode_ext_search() {
  local search_word=${1:-}
  open "https://marketplace.visualstudio.com/search?term=${search_word}&target=VSCode"
}

if cmdcheck mvim; then
  alias gvim='mvim'
  alias mvim='mvim --remote-tab-silent'
  function mvim() {
    [[ $# == 1 ]] && [[ $1 == "--remote-tab-silent" ]] && $(command which mvim) && return $?
    $(command which mvim) $@
  }
fi

################
#### Ubuntu ####
################
if [[ $(uname) == "Linux" ]]; then
  if cmdcheck xclip; then
    alias pbcopy='xclip -sel clip'
    alias pbpaste='xclip -o -sel clip'
  elif cmdcheck xsel; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
  function open() {
    for arg in "$@"; do
      xdg-open &>/dev/null "$arg"
    done
  }

  # start clipboard daemon
  if ! pgrep -f clipboard-daemon >/dev/null; then
    nohup bash -c "exec -a clipboard-daemon bash -c 'while true; do { nc -d -l 5556 || sleep 1; } | xclip -sel clip; done'" >/dev/null 2>&1 &
  fi

  alias apt-upgrade='sudo apt-get upgrade'
  alias apt-update='sudo apt-get update'
  alias apt-install='sudo apt-get install'
  alias apt-search='apt-cache search'
  alias apt-show='apt-cache show'
  # [How can I get a list of all repositories and PPAs from the command line into an install script? \- Ask Ubuntu]( https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an )
  alias add-apt-repository-list="grep -r --include '*.list' '^deb ' /etc/apt/ | sed -re 's/^\/etc\/apt\/sources\.list((\.d\/)?|(:)?)//' -e 's/(.*\.list):/\[\1\] /' -e 's/deb http:\/\/ppa.launchpad.net\/(.*?)\/ubuntu .*/ppa:\1/'"
  alias dpkg-list='sudo dpkg -l'
  function dpkg-executable-list() {
    [[ $# == 0 ]] && echo '<package name>' && return 1
    dpkg -L $1 | executable_filter
  }

  function xdotool-infos() {
    [[ $# == 0 ]] && echo "$0 <class>" && return 1
    xdotool search --class "$1" | xargs -L 1 sh -c 'printf "# $0"; xwininfo -id $0'
  }

  alias os_ver='cat /etc/os-release | grep VERSION_ID | grep -o "[0-9.]*"'

  # [How can I get a list of all repositories and PPAs from the command line into an install script? \- Ask Ubuntu]( https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an )
  function ppa-list() {
    # listppa Script to get all the PPA installed on a system ready to share for reininstall
    for APT in $(find /etc/apt/ -name \*.list); do
      grep -o "^deb http://ppa.launchpad.net/[a-z0-9\-]\+/[a-z0-9\-]\+" $APT | while read ENTRY; do
        USER=$(echo $ENTRY | cut -d/ -f4)
        PPA=$(echo $ENTRY | cut -d/ -f5)
        echo sudo apt-add-repository ppa:$USER/$PPA
      done
    done
  }
  if cmdcheck baobab; then
    function baobab() {
      if [[ $# == 0 ]]; then
        nohup baobab &>$(echo $(mktemp) | tee $(tty)) &
        return 1
      fi
      command baobab "$@"
    }
  fi
  alias vscode='code'

  function chrome-exec-check() {
    if [[ ! -f /usr/share/applications/google-chrome.desktop.bk ]]; then
      sudo cp /usr/share/applications/google-chrome.desktop /usr/share/applications/google-chrome.desktop.bk
    fi
    diff /usr/share/applications/google-chrome.desktop.bk /usr/share/applications/google-chrome.desktop
  }
  function chrome-exec-set() {
    local chrome_arg

    chrome_arg="$*"

    if [[ ! -f /usr/share/applications/google-chrome.desktop.bk ]]; then
      sudo cp /usr/share/applications/google-chrome.desktop /usr/share/applications/google-chrome.desktop.bk
    fi

    # NOTE: use environmen variable to avoid 'Unrecognized switch: --proxy-server=xxx  (-h will show valid options).'
    cat /usr/share/applications/google-chrome.desktop.bk | CHROME_ARG="$chrome_arg" perl -ne "$(
      cat <<'EOF'
BEGIN {
  $Exec_arg=$ENV{CHROME_ARG};
  $Exec_U='^Exec=/usr/bin/google-chrome-stable.*%U$';
  $Exec_incognito='^Exec=/usr/bin/google-chrome-stable.*--incognito$';
  $Exec='^Exec=/usr/bin/google-chrome-stable.*$';
}

if ($_ =~ /${Exec_U}/) {
  printf "%s %s %s\n",'Exec=/usr/bin/google-chrome-stable',$Exec_arg,'%U';
} elsif ($_ =~ /${Exec_incognito}/) {
  printf "%s %s %s\n",'Exec=/usr/bin/google-chrome-stable',$Exec_arg,'--incognito';
} elsif ($_ =~ /${Exec}/) {
  printf "%s %s %s\n",'Exec=/usr/bin/google-chrome-stable',$Exec_arg,'';
} else{
  printf "%s",$_;
}
EOF
    )" | sudo tee /usr/share/applications/google-chrome.desktop

    diff /usr/share/applications/google-chrome.desktop.bk /usr/share/applications/google-chrome.desktop
  }

fi
alias vs='code'

# NOTE: 従来は入力全般を停止させていたが，readで1行でも読み込めた場合にコマンドを実行する仕様に変更
# macのみsudo対応
function pipe-EOF-do() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
  $(basename "$0") 'any commands'
  e.g. $(basename "$0") vim -
EOF
    return 1
  fi
  # NOTE: mac ok
  # NOTE: ubuntu cannot deal with sudo before pipe
  # NOTE: たまに，suspended (tty output)と表示され，バックグランド実行となる(at mac)
  if [[ -p /dev/stdin ]]; then
    IFS= read -r LINE
    {
      [[ -n $LINE ]] && printf '%s\n' "$LINE"
      command cat
    } | $@
  else
    $@
  fi
}

# NOTE: use this command to wait sudo password input
function sudowait() {
  if sudoenable; then
    command cat | ${@}
  else
    # failed to run sudo
  fi
}

alias kaiba='echo "ヽ(*ﾟдﾟ)ノ"'
alias gopher='echo "ʕ ◔ ϖ ◔ ʔ"'

# window path -> unix path
alias w2upath='sed "s:\\\:/:g"'
alias w2p='p|w2upath|p2c'

function u2wpath() {
  local DRIVE="${1:-C:}"
  sed 's/\//\\/g' | sed "s/^/$DRIVE/g"
}

alias relogin='exec ${SHELL:-$0} -l'
alias clean-login-zsh='ZDOTDIR= zsh -l'
alias clean-login-bash='bash --rcfile <(:)'

alias trimspace='sed "s/^[ \t]*//"'

alias filter-exist-line="awk '/.+/{print "'$0'"}'"

# NOTE: 普通に出力するとゴミデータ?が混じっている
function mancat() {
  # MANPAGER="sed \"s/.$(echo \"\\x08\")//g\"" man "$@"
  MANPAGER="col -b -x" man "$@"
}

alias ascii='man ascii'

function _filter_test() {
  [[ $# -lt 1 ]] && echo "$(basename $0) [test flag]" && return 1
  local test_flag=$1
  while read line; do
    test $test_flag $line && echo $line
  done
}
# e.g. ls | filter_executable
function filter_executable() { _filter_test '-x'; }
function filter_readable() { _filter_test '-r'; }
function filter_writable() { _filter_test '-w'; }

if cmdcheck pandoc; then
  function html2md-pandoc() {
    [[ $# == 0 ]] && echo "$0 <input file> [<output file>]" && return 1
    local input=$1
    local output=${2:-${input%.*}.html}
    pandoc -s "$input" -t html5 -c github.css -o "$output"
  }
fi

#       sudo ansi-color
# fzf:  NG   OK(char unit)
# peco: OK   NG
# fzy:  OK   Input OK(not char unit), Output NG

alias view='vim -R'
function pipevim() {
  if [[ $# == 0 ]]; then
    vim -
    return
  elif [[ $# == 1 ]]; then
    local filepath=$1
    command cat >"$filepath"
    vim "$filepath"
    return
  else
    cat
    echo 1>&2 "${RED}pipevim [filename]${DEFAULT}"
    return 1
  fi
}

if [[ "$(uname -a)" =~ Ubuntu ]] && [[ $(lsb_release -r -s) == "18.04" ]]; then
  # NOTE: for avoiding 'suspended (tty output)'
  alias xargs-vim='_xargs-vim -| cat'
else
  alias xargs-vim='_xargs-vim -'
fi

# NOTE: VIMINFO_LS_N: number of max hit
function viminfo-ls() {
  command cat ~/.vim_edit_log | grep -v '^$' | awk '!a[$0]++' \
    | {
      if [[ -z $VIMINFO_LS_N ]]; then
        cat
      else
        tail -n "$VIMINFO_LS_N"
      fi
    } | tac
}
alias viminfo-ls-edit='vim ~/.vim_edit_log'

function clean-vim-undofile() {
  find ~/.vim/tmp -maxdepth 1 -type f -size +1M -ls -delete
}

[[ -f ~/dotfiles/.min.plug.vimrc ]] && alias vimplugtest='vim -u ~/dotfiles/.min.plug.vimrc'

alias xargs1='xargs -L 1'

alias ls-non-dotfiles="find . -name '*' -maxdepth 1 | sed 's:^\./::g' | grep -E -v '\..*'"

function _sed_check_test() {
  echo '# "alias" in function (alias is extracted at defined)'
  sed --version
  echo '# "alias" in $() in function (alias is extracted at running)'
  echo $(sed --version)
}

# NOTE: for md('> ', '* ')
function prefix() { while read n; do echo "${@}${n}"; done; }
function suffix() { while read n; do echo "${n}${@}"; done; }
# NOTE: wrap stdin each line
function sand() {
  [[ $# -gt 2 ]] && echo "$0 text [suffix_text]" && return
  local B=${1:-\"}
  local E
  [[ $B == \( ]] && local E=")"
  [[ $B == \[ ]] && local E="]"
  [[ $B == \< ]] && local E=">"
  [[ $B == \{ ]] && local E="}"
  [[ $B == \" ]] && local B=\\\"
  local E=${E:-${2:-$B}}
  [[ $B == "\\" ]] && local B="\\\\"
  [[ $E == \" ]] && local E=\\\"
  [[ $E == "\\" ]] && local E="\\\\"
  awk '{printf "'$B'%s'$E'\n", $0}'
}

# awk
# n~m列のみを表示(省略時には先頭または最後となる)
function cut2() {
  [[ $# == 0 ]] && echo "cut2 [START_FIELD_INDEX] (END_FIELD_INDEX)" && return 1
  local START=${1:-1}
  local END=${2:-NF}
  awk '{for(i='"$START"';i<='"$END"';i++){printf("%s", $i);if(i<'"$END"')printf(" ");} print ""}'
}
exportf cut2

function ping-web() {
  [[ $# -le 1 ]] && echo "$0 <url>" && exit 1
  local url="$1"
  while true; do
    status=$(curl -sL --head -m 3 -w "%{http_code}" "$url" -o /dev/null)
    if [ $status = 200 ]; then
      printf '.'
    else
      printf 'F'
    fi
    sleep 0.5
  done
}

# for python(3.3~) venv activation
cmdcheck python && alias activate='source bin/activate' # <-> deactivate
cmdcheck ninja && alias ncn='ninja -t clean && ninja'

cmdcheck ipython && function python() {
  if [[ $# == 0 ]]; then
    ipython
  elif type >/dev/null 2>&1 python3; then
    command python3 "$@"
  elif type >/dev/null 2>&1 python; then
    command python "$@"
  elif type >/dev/null 2>&1 python2; then
    command python2 "$@"
  else
    echo 1>&2 'There is no python command in this environment!'
  fi
}

if cmdcheck conda; then
  function conda() {
    local conda_root=$(dirname $(dirname $(which -p conda)))

    __conda_setup="$(command conda 'shell.zsh' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    else
      if [ -f "$conda_root/etc/profile.d/conda.sh" ]; then
        . "$conda_root/etc/profile.d/conda.sh"
      else
        export PATH="$conda_root/bin:$PATH"
      fi
    fi
    unset __conda_setup

    # NOTE: upper script overwrite conda function, so below conda is not this function
    if [[ -n "$CONDA_SHLVL" ]] && [[ "$CONDA_SHLVL" != 0 ]]; then
      conda "$@"
    fi
  }
fi

# rtags daemon start
cmdcheck rdm && alias rdmd='pgrep rdm || rdm --daemon'

# NOTE: to avoid xargs no args error on ubuntu
# [xargs で標準入力が空だったら何もしない \- Qiita]( https://qiita.com/m_doi/items/432b9145b69a0ba3132d )
# --no-run-if-empty: macでは使用不可
function pipecheck() {
  local val="$(cat)"
  [[ -z $val ]] && return 1
  printf '%s\n' "$val" | $@
}

# n秒後に通知する
function timer() { echo "required:terminal-notifier"; }
cmdcheck terminal-notifier && function timer() {
  [[ $# -le 1 ]] && echo "$0 [sleep-second] [message]" && return 1
  sleep $1 && terminal-notifier -sound Basso -message $2
}

# below command are accepted
# got github.com/BurntSushi/toml
# got https://github.com/BurntSushi/toml
# got go get https://github.com/BurntSushi/toml
cmdcheck 'go' && function got() {
  [[ $1 == go ]] && shift
  [[ $1 == get ]] && shift
  local args=()
  for arg in ${@}; do
    local arg=${arg#https://}
    local arg=${arg%.git}
    args+=$arg
  done
  go get ${args}
}

cmdcheck vim && alias vi='vim'
cmdcheck nvim && alias vterminal="command nvim -c terminal -c \"call feedkeys('i','n')\""
cmdcheck nvim && alias vt='vterminal'

function vim() {
  local vim_cmd=(command vim)
  cmdcheck nvim && vim_cmd=(nvim)
  local args=("$@")
  if [[ $# -ge 1 ]] && [[ $1 =~ :[0-9]+ ]]; then
    local file_path="${1%%:*}"
    local line_no=$(printf '%s' "$1" | cut -d":" -f2)
    # "" => 0
    line_no=$((line_no))
    shift
    # -c: do command
    args=("-c" "$line_no" "$file_path" "$@")
  fi
  "${vim_cmd[@]}" "${args[@]}"
  local exit_code=$?
  return $exit_code
}
function _xargs-vim() {
  if [[ $1 == - ]]; then
    shift
    local files=()
    cat | while IFS= read -r file_path || [[ -n "$file_path" ]]; do
      files=("${files[@]}" "$file_path")
      # NOTE: open each file
      # vim "$file_path" $@ </dev/tty >/dev/tty
    done
    if [[ -n "$VSCODE_REMOTE" ]]; then
      code --goto "${files[@]}" $@
    else
      # NOTE: my vim setting (buffers -> tab)
      [[ ${#files[@]} -gt 0 ]] && vim "${files[@]}" $@ </dev/tty >/dev/tty
    fi
    return
  fi
  if [[ -n "$VSCODE_REMOTE" ]]; then
    code --goto $@
  else
    vim $@
  fi
}
cmdcheck nvim && cmdcheck vimdiff && alias vimdiff='nvim -d '

alias minvi='vim -u ~/dotfiles/.minimal.vimrc'
alias minvim='vim -u ~/dotfiles/.minimal.vimrc'
alias minivi='vim -u ~/dotfiles/.minimal.vimrc'
alias minivim='vim -u ~/dotfiles/.minimal.vimrc'

alias dotfiles='cd ~/dotfiles'
alias plugged='cd ~/.vim/plugged'

alias v='vim'
# don't use .viminfo file option
# alias tvim='vim -c "set viminfo="'
alias novim='vim -i NONE'
alias fastvim='VIM_FAST_MODE=on vim'
alias virc='vim ~/.vimrc'
alias vimrc='vim ~/.vimrc'
alias viminfo='vim ~/.viminfo'
alias vimpluginstall="VIM_FAST_MODE='off' vim -c ':PlugInstall' ''"
alias vimplugupdate="VIM_FAST_MODE='off' vim -c ':PlugUpdate' ''"
alias vimplugupgrade="VIM_FAST_MODE='off' vim -c ':PlugUpgrade' ''"
alias vimpi="vim -c ':PlugInstall' ''"
alias vimpud="vim -c ':PlugUpdate' ''"
alias vimpug="vim -c ':PlugUpgrade' ''"

alias vimrenamer="vim -c ':Renamer' ''"

alias vimr='vim README.md'
alias vimre='vim README.md'
alias vimR='vim README.md'
alias vimRe='vim README.md'

function tabvim() {
  if [[ -p /dev/stdin ]]; then
    local filepath_list=($(cat))
    vim -p "${filepath_list[@]}"
    return
  fi
  vim -p "$@"
}

[[ ! -d ~/.tmp/ ]] && mkdir -p ~/.tmp/
function tmpvim() {
  local filename=${1:-$(date +%s)}
  vim ~/.tmp/$filename
}

# for zsh
alias zshrc='vim ~/.zshrc'
alias lzshrc='vim ~/.local.zshrc'
alias zshenv='vim ~/.zshenv'
alias lzshenv='vim ~/.local.zshenv'
alias vizrc='vim ~/.zshrc'
alias vimzrc='vim ~/.zshrc'
alias vizp='vim ~/.zprofile'
alias vimzp='vim ~/.zprofile'
alias zp='vim ~/.zprofile'
alias zrc='vim ~/.zshrc'
alias lzp='[[ -f ~/.local.zprofile ]] && vim ~/.local.zprofile'
alias lzrc='[[ -f ~/.local.zshrc ]] && vim ~/.local.zshrc'
alias lvrc='[[ -f .local.vimrc ]] && vim .local.vimrc || [[ -f ~/.local.vimrc ]] && vim ~/.local.vimrc'

alias autofix='autofixvim'
alias autofixvim='vim ~/.config/auto_fix/fix.yaml'

alias vimemo='vim README.md'
alias vmemo='vim README.md'

alias allow='direnv allow'

alias envrc='vim .envrc'

# move to tmp directory by date
function tmpd() {
  local dir="$HOME/tmp/$(date +'%Y/%m%d')"
  mkdir -p "$dir"
  cd "$dir"
}

# for ssh
alias vissh='vim ~/.ssh/config'
alias vimssh='vim ~/.ssh/config'
alias sshconfig='vim ~/.ssh/config'

# FYI: there is similar command `ssh-copy-id`
function ssh-register_id_rsa.pub() {
  [[ $# -le 1 ]] && echo "$0 <id_rsa.pub filepath> <ssh host name>" && return 1
  local id_rsa_pub_filepath="$1"
  local ssh_host_name="$2"
  cat "$id_rsa_pub_filepath" | ssh "$ssh_host_name" 'mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && cat >> ~/.ssh/authorized_keys'
}

alias path='echo -e ${PATH//:/\\n}'
# NOTE: for c,cpp
alias cpath='echo -e ${CPATH//:/\\n}'
# NOTE: zsh var
alias fpath='tr " " "\n" <<<$fpath'

# 指定したディレクトリに存在する実行可能なファイルを列挙する
function cmds() {
  [[ $# -ne 1 ]] && echo "# Usage: $0 \"dir path\"" && return 1
  # 再帰なし
  # -type f とするとシンボリックリンクのファイルを無視してしまうので-followを付加
  find $1 -maxdepth 1 -type f -follow -perm -=+x
}
alias lscmds='allcmds'
function pathcmds() {
  for name in $(echo $PATH | sed "s/:/\n/g"); do
    find $name -maxdepth 1 -type f -follow -perm -=+x 2>/dev/null
  done
}
function allcmds() {
  pathcmds
  alias
}

# create markdown table body (not including header)
# e.g. paste <(seq 1 10) <(seq 11 20) | mdt "\t"
# $1: delimiter
cmdcheck mdt || function mdt() {
  local delim=${1:-" "}
  sed 's/'"$delim"'/\|/g' | awk '{print "|"$0"|"}'
}

# NOTE: for line message app(drop time and username)
alias line-sed='sed -E "s/^[0-9]+:[0-9]+ \\w+ \\w+ //g"'

alias pwd='pwd | homedir_normalization'

function abspath_raw() {
  perl -MCwd -le 'for (@ARGV) { if ($p = Cwd::abs_path $_) { print $p; } }' "$@"
}
function abspath() {
  abspath_raw $(printf '%s' "$1" | expand_home) | homedir_normalization
}

# accept command starts with `$` (but `$` is invalid alias name at bash)
[[ $ZSH_NAME == zsh ]] && alias \$=''
# ignore command which starts with `#`
# but bellow alias disable comment at interactive shell
# alias \#=':'
setopt interactivecomments

# brew install source-highlight
cmdcheck src-hilite-lesspipe.sh && alias hless="src-hilite-lesspipe.sh"
# at ubuntu
[[ -f "/usr/share/source-highlight/src-hilite-lesspipe.sh" ]] && alias hless="/usr/share/source-highlight/src-hilite-lesspipe.sh"

cmdcheck delta && function diff() {
  if [[ -f /dev/stdout ]] || [[ -p /dev/stdout ]]; then
    # redirect or pipe
    command diff "$@"
  else
    command diff -u "$@" | delta
  fi
}
alias git-icdiff='git difftool --extcmd icdiff -y | less'

# install command: `brew install ccat` or `go get github.com/jingweno/ccat`
if cmdcheck ccat; then
  alias cat='ccat'
  alias catless='local _ccat(){cat --color=always "$@" | command cat -n | less} && _ccat'
else
  if cmdcheck pygmentize; then
    alias ccat='pygmentize -g -O style=colorful,linenos=1'
    alias catless='local _ccat(){cat "$@" | less} && _ccat'
  fi
fi
# brew install bat or access [sharkdp/bat: A cat\(1\) clone with wings\.]( https://github.com/sharkdp/bat )
if cmdcheck bat; then
  alias cat='bat --style=plain --paging=never'
  # NOTE: you can use with grep e.g. git diff | grep include | diffbat
  alias diffbat='bat -l diff'
  alias vimbat='bat -l vim'
  alias cppbat='bat -l cpp'
  alias markdownbat='bat -l markdown'
  alias mdbat='markdownbat'

  # NOTE: decolate bash -x output
  # NOTE: * colorbash required bat more than v0.7.0 (0.9.0 ok)
  function colorbash() {
    [[ $# -le 0 ]] && echo "$0 [target bash file]" && return 1
    bash -x "$@" |& awk '/^\+/{match($0, /^\++/); s=""; for(i=0;i<RLENGTH;i++) s=s"\\+"; printf "%s%s\n", s, substr($0, RLENGTH+1, length($0)-RLENGTH)} !/^\+/{print $0} {fflush()}' | bat -l bash --paging=never --plain --unbuffered
    local exit_code=${PIPESTATUS[0]:-$pipestatus[$((0 + 1))]}
    return $exit_code
  }
fi
# original cat
alias ocat='command cat'

function stepbash() {
  [[ $# -le 0 ]] && echo "$0 [target bash file]" && return 1
  local filepath
  filepath="$1"
  bash <(cat $filepath | sed '2itrap '"'"'echo -ne "\\033[90m[DEBUG]:\\033[35m$BASH_SOURCE:$LINENO:$BASH_COMMAND\\033[00m"; read -p " "'"'"' DEBUG')
}
# NOTE: if shebang is '#!/usr/bin/env bash', we can hook bash recursively
function stepbash-recursive() {
  local tmpdir
  tmpdir=$(mktemp -d)
  local bash_bin_path
  bash_bin_path=$(which bash | head -n 1)
  local SED='sed'
  cmdcheck gsed && SED='gsed'
  # NOTE: heuristic input filepath detection
  cat <<EOF >"$tmpdir/bash"
#!$bash_bin_path
echo "[DEBUG PRE]\$@"
for arg; do
  shift
  if [[ -f "\$arg" ]]; then
    filepath="\$arg"
    continue
  fi
  set -- "\$@" "\$arg"
done
echo "[DEBUG POST]\$@"

if [[ -z \$filepath ]]; then
  $bash_bin_path "\$@"
else
  $bash_bin_path <(cat "\$filepath" | gsed '2itrap '"'"'echo -ne "\\\\033[90m[DEBUG]:\\\\033[35m'"\$filepath"':\$LINENO:\$BASH_COMMAND\\\\033[00m"; read -p " "'"'"' DEBUG') "\$@"
fi
EOF
  chmod u+x "$tmpdir/bash"
  # NOTE: debug only
  # echo "$tmpdir/bash"
  # cat "$tmpdir/bash"
  (
    export PATH="$tmpdir:$PATH"
    bash "$@"
  )
}

# for mac
cmdcheck gsed && alias sed='gsed'
# -s: suppress 'Is a directory'
alias grep='grep -s --color=auto'
cmdcheck ggrep && alias grep='ggrep -s --color=auto'
# brew install coreutils
cmdcheck gtimeout && alias timeout='gtimeout'

# mac: brew install translate-shell
# [LinuxのCUIを使ってgoogle翻訳を実行する - Qiita]( http://qiita.com/YuiM/items/1287286386b8efd58147 )
cmdcheck trans && cmdcheck rlwrap && alias trans='rlwrap trans'
cmdcheck trans && cmdcheck rlwrap && alias transja='rlwrap trans :ja'
cmdcheck rlwrap && alias bc='rlwrap bc'

# html整形コマンド
## [XMLを整形(tidy)して読みやすく、貼りつけやすくする。 - それマグで！](http://takuya-1st.hatenablog.jp/entry/20120229/1330519953)
alias fixhtml='tidy -q -i -utf8'
alias urldecode='nkf -w --url-input'
# [シェルスクリプトでシンプルにurlエンコードする話 \- Qiita]( https://qiita.com/ik-fib/items/cc983ca34600c2d633d5 )
# alias urlencode="nkf -WwMQ | tr '=' '%'"
function urlencode() {
  for arg in "$@"; do
    printf '%s\n' "$arg" | nkf -WwMQ | sed 's/=$//g' | tr '=' '%'
  done
}
function htmldecode() {
  php -r 'while(($line=fgets(STDIN)) !== FALSE) echo html_entity_decode($line, ENT_QUOTES|ENT_HTML401);'
}
function htmlencode() {
  php -r 'while(($line=fgets(STDIN)) !== FALSE) echo htmlspecialchars($line);'
}
# alias htmlencode="perl -MHTML::Entities -pe 'encode_entities($_);'"
# alias htmlencode="perl -MHTML::Entities -pe 'encode_entities($_);'"

# 改行削除
# alias one="tr -d '\r' | tr -d '\n'"
alias one="awk '{if (NR>1){printf \" \"; }; printf \"%s\", \$0}'"
# クリップボードの改行削除
alias poc="p | one | p2c"

if cmdcheck nkf; then
  alias udec='nkf -w --url-input'
  alias uenc='nkf -WwMQ | tr = %'
  alias overwrite-utf8='nkf -w --overwrite'
fi

if $(cmdcheck pbcopy && cmdcheck pbpaste); then
  alias _c='pbcopy'
  if cmdcheck nkf; then
    # NOTE: need nkf -w ?
    alias _p='pbpaste'
  else
    alias _p='pbpaste'
  fi
  # 改行コードなし
  # o: one
  alias oc="tr -d '\n' | c"
  alias op="p | tr -d '\n'"
fi

function paste_to_file() {
  local ret=$(p)
  printf "filename: "
  read filename
  [[ -z $filename ]] && return
  printf "%s" $ret >$filename
}
# [printf %q "$v"]( https://qiita.com/kawaz/items/f8d68f11d31aa3ea3d1c )
function shell_string_escape() {
  printf %q "$(cat)"
}
# NOTE: drop clipboard rich text info
alias cliplain='p | p2c'

# for mac ssh connection
if [[ -z $DISPLAY ]] && [[ $LC_TERMINAL == "iTerm2" ]]; then
  export DISPLAY=':0'
fi
if [[ -z $DISPLAY ]]; then
  function c() {
    mkdir -p ~/tmp
    local VIM="vim"
    cmdcheck nvim && VIM="nvim"
    tee ~/tmp/clipboard | $VIM -u NONE -c 'let @"=join(getline(1, "$"), "\n")' -c 'q!'
  }
  function p() {
    mkdir -p ~/tmp
    touch ~/tmp/clipboard
    local VIM="vim"
    cmdcheck nvim && VIM="nvim"
    $VIM -u NONE -c 'call system("tee ~/tmp/clipboard", @")' -c 'q!'
    command cat ~/tmp/clipboard
  }
else
  function c() {
    if [[ $# == 0 ]]; then
      _c
    else
      command cat $1 | _c
    fi
  }
  function p() {
    _p
  }
fi
# NOTE: for p | sed xxx | c
function p2c() {
  local tmp=$(command cat)
  printf '%s' "$tmp" | c
}
# NOTE: alias p -> function p
alias "p" >/dev/null 2>&1 && unalias "p"

function remove_clipboard_format() {
  local tmpfile=$(mktemp "/tmp/$(basename $0).$$.tmp.XXXXX")
  p >"$tmpfile" && command cat "$tmpfile" | c
  [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
}

function remove_terminal_extra_string() {
  # NOTE: required input is without ansi color
  sed 's/^.* ❯❯❯/$/g' | sed -E 's/ {16}.*(✱|◼|⬆|⬇|✭|✚ )+$//g'
}
function remove_terminal_extra_string_from_clipboard() {
  p | remove_terminal_extra_string | p2c
}

# e.g. get_cursor_pos | read -r cols rows
function get_cursor_pos() {
  echo -ne "\033[6n" >/dev/tty
  read -t 1 -s -d 'R' line </dev/tty
  local rows="${line##*\[}"
  local rows="${rows%;*}"
  local cols="${line##*;}"
  echo "$rows" "$cols"
}

function set-dirname-title() {
  local title=$(echo $PWD | sed -E "s:^.+/::g")
  echo -en '\e]0;'"$title"'\a'
}
# event based function which called at cd (maybe run by subshell)
function chpwd() {
  if type >/dev/null 2>&1 tmux; then
    tmux set automatic-rename on
  fi

  ls_abbrev
  printf '%s\n' "$PWD" >>"$HOME/.cdinfo"
  set-dirname-title

  # NOTE: auto python venv activate and deactivate
  function lambda() {
    local python_venv_activator='bin/activate'
    local dirpath=$PWD && while true; do
      if [[ -f "$dirpath/$python_venv_activator" ]]; then
        [[ -z "$VIRTUAL_ENV" ]] && source "$dirpath/$python_venv_activator"
        return
      fi
      [[ "$dirpath" == "/" ]] && break || local dirpath="$(dirname $dirpath)"
    done
    [[ -n "$VIRTUAL_ENV" ]] && deactivate
  } && lambda

  # disable ros auto setting
  # NOTE: auto ros devel/setup.zsh runner
  # function lambda() {
  # for dir in $(traverse_path_list $PWD); do
  # local setup_zsh_filepath="$dir/devel/setup.zsh"
  # [[ -f $setup_zsh_filepath ]] && source "$setup_zsh_filepath"
  # done
  # } && lambda

  # if [[ -z "$ROS_VERSION" ]] && type >/dev/null 2>&1 rosroot; then
  # local ros_ws_root=$(rosroot)
  # [[ -d $ros_ws_root ]] && [[ -e /opt/ros/kinetic/setup.zsh ]] && echo '[ros setup script loaded]load' && source /opt/ros/kinetic/setup.zsh
  # fi
}

function cdninja() {
  for dir in $(traverse_path_list $PWD); do
    local build_ninja_filepath="$dir/build.ninja"
    [[ -f $build_ninja_filepath ]] && cd "$dir"
  done
}

function cdinfo() {
  tac ~/.cdinfo | awk '!a[$0]++' \
    | {
      if [[ -z $CDINFO_N ]]; then
        cat
      else
        head -n "$CDINFO_N"
      fi
    }
}
alias cdinfo-clean='clean-cdinfo'
cmdcheck tac && function clean-cdinfo() {
  local tmpfile=$(mktemp)
  local cdinfo_filepath="$HOME/.cdinfo"
  command cp "$cdinfo_filepath" "$tmpfile"
  tac "$tmpfile" | awk '!a[$0]++' | awk '{print $0; fflush();}' | while IFS= read -r LINE; do
    [[ -d "$LINE" ]] && printf '%s\n' "$LINE"
  done | tac | tee "$cdinfo_filepath"
  rm -f "$tmpfile"
}

alias memo='touch README.md'
alias tmp='cd ~/tmp/'

function cat-all() {
  [[ $# == 0 ]] && echo "$0 <files...>" && return
  for filepath in "$@"; do
    echo "$YELLOW"
    echo "####################"
    echo "# $(basename $filepath)"
    echo "####################"
    echo "$DEFAULT"
    cat $filepath
  done
}

alias ctest='safe-colorize ctest'
function cmake() {
  if [[ ! $(basename $(dirname $PWD/.)) =~ build ]]; then
    echo 1>&2 "${RED}[WARN]: current directory doesn't include 'build'${DEFAULT}"
    return 1
  fi

  local exit_code
  if [[ ! -t 1 ]] || [[ ! -t 2 ]]; then
    command cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 "$@"
    exit_code=$?
  else
    {
      # NOTE: maybe ccze wait output for parse
      safe-colorize --force command cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 "$@"
    } |& auto_save_log cmake
    exit_code=${PIPESTATUS[0]:-$pipestatus[$((0 + 1))]}
  fi
  # FYI: [NeovimでC/C\+\+のIDE\(っぽい\)環境を構築する \- Qiita]( https://qiita.com/arwtyxouymz0110/items/b09ef1ed7a2f7bf1c5e6 )
  # update compile_commands.json information
  if cmdcheck compdb && [[ -f compile_commands.json ]]; then
    compdb list 1>../compile_commands.json 2>../.compdb_stderr.log
    if [[ -s "../.compdb_stderr.log" ]]; then
      echo "${RED}"'[compdb log] WARNING or ERROR: see "'$PWD'/../.compdb_stderr.log"'"${DEFAULT}"
    fi
    [[ -f ~/.config/clangd/compile_flags.txt ]] && command cp -f ~/.config/clangd/compile_flags.txt ../
  fi
  return $exit_code
}

function auto_save_log() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
  $(basename "$0") <name>
EOF
    return 1
  fi
  local name
  name="$1"

  local ansi_tmpfile
  local raw_tmpfile

  local uuid="$(uuidgen)"
  ansi_tmpfile="$(mktemp "/tmp/$name.$(date +'%Y-%m-%d-%H-%M-%S').${uuid}.XXXXX.$(pwd | sed 's:/:_:g').ansi.log")"
  raw_tmpfile="$(mktemp "/tmp/$name.$(date +'%Y-%m-%d-%H-%M-%S').${uuid}.XXXXX.$(pwd | sed 's:/:_:g').raw.log")"
  eval "export ${name}_ANSI_LOGPATH="$ansi_tmpfile""
  eval "export ${name}_RAW_LOGPATH="$raw_tmpfile""

  tee "$ansi_tmpfile" | tee >(remove-ansi >"$raw_tmpfile")

  echo 1>&2 "${YELLOW}[LOG] ${name} ansi log is saved at \$${name}_ANSI_LOGPATH='$ansi_tmpfile'${DEFAULT}"
  echo 1>&2 "${YELLOW}[LOG] ${name}  raw log is saved at  \$${name}_RAW_LOGPATH='$raw_tmpfile'${DEFAULT}"
}

function make() {
  if [[ ! -t 1 ]] || [[ ! -t 2 ]]; then
    command make "$@"
    return
  fi

  {
    if cmdcheck colormake; then
      {
        colormake "$@"
      } |& {
        if cmdcheck ccze; then
          ccze -A
        else
          command cat
        fi
      }
      return ${PIPESTATUS[0]:-$pipestatus[$((0 + 1))]}
    else
      safe-colorize --force command make "$@"
      return
    fi
  } |& auto_save_log make
  exit_code=${PIPESTATUS[0]:-$pipestatus[$((0 + 1))]}
  # print hint for error log
  if [[ $exit_code != 0 ]]; then
    cat $make_ANSI_LOGPATH | grep -n -C 8 '\*\*\*'
  fi
  return "$exit_code"
}

# swap file
function swap() {
  [[ $# != 2 ]] && echo "Usage: swap <file1> <file2>" && return 1
  local b1=$(basename $1)
  local tmpdir=$(mktemp -d)
  local _l="mv $1 $tmpdir"
  [[ $? != 0 ]] && echo "err:$_l" && return 1
  mv "$1" "$tmpdir"

  local _l="mv $2 $1"
  mv "$2" "$1"
  [[ $? != 0 ]] && echo "err:$_l" && return 1

  local _l="mv $tmpdir/$1 $2"
  mv "$tmpdir/$b1" "$2"
  [[ $? != 0 ]] && echo "err:$_l" && return 1
}

alias cl='clear'

alias cmake-touch='touch CMakeLists.txt'

# webcat
function _webcat() {
  # go get -u github.com/umaumax/gonetcat
  gonetcat localhost $WEBCAT_PORT
}
function webcat() {
  # go get -u github.com/umaumax/gocat
  # screen clear and clear font
  gocat -prefix='\x1b[2J\x1b[1;1H\033[0m' -suffix='# END\n' | _webcat "$@"
}
if cmdcheck gotty; then
  function webcatd() {
    gotty $(which gechota) -p=$WEBCAT_PORT &
  }
fi

# NOTE: print string which fill terminal line
function line() {
  local C=${1:-=}
  seq -f "$C" -s '' $(($(tput cols) / $(printf "%s" "$C" | wc -m)))
  echo ''
}
function hr() { printf '%*s\n' "${2:-$(tput cols)}" '' | tr ' ' "${1:--}"; }
function hr_log() {
  local char=$1
  [[ $# -le 1 ]] && echo "$0 [CHAR] [printf FORMAT] [ARGS]" && return 1
  shift
  hr $char
  hr_message $char $@
  hr $char
}
function hr_message() {
  local char=$1
  [[ $# -le 1 ]] && echo "$0 [CHAR] [printf FORMAT] [ARGS]" && return 1
  shift
  local message="    "$(printf $@)"    "
  local left_cols=$((($(tput cols) - ${#message}) / 2))
  local right_cols=$((($(tput cols) - ${#message} + 1) / 2))
  printf '%*s' "$left_cols" '' | tr ' ' "$char"
  printf '%s' "$message"
  printf '%*s' "$right_cols" '' | tr ' ' "$char"
  printf '\n'
}

# terminal session logger
function script() {
  if [[ $# -gt 0 ]]; then
    command script "$@"
    return $?
  fi
  local dirpath=~/.typescript/$(date "+%Y-%m-%d")
  mkdir -p $dirpath
  local filename=$(date "+%H.%M.%S")"-$$.log"
  local filepath="$dirpath/$filename"
  echo "Script started, output file is $filepath"
  script -q "$filepath"
  echo "Script done, output file is $filepath"
}

# 特定のプロセスがいつから起動していたかを確かめる
# [Linuxプロセスの起動時刻を調べる方法 - Qiita](http://qiita.com/isaoshimizu/items/ee555b99582f251bd295)
# [PSコマンドでプロセスの起動時刻を調べる | ex1-lab](http://ex1.m-yabe.com/archives/1144)
function when() { ps -eo lstart,pid,args | grep -v grep; }

function tree() {
  local COLOR_OPT=()
  [[ ! -p /dev/stdout ]] && local COLOR_OPT=(-C)
  # NOTE: target is for rust
  LS_COLORS='*~=0;38;2;102;102;102:mi=0;38;2;0;0;0;48;2;255;92;87:so=0;38;2;0;0;0;48;2;255;106;193:di=0;38;2;87;199;255:bd=0;38;2;154;237;254;48;2;51;51;51:no=0:fi=0:ex=1;38;2;255;92;87:cd=0;38;2;255;106;193;48;2;51;51;51:or=0;38;2;0;0;0;48;2;255;92;87:pi=0;38;2;0;0;0;48;2;87;199;255:ln=0;38;2;255;106;193:*.d=0;38;2;90;247;142:*.p=0;38;2;90;247;142:*.m=0;38;2;90;247;142:*.t=0;38;2;90;247;142:*.o=0;38;2;102;102;102:*.z=4;38;2;154;237;254:*.c=0;38;2;90;247;142:*.h=0;38;2;90;247;142:*.a=1;38;2;255;92;87:*.r=0;38;2;90;247;142:*.cr=0;38;2;90;247;142:*.ps=0;38;2;255;92;87:*.xz=4;38;2;154;237;254:*.go=0;38;2;90;247;142:*.so=1;38;2;255;92;87:*.gz=4;38;2;154;237;254:*.vb=0;38;2;90;247;142:*.kt=0;38;2;90;247;142:*.py=0;38;2;90;247;142:*.el=0;38;2;90;247;142:*.nb=0;38;2;90;247;142:*.hh=0;38;2;90;247;142:*.hs=0;38;2;90;247;142:*.md=0;38;2;243;249;157:*.cp=0;38;2;90;247;142:*.pl=0;38;2;90;247;142:*.la=0;38;2;102;102;102:*.ko=1;38;2;255;92;87:*.pm=0;38;2;90;247;142:*.bz=4;38;2;154;237;254:*.td=0;38;2;90;247;142:*.rm=0;38;2;255;180;223:*.jl=0;38;2;90;247;142:*css=0;38;2;90;247;142:*.gv=0;38;2;90;247;142:*.ui=0;38;2;243;249;157:*.sh=0;38;2;90;247;142:*.as=0;38;2;90;247;142:*.ml=0;38;2;90;247;142:*.ts=0;38;2;90;247;142:*.pp=0;38;2;90;247;142:*.rs=0;38;2;90;247;142:*.cc=0;38;2;90;247;142:*.cs=0;38;2;90;247;142:*.rb=0;38;2;90;247;142:*.hi=0;38;2;102;102;102:*.bc=0;38;2;102;102;102:*.ex=0;38;2;90;247;142:*.lo=0;38;2;102;102;102:*.js=0;38;2;90;247;142:*.7z=4;38;2;154;237;254:*.ll=0;38;2;90;247;142:*.fs=0;38;2;90;247;142:*.di=0;38;2;90;247;142:*.mn=0;38;2;90;247;142:*.bmp=0;38;2;255;180;223:*.sxw=0;38;2;255;92;87:*.lua=0;38;2;90;247;142:*.exs=0;38;2;90;247;142:*.swp=0;38;2;102;102;102:*.wma=0;38;2;255;180;223:*.vcd=4;38;2;154;237;254:*.bcf=0;38;2;102;102;102:*.mir=0;38;2;90;247;142:*.fsx=0;38;2;90;247;142:*.fls=0;38;2;102;102;102:*.hpp=0;38;2;90;247;142:*.m4v=0;38;2;255;180;223:*.ttf=0;38;2;255;180;223:*.pps=0;38;2;255;92;87:*.pas=0;38;2;90;247;142:*.out=0;38;2;102;102;102:*.pkg=4;38;2;154;237;254:*.yml=0;38;2;243;249;157:*.def=0;38;2;90;247;142:*.elm=0;38;2;90;247;142:*.sxi=0;38;2;255;92;87:*.tml=0;38;2;243;249;157:*.img=4;38;2;154;237;254:*.rst=0;38;2;243;249;157:*.dot=0;38;2;90;247;142:*.asa=0;38;2;90;247;142:*.csv=0;38;2;243;249;157:*.clj=0;38;2;90;247;142:*.pyc=0;38;2;102;102;102:*.tcl=0;38;2;90;247;142:*.pdf=0;38;2;255;92;87:*.otf=0;38;2;255;180;223:*.exe=1;38;2;255;92;87:*.dmg=4;38;2;154;237;254:*.ini=0;38;2;243;249;157:*.toc=0;38;2;102;102;102:*.pod=0;38;2;90;247;142:*.gvy=0;38;2;90;247;142:*.bbl=0;38;2;102;102;102:*.sty=0;38;2;102;102;102:*.pro=0;38;2;165;255;195:*.ind=0;38;2;102;102;102:*.sbt=0;38;2;90;247;142:*.png=0;38;2;255;180;223:*.hxx=0;38;2;90;247;142:*.fnt=0;38;2;255;180;223:*.php=0;38;2;90;247;142:*.pbm=0;38;2;255;180;223:*.flv=0;38;2;255;180;223:*.mkv=0;38;2;255;180;223:*.mli=0;38;2;90;247;142:*.cxx=0;38;2;90;247;142:*.pid=0;38;2;102;102;102:*.rtf=0;38;2;255;92;87:*.ppm=0;38;2;255;180;223:*.ipp=0;38;2;90;247;142:*.mp3=0;38;2;255;180;223:*.swf=0;38;2;255;180;223:*.wav=0;38;2;255;180;223:*.h++=0;38;2;90;247;142:*.xcf=0;38;2;255;180;223:*.ods=0;38;2;255;92;87:*.tar=4;38;2;154;237;254:*.dll=1;38;2;255;92;87:*.bz2=4;38;2;154;237;254:*.dox=0;38;2;165;255;195:*.kex=0;38;2;255;92;87:*.tsx=0;38;2;90;247;142:*.bak=0;38;2;102;102;102:*.txt=0;38;2;243;249;157:*TODO=1:*.rpm=4;38;2;154;237;254:*.xlr=0;38;2;255;92;87:*.zip=4;38;2;154;237;254:*.bin=4;38;2;154;237;254:*.tbz=4;38;2;154;237;254:*.csx=0;38;2;90;247;142:*.erl=0;38;2;90;247;142:*.iso=4;38;2;154;237;254:*.mid=0;38;2;255;180;223:*.mp4=0;38;2;255;180;223:*.ltx=0;38;2;90;247;142:*.fon=0;38;2;255;180;223:*.odt=0;38;2;255;92;87:*.inl=0;38;2;90;247;142:*.git=0;38;2;102;102;102:*.gif=0;38;2;255;180;223:*.inc=0;38;2;90;247;142:*.xls=0;38;2;255;92;87:*.xml=0;38;2;243;249;157:*.ps1=0;38;2;90;247;142:*.bat=1;38;2;255;92;87:*.dpr=0;38;2;90;247;142:*.odp=0;38;2;255;92;87:*.ogg=0;38;2;255;180;223:*.doc=0;38;2;255;92;87:*.bib=0;38;2;243;249;157:*.ilg=0;38;2;102;102;102:*.rar=4;38;2;154;237;254:*.ppt=0;38;2;255;92;87:*.mpg=0;38;2;255;180;223:*.svg=0;38;2;255;180;223:*.vob=0;38;2;255;180;223:*.vim=0;38;2;90;247;142:*.c++=0;38;2;90;247;142:*.epp=0;38;2;90;247;142:*.aux=0;38;2;102;102;102:*.awk=0;38;2;90;247;142:*.ics=0;38;2;255;92;87:*.mov=0;38;2;255;180;223:*.arj=4;38;2;154;237;254:*.htm=0;38;2;243;249;157:*.sql=0;38;2;90;247;142:*.ico=0;38;2;255;180;223:*.cgi=0;38;2;90;247;142:*.cpp=0;38;2;90;247;142:*.avi=0;38;2;255;180;223:*.idx=0;38;2;102;102;102:*.jpg=0;38;2;255;180;223:*.tex=0;38;2;90;247;142:*.bst=0;38;2;243;249;157:*.bag=4;38;2;154;237;254:*.fsi=0;38;2;90;247;142:*.cfg=0;38;2;243;249;157:*.com=1;38;2;255;92;87:*.kts=0;38;2;90;247;142:*.bsh=0;38;2;90;247;142:*.pgm=0;38;2;255;180;223:*hgrc=0;38;2;165;255;195:*.apk=4;38;2;154;237;254:*.tgz=4;38;2;154;237;254:*.nix=0;38;2;243;249;157:*.blg=0;38;2;102;102;102:*.deb=4;38;2;154;237;254:*.aif=0;38;2;255;180;223:*.xmp=0;38;2;243;249;157:*.wmv=0;38;2;255;180;223:*.log=0;38;2;102;102;102:*.jar=4;38;2;154;237;254:*.tmp=0;38;2;102;102;102:*.htc=0;38;2;90;247;142:*.tif=0;38;2;255;180;223:*.zsh=0;38;2;90;247;142:*.lock=0;38;2;102;102;102:*.dart=0;38;2;90;247;142:*.rlib=0;38;2;102;102;102:*.h264=0;38;2;255;180;223:*.bash=0;38;2;90;247;142:*.yaml=0;38;2;243;249;157:*.docx=0;38;2;255;92;87:*.flac=0;38;2;255;180;223:*.jpeg=0;38;2;255;180;223:*.epub=0;38;2;255;92;87:*.java=0;38;2;90;247;142:*.psm1=0;38;2;90;247;142:*.lisp=0;38;2;90;247;142:*.make=0;38;2;165;255;195:*.tbz2=4;38;2;154;237;254:*.orig=0;38;2;102;102;102:*.json=0;38;2;243;249;157:*.fish=0;38;2;90;247;142:*.conf=0;38;2;243;249;157:*.toml=0;38;2;243;249;157:*.xlsx=0;38;2;255;92;87:*.purs=0;38;2;90;247;142:*.mpeg=0;38;2;255;180;223:*.pptx=0;38;2;255;92;87:*.html=0;38;2;243;249;157:*.diff=0;38;2;90;247;142:*.hgrc=0;38;2;165;255;195:*.psd1=0;38;2;90;247;142:*.less=0;38;2;90;247;142:*.ipynb=0;38;2;90;247;142:*.swift=0;38;2;90;247;142:*.cache=0;38;2;102;102;102:*.toast=4;38;2;154;237;254:*.class=0;38;2;102;102;102:*.shtml=0;38;2;243;249;157:*.mdown=0;38;2;243;249;157:*.xhtml=0;38;2;243;249;157:*README=0;38;2;40;42;54;48;2;243;249;157:*.dyn_o=0;38;2;102;102;102:*passwd=0;38;2;243;249;157:*.patch=0;38;2;90;247;142:*.cabal=0;38;2;90;247;142:*.scala=0;38;2;90;247;142:*.cmake=0;38;2;165;255;195:*shadow=0;38;2;243;249;157:*.matlab=0;38;2;90;247;142:*.gradle=0;38;2;90;247;142:*.dyn_hi=0;38;2;102;102;102:*.flake8=0;38;2;165;255;195:*TODO.md=1:*.ignore=0;38;2;165;255;195:*COPYING=0;38;2;153;153;153:*LICENSE=0;38;2;153;153;153:*INSTALL=0;38;2;40;42;54;48;2;243;249;157:*.config=0;38;2;243;249;157:*.groovy=0;38;2;90;247;142:*Makefile=0;38;2;165;255;195:*Doxyfile=0;38;2;165;255;195:*setup.py=0;38;2;165;255;195:*.desktop=0;38;2;243;249;157:*.gemspec=0;38;2;165;255;195:*TODO.txt=1:*configure=0;38;2;165;255;195:*README.md=0;38;2;40;42;54;48;2;243;249;157:*.markdown=0;38;2;243;249;157:*.rgignore=0;38;2;165;255;195:*.cmake.in=0;38;2;165;255;195:*.fdignore=0;38;2;165;255;195:*.kdevelop=0;38;2;165;255;195:*COPYRIGHT=0;38;2;153;153;153:*CODEOWNERS=0;38;2;165;255;195:*INSTALL.md=0;38;2;40;42;54;48;2;243;249;157:*.scons_opt=0;38;2;102;102;102:*SConstruct=0;38;2;165;255;195:*README.txt=0;38;2;40;42;54;48;2;243;249;157:*.gitconfig=0;38;2;165;255;195:*SConscript=0;38;2;165;255;195:*.gitignore=0;38;2;165;255;195:*Dockerfile=0;38;2;243;249;157:*.gitmodules=0;38;2;165;255;195:*Makefile.am=0;38;2;165;255;195:*.synctex.gz=0;38;2;102;102;102:*LICENSE-MIT=0;38;2;153;153;153:*MANIFEST.in=0;38;2;165;255;195:*Makefile.in=0;38;2;102;102;102:*.travis.yml=0;38;2;90;247;142:*.fdb_latexmk=0;38;2;102;102;102:*appveyor.yml=0;38;2;90;247;142:*configure.ac=0;38;2;165;255;195:*.applescript=0;38;2;90;247;142:*CONTRIBUTORS=0;38;2;40;42;54;48;2;243;249;157:*.clang-format=0;38;2;165;255;195:*CMakeLists.txt=0;38;2;165;255;195:*.gitattributes=0;38;2;165;255;195:*CMakeCache.txt=0;38;2;102;102;102:*LICENSE-APACHE=0;38;2;153;153;153:*INSTALL.md.txt=0;38;2;40;42;54;48;2;243;249;157:*CONTRIBUTORS.md=0;38;2;40;42;54;48;2;243;249;157:*.sconsign.dblite=0;38;2;102;102;102:*requirements.txt=0;38;2;165;255;195:*CONTRIBUTORS.txt=0;38;2;40;42;54;48;2;243;249;157:*package-lock.json=0;38;2;102;102;102' \
    command tree -a -I "\.git|target" "${COLOR_OPT[@]}" "$@" | sed "s/$(echo -e "\xc2\xa0")/ /g"
}

# backup file command
function bk() {
  [[ $# -lt 0 ]] && echo "$(basename $0) [files...]" && return 1

  for filepath in "$@"; do
    local src="$filepath"
    local dst="$filepath"
    local max=128
    [[ ! -e "$src" ]] && echo "Not found '$src'!" 1>&2 && continue
    for ((i = 0; i < $max; i++)); do
      dst="${dst}~"
      [[ ! -e "$dst" ]] && cp "$src" "$dst" && echo "[DONE]: cp '$src' '$dst'" && break
    done
  done
}

# only for zsh
alias wtty='() { curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Tokyo}" }'
alias weather.tokyo.en='wtty'
alias weather.tokyo.ja='() { curl -H "Accept-Language: ja" wttr.in/"${1:-Tokyo}" }'
alias moon='() { curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Tokyo}" } moon'

# auto zstyle ':prezto:load' pmodule function
# e.g.
# zploadadd homebrew osx git rails syntax-highlighting history-substring-search
# zploadadd ssh tmux rsync archive
# [sed でシンボリックリンクのファイルを書き換えると、実体ファイルに変わる – Tower of Engineers]( https://toe.bbtower.co.jp/20160915/136/ )
cmdcheck gsed && function zploadadd() {
  [[ $# == 0 ]] && echo "$0 zstyle.pmodule names..." && return
  for package in $@; do
    sed -i --follow-symlinks -e '/^zstyle.*pmodule \\$/a '\'$package\'' \\' ~/.zpreztorc
  done
}

function ifconfig() {
  local COLOR_RED="\e[91m"
  local COLOR_GREEN="\e[92m"
  local COLOR_YELLOW="\e[93m"
  local COLOR_BLUE="\e[94m"
  local COLOR_END="\e[m"
  # `inet `: mac
  # `inet addr:`: ubuntu
  unbuffer ifconfig "$@" \
    | perl -pe "s/^(\w)+/${COLOR_BLUE}$&${COLOR_END}/g" \
    | perl -pe "s/(?<=inet )(\d+\.){3}\d+(\/\d+)?/${COLOR_YELLOW}$&${COLOR_END}/g" \
    | perl -pe "s/(?<=inet addr:)(\d+\.){3}\d+(\/\d+)?/${COLOR_YELLOW}$&${COLOR_END}/g" \
    | perl -pe "s/(?![0f:]{17})([\da-f]{2}:){5}[\da-f]+/${COLOR_GREEN}$&${COLOR_END}/g" \
    | perl -pe "s/(([\da-f]{4})?:){2,7}[\da-f]+(\/\d+)?/${COLOR_RED}$&${COLOR_END}/g"
}

function du() {
  if [[ -p /dev/stdout ]]; then
    command du -kh "$@"
  else
    unbuffer du -kh "$@" \
      | perl -pe "s/^([ 0-9.]+[BK])/${GREEN}$&${DEFAULT}/; s/^([ 0-9.]+[M])/${YELLOW}$&${DEFAULT}/; s/^([ 0-9.]+[G])/${RED}$&${DEFAULT}/"
  fi
}

if [[ $(uname) == "Darwin" ]]; then
  function df() {
    command df "$@" | safe-cat-pipe cgrep 'disk.*s1.* ([0-9.]*Gi)' 198
  }
fi

function id() {
  if [[ -p /dev/stdout ]]; then
    command id "$@"
  else
    unbuffer id "$@" \
      | perl -pe "s/(\([^()]*\))/${LIGHT_BLUE}$&${DEFAULT}/g"
  fi
}

function pstree() {
  if [[ -p /dev/stdout ]]; then
    command pstree "$@"
  else
    unbuffer pstree "$@" \
      | bat -l zsh --color always --plain | perl -pe "s/root/${RED}$&${DEFAULT}/; s/$USER/${GREEN}$&${DEFAULT}/"
  fi
}

function env() {
  if [[ -p /dev/stdout ]] || [[ $# -gt 0 ]]; then
    command env "$@"
  else
    unbuffer env "$@" \
      | perl -pe "s/^([^=]+)/${GREEN}$&${DEFAULT}/g"
  fi
}

# function off() { printf "\e[0;m$*\e[m"; }
# function bold() { printf "\e[1;m$*\e[m"; }
# function under() { printf "\e[4;m$*\e[m"; }
# function blink() { printf "\e[5;m$*\e[m"; }
# function reverse() { printf "\e[7;m$*\e[m"; }
# function back() { printf "\e[7;m$*\e[m"; }
# function concealed() { printf "\e[8;m$*\e[m"; }
# function black() { printf "\e[30m$*\e[m"; }
# function red() { printf "\e[31m$*\e[m"; }
# function green() { printf "\e[32m$*\e[m"; }
# function yellow() { printf "\e[33m$*\e[m"; }
# function blue() { printf "\e[34m$*\e[m"; }
# function magenta() { printf "\e[35m$*\e[m"; }
# function cyan() { printf "\e[36m$*\e[m"; }
# function white() { printf "\e[37m$*\e[m"; }

# FYI: [正規表現でスネークケース↔キャメルケース/パスカルケースの変換 - Qiita]( http://qiita.com/ryo0301/items/7c7b3571d71b934af3f8 )
alias lower="tr '[:upper:]' '[:lower:]'"
alias upper="tr '[:lower:]' '[:upper:]'"
alias camel2snake="sed -r 's/([A-Z])/_\L\1\E/g'"
alias camel2upper="camel2snake|upper"
alias camel2lower="camel2snake|lower"
alias camel2kebab="camel2snake|sed 's/_/-/g'"
alias camel2space="camel2snake|sed 's/_/ /g'"
alias camel2pascal="sed -r 's/(^.)/\U\1\E/g'"
alias snake2camel="sed -r 's/_(.)/\U\1\E/g'"

# * UpperCamelCase(PascalCase): AbcDef
# * UPPERCASW(CONSTANT_CASE): ABC_DEF
# * (lower)camelCase: abcDef
# * snake_case: abc_def
# * kebab-case: abc-def
# * space-case: anc def
function git-sed-gen-name() {
  [[ $# -lt 2 ]] && echo "$(basename $0) [old_camelcase_name] [new_camel_case_name]" && return 1
  local old_camel="$1"
  local new_camel="$2"
  local old_snake=$(printf '%s' "$old_camel" | camel2snake)
  local old_upper=$(printf '%s' "$old_camel" | camel2upper)
  local old_kebab=$(printf '%s' "$old_camel" | camel2kebab)
  local old_pascal=$(printf '%s' "$old_camel" | camel2pascal)
  local old_space=$(printf '%s' "$old_camel" | camel2space)
  local new_snake=$(printf '%s' "$new_camel" | camel2snake)
  local new_upper=$(printf '%s' "$new_camel" | camel2upper)
  local new_kebab=$(printf '%s' "$new_camel" | camel2kebab)
  local new_pascal=$(printf '%s' "$new_camel" | camel2pascal)
  local new_space=$(printf '%s' "$new_camel" | camel2space)
  command cat <<EOF
:  "camel"; git sed 's/$old_camel/$new_camel/g'
:  "snake"; git sed 's/$old_snake/$new_snake/g'
:  "upper"; git sed 's/$old_upper/$new_upper/g'
:  "kebak"; git sed 's/$old_kebab/$new_kebab/g'
: "pascal"; git sed 's/$old_pascal/$new_pascal/g'
:  "space"; git sed 's/$old_space/$new_space/g'
EOF
}
# NOTE: e.g.
# mainの中のcamel caseをすべてsnake caseに変換する
# cat main.cpp | git-sed-gen-name-from-camelcase-pipe | grep camel | bash
function git-sed-gen-name-from-camelcase-pipe() {
  grep-camelcase-filter | while IFS= read -r line || [[ -n "$line" ]]; do
    git-sed-gen-name "$line" "$(printf '%s' "$line" | camel2snake)"
  done
}

function vscode-extension-eval-encoder() {
  echo '['
  sed 's/'$'\t''/    /g' | sed 's/"/\\"/g' | sed -e 's/^/"/' -e 's/$/",/'
  echo ']'
}
function vscode-extension-eval-decoder() {
  sed -E 's/^ *([\["]|\])|",$//g' | sed '1{/^$/d}; ${/^$/d}'
}

alias jobs='jobs -l'
# [裏と表のジョブを使い分ける \- ザリガニが見ていた\.\.\.。]( http://d.hatena.ne.jp/zariganitosh/20141212/fore_back_ground_job )
cmdcheck stop || alias stop='kill -TSTP'

# [command line \- Print a 256\-color test pattern in the terminal \- Ask Ubuntu]( https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal )
function color-test-256() {
  if [[ -f ~/dotfiles/local/bin/colortest.py ]]; then
    ~/dotfiles/local/bin/colortest.py
    return
  fi
  for i in {0..255}; do
    # NOTE: bg
    # printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    # NOTE: fg
    printf "\x1b[38;5;%sm%3d\e[0m " "$i" "$i"
    if ((i == 7)) || ((i == 15)) || { ((i > 15)) && (((i - 15) % 6 == 0)); }; then
      printf "\n"
    fi
  done
  echo "tput setaf <number>"
}
function _color-test-256-tput() {
  echo "tput setaf <number>"
  n=0
  for ((j = 0; j < 2; j++)); do
    for ((i = 0; i < 8; i++, n++)); do printf "%s%03d " $(tput setaf $n) $n; done
    echo
  done
  n=16
  for ((j = 0; j < $(((256 - 16) / 6)); j++)); do
    for ((i = 0; i < 6; i++, n++)); do printf "%s%03d " $(tput setaf $n) $n; done
    echo
  done
}
function color-test-full() {
  # [True Colour \(16 million colours\) support in various terminal applications and terminals]( https://gist.github.com/XVilka/8346728 )
  awk 'BEGIN{
  s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
  for (colnum = 0; colnum<77; colnum++) {
    r = 255-(colnum*255/76);
    g = (colnum*510/76);
    b = (colnum*255/76);
    if (g>255) g = 510-g;
    printf "\033[48;2;%d;%d;%dm", r,g,b;
    printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
    printf "%s\033[0m", substr(s,colnum+1,1);
  }
  printf "\n";
}'
}
function color-tmux() {
  for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"; done | xargs
}

function xargs-printf() {
  while read line || [ -n "${line}" ]; do
    printf "$@" $line
  done
}

function cterms() {
  # [ターミナルで使える色と色番号を一覧にする \- Qiita]( https://qiita.com/tmd45/items/226e7c380453809bc62a )
  ruby -e "$(echo '
# -*- coding: utf-8 -*-

@fg = "\x1b[38;5;"
@bg = "\x1b[48;5;"
@rs = "\x1b[0m"

def color(code)
  number = "%3d" % code
  "#{@bg}#{code}m #{number}#{@rs}#{@fg}#{code}m #{number}#{@rs} "
end

256.times do |n|
  print color(n)
  print "\n" if (n + 1).modulo(8).zero?
end
print "\n"
')"
}

# FYI: [Direct linking to your files on Dropbox, Google Drive and OneDrive — Milan Aryal]( https://milanaryal.com.np/direct-linking-to-your-files-on-dropbox-google-drive-and-onedrive/ )
function google_web_url_to_wget_url() {
  [[ $# -lt 1 ]] && echo "$(basename "$0") <google drive or docs or spreadsheets or presentation url>" && return 1
  local url="$1"
  # NOTE: google drive
  if echo "$url" | grep -q '^https://drive.google.com'; then
    local file_id=$(echo "$url" | sed -E 's|^https://drive.google.com/file/d/([^/]+)/.*|\1|')
    local direct_url="https://drive.google.com/uc?export=download&id=$file_id"
    echo "$direct_url"
    return
  fi
  # NOTE: google docs
  if echo "$url" | grep -q '^https://docs.google.com'; then
    local file_id=$(echo "$url" | sed -E 's|^https://docs.google.com/document/d/([^/]+)/.*|\1|')
    local direct_url="https://docs.google.com/document/d/$file_id/export?format=pdf" # or doc
    echo "$direct_url"
    return
  fi
  # NOTE: google spreadsheets
  if echo "$url" | grep -q '^https://docs.google.com'; then
    local file_id=$(echo "$url" | sed -E 's|^https://docs.google.com/spreadsheets/d/([^/]+)/.*|\1|')
    local direct_url="https://docs.google.com/spreadsheets/d/$file_id/export?format=xlsx" # or pdf
    echo "$direct_url"
    return
  fi
  # NOTE: google presentation
  if echo "$url" | grep -q '^https://docs.google.com'; then
    local file_id=$(echo "$url" | sed -E 's|^https://docs.google.com/presentation/d/([^/]+)/.*|\1|')
    local direct_url="https://docs.google.com/presentation/d/$file_id/export?format=pdf" # or pptx
    echo "$direct_url"
    return
  fi
  echo 1>&2 "unknown google url type: $url"
  return 1
}

# FYI: [google driveをコマンドラインで操作する \- Qiita]( https://qiita.com/shinkoma/items/e2d80f82303bd90e9e30 )
# Failed to get file: googleapi: Error 403: Rate Limit Exceeded, rateLimitExceeded
# Failed to find root dir: googleapi: Error 403: Rate Limit Exceeded, rateLimitExceeded
#
# required: gdrive
if cmdcheck gdrive; then
  function memosync() {
    local n=${1:-30}
    for ((i = 0; i < $n; i++)); do
      gsync-gshare && break
      sleep 10
    done
  }
  function gsync-gshare() {
    # NOTE: zsh cd message stdout
    # NOTE: gsync  message stderr
    local _
    _=$(gshare && gsync 1>&2)
  }
  function gsync() {
    local ID=$1
    [[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
    [[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'" && return 1
    echo "${YELLOW}ID:$ID${DEFAULT}"

    echo "# ${GREEN}downloading...${DEFAULT}"
    local ret=$(gdrive sync download $ID . 2>&1 | tee $(tty))
    local code=0
    echo "$ret" | grep -E "Failed .*: googleapi: Error 403: Rate Limit Exceeded, rateLimitExceeded" >/dev/null 2>&1 && local code=1
    [[ ! $code == "0" ]] && echo "${RED}[Error]$DEFAULT: download" && return $code

    echo "# ${GREEN}uploading...${DEFAULT}"
    local ret=$(gdrive sync upload . $ID 2>&1 | tee $(tty))
    local code=0
    echo "$ret" | grep -E "Failed .*: googleapi: Error 403: Rate Limit Exceeded, rateLimitExceeded" >/dev/null 2>&1 && local code=1
    [[ ! $code == "0" ]] && echo "${RED}[Error]$DEFAULT: upload" && return $code
    return $code
  }
  function gsync-download() {
    local ID=$1
    [[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
    [[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'" && return 1
    echo "ID:$ID"
    echo "# downloading..."
    gdrive sync download $ID .
  }
  function gsync-upload() {
    local ID=$1
    [[ $# == 0 ]] && [[ -f .gdrive ]] && local ID=$(command cat .gdrive | tr -d '\n')
    [[ -z $ID ]] && echo "$0 <ID> or set <ID> '.gdrive'" && return 1
    echo "ID:$ID"
    echo "# uploading..."
    gdrive sync upload . $ID
  }
fi

alias history_detail='detail_history'
function detail_history() {
  cat ~/.detail_history | sed 's/^/'$(tput setaf 69)'/1' | sed 's/@/'$(tput setaf 202)' /1' | sed 's/@/'$(tput setaf 112)' /1' | sed 's/@/'$(tput setaf 99)' /1' | cat
}
alias history_recent='recent_history'
function recent_history() {
  local n=${1:-20}
  cat ~/.detail_history | grep "$TTY" | cut -d"@" -f4 | tail -n $n
}
alias current_history='wd_history'
alias history_wd='wd_history'
function wd_history() {
  local n=${1:-20}
  cat ~/.detail_history | grep "@$(pwd)@" | cut -d"@" -f4 | tail -n $n
}

# FYI: [あるファイルを削除するだけでディスク使用率が100％になる理由 \- Qiita]( https://qiita.com/nacika_ins/items/d614b933034137ed42f6 )
function show-all-files-which-processes-grab() {
  lsof \
    | grep REG \
    | grep -v "stat: No such file or directory" \
    | grep -v DEL \
    | awk '{if ($NF=="(deleted)") {x=3;y=1} else {x=2;y=0}; {print $(NF-x) "  " $(NF-y) } }' \
    | sort -n -u
}

# edit clipboard on vim
function cedit() {
  local tmpfile=$(mktemp '/tmp/cedit.tmp.orderfile.XXXXX')
  p >"$tmpfile"
  VIM_FAST_MODE='on' vim "$tmpfile" && cat "$tmpfile" | c
  [[ -f $tmpfile ]] && rm -f $tmpfile
}

function c() {
  if [[ $# == 0 ]]; then
    _c
  else
    command cat $1 | _c
  fi
}

# NOTE: one line copy
alias oc='perl -pe "chomp if eof" | tr '"'"'\n'"'"' " " | c'

# global aliases
alias -g PV="| pecovim"
alias -g WC="| wc"
alias -g L="| less"
alias -g C="| c"
alias -g P="p |"

# [How to remove ^\[, and all of the escape sequences in a file using linux shell scripting \- Stack Overflow]( https://stackoverflow.com/questions/6534556/how-to-remove-and-all-of-the-escape-sequences-in-a-file-using-linux-shell-sc )
alias drop-without-ascii='sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"'
alias remove-without-ascii='drop-without-ascii'

alias remove-ansi="perl -MTerm::ANSIColor=colorstrip -ne 'print colorstrip(\$_)'"
alias drop-color="remove-ansi"
alias drop-ansi="remove-ansi"
alias filter-ansi="remove-ansi"
alias filter-color="remove-ansi"
alias monokuro="remove-ansi"
alias mono-color="remove-ansi"
alias term-cols='tput cols'
alias term-lines='tput lines'

# NOTE: 動作が遅い
# nずれのシーザ暗号を解く(lookによる簡易テスト機能つき)
function solve_caesar_cipher() {
  local dict_path="/usr/share/dict/words"
  local input=($(cat))
  for i in $(seq 1 25); do
    local output=()
    printf "[%2d]:" $i
    local output=($(echo $input | tr "$(printf %${i}sa-z | tr ' ' '🍣')" a-za-z | tr "$(printf %${i}sA-Z | tr ' ' '🍣')" A-ZA-Z))
    # check?
    local n=0
    local n_no_hit=0
    for word in "${output[@]}"; do
      # NOTE: ある程度以上の文字数の単語のみを検索対象とする
      if [[ ${#word} -ge 4 ]]; then
        local n=$((n + 1))
        # 文章に含まれている余計な記号の削除
        word=$(echo $word | sed -E 's/\.|,//g')
        look $word >/dev/null
        # or
        #         cat $dict_path | grep "^${word}$" >/dev/null
        local n_no_hit=$((n_no_hit + $?))
      fi
    done
    local n_hit=$((n - n_no_hit))
    printf "(%3d/%3d):" $n_hit $n
    # more than 50%?
    if [[ $n_hit -gt $((n / 2)) ]]; then
      echo -n $GREEN
    fi
    echo $output
    echo -n $DEFAULT
  done
}

alias date-for-file='date +"%Y-%m-%d_%k-%M-%S"'

alias sum="awk '{for(i=1;i<=NF;i++)sum+=\$i;} END{print sum}'"
alias sum-all='sum'
alias sum-col="awk '{for(i=1;i<=NF;i++)sum[i]+=\$i;} END{for(i in sum)printf \"%d \", sum[i]; print \"\"}'"
alias sum-line="awk '{sum=0; for(i=1;i<=NF;i++)sum+=\$i; print sum}'"
alias awk-sum='sum'
alias awk-sum-all='sum'
alias awk-sum-col='sum-col'
alias awk-sum-line='sum-line'

########################XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
if [[ $(uname) == "Linux" ]]; then
  alias ps-cpu='ps aux --sort -%cpu'
  alias ps-mem='ps aux --sort -rss'
elif [[ $(uname) == "Darwin" ]]; then
  alias ps-cpu='ps aux -r'
  alias ps-mem='ps aux -m'
fi

function cheatsheet() {
  local target=$(
    cd ~/dotfiles/local/cheatsheets >/dev/null
    ls | pecocat
  )
  [[ -z $target ]] && return
  echo $target
  cat ~/dotfiles/local/cheatsheets/$target
}

# FYI: [文字を中央寄せで表示するスクリプト \- Qiita]( https://qiita.com/april418/items/1c44d3bd13647183deae )
function text_center() {
  local columns=$(tput cols)
  local line=
  if [[ -p /dev/stdin ]]; then
    while IFS= read -r line || [ -n "$line" ]; do
      printf "%*s\n" $(((${#line} + columns) / 2)) "$line"
    done
  else
    line="$@"
    printf "%*s\n" $(((${#line} + columns) / 2)) "$line"
  fi
}

function display_center() {
  function max_length() {
    local length=
    local max_length=0
    local line=
    if [ -p /dev/stdin ]; then
      while IFS= read -r line || [ -n "$line" ]; do
        length=${#line}
        if [ $length -gt $max_length ]; then
          max_length=$length
        fi
      done </dev/stdin
      echo $max_length
    else
      line="$@"
      echo ${#line}
    fi
  }
  function with_indent() {
    local length="$1"
    local line=
    local indent=
    local i=
    for ((i = 0; i < length; i++)); do
      indent="$indent "
    done
    if [ -p /dev/stdin ]; then
      while IFS= read -r line || [ -n "$line" ]; do
        echo "${indent}${line}"
      done </dev/stdin
    else
      shift
      line="$@"
      echo "${indent}${#line}"
    fi
  }
  local columns=$(tput cols)
  local length=$(echo "$@" | max_length)
  echo "$@" | with_indent "$(((columns - length) / 2))"
}

# [bashでポモドーロタイマー作ったった \- Qiita]( https://qiita.com/imura81gt/items/61ff64db8e767ecbbb9d )
function pomodoro() {
  clear
  local i=${1:-$((25 * 60))}
  #   figlet "ready?" | sand "$GREEN" | text_center
  #   read Wait

  while :; do
    clear
    figlet "Pomodoro Timer" | sand "$YELLOW" | text_center
    (figlet $(printf "%02d : %02d" $((i / 60)) $((i % 60))) | sand "$BLUE" | text_center)
    : $((i -= 1))
    sleep 1
    if [ $i -eq 0 ]; then
      # NOTE: picture is chicken
      cmdcheck notify && notify -t "Pomodoro" --icon https://icondecotter.jp/data/16709/1401284346/169a75762480f56cd2d282afedd93568.png -m "Finish!"

      echo -n "Pomodoro[P],Short break[S], Long break[L]?> "
      read WAIT
      case "${WAIT:0:1}" in
        'P' | 'p')
          i=$((25 * 60))
          ;;
        'S' | 's')
          i=$((5 * 60))
          ;;
        'L' | 'l')
          i=$((15 * 60))
          ;;
        *)
          echo "Didn't match anything"
          echo "Pomodoro Start!"
          i=$((25 * 60))
          ;;
      esac
      clear
      figlet $(printf "%02d : %02d" $((i / 60)) $((i % 60)))
    fi
  done
}

# [edouard\-lopez/progress\-bar\.sh: Simple & sexy progress bar for \`bash\`, give it a duration and it will do the rest\.]( https://github.com/edouard-lopez/progress-bar.sh )
function progress-bar-blue() {
  echo -ne $BLUE
  progress-bar "$@"
  echo -e $DEFAULT
}
function progress-bar() {
  local duration=${1}

  function already_done() { for ((done = 0; done < $elapsed; done++)); do printf "▇"; done; }
  function remaining() { for ((remain = $elapsed; remain < $duration; remain++)); do printf " "; done; }
  function percentage() { printf "| %s%%" $(((($elapsed) * 100) / ($duration) * 100 / 100)); }
  function clean_line() { printf "\r"; }

  for ((elapsed = 1; elapsed <= $duration; elapsed++)); do
    already_done
    remaining
    percentage
    sleep 1
    clean_line
  done
  clean_line
}

cmdcheck say && function mississippi() {
  local n=${1:-9999}
  local start=$(date +%s)
  for i in $(seq 1 $n); do
    say "$i mississippi"
    local end=$(date +%s)
    echo -n "\r$((end - start)) sec"
  done
}

alias ssh='TERM=xterm-256color ssh'
cmdcheck oressh && alias oressh='TERM=xterm-256color oressh'
function ssh() {
  local exit_code=0
  if cmdcheck autossh; then
    autossh -M 0 $@
    local exit_code=$?
  else
    command ssh $@
    local exit_code=$?
  fi

  # NOTE: autossh使用時にはexit codeが異なる可能性がある
  # ssh: `connect to host xxx.xxx.xxx.xxx port 22: Connection refused` is also return 255
  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  # @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
  # @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  if [[ $exit_code == 255 ]]; then
    for ssh_hostname in "$@"; do
      if [[ ! $ssh_hostname =~ ^-.* ]]; then
        local tmp_ssh_hostname=${ssh_hostname##*@}
        local tmp_ssh_hostname=${tmp_ssh_hostname%:*}
        local hostname=$(sshconfig_host_hostname $tmp_ssh_hostname)
        if [[ -n $hostname ]]; then
          export WARNING_REMOTE_HOST_IDENTIFICATION_HAS_CHANGED_HOSTNAME="$hostname"
          echo "$PURPLE"
          echo "$hostname is exported to "'$WARNING_REMOTE_HOST_IDENTIFICATION_HAS_CHANGED_HOSTNAME'
          echo "If you want to remove the IDENTIFICATION, run ${YELLOW}sshdelkey${DEFAULT}"
          echo "$DEFAULT"
          break
        fi
      fi
    done
  fi
  return $exit_code
}
function sshdelkey() {
  [[ -z $WARNING_REMOTE_HOST_IDENTIFICATION_HAS_CHANGED_HOSTNAME ]] && echo '$WARNING_REMOTE_HOST_IDENTIFICATION_HAS_CHANGED_HOSTNAME is empty!'
  ssh-keygen -f "$HOME/.ssh/known_hosts" -R $WARNING_REMOTE_HOST_IDENTIFICATION_HAS_CHANGED_HOSTNAME
}
# [regex \- Parsing \.ssh/config for proxy information \- Stack Overflow]( https://stackoverflow.com/questions/12779134/parsing-ssh-config-for-proxy-information )
function sshconfig_host_hostname() {
  awk -v "target=$1" '
    BEGIN {
      if (target == "") printf "%32s %32s\n", "Host", "HostName"
      exit_code=1
    }
    $1 == "Host" {
      host = $2;
      next;
    }
    $1 == "HostName" {
      $1 = "";
      sub( /^ */, "" , $0);
      if (target == "") {
        printf "%32s %32s\n", host, $0;
        exit_code=0
      }
      if (target == host) {
        printf "%s", $0;
        exit 0
      }
    }
    END {
      exit exit_code
    }
' ~/.ssh/config
}

# NOTE: for wrap commands to catch errors
function tar() { cmd_fuzzy_error_check tar $@; }
function rsync() { cmd_fuzzy_error_check rsync $@; }
function scp() { cmd_fuzzy_error_check scp $@; }
function cmd_fuzzy_error_check() {
  [[ $# -le 0 ]] && echo "$0 [CMD] [ARGS]" && return 1
  local cmd=$1
  shift

  local tmpfile=$(mktemp "/tmp/$(basename $0).$$.tmp.XXXXX")
  # save stderr to file and pass stderr to pipe
  command $cmd $@ 2> >(tee "$tmpfile" 1>&2)
  local exit_code=$?
  # NOTE: ignore bellow warning
  # @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
  # Warning: Permanently added 'x.x.x.x' (ECDSA) to the list of known hosts.
  command cat "$tmpfile" | grep -v -i 'warning:' | grep ': ' -q
  local grep_exit_code=$?
  if [[ $exit_code != 0 || $grep_exit_code == 0 ]]; then
    {
      echo -ne "${RED}"
      hr_log '#' "MAYBE $cmd ERROR"
      echo -ne "${DEFAULT}"
      echo "[log]: $tmpfile"
      hr '#'
      command cat "$tmpfile" | grep -C 1 ': '
      hr '#'
    } >$(tty)
    return $exit_code
  else
    [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
  fi
}

alias signalman='man-signal'
function man-signal() {
  command cat <<EOF
     No    Name         Default Action       Description
     1     SIGHUP       terminate process    terminal line hangup
     2     SIGINT       terminate process    interrupt program
     3     SIGQUIT      create core image    quit program
     4     SIGILL       create core image    illegal instruction
     5     SIGTRAP      create core image    trace trap
     6     SIGABRT      create core image    abort program (formerly SIGIOT)
     7     SIGEMT       create core image    emulate instruction executed
     8     SIGFPE       create core image    floating-point exception
     9     SIGKILL      terminate process    kill program
     10    SIGBUS       create core image    bus error
     11    SIGSEGV      create core image    segmentation violation
     12    SIGSYS       create core image    non-existent system call invoked
     13    SIGPIPE      terminate process    write on a pipe with no reader
     14    SIGALRM      terminate process    real-time timer expired
     15    SIGTERM      terminate process    software termination signal
     16    SIGURG       discard signal       urgent condition present on socket
     17    SIGSTOP      stop process         stop (cannot be caught or ignored)
     18    SIGTSTP      stop process         stop signal generated from keyboard
     19    SIGCONT      discard signal       continue after stop
     20    SIGCHLD      discard signal       child status has changed
     21    SIGTTIN      stop process         background read attempted from control
                                             terminal
     22    SIGTTOU      stop process         background write attempted to control
                                             terminal
     23    SIGIO        discard signal       I/O is possible on a descriptor (see
                                             fcntl(2))
     24    SIGXCPU      terminate process    cpu time limit exceeded (see
                                             setrlimit(2))
     25    SIGXFSZ      terminate process    file size limit exceeded (see
                                             setrlimit(2))
     26    SIGVTALRM    terminate process    virtual time alarm (see setitimer(2))
     27    SIGPROF      terminate process    profiling timer alarm (see setitimer(2))
     28    SIGWINCH     discard signal       Window size change
     29    SIGINFO      discard signal       status request from keyboard
     30    SIGUSR1      terminate process    User defined signal 1
     31    SIGUSR2      terminate process    User defined signal 2
EOF
}

# FYI: [How to view\-source of a Chrome extension]( https://gist.github.com/paulirish/78d6c1406c901be02c2d )
function chrome-extension-code() {
  [[ $# -lt 1 ]] && echo "$(basename $0) [url]" && return 1
  local extension_id=$(printf '%s' "$1" | sed -E 's:^.*chrome.google.com/webstore/detail/[^/]*/([^/]*).*$:\1:g')
  curl -L -o "$extension_id.zip" "https://clients2.google.com/service/update2/crx?response=redirect&os=mac&arch=x86-64&nacl_arch=x86-64&prod=chromecrx&prodchannel=stable&prodversion=44.0.2403.130&x=id%3D$extension_id%26uc"
  unzip -d "$extension_id-source" "$extension_id.zip"
}

function icon_gen() {
  [[ $# -lt 1 ]] && echo "$(basename "$0") png to icns(for mac) and ico(for windows)" && return 1
  local target="$1"
  local tmpdir=$(mktemp -d "/tmp/$(basename $0).$$.tmp.XXXXXX.iconset")
  # ! type >/dev/null 2>&1 'identify' && echo 'install identify command!' && return 1
  ! type >/dev/null 2>&1 'convert' && echo 'install convert command!' && return 1
  # local width=$(identify -format "%w" "$target")
  # local height=$(identify -format "%h" "$target")

  local size_list=(1024 512 256 128 32 16)
  for size in "${size_list[@]}"; do
    local size2x="$((size * 2))"
    local size_str="${size}x${size}"
    local size2x_str="${size2x}x${size2x}"
    convert "$target" -resize "$size" "$tmpdir/icon_${size_str}.png"
    [[ -f "$tmpdir/icon_${size2x_str}.png" ]] && ln -sf "icon_${size2x_str}.png" "$tmpdir/icon_${size_str}@2x.png"
  done
  # NOTE: REQUIRED files
  # icon_16x16.png
  # icon_16x16@2x.png
  # icon_32x32.png
  # icon_32x32@2x.png
  # icon_128x128.png
  # icon_128x128@2x.png
  # icon_256x256.png
  # icon_256x256@2x.png
  # icon_512x512.png
  # icon_512x512@2x.png

  local output="${target%.*}.icns"
  iconutil -c icns "$tmpdir" --output "$output"
  (
    cd "$tmpdir" >/dev/null 2>&1 && tree .
  )
  echo "[CREATED] $output"

  output="${target%.*}.ico"
  convert "$target" -define icon:auto-resize "$output"
  echo "[CREATED] $output"

  [[ -d "$tmpdir" ]] && rm -rf "$tmpdir"
}

function is_binary() {
  [[ $# -lt 1 ]] && echo "$(basename "$0") filepath" && return 1
  local filepath="$1"
  file --mime "$filepath" | grep -q "charset=binary"
}

function xdiff() {
  if [[ $# -lt 1 ]] || [[ $1 =~ ^(-h|-{1,2}help)$ ]]; then
    command cat <<EOF
usage:
echo file1 file2 ... | $0 <xargs commands>

e.g.
echo libhoge.so libfuga.so libpiyo.so | $0 'nm -D {}'
EOF
    return 1
  fi

  local tmpdir=$(mktemp -d "/tmp/$(basename $0).XXXXXX")
  local commands="$*"
  cat | tr ' ' '\n' | xargs -n1 -I{} bash -c "$commands > '${tmpdir}/{}.log'"
  local basefilepath=''
  for file in $(ls -rt "$tmpdir/"); do
    local filepath="$tmpdir/$file"
    if [[ ! -f "$basefilepath" ]]; then
      basefilepath="$filepath"
      continue
    fi
    echo "[diff] $basefilepath" "$filepath"
    diff -u "$basefilepath" "$filepath" | delta
  done
}

alias diff-grep='grep-diff'
function grep-diff() {
  function _help() {
    command cat <<EOF
[ | (pipe input) ] $cmd_name     <grep options>...  -- [base file] <target files>...
[ | (pipe input) ] $cmd_name -c <bash commands>...  -- [base file] <target files>...
    e.g.
      $cmd_name "search_word" -- a.log b.log c.log | colordiff
      cat a.log | $cmd_name "search_word" -- b.log c.log | colordiff
      $cmd_name -v "non_search_word" -- a.log b.log c.log | colordiff
      $cmd_name -c "grep -v sample | grep -e hello" -- a.log b.log c.log | colordiff
EOF
  }
  local cmd_name="grep-diff"
  local grep_args=()
  local filter_option=''
  local start_offset=1
  local end_offset=0

  if [[ $# -lt 1 ]] || [[ $1 =~ ^(-h|-{1,2}help)$ ]]; then
    _help
    return 1
  fi

  for arg in "$@"; do
    if [[ $arg == "-c" ]]; then
      filter_option='bash'
      ((start_offset++))
    fi
    if [[ $arg == "--" ]]; then
      grep_args=(${@:$start_offset:$end_offset})
      ((end_offset++))
      if [[ -z $filter_option ]] && [[ $start_offset -ne $end_offset ]]; then
        filter_option='grep'
      fi
      shift $end_offset
      break
    fi
    ((end_offset++))
  done

  if [[ -p /dev/stdin ]]; then
    local input="/dev/stdin"
  else
    local input="$1"
    shift
  fi

  if [[ $filter_option == 'bash' ]]; then
    function _filter() {
      bash -c "${grep_args[@]}"
    }
  elif [[ $filter_option == 'grep' ]]; then
    function _filter() {
      grep "${grep_args[@]}"
    }
  else
    function _filter() {
      command cat
    }
  fi

  # NOTE: save to var for pipe not file input
  local input_data=$(cat "$input" | _filter)

  local targets=("$@")
  for target in "${targets[@]}"; do
    echo "# [GREP_DIFF LOG]: diff $input $target"
    diff <(printf "%s" "$input_data") <(cat $target | _filter)
    printf '%*s\n' "$(tput cols)" '' | tr ' ' "#"
  done
}

function splitbat() {
  ! type >/dev/null 2>&1 bat && echo 1>&2 "install bat" && return 1
  ! type >/dev/null 2>&1 splitcat && echo 1>&2 "install splitcat" && return 1
  ! type >/dev/null 2>&1 terminal-truncate && echo 1>&2 "install terminal-truncate" && return 1
  [[ $# -lt 2 ]] && echo "$(basename "$0") [filepath] [filepath]" && return 1
  local filepath_1="$1"
  local filepath_2="$2"
  splitcat <(bat "$filepath_1" -p --color=always) <(bat "$filepath_2" -p --color=always)
}

# FMI: [dateコマンドの使い方: UNIX/Linuxの部屋]( http://x68000.q-e-d.net/~68user/unix/pickup?date )
# [shell \- Unix: sleep until the specified time \- Super User]( https://superuser.com/questions/222301/unix-sleep-until-the-specified-time )
# [Bash: Sleep until a specific time/date \- Stack Overflow]( https://stackoverflow.com/questions/645992/bash-sleep-until-a-specific-time-date )
function bomb() {
  if [[ $# == 0 ]] || [[ $1 =~ ^(-h|-{1,2}help)$ ]]; then
    echo "$0 "'<sleep time>'
    echo "sleep time: e.g. 12:34, 01/23 12:34, 1 min, 1 day"
    echo "cmd: e.g. bomb 10 min && git push"
    return 1
  fi
  local date_cmd='date'
  if [[ $(uname) == "Darwin" ]]; then
    ! type >/dev/null 2>&1 gdate && echo 'install gdate' && return 1
    date_cmd='gdate'
  fi
  local str="$*"
  local unix_time
  unix_time=$($date_cmd -d "$str" "+%s") || return 1
  remain_time=$(($($date_cmd -d "$str" "+%s") - $($date_cmd "+%s")))
  echo '[LOG] bomb is set at'"$YELLOW" $($date_cmd -d "$str") "$DEFAULT"'until' "$PURPLE"$(displaytime $remain_time)"$DEFAULT"
  sleep $remain_time
  echo "${RED}"'BOMB!!'"${DEFAULT}"
}

# FYI: [bash \- Displaying seconds as days/hours/mins/seconds? \- Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/27013/displaying-seconds-as-days-hours-mins-seconds )
function displaytime() {
  local T=$1
  local D=$((T / 60 / 60 / 24))
  local H=$((T / 60 / 60 % 24))
  local M=$((T / 60 % 60))
  local S=$((T % 60))
  (($D > 0)) && printf '%d days ' $D
  (($H > 0)) && printf '%d hours ' $H
  (($M > 0)) && printf '%d minutes ' $M
  (($D > 0 || $H > 0 || $M > 0)) && printf 'and '
  printf '%d seconds\n' $S
}

# NOTE: 高速化とするために，xargsで複数の値を一括で処理する設計とした
# 1. check size
# 2. check md5sum
function pipe_same_file_check() {
  if [[ ! -p /dev/stdin ]]; then
    echo 1>&2 "e.g. find . | pipe_same_file_check <target file>"
    return 1
  fi
  [[ $# -lt 1 ]] && echo "$(basename "$0") <target file>" && return 1
  local filepath
  local size
  local md5_ret
  filepath=$1
  [[ -d $filepath ]] && echo 1>&2 "$filepath is dir" && return 1
  md5_checksum=$(md5sum $filepath | cut -f 1 -d " ")
  if [[ $(uname) == "Darwin" ]]; then
    size=$(stat -f%z $filepath)
    xargs -I{} stat -f%z:%N '{}' | grep "^$size:" | cut -d: -f2 | xargs -I{} md5sum '{}' | grep "^$md5_checksum"
  else
    size=$(stat --printf="%s" $filepath)
    xargs -I{} stat --printf="%s:%n\n" '{}' | grep "^$size:" | cut -d: -f2 | xargs -I{} md5sum '{}' | grep "^$md5_checksum"
  fi
}

# NOTE: maybe you can use below command also
# du -sS | cut -f1
# macでは-Sが使えず，Bのsuffixがついてしまう
function stat_file_size() {
  if [[ $(uname) == "Darwin" ]]; then
    stat -f%z "$@"
  else
    stat --printf="%s\n" "$@"
  fi
}

# NOTE: how to use: cat /bin/echo | pipe_exec "$@"
function pipe_exec() {
  local tmpfile=$(mktemp)
  cat >$tmpfile
  chmod u+x $tmpfile
  $tmpfile "$@"
}

function tmpguidiropen() {
  local tmpdir=$(mktemp -d "/tmp/$(basename $0).$$.tmp.XXXXXX")
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
  $(basename "$0") [files or dirs]
EOF
    return 1
  fi
  for arg in "$@"; do
    echo "generating $arg link"
    ln -s "$PWD/$arg" "$tmpdir"
  done
  open "$tmpdir"
}

cmdcheck pyenv && function pyenv() {
  command pyenv "$@"
  local exit_code=$?
  if [[ $exit_code == 0 ]] && [[ $1 == 'local' ]] && [[ $1 == 'global' ]]; then
    echo 1>&2 "$YELLOW[LOG] start pyenv rehash"
    pyenv rehash
    local exit_code=$?
    echo 1>&2 "$YELLOW[LOG] end pyenv rehash"
  fi
  return $exit_code
}

# FYI: [unlinkコマンドは使い方に注意しないといけない危険なコマンド \- Qiita]( https://qiita.com/Kyou13/items/4a6742bf1cf260d96b29 )
# safe unlink wrapper command
function unlink() {
  local fail_flag=0
  for arg in "$@"; do
    if [[ -e "$arg" ]] && [[ ! -L "$arg" ]]; then
      fail_flag=1
      echo 1>&2 "${RED}[WARN]ヽ(*゜д゜)ノ: '$arg' is not symbolic link${DEFAULT}"
    fi
  done
  if [[ $fail_flag != 0 ]]; then
    return 1
  fi
  command unlink "$@"
}

if cmdcheck ranger; then
  # FYI: [ranger\-cdをzshで使えるようにした \- 生涯未熟]( https://syossan.hateblo.jp/entry/2017/02/04/192111 )
  function ranger() {
    if [[ $# == 0 ]]; then
      ranger-cd "$@"
    else
      # NOTE: avoid recursive open ranger
      if [ -z "$RANGER_LEVEL" ]; then
        command ranger "$@"
      else
        exit
      fi
    fi
  }
  alias r='ranger-cd'
  function ranger-cd() {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" "${@:-$PWD}"
    local exit_code=$?
    if [[ -f "$tempfile" ]]; then
      local new_wd=$(cat -- "$tempfile")
      if [ "$new_wd" != "$PWD" ]; then
        cd -- "$new_wd"
      fi
      rm -f -- "$tempfile"
    fi
    return $exit_code
  }
fi

function mktempfifo() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
  $(basename "$0") <id>
EOF
    return 1
  fi

  # NOTE: ubuntu: /tmp/$USER, mac: /var/folders/55/wjyjz80d6dz4gtmx3dl4qtk40000gn/T/
  if [[ -z $TMPDIR ]]; then
    echo "${RED}Please set \$TMPDIR${DEFAULT}"
    return 1
  fi

  local id="$1"

  local tmp_dirpath="${TMPDIR}/tmp-fifo-dir"
  mkdir -p "$tmp_dirpath"
  local tmpfifo_filepath="$tmp_dirpath/$id"
  if [[ ! -e "$tmpfifo_filepath" ]]; then
    mkfifo "$tmpfifo_filepath"
  fi
  echo "$tmpfifo_filepath"
}

alias catfifo='fifocat'
function fifocat() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
$(basename "$0") <id>
e.g. git diff | fifocat git-diff-fifo
     fifocat git-diff-fifo | git apply
EOF
    return 1
  fi

  local id="$1"
  local fifo_filepath=$(mktempfifo "$id")
  if [[ -p /dev/stdin ]] && [[ -p /dev/stdout ]]; then
    command cat >$fifo_filepath | command cat $fifo_filepath
  elif [[ -p /dev/stdin ]]; then
    command cat >$fifo_filepath
  fi
  if [[ ! -p /dev/stdin ]] || [[ -p /dev/stdout ]]; then
    command cat $fifo_filepath
  fi
}
if cmdcheck peco; then
  alias fifocatrm='rmfifocat'
  function rmfifocat() {
    local tmp_dirpath="${TMPDIR}/tmp-fifo-dir"
    local ret=$(find "$tmp_dirpath" -type p | perl -pe "s:^(.*/tmp-fifo-dir/)(.*)$:${GRAY}\$1${LIGHT_BLUE}\$2${DEFAULT}:g" | peco | tr '\n' ' ')
    [[ -n $ret ]] && print -z ' rm -f '"$ret"
  }
fi

function addr2func() {
  if [[ $1 =~ ^(-h|-{1,2}help)$ ]] || [[ $# == 1 ]]; then
    echo "$0 "'elf_filepath [hex style addrs...]'
    return 1
  fi

  local tmpfile=$(mktemp)
  local OBJDUMP=${OBJDUMP:-objdump}
  local elf_filepath=$1
  shift
  $OBJDUMP -d --prefix-addresses -l "$elf_filepath" | awk '/^_.*:$/{file=""} /^\// { file=$1 } /^[0-9a-fA-F]+ / {printf "%s %s", $1, $2; if (file!=""){ printf ":%s", file}; printf "\n"; }' >"$tmpfile"
  local output=($(
    {
      for arg in "$@"; do
        local orig_addr=$arg
        local addr=${arg##0x}
        cat "$tmpfile" \
          | grep -E "^[0 ]*$addr" \
          | awk '{objdump_addr=$1; func_name=$2; printf("%s %s\n", "'"$orig_addr"'", func_name); }'
      done
    } | awk 'NF'
  ))
  if [[ "${#output[@]}" == "0" ]]; then
    echo 1>&2 "objdump filter ends with 0 result"
    return 1
  fi
  if [[ -p /dev/stdin ]]; then
    perl -ne 'BEGIN { @src_pts=(); @dst_pts=(); $pts_len=$#ARGV / 2; while($#ARGV > 0){ push(@src_pts, shift); push(@dst_pts, shift); }; } for ($i = 0; $i < $pts_len; $i++){ s/@src_pts[$i]/@dst_pts[$i]/; } print $_' "${output[@]}"
  else
    printf '%s ' "${output[@]}" | tr ' ' '\n' | awk '{if (NR>1 && NR%2==1) {printf "\n";} printf "%s", $0; if (NR%2!=0) {printf " ";}}'
  fi
}

function jenkins-lint() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
  $(basename "$0") filepath
EOF
    return 1
  fi
  if [[ -z "$JENKINS_SERVER" ]]; then
    echo 1>&2 "Not found JENKINS_SERVER environment variable e.g. JENKINS_SERVER=http://jenkins.example.com"
    return 1
  fi
  local JENKINS_PIPELINE_GROOVY_FILEPATH=$1
  local result=$(curl --silent -X POST -F "jenkinsfile=<$(readlink -f $JENKINS_PIPELINE_GROOVY_FILEPATH)" $JENKINS_SERVER/pipeline-model-converter/validate)
  printf '%s\n' "$result"
  if ! (printf '%s' "$result" | grep -q "Jenkinsfile successfully validated."); then
    return 1
  fi
}

# FYI: [If you need to 'diff' two dmesg files, you will find that the timestamps cause diff\-noise\. Remove the timestamps so that you get to the underlying diff\. · GitHub]( https://gist.github.com/kbingham/c96812ed4e6c26f1c0264a022ab91a88 )
function dmesg-T-diff() {
  local file1=$1
  local file2=$2
  if [[ $# -lt 2 ]]; then
    command cat <<EOF 1>&2
$(basename "$0") file1 file2
e.g.
DMESG_DIFF=diff $(basename "$0") file1 file2
default
DMESG_DIFF=icdiff $(basename "$0") file1 file2
EOF
    return 1
  fi

  local DMESG_DIFF=${DMESG_DIFF:-icdiff}

  # for log: dmesg -T
  local STRIP_TS='s/^\[[0-9 a-zA-Z:]*]//'

  if [[ "$DMESG_DIFF" == "icdiff" ]]; then
    icdiff -U 1 --line-numbers \
      --label="$file1" <(sed -E "$STRIP_TS" "$file1") \
      --label="$file2" <(sed -E "$STRIP_TS" "$file2")
  else
    command diff -u \
      --label="$file1" <(sed -E "$STRIP_TS" "$file1") \
      --label="$file2" <(sed -E "$STRIP_TS" "$file2")
  fi
}

alias ctrace='set_command_logger'
alias cmdtrace='set_command_logger'
function set_command_logger() {
  local target_command=$1
  local log_output_filepath=${2:-$(mktemp "/tmp/$(basename $0).$$.tmp.XXXXXX")}
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
usage: $(basename "$0") <target_command> <log_output_filepath>

e.g. for tig
$(basename "$0") git <some_tty_output or file>
EOF
    return 1
  fi
  local target_command_fullpath
  target_command_fullpath=$(which -p $target_command)
  if [[ "$?" != 0 ]]; then
    echo 1>&2 "'$target_command' not found"
    return 1
  fi
  local tmpdir=$(mktemp -d "/tmp/$(basename $0).$$.tmp.XXXXXX")
  mkdir -p "$tmpdir"
  local dummy_command_path="$tmpdir/$target_command"

  cat >"$dummy_command_path" <<EOF
#!/usr/bin/env bash
printf '$target_command %s\\n' "\$*" >> "$log_output_filepath"
$target_command_fullpath "\$@"
EOF
  chmod u+x "$dummy_command_path"
  export PATH="$tmpdir:$PATH"

  echo 1>&2 "${YELLOW}[LOG] Add '$tmpdir' to \$PATH for dummy '$target_command'"
  echo 1>&2 "${YELLOW}[LOG] See output: less +F '$log_output_filepath'"
}

function ntimes() {
  if [[ $# -lt 2 ]]; then
    command cat <<EOF 1>&2
usage: $0 repeat-number commands...
EOF
    return 1
  fi
  local number=$1
  shift
  for i in $(seq $number); do
    $@
  done
}

alias help='run-help'

function svg-extension() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
usage: $0 <svg filepath>

This command inserts javascript to svg for graphviz callgraph.
Please open svg by Google Chrome (not Firefox).
EOF
    return 1
  fi

  local svg_filepath="$1"

  {
    cat <<'EOS'
  <style type="text/css">
    g:focus *:not(text) { fill: lightskyblue; stroke:midnightblue; stroke-width:2; }
  </style>
  <script><![CDATA[
EOS

    cat ~/dotfiles/local/scripts/svg-extension.js

    cat <<'EOS'
  ]]>
  </script>
EOS
  } | sed -i '/^ viewBox=/r /dev/stdin' "$svg_filepath"
}

function pack() {
  if [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
description: generate file generation command
usage: $(basename "$0") [files... or dirs...]
EOF
    return 1
  fi

  local tmpfile=$(mktemp)
  echo " echo '"$(
    {
      for arg in "$@"; do
        echo "$arg"
      done
    } | {
      if command tar -cvz -T - -f "$tmpfile" 1>&2; then
        command cat "$tmpfile"
        rm -f "$tmpfile"
        echo 1>&2 '\033[32m✔[success] copy file generation command to clipboard\033[0m'
      else
        echo 1>&2 '\033[31m✗[failure] copy file generation command to clipboard\033[0m'
      fi
    } | { [[ $(uname) == 'Darwin' ]] && base64 || base64 -w 0; }
  )"' | { [[ \$(uname) == 'Darwin' ]] && base64 -D || base64 -d; } | tar -C . -xvz" | c
}

function journalctl-diff() {
  if [[ $# -lt 2 ]]; then
    command cat <<EOF 1>&2
usage: $(basename "$0") <file1> <file2>
EOF
    return 1
  fi
  local file1=$1
  local file2=$2
  tmpfile1=$(mktemp "/tmp/$(basename $file1).XXXXX")
  tmpfile2=$(mktemp "/tmp/$(basename $file1).XXXXX")
  cat "$file1" | cut -c17- >"$tmpfile1"
  cat "$file2" | cut -c17- >"$tmpfile2"
  git diff --word-diff --no-index -- "$tmpfile1" "$tmpfile2"
}

function calc-hex() {
  bash -s -- "$@" <<'FUNC_EOF'
  if [[ $# == 0 ]]; then
    command cat <<EOF 1>&2
usage: $0
cal-hex "0x10 ** 2"
cal-hex 0x100 + 0x20
cal-hex 2#100 + 4#10
EOF
    return 1
  fi

  ret=$(echo $(($@)))
  base2ret=$(echo "obase=2; $ret" | bc)

  printf "( 2 be) %s  \n" $base2ret
  printf '( 8 be) %#o \n' $ret
  printf "(10 be) %s  \n" $ret
  printf '(16 be) 0X%016X \n' $ret

  # 64bit
  ret_le=$(((ret << 8 & 0xff00ff00ff00ff00) | (ret >> 8 & 0x00ff00ff00ff00ff)))
  ret_le=$(((ret_le << 16 & 0xffff0000ffff0000) | ret_le >> 16 & 0x0000ffff0000ffff))
  ret_le=$(((ret_le << 32 & 0xffffffff00000000) | ret_le >> 32))
  printf '(16 le) 0X%016X\n' $ret_le

  # 32bit
  ret_le=$(((ret << 8 & 0xff00ff00) | (ret >> 8 & 0xff00ff)))
  ret_le=$(((ret_le << 16 & 0xffff0000) | ret_le >> 16))
  printf '(16 le) 0X%08X\n' $ret_le

  echo

  ret=$(echo $(($ret / 1024)))
  base2ret=$(echo "obase=2; $ret" | bc)

  printf "( 2) %8s KB\n" $base2ret
  printf '( 8) %#8o KB\n' $ret
  printf "(10) %8s KB\n" $ret
  printf '(16) %#8X KB\n' $ret

  echo

  ret=$(echo $(($ret / 1024)))
  base2ret=$(echo "obase=2; $ret" | bc)

  printf "( 2) %8s MB\n" $base2ret
  printf '( 8) %#8o MB\n' $ret
  printf "(10) %8s MB\n" $ret
  printf '(16) %#8X MB\n' $ret
FUNC_EOF
}
