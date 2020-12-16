#!/usr/bin/env bash

set -eu

# how to list installed extensions
# code --list-extensions

extensions=(
  jebbs.plantuml
  shd101wyy.markdown-preview-enhanced
  artdiniz.quitcontrol-vscode
  GitHub.vscode-pull-request-github
  jebbs.plantuml
  wayou.vscode-todo-highlight
  shardulm94.trailing-spaces
  mosapride.zenkaku

  # for unity
  ms-dotnettools.csharp
  ms-vscode.mono-debug
  k--kato.docomment
  Unity.unity-debug
  zrachod.mono-snippets
)
for extension in "${extensions[@]}"; do
  echo $'\e[92m'"$extension"$'\e[m'
  code --install-extension "$extension"
done
