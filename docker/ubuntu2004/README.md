# dotfiles

* use __tmux__ or __screen__ while install

## init script
```
git clone https://github.com/umaumax/dotfiles.git
cd ~/dotfiles
./deploy.sh
# relogin
command which zsh >/dev/null 2>&1 && exec $(command which zsh) -l
# set zsh as login shell
command which zsh >/dev/null 2>&1 && sudo chsh -s $(command which zsh) $(whoami)

source ~/.zshenv
source ~/.zprofile
source ~/.zshrc
```

## packages
```
~/dotfiles/scripts/setup/apt-get.sh
~/dotfiles/scripts/setup/apt-get-ppa.sh
~/dotfiles/scripts/setup/pip.sh
~/dotfiles/scripts/setup/npm.sh
# NOTE: run after npm.sh
~/dotfiles/scripts/setup/yarn.sh
~/dotfiles/scripts/setup/go.sh

nugget tig
nugget tmux
nugget rtags
nugget fzf
nugget bats
nugget pandoc
nugget googlebenchmark
nugget googletest
nugget ctop
nugget rust
nugget rust-analyzer
nugget git-webui

~/dotfiles/scripts/setup/cargo.sh

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
