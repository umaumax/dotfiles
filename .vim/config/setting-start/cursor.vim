function! s:cursor_position_register()
  " NOTE: disable this function of no name buffer
  let b:cursor_position_history = get(b:, 'cursor_position_history', [getpos("'`")])
  let b:cursor_position_history_index = get(b:, 'cursor_position_history_index', 0)

  let pos=getpos('.')
  let head_pos=b:cursor_position_history[b:cursor_position_history_index]
  " NOTE: [1]:line
  let cursor_same_area_th=10
  if abs(pos[1]-head_pos[1]) > cursor_same_area_th
    let b:cursor_position_history += [pos]
    " NOTE: move cursor to top
    let b:cursor_position_history_index=len(b:cursor_position_history)-1
  endif
endfunction
function! Set_cursor_position(direction)
  let index=b:cursor_position_history_index+a:direction
  if 0<=index && index<len(b:cursor_position_history)
    call setpos('.',b:cursor_position_history[index])
    let b:cursor_position_history_index=index
  else
    echom "you can't move cursor any more!"
  endif
endfunction
augroup cursor_position_register_group
  autocmd!
  autocmd InsertEnter,CmdlineEnter,TextYankPost * call <SID>cursor_position_register()
augroup END

" NOTE: change listを利用する形式では，保存時のカーソル位置も登録してしまい，現在のファイル行数がそれ未満になったときに
" E19: Mark has invalid line number
" nnoremap gb g;
" nnoremap gn g,
nnoremap <silent> gb :call Set_cursor_position(-1)<CR>
nnoremap <silent> gn :call Set_cursor_position(1)<CR>

if &rtp =~ 'vim-submode'
  " cursor move to back or next
  call submode#enter_with('move_cursor', 'n', '', 'gb', ':call Set_cursor_position(-1)<CR>')
  call submode#enter_with('move_cursor', 'n', '', 'gn', ':call Set_cursor_position(1)<CR>')
  call submode#map('move_cursor',        'n', '', 'b',  ':call Set_cursor_position(-1)<CR>')
  call submode#map('move_cursor',        'n', '', 'n',  ':call Set_cursor_position(1)<CR>')
endif
