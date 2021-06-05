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
skip_build_option=0
if [[ $# -gt 0 ]]; then
  if [[ $1 == "--skip-build" ]]; then
    skip_build_option=1
    echo $'\e[95m'"[SKIP INSTALL BY BUILD FROM SOURCE]"$'\e[m'
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
  streetsidesoftware.code-spell-checker
  sygene.auto-correct
  tranhl.find-then-jump
  wayou.vscode-todo-highlight
  zhengxiaoyao0716.intelligence-change-case
extensions_url=(
  https://github.com/umaumax/vscode-extension-eval/releases/download/v0.0.4/vscode-extension-eval-0.0.4.vsix
  https://github.com/umaumax/vscode-extension-autofix/releases/download/v0.0.1/vscode-extension-autofix-0.0.1.vsix
)
extensions_source_url=($(for e in ${extensions_url[@]}; do echo "$e"; done | grep -v 'vsix$' || true))
extensions_vsix_url=($(for e in ${extensions_url[@]}; do echo "$e"; done | grep 'vsix$' || true))

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

if [[ "$skip_build_option" == 0 ]]; then
  if [[ ${#extensions_source_url[@]} != 0 ]]; then
    if ! type >/dev/null 2>&1 npm; then
      echo $'\e[95m'"no npm command"$'\e[m'
      exit 1
    fi
    if ! type >/dev/null 2>&1 vsce; then
      echo $'\e[95m'"no vsce command"$'\e[m'
      exit 1
    fi
  fi
fi

tmpdir=$(mktemp -d)
pushd "$tmpdir"

# use vsix package
for extension_url in "${extensions_vsix_url[@]}"; do
  echo $'\e[92m'"$extension_url"$'\e[m'
  extension="$(basename "$extension_url")"
  wget "$extension_url" -O "$extension"
  if [[ "$remote_option" == 0 ]]; then
    code --install-extension "$extension"
  else
    code --extensions-dir ~/.vscode-server/extensions --install-extension "$extension"
  fi
done

if [[ "$skip_build_option" == 0 ]]; then
  # build from source
  for extension_url in "${extensions_source_url[@]+"${extensions_source_url[@]}"}"; do
    echo $'\e[92m'"$extension_url"$'\e[m'
    extension="$(basename "$extension_url")"
    git clone "$extension_url" -o "$extension"
    pushd "$extension"
    npm install
    vsce package
    if [[ "$remote_option" == 0 ]]; then
      code --install-extension *.vsix
    else
      code --extensions-dir ~/.vscode-server/extensions --install-extension *.vsix
    fi
    popd # pushd "$extension"
  done
fi
popd # pushd "$tmpdir"

for extension in "${extensions[@]}"; do
  echo $'\e[92m'"$extension"$'\e[m'
  if [[ "$remote_option" == 0 ]]; then
    code --install-extension "$extension"
  else
    code --extensions-dir ~/.vscode-server/extensions --install-extension "$extension"
  fi
done
