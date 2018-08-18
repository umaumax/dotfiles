" <C-N> on word
" repeat <C-N> or <C-X>:skip, <C-p>:prev
" c,s: change text
" I: insert at start of range
" A: insert at end of range
LazyPlug 'terryma/vim-multiple-cursors'
function! Multiple_cursors_before()
  let g:multi_cursor_inputing=1
  let b:i_triggers_mappings = s:Save_mappings(get(g:, 'i_triggers', []), 'i', 1)

  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

function! Multiple_cursors_after()
  let g:multi_cursor_inputing=0
  call s:Restore_mappings(b:i_triggers_mappings)

  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction

" -------------------------------- 

" [key bindings \- How to save and restore a mapping? \- Vi and Vim Stack Exchange]( https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping )
fu! s:Save_mappings(keys, mode, global) abort
  let mappings = {}

  if a:global
    for l:key in a:keys
      let buf_local_map = maparg(l:key, a:mode, 0, 1)

      sil! exe a:mode.'unmap <buffer> '.l:key

      let map_info        = maparg(l:key, a:mode, 0, 1)
      let mappings[l:key] = !empty(map_info)
            \     ? map_info
            \     : {
            \ 'unmapped' : 1,
            \ 'buffer'   : 0,
            \ 'lhs'      : l:key,
            \ 'mode'     : a:mode,
            \ }

      call s:Restore_mappings({l:key : buf_local_map})
    endfor

  else
    for l:key in a:keys
      let map_info        = maparg(l:key, a:mode, 0, 1)
      let mappings[l:key] = !empty(map_info)
            \     ? map_info
            \     : {
            \ 'unmapped' : 1,
            \ 'buffer'   : 1,
            \ 'lhs'      : l:key,
            \ 'mode'     : a:mode,
            \ }
    endfor
  endif

  return mappings
endfu
fu! s:Restore_mappings(mappings) abort

  for mapping in values(a:mappings)
    if !has_key(mapping, 'unmapped') && !empty(mapping)
      exe     mapping.mode
            \ . (mapping.noremap ? 'noremap   ' : 'map ')
            \ . (mapping.buffer  ? ' <buffer> ' : '')
            \ . (mapping.expr    ? ' <expr>   ' : '')
            \ . (mapping.nowait  ? ' <nowait> ' : '')
            \ . (mapping.silent  ? ' <silent> ' : '')
            \ .  mapping.lhs
            \ . ' '
            \ . substitute(mapping.rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')

    elseif has_key(mapping, 'unmapped')
      sil! exe mapping.mode.'unmap '
            \ .(mapping.buffer ? ' <buffer> ' : '')
            \ . mapping.lhs
    endif
  endfor

endfu
