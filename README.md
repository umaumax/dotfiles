# dotfiles

oreore dotfiles

## how to install
``` bash
git clone --recursive https://github.com/umaumax/dotfiles.git "$HOME/dotfiles"
```

## update
``` bash
git submodule update -i

# for the first time
./deploy.sh

# after setup
./update_tools.sh # or colorbash ./update_tools.sh

# for update dotfiles
git-update-dummy-alias
.config/gdb/update.sh
```

## vim setup
* first  time:  open vim and puts `:PlugInstall`
* second time~: open vim and puts `:PlugUpdate` and `:PlugUpgrade`

## Karabiner-Element for Mac setup
use `~/.config/karabiner/assets/complex_modifications/*.json`

## NOTE
* `.gitignore`: This `.gitignore` file is for this repo not for a host machine setting.
* `.config/git/ignore`: This will be link to `~/.config/git/ignore`
* `.local.git_template`: This template is for `.git_template` (basically, use `~/dotfiles/.git_template/`, maybe not needed)

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
* `~/.local.compile_flags.txt`

### how to test
#### neosnippet
``` bash
./neosnippet/neosnippet_lint.sh
```
