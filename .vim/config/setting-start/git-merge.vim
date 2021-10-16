function! s:diffget()
  let cursor_line=getpos('.')[1]
  let cursor_index=cursor_line-1
  let ours_index=-1
  let theirs_index=-1
  let border_index=-1
  " NOTE: for debug
  "   let lines=[
  "         \"dummy",
  "         \"<<<<<<< Updated upstream",
  "         \"FATE is cute!",
  "         \"=======",
  "         \"NANOHA is cute!",
  "         \">>>>>>> Stashed changes",
  "         \"dummy",
  "         \]
  let lines=getline(1,'$')
  for i in range(cursor_index, 0, -1)
    if lines[i] =~# '^<<<<<<<'
      let ours_index=i
      break
    endif
  endfor
  for i in range(cursor_index, len(lines)-1, 1)
    if lines[i] =~# '^>>>>>>>'
      let theirs_index=i
      break
    endif
  endfor
  if ours_index!=-1 && theirs_index != -1
    for i in range(ours_index, theirs_index, 1)
      if lines[i] =~# '^======='
        let border_index=i
        break
      endif
    endfor
  endif
  if border_index == -1
    echom 'Here is not conflict block!'
    return v:false
  endif
  if cursor_index == border_index
    echom 'Cursor is on border line! Move ours or theirs block!'
    return v:false
  endif
  let new_lines=[]
  if cursor_index < border_index
    let new_lines=lines[ours_index+1:border_index-1]
    echom 'Accept ours'
  else
    let new_lines=lines[border_index+1:theirs_index-1]
    echom 'Accept theirs'
  endif
  " NOTE: delet line
  silent! execute ':'.(ours_index+1).','.(theirs_index+1).'!:'
  call append(ours_index, new_lines)
  return v:true
endfunction

" NOTE: a: accept, adopt
nnoremap <silent> <Leader>ga :call <SID>diffget()<CR>
" NOTE: p: pickup
" nnoremap <silent> <Leader>gp :call <SID>diffget()<CR>

" NOTE: move to next conflict codes
nnoremap <silent> <Leader>gn :call search('=======')<CR>
nnoremap <silent> <Leader>gN :call search('=======','b')<CR>
