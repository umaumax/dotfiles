#!/usr/bin/env bash
tag="ubuntu20.04-dotfiles"

login_shell='type zsh >/dev/null 2>&1 && exec zsh -l || type bash >/dev/null 2>&1 && exec bash -l'

proxyurl="$HTTP_PROXY"
docker run \
  -e http_proxy=${proxyurl} -e https_proxy=${proxyurl} \
  -e COLUMNS=$COLUMNS -e LINES=$LINES -e TERM=$TERM \
  -it $tag /bin/bash -c "eval $login_shell"
