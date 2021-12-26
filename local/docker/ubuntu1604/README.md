# dotfiles

* use __tmux__ or __screen__ while install

## how to run
```
# git clone https://github.com/umaumax/dotfiles.git
# NOTE: 途中でexecが入るため，この方法は不可
# cat ~/dotfiles/local/docker/ubuntu1604/README.md | grep -v "^#" | grep -v "^\`" | bash
```

## init script
```
sudo apt-get install -y git wget curl zsh sudo
git clone https://github.com/umaumax/dotfiles.git
cd ~/dotfiles
./deploy.sh
# relogin
command which zsh >/dev/null 2>&1 && exec $(command which zsh) -l
# set zsh as login shell
command which zsh >/dev/null 2>&1 && sudo chsh -s $(command which zsh) $(whoami)

# NOTE: ここ以降は自動化可能なはず...

source ~/.zshenv
source ~/.zprofile
source ~/.zshrc
```

## packages
```
./local/scripts/setup/apt-get.sh
./local/scripts/setup/apt-get-ppa.sh
./local/scripts/setup/pip.sh
./local/scripts/setup/npm.sh
# NOTE: run after npm.sh
./local/scripts/setup/yarn.sh
./local/scripts/setup/go.sh

# ./local/scripts/setup/cpanm.sh
# ./local/scripts/setup/gem.sh
# ./local/scripts/setup/linuxbrew.sh

# nugget peco
nugget tig
nugget tmux
nugget rtags
# nugget fzy
nugget fzf
nugget bat
nugget bats
nugget pandoc
nugget googlebenchmark
nugget googletest
nugget exa
nugget ctop
nugget rust
nugget git-webui

./local/scripts/setup/cargo.sh

# NOTE: DISPLAY env?
# nvimの画面が起動しないときにはsshで接続し直すと解決した
nugget nvim
nugget nvim_deoplete

source ~/.zshenv
source ~/.zprofile
source ~/.zshrc
```

## vim
```
doctor
# nvim
# :PlugInstall
# :UpdateRemotePlugins
# :checkhealth
# :Doctor
```
