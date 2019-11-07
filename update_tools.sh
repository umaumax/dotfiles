#!/usr/bin/env bash
! type git-wget >/dev/null 2>&1 && echo "Please install 'https://github.com/umaumax/git-wget'" && exit 1

# init setup
mkdir -p ~/local/bin
cd ~/local/bin

set -ex
export GIT_WGET_TMP_DIR=~/.config/git-wget/

zsh_completion_dirpath="$HOME/local/share/zsh/site-functions/"
mkdir -p "$zsh_completion_dirpath"

git wget https://github.com/umaumax/wgit/blob/master/wgit
git wget https://github.com/umaumax/oressh/blob/master/oressh
git wget https://github.com/umaumax/diff-filter/blob/master/diff-filter
git wget https://github.com/umaumax/git-sed/blob/master/git-sed
git wget https://github.com/umaumax/git-sed/blob/master/git-fixedsed
git wget https://github.com/umaumax/git-shadow/blob/master/git-shadow
git wget https://github.com/umaumax/git-shadow/blob/master/_git_shadow -O "$zsh_completion_dirpath/"
git wget https://github.com/umaumax/git-at/blob/master/git-at
git wget https://github.com/umaumax/git-at/blob/master/_git_at -O "$zsh_completion_dirpath/"
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

git wget https://github.com/umaumax/yaml-sort/blob/master/_yaml-sort -O "$zsh_completion_dirpath/"
git wget https://github.com/umaumax/dotorphan/blob/master/_dotorphan -O "$zsh_completion_dirpath/"

git wget https://github.com/paulirish/git-recent/blob/master/git-recent
git wget https://github.com/stedolan/git-ls/blob/master/git-ls
git wget https://github.com/dmnd/git-diff-blame/blob/master/git-diff-blame
git wget https://github.com/nornagon/git-rebase-all/blob/master/git-rebase-all
git wget https://github.com/unixorn/git-extra-commands/blob/master/bin/git-pylint
git wget https://github.com/unixorn/git-extra-commands/blob/master/bin/git-rename-branches
git wget https://github.com/tj/git-extras/blob/master/bin/git-touch
# NOTE: Can't locate DiffHighlight.pm in @INC (you may need to install the DiffHighlight module)
# git wget https://github.com/so-fancy/diff-so-fancy/blob/master/diff-so-fancy
# USE: brew install diff-so-fancy or use the fatpack version
# FYI: [Can't locate DiffHighlight\.pm in @INC \(Windows 10\) · Issue \#265 · so\-fancy/diff\-so\-fancy]( https://github.com/so-fancy/diff-so-fancy/issues/265 )
# wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
git wget https://github.com/so-fancy/diff-so-fancy/blob/master/third_party/build_fatpack/diff-so-fancy

git wget https://github.com/jantman/misc-scripts/blob/master/dot_find_cycles.py
# NOTE: for wrap script by python3
cat >dot_find_cycles <<'EOF'
#!/usr/bin/env bash
python3 "$(dirname $0)/dot_find_cycles.py" $@
EOF
chmod u+x dot_find_cycles

# only for ubuntu
if [[ "$(uname -a)" =~ Ubuntu ]]; then
  git wget https://github.com/umaumax/window-toggle/blob/master/window-toggle
  git wget https://github.com/umaumax/window-toggle/blob/master/wintoggle
fi

git wget https://github.com/umaumax/git-wget/blob/master/_git_wget -O "$zsh_completion_dirpath/"
# NOTE: update itself (run at the end)
git wget https://github.com/umaumax/git-wget/blob/master/git-wget
