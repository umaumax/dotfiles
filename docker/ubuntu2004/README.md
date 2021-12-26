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
./local/scripts/setup/apt-get.sh
./local/scripts/setup/apt-get-ppa.sh
./local/scripts/setup/pip.sh
./local/scripts/setup/npm.sh
# NOTE: run after npm.sh
./local/scripts/setup/yarn.sh
./local/scripts/setup/go.sh

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

./local/scripts/setup/cargo.sh

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
