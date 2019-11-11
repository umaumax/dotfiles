# dotfiles

oreore dotfiles

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
colorbash ./update_tools.sh
# for debug
# GIT_WGET_DEBUG=1 colorbash ./update_tools.sh
git-update-dummy-alias
```

### how to test
#### neosnippet
```
./neosnippet/neosnippet_lint.sh
```

## vim setup
* first  time:  open vim and puts `:PlugInstall`
* second time~: open vim and puts `:PlugUpdate` and `:PlugUpgrade`

## Karabiner-Element for Mac setup
* `~/.config/karabiner/assets/complex_modifications`
  * [Karabiner\-Elementsの設定項目をまとめました]( https://qiita.com/s-show/items/a1fd228b04801477729c )

## NOTE
* `./.gitignore`: This `.gitignore` file is for this repo not for a host machine setting.
* `./.config/git/ignore`: this will be link to `~/.gitignore`
* `./.local.git_template`: is template for `./.git_template` (基本的には，`~/dotfiles/.git_template/`を利用するので不要)
