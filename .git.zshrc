#!/usr/bin/env zsh
# MEMO
# git-xxx系はaliasではなくfunctionとすること
# 下記のコマンドではaliasは実行できないため
# NOTE: e.g. bind git open to git-open function (not command)
function git() {
	local cmd="git-$1"
	if ! cmdcheck "$cmd"; then
		command git "$@"
		return
	fi
	shift 1
	"$cmd" "$@"
}

function git-update-dummy-alias() {
	local dummy_alias_filepath="$HOME/dotfiles/.dummy_alias.gitconfig"
	cat <<'EOF' >$dummy_alias_filepath
# NOTE: dummy alias list for zsh completion
#
[alias]
EOF
	functions-list | grep '^git-' | sed -E 's/^git-(.*)$/'"$(printf '\t')"'\1 = :/g' >>~/dotfiles/.dummy_alias.gitconfig
}

# FYI: [prezto/git\-branch\-current at master · sorin\-ionescu/prezto]( https://github.com/sorin-ionescu/prezto/blob/master/modules/git/functions/git-branch-current )
# NOTE: 下記のコマンドはpreztoで実装されている
# git-branch-current
# git-commit-lost
# git-dir
# git-hub-browse
# git-hub-shorten-url
# git-info
# git-root
# git-stash-clear-interactive
# git-stash-dropped
# git-stash-recover
# git-submodule-move
# git-submodule-remove

# NOTE: unalias default? git aliases
function lambda() {
	local git_aliases=(gCa gCe gCl gCo gCt gFb gFbc gFbd gFbf gFbl gFbm gFbp gFbr gFbs gFbt gFbx gFf gFfc gFfd gFff gFfl gFfm gFfp gFfr gFfs gFft gFfx gFh gFhc gFhd gFhf gFhl gFhm gFhp gFhr gFhs gFht gFhx gFi gFl gFlc gFld gFlf gFll gFlm gFlp gFlr gFls gFlt gFlx gFs gFsc gFsd gFsf gFsl gFsm gFsp gFsr gFss gFst gFsx gR gRa gRb gRl gRm gRp gRs gRu gRx gS gSI gSa gSf gSi gSl gSm gSs gSu gSx gb gbD gbL gbM gbR gbS gbV gbX gba gbc gbd gbl gbm gbr gbs gbv gbx gc gcF gcO gcP gcR gcS gcSF gcSa gcSf gcSm gca gcam gcd gcf gcl gcm gco gcp gcr gcs gd gdc gdi gdk gdm gdu gdx gf gfa gfc gfcr gfm gfr gg ggL ggi ggl ggv ggw giA giD giI giR giX gia gid gii gir giu gix gl glb glc gld glg glo gm gmC gmF gma gmt gp gpA gpF gpa gpc gpf gpp gpt gr gra grc gri grs gs gsL gsS gsX gsa gsd gsl gsp gsr gss gsw gsx gwC gwD gwR gwS gwX gwc gwd gwr gws gwx)
	for e in ${git_aliases[@]}; do
		alias $e >/dev/null 2>&1 && unalias $e
	done
} && lambda

alias gm='git mergetool'
alias merge='git mergetool'

alias gr='cd-git-root'
alias cdgr='cd-git-root'
# [ターミナルからカレントディレクトリのGitHubページを開く \- Qiita]( https://qiita.com/kobakazu0429/items/0dc93aeeb66e497f51ae )
function git-open() {
	is_git_repo_with_message || return
	local url=$(git-url "$@")
	if [[ -n $url ]]; then
		open "$url"
	else
		open $(git remote -v | head -n 1 | awk '{ print $2 }' | awk -F'[:]' '{ print $2 }' | awk -F'.git' '{ print "https://github.com/" $0 }')
	fi
}
alias git-alias-list='git alias | sed "s/^alias\.//g" | sed -e "s:^\([a-zA-Z0-9_-]* \):\x1b[35m\1\x1b[0m:g" | sort | '"awk '{printf \"%-38s = \", \$1; for(i=2;i<=NF;i++) printf \"%s \", \$i; print \"\";}'"
function git-ranking() {
	builtin history -r 1 | awk '{ print $2,$3 }' | grep '^git' | sort | uniq -c | awk '{com[NR]=$3;a[NR]=$1;sum=sum+$1} END{for(i in com) printf("%6.2f%% %s %s \n" ,(a[i]/sum)*100."%","git",com[i])}' | sort -gr | uniq | sed -n 1,30p | cat -n
}
function vim-git-modified() {
	is_git_repo_with_message || return
	vim -p $(git diff --name-only)
}
# NOTE: あるファイルを特定のcommitのファイルの状態にする
function git-revert-files() {
	is_git_repo_with_message || return
	local target=${1:-"HEAD^"}
	git diff --name-only HEAD "$target" | awk 'BEGIN{ print "# edit below commands and run by yourself" }{ printf "git checkout \"'"$target"'\" %s\n", $0}' | vim -
}
function git-restore-stash() {
	is_git_repo_with_message || return
	git fsck --unreachable | grep commit | cut -d' ' -f3 | xargs git log --merges --no-walk --grep=WIP
	echo '--------------------------------'
	echo '--------------------------------'
	echo "$RED If you want to restore commit, put below command! $DEFAULT"
	echo "$PURPLE git cherry-pick -n -m1 <commit id> $DEFAULT"
	echo '--------------------------------'
	echo '--------------------------------'
}
function _grep_if_file_exist() {
	local git_root_path="$(git rev-parse --show-toplevel)"
	local grep='grep'
	cmdcheck 'ggrep' && local grep='ggrep'
	awk 1 | while read LINE; do
		local filepath="$git_root_path/$LINE"
		[[ -e "$filepath" ]] && $grep -E '^[><=]{7}' -C 1 -H -n --color=always "$filepath"
	done
}
# FYI: [\[Git\]コンフリクトをよりスマートに解消したい！ \- Qiita]( https://qiita.com/m-yamazaki/items/62fc1f877c7ab315e0d8 )
function git-find-conflict() {
	is_git_repo_with_message || return
	local changed=$(git diff --cached --name-only)
	[[ -z "$changed" ]] && return

	# abs path
	local _home=$(echo $HOME | sed "s/\//\\\\\//g")
	# 	local ret=$(echo $changed | xargs -L 1 -IXXX $grep -E '^[><=]{7}' -C 1 -H -n --color=always "$git_root_path/XXX" | sed "s/$_home/~/")
	local ret=$(echo $changed | _grep_if_file_exist | sed "s/$_home/~/")
	# rel path
	# 	pushd $git_root_path >/dev/null 2>&1
	# 	echo $changed | xargs -L 1 -IXXX $grep -E '^[><=]{7}' -C 1 -H -n --color=always XXX
	# 	popd >/dev/null 2>&1

	## If the egrep command has any hits - echo a warning and exit with non-zero status.
	if [[ -n $ret ]]; then
		echo $ret
		echo "${RED}WARNING: You have merge markers in the above files, lines. Fix them before committing.${DEFAULT}"
		return 1
	fi
}
function git-reload-local-hooks() {
	is_git_repo_with_message || return
	local git_templatedir=${1:-}
	[[ -n $git_templatedir ]] && [[ ! -d $git_templatedir ]] && echo "no such dir '$git_templatedir'" && return 1
	[[ -z $git_templatedir ]] && local git_templatedir="$(git rev-parse --show-toplevel)/.local$(basename $(git config init.templatedir))"
	[[ -n $git_templatedir ]] && [[ ! -d $git_templatedir ]] && echo "no local git_templatedir '$git_templatedir'" && local git_templatedir="$(git config init.templatedir | sed -e "s:^~/:$HOME/.local:g")"
	[[ -n $git_templatedir ]] && [[ ! -d $git_templatedir ]] && echo "no local git_templatedir '$git_templatedir'" && return 1
	git-reload-global-hooks "$git_templatedir"
}
function git-reload-global-hooks() {
	is_git_repo_with_message || return
	local git_templatedir=${1:-$(git config init.templatedir | sed -e "s:^~:$HOME:g")}
	[[ -z $git_templatedir ]] && echo 'no git_templatedir setings \n e.g. git config --global init.templatedir ~/.git_template/' && return 1
	[[ ! -d $git_templatedir ]] && echo "no such dir '$git_templatedir'" && return 1
	local git_hookdir="$git_templatedir/hooks"
	command cp -r "$git_hookdir/" "$(git rev-parse --show-toplevel)/.git/hooks"
}
# [Git フックの基本的な使い方 \- Qiita]( https://qiita.com/noraworld/items/c562de68a627ae792c6c#%E6%B3%A8%E6%84%8F%E7%82%B9%E3%81%BE%E3%81%A8%E3%82%81 )
function git-find-last-space() {
	git grep -e $'\t''$\| $'
}
function git-find-last-space-vim() {
	local filelist=$(git-find-last-space)
	{
		echo '# original key mapping info'
		echo '# gf: open file'
		echo '# go: next'
		echo '# gi: back'
		echo ''
		echo $filelist
	} | command vim --cmd "let g:auto_lcd_basedir=0 | autocmd VimEnter * :execute ':w '.tempname() | :lcd $PWD" -
}

cmdcheck 'git-ls' && alias gls='git-ls'
# NOTE: 差分が少ないファイルから順番にdiffを表示
function git_diff() {
	is_git_repo_with_message || return

	local diff_cmd='cdiff'
	# 	[[ $# -ge 1 ]] && local diff_cmd="$1"
	# FYI: [\[git\]git diff \-\-stat でパスを省略しない方法 \- dackdive's blog]( https://dackdive.hateblo.jp/entry/2014/05/13/112549 )
	local files=($(git diff --stat --stat-width=9999 "$@" | awk '{ print $3 " "$4 " " $1}' | sort -n | grep -v '^changed' | cut -f3 -d' '))
	local tmpfile=$(mktemp '/tmp/git.tmp.orderfile.XXXXX')
	for e in "${files[@]}"; do
		[[ -e "$e" ]] && echo $e >>$tmpfile
	done
	local files=($(cat $tmpfile))
	bash -c "cd $(git rev-parse --show-toplevel) && git '$diff_cmd' -O'$tmpfile' "'"$@"' '$0-dummy' "$@" "${files[@]}"
	[[ -e $tmpfile ]] && rm -f $tmpfile
}
alias gd='git_diff'
alias gdh='      gd HEAD'
alias gdhh='     gd HEAD~     HEAD'
alias gdhhh='    gd HEAD~~     HEAD~'
alias gdhhhh='   gd HEAD~~~    HEAD~~'
alias gdhhhhh='  gd HEAD~~~~   HEAD~~~'
alias gdhhhhhh=' gd HEAD~~~~~  HEAD~~~~'
alias gdhhhhhhh='gd HEAD~~~~~~ HEAD~~~~~'

alias gdc='       gd        --relative=.'
alias gdhc='      gdh       --relative=.'
alias gdhhc='     gdhh      --relative=.'
alias gdhhhc='    gdhhh     --relative=.'
alias gdhhhhc='   gdhhhh    --relative=.'
alias gdhhhhhc='  gdhhhhh   --relative=.'
alias gdhhhhhhc=' gdhhhhhh  --relative=.'
alias gdhhhhhhhc='gdhhhhhhh --relative=.'

alias gdw='gd --word-diff'
alias gdhw='gdh --word-diff'
alias gdhhw='gdhh --word-diff'
alias gdhhhw='gdhhh --word-diff'
alias gdhhhhw='gdhhhh --word-diff'
alias gdhhhhhw='gdhhhhh --word-diff'
alias gdhhhhhhw='gdhhhhhh --word-diff'
alias gdhhhhhhhw='gdhhhhhhh --word-diff'

alias gdcw='gdc --word-diff'
alias gdhcw='gdhc --word-diff'
alias gdhhcw='gdhhc --word-diff'
alias gdhhhcw='gdhhhc --word-diff'
alias gdhhhhcw='gdhhhhc --word-diff'
alias gdhhhhhcw='gdhhhhhc --word-diff'
alias gdhhhhhhcw='gdhhhhhhc --word-diff'
alias gdhhhhhhhcw='gdhhhhhhhc --word-diff'

alias ga='git add --all'
alias gc='git commit'
alias gadd='git add'
alias gap='git add -p'
alias gai='git add -i'
# this alias overwrite Ghostscript command
alias gs='git status'
alias gsall='git status --ignored --untracked-files'
alias gst='git status'
alias gstall='git status --ignored --untracked-files'
alias gsc='git status .'
alias gscall='git status --ignored --untracked-files .'
alias gstc='git status .'
alias gstcall='git status --ignored --untracked-files .'
alias gstp='git log HEAD...HEAD~ --stat'

alias glog='git log'
alias gstlog='git log --stat'
alias glst='git log --stat'
alias glogst='git log --stat'
alias glogstat='git log --stat'
function git-add-peco() {
	local SELECTED_FILE_TO_ADD="$(git status --short | peco | awk -F ' ' '{print $NF}')"
	if [ -n "$SELECTED_FILE_TO_ADD" ]; then
		git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')
		git status
	fi
}

# git grep settings
alias gg='git_grep_root'
alias ggr='git_grep_root'
alias ggc='git_grep_current'
alias ggpv='ggpv_root'
alias ggpvr='ggpv_root'
alias ggpvc='ggpv_current'
function ggpv_root() {
	local ret=$(git_grep_root --color=always "$@")
	[[ -n "$ret" ]] && local _=$(echo "$ret" | pecovim)
}
function ggpv_current() {
	local ret=$(git_grep_current --color=always "$@")
	[[ -n "$ret" ]] && echo $(echo "$ret" | pecovim)
}
function git_grep_root() { is_git_repo_with_message && git grep "$@" -- $(git rev-parse --show-toplevel); }
function git_grep_current() { is_git_repo_with_message && git grep "$@"; }

alias glpv='git_log_pecovim'
function git_log_pecovim() {
	is_git_repo_with_message || return 1
	pushd $(git rev-parse --show-toplevel) >/dev/null 2>&1
	echo -n $(git log --numstat --format= | sed 's/^[0-9\-]*\t[0-9\-]*\t//g' | awk '!a[$0]++' | pecovim)
	popd >/dev/null 2>&1
}

# FYI: [unicode \- grep: Find all lines that contain Japanese kanjis \- Unix & Linux Stack Exchange]( https://unix.stackexchange.com/questions/65715/grep-find-all-lines-that-contain-japanese-kanjis )
alias gg-japanese='gg -P "[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]"'
alias ggr-japanese='ggr -P "[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]"'
alias ggc-japanese='ggc -P "[\xe4-\xe9][\x80-\xbf][\x80-\xbf]|\xe3[\x81-\x83][\x80-\xbf]"'
function git-grep-japanese() { gg-japanese; }
function git-grep-japanese-root() { ggr-japanese; }
function git-grep-japanese-current() { ggc-japanese; }

alias gfvim='git ls-files | pecovim'

function is_git_repo() { git rev-parse --is-inside-work-tree >/dev/null 2>&1; }
function is_git_repo_with_message() {
	local message=${1:-"${RED}no git repo here!${DEFAULT}"}
	is_git_repo
	local code=$?
	[[ $code != 0 ]] && echo "$message" >&2
	return $code
}
if cmdcheck tig; then
	alias ts='tig status'
	function tig() {
		if [[ $# == 0 ]]; then
			command tig status
			return
		fi
		command tig "$@"
	}
fi

function find-git-repo() {
	local args=(${@})
	[[ $# -le 0 ]] && local args=(".")
	for dirpath in ""${args[@]}""; do
		local dirpath=$(echo $dirpath | sed "s:^~:$HOME:g")
		[[ ! -d $dirpath ]] && continue
		find "$dirpath" -name '.git' | sed 's:/.git$::g'
	done
}
function find-git-repo-and-show-head-commit-hash-id() {
	find-git-repo | xargs -L 1 -IXXX bash -c "cd XXX && echo XXX && git rev-parse HEAD"
}

function git-check-up-to-date() {
	target='.'
	[[ $# -ge 1 ]] && target="$1"
	# NOTE: for debug
	echo $target
	# NOTE: for suppressing of chpwd()
	ret=$(
		cd "$target" >/dev/null 2>&1
		git log "origin/master..master"
	)
	if [[ $ret != "" ]]; then
		echo "[$target]"
		echo $ret
	fi
	ret=$(
		cd "$target" >/dev/null 2>&1
		git status --porcelain
	)
	if [[ $ret != "" ]]; then
		echo "[$target] Changes not staged for commit:"
		echo $ret
	fi
}

function cdgit() {
	local git_dirs=('~/dotfiles' '~/git' '~/github.com' '~/local_git')
	local ret=$(find-git-repo "${git_dirs[@]}" | sed "s:^$HOME:~:" | peco | sed "s:^~:$HOME:g")
	[[ -n $ret ]] && cd $ret
}

function find-my-git-non-up-to-date-repo() {
	(
		echo '~/dotfiles'
		echo '~/git'
		echo '~/github.com'
		echo '~/local_git'
	) | find-git-non-up-to-date-repo-pipe
}

function find-git-non-up-to-date-repo() {
	find-git-repo "$@" | find-git-non-up-to-date-repo-pipe
}
function find-git-non-up-to-date-repo-pipe() {
	local ccze="cat"
	cmdcheck ccze && ccze="ccze -A"
	while read line || [ -n "${line}" ]; do
		git-check-up-to-date "$line" | eval $ccze
	done
}
# [Gitのルートディレクトリへ簡単に移動できるようにする関数]( https://qiita.com/ponko2/items/d5f45b2cf2326100cdbc )
function cd-git-root() {
	is_git_repo_with_message || return
	cd $(git rev-parse --show-toplevel)
}

function git-pull-all() {
	is_git_repo_with_message || return
	local current_branch=$(git rev-parse --abbrev-ref HEAD)
	for branch in $(git branch -r | grep -v HEAD); do
		# NOTE: remove e.g. 'origin/'
		local local_branch=${branch#*/}
		git checkout $local_branch
		git pull
	done
	git checkout $current_branch
}

cmdcheck diff-filter && alias git-filter='diff-filter -v file=<(git ls-files)'

# function git-diff() {
# 	git diff --color-words
# }
# function git-log-peco() {
# 	cat ~/.git-logs/*.log | peco
# }

## git
cmdcheck git && alias gl='git log --oneline --decorate --graph --branches --tags --remotes'

# [\`git remote add upstream\`を楽にする \| Tomorrow Never Comes\.]( http://blog.sgr-ksmt.org/2016/03/04/git_remote_add_upstream/ )
function git-remote-add-upstream() {
	if ! type jq >/dev/null 2>&1; then
		echo "'jq' is not installed." >&2
		return 1
	fi
	local repo=$(git config user.name)/$(basename $PWD)
	if [ $# -ge 1 ]; then
		local repo="$1"
	fi
	echo "repo: $repo"
	local upstream=$(curl -L "https://api.github.com/repos/$repo" | jq -r '.parent.full_name')
	if [ "$upstream" = "null" ]; then
		echo "upstream not found." >&2
		return 1
	fi
	echo git remote add upstream "git@github.com:${upstream}.git"
	git remote add upstream "git@github.com:${upstream}.git"
}

# NOTE: 現在のcommitにおける最新のtagを取得する
function git_tag_name() {
	local commit=$(git rev-parse HEAD)
	if [[ -n $commit ]]; then
		local desc=$(git describe --tags ${commit})
		if $(is_tag "$desc"); then
			git describe --tags ${commit} --abbrev=0
		fi
		return
	fi
}

function git_tag_message() {
	local name=$(git_tag_name)
	local msg=$(git tag -n10000 -l ${name})
	if [[ -n $msg ]]; then
		echo $msg
		local name_n=${#name}
		echo $(substr "$msg" $((name_n + 1)) ${#msg})
	fi
}

function is_tag() {
	local desc=$1
	echo -n "$desc" | perl -ne 'exit int($_ =~ /.+-[0-9]+-g[0-9A-Fa-f]{6,}$/)'
	return $?
}

function substr() { echo -n ${1:$2:${3:-${#1}}}; } #substr( str, pos[, len] )

function git-search-open() {
	open https://github.com/search
}

# FYI: [Git 管理下のファイルを一括置換する git\-sed コマンドを作った \- Qiita]( https://qiita.com/tonluqclml/items/13b323cea92425b85218 )
# HINT: git sed 's|find_by_admin|find_by(type: :admin)|g' spec/ test/
function git-sed() {
	[[ $# == 0 ]] && echo "$0 <pattern> [PATH [PATH[...]]]" >&2 && return 1
	[[ $(uname) == "Darwin" ]] && ! cmdcheck gsed && echo 'install gsed!'

	local SED=sed
	cmdcheck gsed && local SED=gsed

	local pattern="$1"
	shift

	while read -r line; do
		# NOTE: -L: symbolic link
		[[ -f "$line" ]] && [[ ! -L "$line" ]] && "$SED" -i -E -e "$pattern" "$line"
	done < <(git ls-files -- "$@")
}

function git-comments() {
	# NOTE: see GITGLOSSARY(7) <pathspec>
	# NOTE: man 7 gitglossary
	# 	git grep -E -e '(^|\s+)//' --and --not -e 'NOTE|TODO' -e '(^|\s+)#' --and --not -e 'NOTE|TODO' -- . ':!*.md' ':!*.txt' ':!*.log'
	# 	git grep -E -e '(^|\s+)//' --and --not -e 'NOTE|TODO' -e '(^|\s+)#' --and --not -e 'NOTE|TODO' -- ':CMakeLists.txt'
	git grep -E -e '(^|\s+)//' --and --not -e 'NOTE|TODO|FYI|namespace|[Cc]opyright' -- ':*.cpp' ':*.hpp' ':*.cxx' ':*.c' ':*.h' ':*.go'
	git grep -E -e '(^|\s+)#' --and --not -e 'NOTE|TODO|FYI' -- ':*.python' ':*.sh' ':*rc' ':*.zsh' ':*.ninja'
	#  	git grep -E -e '(^|\s+)#' --and --not -e 'NOTE|TODO|FYI' -- ':CMakeLists.txt'
}
function git-comments-todo() {
	git grep -E -e '(^|\s+)//' --and -e 'TODO' -e '(^|\s+)#' --and -e 'TODO' -- . ':!*.md'
}
function git-comments-note() {
	git grep -E -e '(^|\s+)//' --and -e 'NOTE' -e '(^|\s+)#' --and -e 'NOTE' -- . ':!*.md'
}
function git-comments-fix() {
	git grep -E -e '(^|\s+)//' --and -e 'FIX' -e '(^|\s+)#' --and -e 'FIX' -- . ':!*.md'
}

# NOTE: cpp private '_field' to 'field_'
function git-rename-cpp-field() {
	git-sed 's/([^_A-Za-z0-9])_([A-Za-z0-9][_A-Za-z0-9]*)/\1\2_/g' ':*.hpp' ':*.cpp' ':*.cc' ':*.cxx' ':.c' ':*.h'
}

alias gg-comments='git-comments'
alias gg-comments-todo='git-comments-todo'
alias gg-comments-note='git-comments-note'

# FYI: [git branch の結果を時間順にソート: git branch \-\-sort=\-authordate \- Islands in the byte stream]( https://gfx.hatenablog.com/entry/2016/06/10/153747 )
function git-branch-old-to-new() {
	git branch --sort=authordate
}
function git-branch-new-to-old() {
	git branch --sort=-authordate
}

function gitdiffgrep() {
	grep '^[+-]' | bat -l diff --color=always | grep "$@"
}

function vimgit() {
	[[ $# -lt 1 ]] && echo "$(basename $0) [commit hash] [files...]" && return 1
	local commit_hash=$1
	if git rev-parse --verify $commit_hash >/dev/null 2>&1; then
		shift
	else
		local commit_hash=$(_git-commit-peco)
		git rev-parse --verify $commit_hash >/dev/null 2>&1 || return 1
	fi

	local tmpfile_list=()
	for filepath in $@; do
		[[ ! -e $filepath ]] && echo "No such file $filepath" 1>&2 && continue
		local tmpfile_list=($tmpfile_list $(git show $commit_hash:$filepath 2>/dev/null | pipe_tmpfile $filepath))
	done
	vim -p ${tmpfile_list[@]}
}

function vimgitdiff() {
	[[ $# -lt 1 ]] && echo "$(basename $0) [commit hash] [files]" && return 1
	local commit_hash=$1
	if git rev-parse --verify $commit_hash >/dev/null 2>&1; then
		shift
	else
		local commit_hash=$(_git-commit-peco)
		git rev-parse --verify $commit_hash >/dev/null 2>&1 || return 1
	fi

	local filepath=$1
	[[ ! -e $filepath ]] && echo "No such file $filepath" 1>&2 && return 1
	local tmpfile=$(git show $commit_hash:$filepath 2>/dev/null | pipe_tmpfile $filepath)
	vimdiff $filepath $tmpfile
}

# NOTE: input pipe
# NOTE: output tmp filepath
function pipe_tmpfile() {
	[[ $# == 0 ]] && echo "$0 [filepath]" && return 0
	local filepath=$1
	# NOTE: 過去にも未来にも他のファイルにも重複しない名称
	local filepath_hash=$(echo "$filepath:$(date +%s%3N)" | md5sum | cut -d' ' -f1)
	local tmpfile=$(mktemp "/tmp/$filepath_hash.$(basename $filepath)")
	cat >$tmpfile
	echo "$tmpfile"
}

if $(cmdcheck fzf); then
	alias co='git checkout $(git branch -a | tr -d " " | fzf --height 100% --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")'
	function finder() {
		local ret=$(
			(
				echo '..'
				ls
			) | fzf --height 100% --prompt "file >" --preview "[[ -d {} ]] && ls {}; [[ -f {} ]] && cat {}"
		)
		[[ -d $ret ]] && cd $ret
		[[ -f $ret ]] && cat $ret
	}
	function tigl() {
		git log --color --oneline | fzf --reverse --ansi --multi --preview 'git -c color.diff=always show {+1}'
	}
fi
