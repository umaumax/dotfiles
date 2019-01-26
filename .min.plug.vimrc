if has('nvim')
  set runtimepath+=~/.vim
else
  source $VIMRUNTIME/defaults.vim
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! -bang -nargs=* Pt
      \ call fzf#vim#grep(
      \   'pt --column --ignore=.git --global-gitignore '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:100%')
      \           : fzf#vim#with_preview({ 'dir': s:find_git_root(),'up':'100%' }),
      \   <bang>0)
call plug#end()
