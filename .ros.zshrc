# ros
# auto source
[[ -f /opt/ros/kinetic/setup.zsh ]] && source /opt/ros/kinetic/setup.zsh

# for catkin_make shortcut (auto catkin work dir detection)
alias ctm='catkin_make'
alias ctmk='catkin_make'
alias cmk='catkin_make'
function catkin_make() {
	# NOTE: push CPATH
	local _CPATH="$CPATH"
	unset CPATH
	local ros_ws_root=$(rosroot)
	[[ ! -d $ros_ws_root ]] && echo "${RED}Not a ros repository${DEFAULT}, but if this is first catkin_make to init, please run 'command catkin_make'" && return 1

	# NOTE: なぜが，pushd, popdがうまくいかない(ros sourceの関係上?)
	# 	pushd $ros_ws_root >/dev/null 2>&1
	local _PWD="$PWD"
	cd $ros_ws_root >/dev/null 2>&1
	# NOTE: force append compile_commands.json option
	command catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1 "$@"
	local exit_code=$?
	if [[ $exit_code == 0 ]]; then
		local setup_zsh_filepath="./devel/setup.zsh"
		[[ -f $setup_zsh_filepath ]] && source "$setup_zsh_filepath"
		pgrep rdm >/dev/null 2>&1 && rc -J build
	fi
	# 	popd >/dev/null 2>&1
	cd "$_PWD" >/dev/null 2>&1
	# NOTE: pop CPATH
	export CPATH="$_CPATH"
	# NOTE: to update info from builded files
	cmdcheck direnv && direnv allow >/dev/null 2>&1
	return $exit_code
}
function ros_gitignore_download() {
	local ros_ws_root=$(rosroot)
	[[ ! -d $ros_ws_root ]] && echo "${RED}Not a ros repository${DEFAULT}" && return 1
	(
		curl -L http://www.gitignore.io/api/ros
		echo 'CMakeLists.txt'
		echo '!*/CMakeLists.txt'
	) | tee $ros_ws_root/src/.gitignore
}

function cdrosroot() {
	local ros_ws_root=$(rosroot)
	[[ ! -d $ros_ws_root ]] && echo "${RED}Not a ros repository${DEFAULT}" && return 1
	cd $ros_ws_root
}
function rosroot() {
	local dirpath=$PWD && while true; do
		local target_filepath="$dirpath/src/CMakeLists.txt"
		if [[ -L "$target_filepath" ]] && [[ $(basename $(readlink $target_filepath)) == 'toplevel.cmake' ]]; then
			echo $dirpath
			return
		fi
		[[ "$dirpath" == "/" ]] && break || local dirpath="$(dirname $dirpath)"
	done
	return 1
}

if cmdcheck peco; then
	function rostopicpeco() {
		local ret=$(rostopic list | peco)
		[[ -n $ret ]] && ROSTOPIC="$ret" && echo "\$ROSTOPIC=$ROSTOPIC"
	}
fi
