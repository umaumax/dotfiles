# dotfiles

## how to run
```
# git clone https://github.com/umaumax/dotfiles.git
# NOTE: 途中でexecが入るため，この方法は不可
# cat ~/dotfiles/docker/ubuntu1604/README.md | grep -v "^#" | grep -v "^\`" | bash
```

## init script
```
sudo apt-get install -y git wget curl zsh sudo
git clone https://github.com/umaumax/dotfiles.git
cd ~/dotfiles
./link.sh
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
~/dotfiles/scripts/setup/apt-get.sh
~/dotfiles/scripts/setup/pip.sh
~/dotfiles/scripts/setup/npm.sh
~/dotfiles/scripts/setup/go.sh

# ~/dotfiles/scripts/setup/ros.sh

nugget peco
nugget tig
nugget tmux
nugget rtags
nugget fzy
nugget fzf
nugget bat

# NOTE: DISPLAY env?
# nvimの画面が起動しないときにはsshで接続し直すと解決した
nugget nvim
nugget vim_deoplete

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
