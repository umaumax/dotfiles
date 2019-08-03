#!/usr/bin/env bash
! type git-wget >/dev/null 2>&1 && echo "Please install 'https://github.com/umaumax/git-wget'" && exit 1

# init setup
mkdir -p ~/local/bin
cd ~/local/bin

set -ex
export GIT_WGET_TMP_DIR=~/.config/git-wget/
git wget https://github.com/umaumax/wgit/blob/master/wgit
git wget https://github.com/umaumax/oressh/blob/master/oressh
git wget https://github.com/umaumax/diff-filter/blob/master/diff-filter
git wget https://github.com/umaumax/git-sed/blob/master/git-sed
git wget https://github.com/umaumax/git-sed/blob/master/git-fixedsed
git wget https://github.com/umaumax/git-url/blob/master/git-url
git wget https://github.com/umaumax/imv/blob/master/imv
git wget https://github.com/umaumax/clip-share/blob/master/clip-share
git wget https://github.com/umaumax/wcat/blob/master/wcat
git wget https://github.com/umaumax/comment_asm/blob/master/comment_asm
git wget https://github.com/umaumax/lessbat/blob/master/lessbat
git wget https://github.com/umaumax/findtar/blob/master/findtar
git wget https://github.com/umaumax/awkst/blob/master/awkst
git wget https://github.com/umaumax/oresed/blob/master/oresed
git wget https://github.com/umaumax/sedry/blob/master/sedry
git wget https://github.com/umaumax/sshpass_wrapper/blob/master/autosshpass
git wget https://github.com/umaumax/sshpass_wrapper/blob/master/autoscppass
git wget https://github.com/umaumax/sshpass_wrapper/blob/master/autorsyncpass
ln -sf autosshpass autooresshpass

git wget https://github.com/paulirish/git-recent/blob/master/git-recent
git wget https://github.com/stedolan/git-ls/blob/master/git-ls
git wget https://github.com/dmnd/git-diff-blame/blob/master/git-diff-blame
git wget https://github.com/nornagon/git-rebase-all/blob/master/git-rebase-all
# NOTE: Can't locate DiffHighlight.pm in @INC (you may need to install the DiffHighlight module)
# git wget https://github.com/so-fancy/diff-so-fancy/blob/master/diff-so-fancy
# USE: brew install diff-so-fancy or use the fatpack version
# FYI: [Can't locate DiffHighlight\.pm in @INC \(Windows 10\) · Issue \#265 · so\-fancy/diff\-so\-fancy]( https://github.com/so-fancy/diff-so-fancy/issues/265 )
# wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
git wget https://github.com/so-fancy/diff-so-fancy/blob/master/third_party/build_fatpack/diff-so-fancy

git wget https://github.com/jantman/misc-scripts/blob/master/dot_find_cycles.py
ln -sf dot_find_cycles.py dot_find_cycles

# only for ubuntu
if [[ "$(uname -a)" =~ Ubuntu ]]; then
  git wget https://github.com/umaumax/window-toggle/blob/master/window-toggle
  git wget https://github.com/umaumax/window-toggle/blob/master/wintoggle
fi

# NOTE: update itself (run at the end)
git wget https://github.com/umaumax/git-wget/blob/master/git-wget
