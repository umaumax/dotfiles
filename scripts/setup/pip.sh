#!/usr/bin/env bash

set -ex

[[ $1 == '--sudo' ]] && function pip() {
	sudo -E pip "$@"
} && function pip3() {
	sudo -E pip3 "$@"
}

# --------------------------------
# NOTE: as tools
# --------------------------------

pip install autopep8
pip install flake8
pip install jedi
pip3 install cpplint
pip3 install pylint
pip install python-language-server
# for vim linting
pip install vim-vint

pip install Pygments
pip install icdiff

pip install neovim
pip3 install neovim

# for ptpython ptipython
pip install ptpython
pip3 install "ipython[notebook]"
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
sudo -E pip3 install xkeysnail

# for perf command visualization
pip3 install gprof2dot

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

# NOTE: pip install colout failed...(colout v0.5)
pip3 install https://github.com/nojhan/colout/archive/master.tar.gz
