#!/usr/bin/env bash
# Required: pyenv, virtualenv
if [[ ! -d ~/.pyenv/plugins/pyenv-virtualenv ]]; then
	git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
fi

pyenv install 2.7.15
pyenv install 3.6.5
pyenv virtualenv 2.7.15 neovim2
pyenv virtualenv 3.6.5 neovim3
pyenv shell neovim2
pyenv exec pip install neovim
pyenv which python
# $HOME/.pyenv/versions/neovim2/bin/python
pyenv shell neovim3
pyenv exec pip install neovim
pyenv which python
# $HOME/.pyenv/versions/neovim3/bin/python

# curl -kL https://bootstrap.pypa.io/get-pip.py | python
