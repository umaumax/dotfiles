#!/usr/bin/env bash
tag='ubuntu20.04-dotfiles:latest'

docker build -t $tag \
  --build-arg user="$(id -F)" --build-arg uid="$(id -u)" --build-arg gid="$(id -g)" .
