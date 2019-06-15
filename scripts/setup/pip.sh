#!/usr/bin/env bash

set -ex

[[ $1 == '--sudo' ]] && function pip() {
  sudo -E pip "$@"
} && function pip2() {
  sudo -E pip2 "$@"
} && function pip3() {
  sudo -E pip3 "$@"
}
! type >/dev/null 2>&1 pip && type >/dev/null 2>&1 pip3 && function pip() {
  if [[ $1 == '--sudo' ]]; then
    sudo -E pip3 "$@"
  else
    pip3 "$@"
  fi
}

# --------------------------------
# NOTE: as tools
# --------------------------------

pip install autopep8
pip install flake8
pip install jedi
pip3 install cpplint
pip3 install pylint
# WARN: don't run pip install pyls
pip install 'python-language-server[all]'
# for vim linting
pip install vim-vint

pip install Pygments
pip install icdiff

pip install neovim
pip3 install neovim
pip install pynvim
pip3 install pynvim

# for ptpython ptipython
pip install ptpython
pip3 install 'ipython[notebook]'
# jupyter notebook
pip3 install jupyter

# for cmake
# pip install cmake-format
pip install https://github.com/umaumax/cmake_format/archive/master.tar.gz
pip install cmakelint

# for translate
pip3 install https://github.com/umaumax/gtrans/archive/master.tar.gz

# for keybind
# NOTE: xkeysnail is used as root
if [[ "$(uname -a)" =~ Ubuntu ]]; then
  sudo -E pip3 install xkeysnail
fi

# for perf command visualization
pip3 install gprof2dot

# for yaml
pip3 install pyyaml
pip3 install yamllint

# for git
pip2 install git-tree
pip3 install webdiff

# NOTE: --user is used to avoid below message
# Could not install packages due to an EnvironmentError: [Errno 13] Permission denied: 'etree.py'
# Consider using the `--user` option or check the permissions.
# NOTE: for bookmark searcher
pip3 install --user buku

# --------------------------------
# NOTE: as library
# --------------------------------

pip3 install beautifulsoup4
pip3 install clipboard
pip3 install googletrans
pip3 install requests
pip3 install urllib3
pip3 install certifi
pip3 install clang
pip3 install bokeh
pip3 install pandas

# FYI: [Exporting Plots — Bokeh 1\.0\.4 documentation]( https://bokeh.pydata.org/en/latest/docs/user_guide/export.html )
# for bokeh svg
pip3 install selenium

# NOTE: pip install colout failed...(colout v0.5)
pip3 install https://github.com/nojhan/colout/archive/master.tar.gz
