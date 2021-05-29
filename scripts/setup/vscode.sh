#!/usr/bin/env bash

set -eu

# how to list installed extensions
# code --list-extensions

remote_option=0
if [[ $# -gt 0 ]]; then
  if [[ $1 == "--remote" ]]; then
    remote_option=1
    echo $'\e[95m'"[ENABLE REMOTE OPTION]"$'\e[m'
    shift
  fi
fi

extensions=(
  Atishay-Jain.All-Autocomplete
  BriteSnow.vscode-toggle-quotes
  CoenraadS.bracket-pair-colorizer
  GitHub.vscode-pull-request-github
  # only for Python, TypeScript/JavaScript and Java
  VisualStudioExptTeam.vscodeintellicode
  YoshinoriN.current-file-path
  ZakCodes.rust-snippets
  artdiniz.quitcontrol-vscode
  be5invis.toml
  bierner.markdown-preview-github-styles
  bwildeman.tabulous
  christian-kohler.path-intellisense
  eamodio.gitlens
  high-moctane.nextword
  ionutvmi.path-autocomplete
  jebbs.plantuml
  mhutchie.git-graph
  mosapride.zenkaku
  ms-python.python
  ms-python.vscode-pylance
  oderwat.indent-rainbow
  rust-lang.rust
  ryu1kn.text-marker
  shardulm94.trailing-spaces
  shd101wyy.markdown-preview-enhanced
  sygene.auto-correct
  tranhl.find-then-jump
  wayou.vscode-todo-highlight
  zhengxiaoyao0716.intelligence-change-case
)

if [[ "$(uname)" =~ Windows ]]; then
  extensions=("${extensions[@]}"
    cweijan.vscode-autohotkey-plus
    ms-vscode.powershell
    slevesque.vscode-autohotkey
  )
fi

if [[ $(uname) == "Darwin" ]]; then
  extensions=("${extensions[@]}"
    ms-vscode-remote.vscode-remote-extensionpack
    praveencrony.total-lines

    # for unity
    ms-dotnettools.csharp
    ms-vscode.mono-debug
    k--kato.docomment
    Unity.unity-debug
    zrachod.mono-snippets
  )
fi

for extension in "${extensions[@]}"; do
  echo $'\e[92m'"$extension"$'\e[m'
  if [[ "$remote_option" == 0 ]]; then
    code --install-extension "$extension"
  else
    code --extensions-dir ~/.vscode-server/extensions --install-extension "$extension"
  fi
done
