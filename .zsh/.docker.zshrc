if ! cmdcheck docker; then
  return
fi

alias docker-remove-all-container='docker rm $(docker ps -aq)'
alias docker-remove-image='docker images | peco | awk "{print \$3}" | pipecheck xargs -L 1 docker rmi'
alias docker-stop='docker ps | peco | awk "{print \$1}" | pipecheck xargs -L 1 docker stop'
alias docker-stop-all='docker stop $(docker ps -aq)'
alias docker-start='docker ps -a | peco | awk "{print \$1}" | pipecheck xargs -L 1 docker start'
# to avoid 'the input device is not a TTY'
function docker-attach() {
  local container_id=$(docker ps | peco | awk '{print $1}')
  [[ -n $container_id ]] && docker attach $container_id
}
function docker-inspect() {
  local container_id=$(docker ps | peco | awk '{print $1}')
  [[ -n $container_id ]] && docker inspect $container_id
}
function docker-exec() {
  # NOTE: sudo su with '-' cause "Session terminated, terminating shell..." message when C-c is pressed ... why?
  # local login_shell="env zsh || env bash"
  # NOTE: sudo suを行わない場合と比較してLANGの設定が変化する(sudo suのみでは~/.zprofileは実行されていないっぽい)
  # local login_shell='type sudo >/dev/null 2>&1 && exec sudo su $(whoami) || type zsh >/dev/null 2>&1 && exec zsh -l || type bash >/dev/null 2>&1 && exec bash -l'
  local login_shell='type zsh >/dev/null 2>&1 && exec zsh -l || type bash >/dev/null 2>&1 && exec bash -l'
  [[ $1 == '--bash' ]] && local login_shell='exec bash -l'

  local container_id=$(docker ps | peco | awk '{print $1}')
  local val=$(stty size)
  local rows=$(echo $val | cut -d ' ' -f 1)
  local cols=$(echo $val | cut -d ' ' -f 2)
  [[ -z $container_id ]] && return

  echo "${YELLOW}[HINT]${DEFAULT}[relogin command]:"' sudo su $(whoami)'
  docker exec -it $container_id /bin/bash -c "stty rows $rows cols $cols; eval '$login_shell'"
}
function docker-start-and-attach() {
  local container_id=$(docker ps -a | peco | awk '{print $1}')
  [[ -n $container_id ]] && docker start $container_id && docker attach $container_id
}
function docker-remove-container() {
  local container_id=$(docker ps -a | peco | awk '{print $1}')
  [[ -n $container_id ]] && { echo "$container_id" | xargs -L1 docker rm; }
}
function docker-container-id() {
  local ret=$(docker ps | peco | awk '{print $1}')
  [[ -n $ret ]] && CONTAINER_ID="$ret" && echo "\$CONTAINER_ID=$CONTAINER_ID"
}
alias de='docker-exec'
alias dexec='docker-exec'
alias da='docker-attach'
alias dattach='docker-attach'
alias ds='docker-start'
alias dsa='docker-start-and-attach'
alias dls='docker ps'
alias dlsa='docker ps -a'
alias did='docker-container-id'

function docker-mount() {
  if [[ $1 =~ ^(-h|-{1,2}help)$ ]] || [[ $# -lt 3 ]]; then
    command cat <<EOF 1>&2
usage:
$(basename "$0") <container_id> <host_path> <container_path>

lazy mount volume to docker container

e.g.
$(basename "$0") xxxxxxxx ./ws ~/ws
$(basename "$0") xxxxxxxx ./ws/hoge ~/ws/hoge
EOF
    return 1
  fi

  if ! type >/dev/null 2>&1 docker-enter; then
    echo 1>&2 "not found docker-enter"
    return 1
  fi

  local CONTAINER="$1"
  local HOST_PATH="$2"
  local CONTAINER_PATH="$3"

  local RED=$'\e[31m'
  local GREEN=$'\e[32m'
  local YELLOW=$'\e[33m'
  local BLUE=$'\e[34m'
  local DEFAULT=$'\e[0m'
  (
    set -e

    REALPATH=$(readlink --canonicalize $HOST_PATH)
    # e.g. FILESYS=/
    FILESYS=$(df -P $REALPATH | tail -n 1 | awk '{print $6}')
    # below command is also ok
    # FILESYS=$(stat --printf '%m' $REALPATH)

    # for getting DEV_HOST_ROOT (e.g. /dev/sda2)
    while read DEV_HOST_ROOT MOUNT _JUNK; do
      [[ $MOUNT == $FILESYS ]] && break
    done </proc/mounts
    [[ $MOUNT == $FILESYS ]] # sanity check

    # for getting SUBROOT which is mount point of $DEV_HOST_ROOT (e.g. /)
    while read _MOUNT_ID _PARENT_MOUNT_ID _DEV_MAJOR_MINOR_NUMBER SUBROOT MOUNT _JUNK; do
      [[ $MOUNT == $FILESYS ]] && break
    done </proc/self/mountinfo
    [[ $MOUNT == $FILESYS ]] # sanity check

    SUBPATH=$(perl -MCwd -le '$target=shift; $prefix=shift; if ((rindex $target, $prefix, 0) == 0) { $target=substr($target, length($prefix)); } print $target' "$REALPATH" "$FILESYS")
    # e.g. "18 12" decimal number of major device and minor device pair
    DEVDEC=$(printf "%d %d" $(stat --format "0x%t 0x%T" $DEV_HOST_ROOT))

    # use sh for no bash docker container
    # WARN: busybox mdnod has no long option --mode
    docker-enter $CONTAINER true || return 1
    docker-enter $CONTAINER sh -c "[ -b $DEV_HOST_ROOT ] || mknod -m 0600 $DEV_HOST_ROOT b $DEVDEC"
    docker-enter $CONTAINER mkdir -p /tmpmnt
    docker-enter $CONTAINER sh -c "mountpoint -q /tmpmnt/ || mount '$DEV_HOST_ROOT' /tmpmnt"
    docker-enter $CONTAINER mkdir -p "$CONTAINER_PATH"
    docker-enter $CONTAINER mount -o bind "/tmpmnt/$SUBROOT/$SUBPATH" "$CONTAINER_PATH"
    docker-enter $CONTAINER umount /tmpmnt
    docker-enter $CONTAINER rmdir /tmpmnt

    echo "$BLUE""[✔] mount success""$DEFAULT"
    echo "$YELLOW""HOST:""$GREEN""$HOST_PATH""$DEFAULT"" to 🐳""$YELLOW""$CONTAINER:""$GREEN""$CONTAINER_PATH""$DEFAULT"
    echo "$YELLOW""unmount command:""$GREEN"" docker-enter $CONTAINER umount $CONTAINER_PATH""$DEFAULT"
  ) || {
    echo "$RED""[✗] mount failure""$DEFAULT"
    return 1
  }
}

function docker-umount() {
  if [[ $1 =~ ^(-h|-{1,2}help)$ ]] || [[ $# -lt 1 ]]; then
    command cat <<EOF 1>&2
usage:
$(basename "$0") <container_id> <container_path>

umount volume at docker container

e.g.
$(basename "$0") xxxxxxxx ~/ws
$(basename "$0") xxxxxxxx ~/ws/hoge
EOF
    return 1
  fi

  if ! type >/dev/null 2>&1 docker-enter; then
    echo 1>&2 "not found docker-enter"
    return 1
  fi

  local CONTAINER="$1"
  local CONTAINER_PATH="$2"

  (
    set -e
    if [[ -z "$CONTAINER_PATH" ]]; then
      # list up
      echo "$BLUE""[ext4 mount list]""$DEFAULT"
      docker-enter $CONTAINER mount -t ext4
    else
      docker-enter $CONTAINER umount "$CONTAINER_PATH"
      echo "$BLUE""[✔] umount success""$DEFAULT"
    fi
  )
  if [[ $? != 0 ]]; then
    echo "$RED""[✗] umount failure""$DEFAULT"
    return 1
  fi
}

type >/dev/null 2>&1 nsenter && function docker-simple-enter() {
  local container="$1"
  if [ -z "$container" ]; then
    echo "Usage: $0 CONTAINER [COMMAND ARGS...]"
    echo
    docker ps
    return 1
  fi
  shift
  if [[ $# == 0 ]]; then
    set -- "/bin/bash"
  fi
  sudo nsenter -m -u -i -n -p -t "$(docker inspect --format {{.State.Pid}} "$container")" "$@"
}
