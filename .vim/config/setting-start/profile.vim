" e.g.
" vim +'call ProfileCursorMove()' .zshrc
" cat ~/.log/vim-profile.log
" see "FUNCTIONS SORTED ON TOTAL TIME"
function! ProfileCursorMove() abort
  "   let g:profile_file = tempname()
  let g:profile_file =  expand('~/.log/vim-profile.log')

  if filereadable(g:profile_file)
    call delete(g:profile_file)
  endif

  normal! gg
  normal! zR

  execute 'profile start ' . g:profile_file
  profile func *
  profile file *

  " NOTE: 一定時間動作しない状態で終了する
  augroup ProfileCursorMove
    autocmd!
    autocmd CursorHold <buffer> profile pause | q
    "     autocmd CursorHold <buffer> profile pause | echo "profile file path\n".g:profile_file | q
  augroup END

  " NOTE: 指定したカーソル位置で指定した動作を行う
  call cursor(45,0)
  for i in range(100)
    " NOTE: 非同期
    "     call feedkeys('j')
    call feedkeys('l')
  endfor
endfunction
