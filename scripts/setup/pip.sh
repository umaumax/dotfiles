#!/usr/bin/env bash

[[ $1 == '--sudo' ]] && sudo su

# --------------------------------
# NOTE: as tools
# --------------------------------

pip install autopep8
pip install flake8
pip install jedi
pip3 install pylint
pip install python-language-server
pip install vim-vint

pip install Pygments
pip install icdiff

pip install neovim
pip3 install neovim

# for ptpython ptipython
pip install ptpython
pip3 install "ipython[notebook]"
# jupyter notebook
pip install jupyter

# for cmake
# pip install cmake-format
pip install https://github.com/umaumax/cmake_format/archive/master.tar.gz
pip install cmakelint

# --------------------------------
# NOTE: as library
# --------------------------------

pip install beautifulsoup4
pip install clipboard
pip install googletrans
pip install requests
pip install urllib3
pip install certifi
pip install clang
