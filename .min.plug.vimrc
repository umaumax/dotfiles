if has('nvim')
  set runtimepath+=~/.vim
else
  source $VIMRUNTIME/defaults.vim
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

call plug#end()
