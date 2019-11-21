#!/usr/bin/env zsh

if ! [[ -f /opt/ros/kinetic/setup.zsh ]]; then
  return
fi

# source setup file automatically
source /opt/ros/kinetic/setup.zsh

function tmp_force_pyenv_system_shell_start() {
  if type >/dev/null 2>&1 pyenv; then
    # NOTE: ubuntu16.04 default python version is 2.7.12
    TMP_PYENV_SHELL=${TMP_PYENV_SHELL:-system}
    pyenv shell $TMP_PYENV_SHELL
  fi
}

function tmp_force_pyenv_system_shell_end() {
  if type >/dev/null 2>&1 pyenv; then
    pyenv shell --unset
  fi
}

ros_cmds=(
  rosbag
  roscd
  rosclean
  roscore
  rosdep
  rosed
  roscreate-pkg
  roscreate-stack
  rosrun
  roslaunch
  roslocate
  rosmake
  rosmsg
  rosnode
  rospack
  rosparam
  rossrv
  rosservice
  rosstack
  rostopic
  rosversion
  rxbag
  rxdeps
  rxgraph
  rxplot
  #
  gendeps
  #
  rqt
  rqt_bag
  rqt_deps
  rqt_graph
  rqt_plot
  #
  rviz
  #
  catkin_make
  catkin_create_pkg
)

for ros_cmd in "${ros_cmds[@]}"; do
  type >/dev/null 2>&1 $ros_cmd && alias $ros_cmd="$(
    cat <<EOF | tr '\n' ' '
  () {
    tmp_force_pyenv_system_shell_start;
    $ros_cmd "\$@";
    local exit_code=\$?;
    tmp_force_pyenv_system_shell_end;
    return \$exit_code;
  }
EOF
  )"
done

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

  # NOTE: なぜが，pushd, popdがうまくいかない
  # (rosのdevel setup script sourceの内部でcdを行っているのでは?)
  # pushd $ros_ws_root >/dev/null 2>&1
  local _PWD="$PWD"
  cd $ros_ws_root >/dev/null 2>&1
  # NOTE: force append compile_commands.json option
  command catkin_make -DCMAKE_EXPORT_COMPILE_COMMANDS=1 "$@"
  local exit_code=$?
  if [[ $exit_code == 0 ]]; then
    local setup_zsh_filepath="./devel/setup.zsh"
    [[ -f $setup_zsh_filepath ]] && source "$setup_zsh_filepath"
    # NOTE: disable for cpu usage
    # pgrep rdm >/dev/null 2>&1 && rc -J build
  fi
  # popd >/dev/null 2>&1
  cd "$_PWD" >/dev/null 2>&1
  # NOTE: pop CPATH
  export CPATH="$_CPATH"
  # NOTE: to update info from builded files
  cmdcheck direnv && direnv allow >/dev/null 2>&1
  return $exit_code
}
alias ctcl='catkin_make_all_clean'
alias ctmk_clean_all='catkin_make_all_clean'
function catkin_make_all_clean() {
  local ros_ws_root=$(rosroot)
  [[ ! -d $ros_ws_root ]] && echo "${RED}Not a ros repository${DEFAULT}, but if this is first catkin_make to init, please run 'command catkin_make'" && return 1
  [[ -d "$ros_ws_root/src" ]] && rm -rf "$ros_ws_root/build" "$ros_ws_root/devel" "$ros_ws_root/install" || echo "\033[0;31m"'here is not catkin workspace'"\033[0m"
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
  local dirpath=$PWD
  while :; do
    local target_filepath="$dirpath/src/CMakeLists.txt"
    if [[ -L "$target_filepath" ]] && [[ $(basename $(readlink $target_filepath)) == 'toplevel.cmake' ]]; then
      printf '%s' "$dirpath"
      return
    fi
    [[ "$dirpath" == "/" ]] && break || dirpath="$(dirname $dirpath)"
  done
  return 1
}

function rosbag_to_image() {
  [[ $# -lt 4 ]] && echo "$(basename "$0") <rosbag filepath> <image topic> <output dir> <filename_format>\n e.g. xxx.bag /xxx/yyy images_out frame%04d.png " && return 1
  local tmpfile="/tmp/$(mktemp "$(basename $0).$$.tmp.XXXXXX")"
  function abs_path() {
    perl -MCwd -le '
    for (@ARGV) {
      if ($p = Cwd::abs_path $_) {
        print $p;
      } else {
        warn "abs_path: $_: $!\n";
        $ret = 1;
      }
    }
    exit $ret' "$@"
  }
  # NOTE: you must use abs filepath
  local rosbag_abs_filepath=$(abs_path $1)
  local image_topic=$2
  local output_abs_dirpath=$(abs_path $3)
  local filename_format=$4
  mkdir -p "$output_abs_dirpath"
  cat >$tmpfile <<EOF
<launch>
  <arg name="rosbag" default="$rosbag_abs_filepath"/>
  <arg name="image_topic" default="$image_topic"/>
  <arg name="output_dir" default="$output_abs_dirpath"/>
  <arg name="filename_format" default="$filename_format"/>
  <node pkg="rosbag" type="play" name="rosbag" args="-d 2 \$(arg rosbag)"/>
  <node name="extract" pkg="image_view" type="extract_images" respawn="false" output="screen">
    <remap from="image" to="\$(arg image_topic)"/>
    <param name="filename_format" value="\$(arg output_dir)/\$(arg filename_format)" />
  </node>
</launch>
EOF
  roslaunch $tmpfile
}

if cmdcheck peco; then
  alias roscdpeco='roscdpeco_local'
  function roscdpeco_global() {
    local ret=$(
      rospack list | awk '{printf "%-40s:%s\n", $1, $2}' | peco | awk '{print $1}'
    )
    [[ -n $ret ]] && roscd $ret
  }
  function roscdpeco_local() {
    local ros_ws_root=$(rosroot)
    [[ ! -d $ros_ws_root ]] && echo "${RED}Not a ros repository${DEFAULT}" && return 1
    local ret=$(
      (
        echo "workspace_root $ros_ws_root"
        rospack list
      ) \
        | grep $ros_ws_root | awk '{printf "%-40s:%s\n", $1, $2}' | peco | awk '{print $1}'
    )
    [[ -n $ret ]] && roscd $ret
  }

  function rostopicpeco() {
    local ret=$(rostopic list | peco)
    [[ -n $ret ]] && ROSTOPIC="$ret" && echo "\$ROSTOPIC=$ROSTOPIC"
  }
fi
