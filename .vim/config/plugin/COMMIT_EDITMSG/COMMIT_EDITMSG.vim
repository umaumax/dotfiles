" NOTE: only for normal git commit (when using --amend without git add, this plugin is disabled)
" NOTE: you can't add {'for':'gitcommit'}
Plug 'rhysd/committia.vim'
" NOTE: don't use hook with lazy plug load
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  call s:committia_hooks_edit_open(a:info)
endfunction
function! s:committia_hooks_edit_open(info)
  " Additional settings
  setlocal spell

  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
    startinsert
  endif

  " Scroll the diff window from insert mode
  map <buffer><S-Down> <Plug>(committia-scroll-diff-down-half)
  map <buffer><S-Up> <Plug>(committia-scroll-diff-up-half)
endfunction

" augroup committia_hooks_group
"   autocmd!
"   autocmd User VimEnterDrawPost if &ft == 'gitcommit' | call s:committia_hooks_edit_open({'vcs':'git'}) | endif
" augroup END
