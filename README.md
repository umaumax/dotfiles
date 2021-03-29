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
./deploy.sh

# after setting end
./update_tools.sh # or colorbash ./update_tools.sh
# for debug
# GIT_WGET_DEBUG=1 colorbash ./update_tools.sh
# for force update
# GIT_WGET_TMP_DIR= ./update_tools.sh

# for update
git-update-dummy-alias
.config/gdb/update.sh
```

## vim setup
* first  time:  open vim and puts `:PlugInstall`
* second time~: open vim and puts `:PlugUpdate` and `:PlugUpgrade`

## Karabiner-Element for Mac setup
* open `~/.config/karabiner/assets/complex_modifications` directory
  * FYI: [Karabiner\-Elementsの設定項目をまとめました]( https://qiita.com/s-show/items/a1fd228b04801477729c )

## NOTE
* `./.gitignore`: This `.gitignore` file is for this repo not for a host machine setting.
* `./.config/git/ignore`: This will be link to `~/.config/git/ignore`
* `./.local.git_template`: This template is for `./.git_template` (basically, use `~/dotfiles/.git_template/`, maybe not needed)
* `required`
  * tmux 3.1b or later

## VSCode for Windows setup
Run below code at PowerShell
``` ps
Invoke-WebRequest https://raw.githubusercontent.com/umaumax/dotfiles/master/.config/Code/User/settings.json    -OutFile $HOME/AppData/Roaming/Code/User/settings.json
Invoke-WebRequest https://raw.githubusercontent.com/umaumax/dotfiles/master/.config/Code/User/keybindings.json -OutFile $HOME/AppData/Roaming/Code/User/keybindings.json
```

## Windows Terminal for Windows setup
Run below code at PowerShell (__Don't run on PowerShell on Windows Terminal__)
``` ps
# for Windows Terminal
Invoke-WebRequest https://raw.githubusercontent.com/umaumax/dotfiles/master/.config/Microsoft.WindowsTerminal/settings.json -OutFile $env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
# for Windows Terminal Preview
Invoke-WebRequest https://raw.githubusercontent.com/umaumax/dotfiles/master/.config/Microsoft.WindowsTerminal/settings.json -OutFile $env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json
```

### local setting
#### files
* `~/.local.zshrc`
* `~/.local.zprofile`
* `~/.local.zshenv`
* `~/.local.vimrc`
* `~/compile_flags.local.txt`

#### commands
* `chrome-exec-set`: command for proxy setting for Ubuntu

### how to test
#### neosnippet
```
./neosnippet/neosnippet_lint.sh
```

## TODO
* [ ] use `DOTPATH` not use `~/dotfiles/` (done at deploy.sh)
* [ ] use `init.sh` which runs only once for setup
* [ ] use `update.sh`
* [ ] test docker ubuntu16.04
* [ ] test docker ubuntu18.04 and gui
