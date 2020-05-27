#!/usr/bin/env bash
! type git-wget >/dev/null 2>&1 && echo "Please install 'https://github.com/umaumax/git-wget'" && exit 1

BLACK=$'\e[30m' RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m' PURPLE=$'\e[35m' LIGHT_BLUE=$'\e[36m' WHITE=$'\e[37m' GRAY=$'\e[90m' DEFAULT=$'\e[0m'

echo_log() {
  echo "${GREEN}$*${DEFAULT}" 1>&2
}

download() {
  local url="$1"
  echo_log "[LOG] download $url"
  git wget "$@"
}

echo_log "[LOG] init setup"

LOCAL_BIN_PATH="${LOCAL_BIN_PATH:-$HOME/local/bin}"
mkdir -p "$LOCAL_BIN_PATH"
cd "$LOCAL_BIN_PATH"

set -e
export GIT_WGET_TMP_DIR=~/.config/git-wget/

zsh_completion_dirpath="$HOME/local/share/zsh/site-functions/"
mkdir -p "$zsh_completion_dirpath"

# ====

echo_log "[LOG] start download"

download https://github.com/umaumax/wgit/blob/master/wgit
download https://github.com/umaumax/oressh/blob/master/oressh
download https://github.com/umaumax/diff-filter/blob/master/diff-filter
download https://github.com/umaumax/git-sed/blob/master/git-sed
download https://github.com/umaumax/git-sed/blob/master/git-fixedsed
download https://github.com/umaumax/git-shadow/blob/master/git-shadow
download https://github.com/umaumax/git-shadow/blob/master/_git_shadow -O "$zsh_completion_dirpath/"
download https://github.com/umaumax/git-at/blob/master/git-at
download https://github.com/umaumax/git-at/blob/master/_git_at -O "$zsh_completion_dirpath/"
download https://github.com/umaumax/git-url/blob/master/git-url
download https://github.com/umaumax/imv/blob/master/imv
download https://github.com/umaumax/clip-share/blob/master/clip-share
download https://github.com/umaumax/wcat/blob/master/wcat
download https://github.com/umaumax/comment_asm/blob/master/comment_asm
download https://github.com/umaumax/lessbat/blob/master/lessbat
download https://github.com/umaumax/findtar/blob/master/findtar
download https://github.com/umaumax/awkst/blob/master/awkst
download https://github.com/umaumax/oresed/blob/master/oresed
download https://github.com/umaumax/sedry/blob/master/sedry
download https://github.com/umaumax/sshpass_wrapper/blob/master/autosshpass
download https://github.com/umaumax/sshpass_wrapper/blob/master/autoscppass
download https://github.com/umaumax/sshpass_wrapper/blob/master/autorsyncpass
ln -sf autosshpass autooresshpass
download https://github.com/umaumax/bash_onerror/blob/master/bash_onerror

download https://github.com/umaumax/yaml-sort/blob/master/_yaml-sort -O "$zsh_completion_dirpath/"
download https://github.com/umaumax/dotorphan/blob/master/_dotorphan -O "$zsh_completion_dirpath/"

download https://github.com/paulirish/git-recent/blob/master/git-recent
download https://github.com/stedolan/git-ls/blob/master/git-ls
download https://github.com/dmnd/git-diff-blame/blob/master/git-diff-blame
download https://github.com/nornagon/git-rebase-all/blob/master/git-rebase-all
download https://github.com/unixorn/git-extra-commands/blob/master/bin/git-pylint
download https://github.com/unixorn/git-extra-commands/blob/master/bin/git-rename-branches
download https://github.com/tj/git-extras/blob/master/bin/git-touch
# NOTE: Can't locate DiffHighlight.pm in @INC (you may need to install the DiffHighlight module)
# download https://github.com/so-fancy/diff-so-fancy/blob/master/diff-so-fancy
# USE: brew install diff-so-fancy or use the fatpack version
# FYI: [Can't locate DiffHighlight\.pm in @INC \(Windows 10\) · Issue \#265 · so\-fancy/diff\-so\-fancy]( https://github.com/so-fancy/diff-so-fancy/issues/265 )
# wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
download https://github.com/so-fancy/diff-so-fancy/blob/master/third_party/build_fatpack/diff-so-fancy

download https://github.com/jantman/misc-scripts/blob/master/dot_find_cycles.py
# NOTE: for wrap script by python3
cat >dot_find_cycles <<'EOF'
#!/usr/bin/env bash
python3 "$(dirname $0)/dot_find_cycles.py" $@
EOF
chmod u+x dot_find_cycles

# only for ubuntu
if [[ "$(uname -a)" =~ Ubuntu ]]; then
  download https://github.com/umaumax/window-toggle/blob/master/window-toggle
  download https://github.com/umaumax/window-toggle/blob/master/wintoggle
fi

# only for Mac OS X
if [[ $(uname) == "Darwin" ]]; then
  download https://github.com/Rasukarusan/fzf-chrome-active-tab/blob/master/chrome-tab-activate
  download https://github.com/umaumax/fzf-chrome-history/blob/master/chromeHistory.sh -O chromeHistory
fi

download https://github.com/umaumax/git-wget/blob/master/_git_wget -O "$zsh_completion_dirpath/"

# ----

echo_log "[LOG] update download command ifself"
download https://github.com/umaumax/git-wget/blob/master/git-wget
