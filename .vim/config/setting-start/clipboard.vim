" OS clupboard share
" [vimのクリップボードとレジスタのコピーアンドペースト - たけし備忘録](http://takeshid.hatenadiary.jp/entry/2015/09/08/001517)
" [zshとVimでOS判定 - shkh's blog](http://shkh.hatenablog.com/entry/2012/06/17/222936)

function! s:init_clipboard()
  if has('windows')
    " NOTE: for windows
    set clipboard=unnamed,unnamedplus
  elseif has('mac') " NOTE: mac also has 'unix'
    " NOTE: for mac
    " for cui vim
    " set clipboard=unnamed,autoselect
    " for gvim and cui vim
    set clipboard=unnamed,unnamedplus
  elseif has('unix')
    " NOTE: for ubuntu
    set clipboard=unnamedplus
  endif
  execute "setlocal clipboard=".&clipboard
endfunction

call s:init_clipboard()
command! InitClipBoard :call s:init_clipboard()
