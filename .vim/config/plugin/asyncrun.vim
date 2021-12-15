" for async exec
LazyPlug 'skywind3000/asyncrun.vim'
function! s:goto_quickfix_top()
  let save_winnr = winnr()
  " `normal gg`は`|`で使用不可?
  windo if &bt=='quickfix' | call cursor(1,1) | endif
  exe save_winnr. 'wincmd w'
endfunction
augroup auto_async_quickfix_open
  autocmd!
  autocmd User AsyncRunStart call asyncrun#quickfix_toggle(16, 1)
  autocmd User AsyncRunStop  call <SID>goto_quickfix_top()
augroup END
