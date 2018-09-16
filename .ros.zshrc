# ros
# auto source
[[ -f /opt/ros/kinetic/share/rosbash/roszsh ]] && source /opt/ros/kinetic/share/rosbash/roszsh

# for catkin_make shortcut (auto catkin work dir detection)
alias ctm='cmk'
alias ctmk='cmk'
function cmk() {
	local ros_ws_root=$(rosroot)
	[[ ! -d $ros_ws_root ]] && echo "${RED}Not a ros repository${DEFAULT}" && return 1
	pushd $ros_ws_root >/dev/null 2>&1
	catkin_make "$@"
	popd >/dev/null 2>&1
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
