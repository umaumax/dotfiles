# dotfiles

## install
```sh
git clone --recursive https://github.com/umaumax/dotfiles.git "$HOME/dotfiles"
```

## update
```sh
git submodule update -i

# first time
./link.sh

# after setting end
colorbash ./link.sh
colorbash update_tools.sh
git-update-dummy-alias
```

### vim setup
<!-- [junegunn/vim\-plug: Minimalist Vim Plugin Manager]( https://github.com/junegunn/vim-plug ) -->
<!--  -->
<!-- > curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -->

* first  time:  open vim and puts `:PlugInstall`
* second time~: open vim and puts `:PlugUpdate` and `:PlugUpgrade`

### Karabiner-Element for Mac setup
* `~/.config/karabiner/assets/complex_modifications`
* [Karabiner\-Elementsの設定項目をまとめました]( https://qiita.com/s-show/items/a1fd228b04801477729c )

## others setup
<!-- * [umaumax/window\-toggle]( https://github.com/umaumax/window-toggle ) -->
<!-- * [zsh でワンライナーを手早く呼び出し実行する \- Qiita]( https://qiita.com/b4b4r07/items/c29163cf1723cccefed6 ) -->
<!-- * `snippets/snippet.txt` -->

## NOTE
* `./.gitignore`: This `.gitignore` file is for this repo not for a host machine setting.
* `./.config/git/ignore`: this will be link to ~/.gitignore
