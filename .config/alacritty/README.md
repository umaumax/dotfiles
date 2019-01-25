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
#### WARN REQUIRED: libgcc1 (>= 1:8.2.0)
```
wget https://github.com/jwilm/alacritty/releases/download/v0.2.7/Alacritty-v0.2.7_amd64.deb
sudo dpkg -i Alacritty-v0.2.7_amd64.deb
# or sudo gdebi --non-interactive Alacritty-v0.2.7_amd64.deb
rm -f Alacritty-v0.2.7_amd64.deb
```

#### BEST WAY: build from src
```
if ! type rustc >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh
  export PATH="$HOME/.cargo/bin:$PATH"
fi

sudo apt-get install -y cmake libfreetype6-dev libfontconfig1-dev xclip

git clone https://github.com/jwilm/alacritty.git
git checkout v0.2.7
cd alacritty
# make -j app
cargo install cargo-deb
cargo deb --install
sudo dpkg -i target/debian/alacritty_0.2.7_amd64.deb
```

## setting file
```
~/.config/alacritty/alacritty.yml
```
