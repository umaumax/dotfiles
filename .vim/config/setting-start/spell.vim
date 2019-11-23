" #### spell check ####
" [Vim のスペルチェッカ早わかり - Alone Like a Rhinoceros Horn]( http://d.hatena.ne.jp/h1mesuke/20100803/p1 )
" ]s : next (zn)
" [s : back (zN)
" z= : list(fix)
" zg : good
" zw : wrong
" cjk disable asian language check
" f:fix
nnoremap zf z=
set spelllang=en,cjk
" set spell
" [Vimのスペルチェックのハイライトを止めて下線だけにする方法 - ジャバ・ザ・ハットリの日記]( http://tango-ruby.hatenablog.com/entry/2015/09/04/175729 )
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=9
" [Toggle spellcheck on/off in vim]( https://gist.github.com/brandonpittman/9d15134057c7267a88a8 )
function! ToggleSpellCheck()
  set spell!
  if &spell
    set spell
  else
    set nospell
  endif
endfunction
" English Check
nnoremap <silent> <Space>sp :call ToggleSpellCheck()<CR>

if &rtp =~ 'vim-submode'
  call submode#enter_with('bufmove', 'n', '', 'zn', ']s')
  call submode#map       ('bufmove', 'n', '',  'n', ']s')
  call submode#enter_with('bufmove', 'n', '', 'zN', '[s')
  call submode#map       ('bufmove', 'n', '',  'N', '[s')
endif
