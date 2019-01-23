# alacritty

[jwilm/alacritty: A cross\-platform, GPU\-accelerated terminal emulator]( https://github.com/jwilm/alacritty )

## NOTE
* corss platform
* FAST(for using GPU)
  * try tmux + nvim + scroll
* no tab, no window split
  * use tmux
* Japanese input issue
  * [Cannot input japanese characters · Issue \#1101 · jwilm/alacritty]( https://github.com/jwilm/alacritty/issues/1101 )

## how to install
### Mac OS X
```
brew cask install alacritty
```
### Ubuntu
```
wget https://github.com/jwilm/alacritty/releases/download/v0.2.7/Alacritty-v0.2.7_amd64.deb
sudo dpkg -i Alacritty-v0.2.7_amd64.deb
rm -f Alacritty-v0.2.7_amd64.deb
```

## setting file
```
~/.config/alacritty/alacritty.yml
```
