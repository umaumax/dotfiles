#!/usr/bin/env zsh
#
function wmopen() {
  # NOTE: default filepath is clipboard
  local filepath=${1:-$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard')}
  local default_drive=${DEFAULT_WMOPEN_DRIVE:-e}
  local drive=${2:-$(printf '%s' "$filepath" | sed -E 's/^(([a-zA-Z]):)?.*$/\2/g')}
  [[ -z $drive ]] && drive="$default_drive"
  filepath=$(printf '%s' "$filepath" | sed -E -e 's/[a-zA-Z]://g' -e 's:/home/[^/]+|~:.:g' | sed 's:/:\\:g')
  echo "$drive:\\$filepath"
  /mnt/c/Windows/explorer.exe "$drive:\\$filepath"
}
