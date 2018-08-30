let b:cursor_position_history_index=0
let b:cursor_position_history=[getpos("'`")]
function! s:cursor_position_register()
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
function! s:set_cursor_position(direction)
  let index=b:cursor_position_history_index+a:direction
  if 0<=index && index<len(b:cursor_position_history)
    call setpos('.',b:cursor_position_history[index])
    let b:cursor_position_history_index=index
  endif
endfunction
augroup cursor_position_register_group
  autocmd!
  autocmd InsertEnter,CmdlineEnter,TextYankPost * call <SID>cursor_position_register()
augroup END

" NOTE:  change
" listを利用する形式では，保存時のカーソル位置も登録してしまい，現在のファイル行数がそれ未満になったときに
" E19: Mark has invalid line number
" nnoremap gb g;
" nnoremap gn g,
nnoremap <silent> gb :call <SID>set_cursor_position(-1)<CR>
nnoremap <silent> gn :call <SID>set_cursor_position(1)<CR>
