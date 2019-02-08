#!/usr/bin/env bash
! type git-wget >/dev/null 2>&1 && echo "Please install 'https://github.com/umaumax/git-wget'" && exit 1

# init setup
mkdir -p ~/local/bin
cd ~/local/bin

set -ex
export GIT_WGET_TMP_DIR=~/.config/git-wget/
git wget https://github.com/umaumax/wgit/blob/master/wgit.sh -O wgit
git wget https://github.com/umaumax/oressh/blob/master/oressh
git wget https://github.com/umaumax/diff-filter/blob/master/diff-filter.awk -O diff-filter
git wget https://github.com/stedolan/git-ls/blob/master/git-ls
git wget https://github.com/umaumax/git-url/blob/master/git-url.sh -O git-url
git wget https://github.com/dmnd/git-diff-blame/blob/master/git-diff-blame
git wget https://github.com/umaumax/imv/blob/master/imv.sh -O imv
git wget https://github.com/umaumax/clip-share/blob/master/clip-share.sh -O clip-share
git wget https://github.com/paulirish/git-recent/blob/master/git-recent
git wget https://github.com/umaumax/wcat/blob/master/wcat.sh -O wcat
git wget https://github.com/umaumax/comment_asm/blob/master/comment_asm.awk -O comment_asm
git wget https://github.com/umaumax/lessbat/blob/master/lessbat.sh -O lessbat
git wget https://github.com/umaumax/findtar/blob/master/findtar.sh -O findtar
git wget https://github.com/umaumax/awkst/blob/master/awkst.awk -O awkst
git wget https://github.com/umaumax/oresed/blob/master/oresed.sh -O oresed
git wget https://github.com/umaumax/sshpass_wrapper/blob/master/autosshpass.sh -O autosshpass
ln -sf autosshpass autoscppass && ln -sf autosshpass autorsyncpass

# only for ubuntu
if [[ "$(uname -a)" =~ Ubuntu ]]; then
	git wget https://github.com/umaumax/window-toggle/blob/master/window-toggle.sh -O window-toggle
	git wget https://github.com/umaumax/window-toggle/blob/master/wintoggle.sh -O wintoggle
fi

# NOTE: update itself (run at the end)
git wget https://github.com/umaumax/git-wget/blob/master/git-wget
