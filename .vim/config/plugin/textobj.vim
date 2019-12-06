" WARN: don't use LazyPlug
" you must load vim-textobj-user before loading below plugins for dependency
Plug 'kana/vim-textobj-user'
" NOTE: for il
LazyPlug 'kana/vim-textobj-line'
" NOTE: for ie
LazyPlug 'kana/vim-textobj-entire'

" NOTE: for i,|a,|i2,
" let g:vim_textobj_parameter_mapping = ','
LazyPlug 'sgur/vim-textobj-parameter'

" NOTE: ic, ac for markdown codeblock
LazyPlug 'pocke/vim-textobj-markdown'

" WARN: you must add code block type for detection (e.g. ```sh ~ ```)
" Plug 'christoomey/vim-textobj-codeblock'
" NOTE: ['^```\s\?\w\+$\n', '^```$'],
" NOTE: you can't use next pattern ['^```\(\s\?\w\+\)\?$\n', '^```$'],
" because? start end end pattern maybe same one

LazyPlug 'osyo-manga/vim-textobj-from_regexp'
function! s:init_textobj()
  call textobj#user#plugin('php', {
        \   'code': {
        \     'pattern': ['<?php\>', '?>'],
        \     'select-a': 'aP',
        \     'select-i': 'iP',
        \   },
        \ })

  " number
  omap <expr> in textobj#from_regexp#mapexpr('\d\+')
  xmap <expr> in textobj#from_regexp#mapexpr('\d\+')
  " hyphen
  omap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9-]\+')
  xmap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9-]\+')
  " dot
  omap <expr> id textobj#from_regexp#mapexpr('[A-Za-z0-9.]\+')
  xmap <expr> id textobj#from_regexp#mapexpr('[A-Za-z0-9.]\+')
  " comma
  "omap <expr> ic textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
  "xmap <expr> ic textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
  " file path
  omap <expr> if textobj#from_regexp#mapexpr('[A-Za-z0-9-./~$_+]\+')
  xmap <expr> if textobj#from_regexp#mapexpr('[A-Za-z0-9-./~$_+]\+')
  " url (not complete regexp for comfortableness)
  omap <expr> iu textobj#from_regexp#mapexpr('[A-Za-z0-9\-./~$_:?=%!*()<>#:@&]\+')
  xmap <expr> iu textobj#from_regexp#mapexpr('[A-Za-z0-9\-./~$_:?=%!*()<>#:@&]\+')
  " regexp
  omap <expr> ir textobj#from_regexp#mapexpr('/.*/')
  xmap <expr> ir textobj#from_regexp#mapexpr('/.*/')
  " message
  " ()内の`|`は\\が必要みたい
  " つまり，`|`を使いたいときには`'\(xxx\\|yyy\)'`
  omap <expr> im textobj#from_regexp#mapexpr('\("\([^\\"]\\|\\.\)*"'.'\\|'."'.*'\\)")
  xmap <expr> im textobj#from_regexp#mapexpr('\("\([^\\"]\\|\\.\)*"'.'\\|'."'.*'\\)")
  " space
  omap <expr> i<Space> textobj#from_regexp#mapexpr('\S\+')
  xmap <expr> i<Space> textobj#from_regexp#mapexpr('\S\+')
endfunction

augroup textobj_init_mapping_augroup
  autocmd!
  autocmd User VimEnterDrawPost call s:init_textobj()
  " variable
  autocmd FileType * omap <expr> iv iw
  autocmd FileType * xmap <expr> iv iw
  autocmd FileType vim omap <expr> iv textobj#from_regexp#mapexpr('[:A-Za-z0-9-_]\+')
  autocmd FileType vim xmap <expr> iv textobj#from_regexp#mapexpr('[:A-Za-z0-9-_]\+')
  autocmd FileType sh,zsh,bash omap <expr> iv textobj#from_regexp#mapexpr('\${\?[$A-Za-z0-9_@#\[\]]\+}\?')
  autocmd FileType sh,zsh,bash xmap <expr> iv textobj#from_regexp#mapexpr('\${\?[$A-Za-z0-9_@#\[\]]\+}\?')
augroup END

" Requires: 'machakann/vim-swap'
" NOTE: press 'v' -> 'i,'
omap i, <Plug>(swap-textobject-i)
xmap i, <Plug>(swap-textobject-i)
omap a, <Plug>(swap-textobject-a)
xmap a, <Plug>(swap-textobject-a)

" [Vimメモ : vim\-expand\-regionでビジュアルモードの選択領域を拡大／縮小 \- もた日記]( https://wonderwall.hatenablog.com/entry/2016/03/31/231621 )
" il: 'kana/vim-textobj-line'
" ie: 'kana/vim-textobj-entire'
" 'iv' my command
" 'ih' my command
" 'id' my command
" ic, ac: 'pocke/vim-textobj-markdown' for codeblock
LazyPlug 'terryma/vim-expand-region'
vmap j <Plug>(expand_region_expand)
vmap k <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'iv'  :0,
      \ 'ih'  :0,
      \ 'id'  :0,
      \ 'i<'  :0,
      \ 'a<'  :0,
      \ 'i"'  :0,
      \ 'a"'  :0,
      \ 'i''' :0,
      \ 'a''' :0,
      \ 'i`'  :0,
      \ 'a`'  :0,
      \ 'ic'  :0,
      \ 'ac'  :0,
      \ 'i]'  :1,
      \ 'a]'  :1,
      \ 'ib'  :1,
      \ 'ab'  :1,
      \ 'iB'  :1,
      \ 'aB'  :1,
      \ 'il'  :0,
      \ 'ip'  :0,
      \ 'ie'  :0,
      \ }

" NOTE:
" 下記を追加すると，判定に時間がかかるらしく，待機時間がつらいので，導入しない
" \ 'i,'  :0,
" \ 'a,'  :0,

" NOTE: oによるカーソル位置によってはexapnd or shrink
" expand range one char both side
function! s:expand_visual_range(n)
  " NOTE: up and down move
  if visualmode() ==# 'V'
    if a:n > 0
      execute "normal! gv\<Down>"
    elseif a:n < 0
      execute "normal! gv\<Up>"
    endif
    return
  endif

  let pos=getpos('.')
  if a:n > 0
    execute "normal! gv\<Right>o\<Left>o"
  elseif a:n < 0
    execute "normal! gv\<Left>o\<Right>o"
  endif
endfunction

vnoremap <silent> J :<C-u>call <SID>expand_visual_range(1)<CR>
vnoremap <silent> K :<C-u>call <SID>expand_visual_range(-1)<CR>
