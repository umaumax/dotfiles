FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server git tree wget less vim tmux zsh sudo curl golang-go

# to avoid perl locale warning
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN locale-gen en_US.UTF-8
# enable emoji(fullwidth chars)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y language-pack-ja
RUN update-locale LANG=ja_JP.UTF-8

# replace user, uid, gid by adding below flags at docker build
# --build-arg user="$USER" --build-arg uid="$UID" --build-arg gid="$GID"
ARG user=docker
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${uid} ${user} && \
      useradd -u ${uid} -g ${user} -r ${user} && \
      mkdir /home/${user} && \
      chown ${uid}:${gid} -R /home/${user}

RUN usermod -aG sudo ${user}
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ${user}
WORKDIR /home/${user}
