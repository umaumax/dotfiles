" <C-N> on word
" repeat <C-N> or <C-X>:skip, <C-p>:prev
" c,s: change text
" I: insert at start of range
" A: insert at end of range
LazyPlug 'terryma/vim-multiple-cursors'
function! Multiple_cursors_before()
  let g:multi_cursor_inputing=1
  " NOTE: vim-smartinput plugin mapping
  let key_mapping_list = get(g:, 'i_triggers', [])
  " NOTE: original mapping
  let key_mapping_list += ['<Tab>','<S-Tab>']
  let b:i_triggers_mappings = s:Store_mappings(key_mapping_list, 'i', 1)

  " NOTE: to prevent strange word '<Plug>_-1'
  call deoplete#disable()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

function! Multiple_cursors_after()
  let g:multi_cursor_inputing=0
  call s:Restore_mappings(b:i_triggers_mappings)

  call deoplete#enable()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction

" --------------------------------

" [key bindings \- How to save and restore a mapping? \- Vi and Vim Stack Exchange]( https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping )
fu! s:Store_mappings(keys, mode, global) abort
  let mappings = {}
  if a:global
    for l:key in a:keys
      " NOTE: 現状: ", ', [, `, {, |のマッピングは解除できていない
      let buf_local_map = maparg(l:key, a:mode, 0, 1)
      echom 'key:'. l:key
      " NOTE: ' 'と'\<Space>'が別々に登録されている場合に2重削除が発生しうる
      if empty(buf_local_map)
        continue
      endif

      let l:key = substitute(l:key, ' ', '<Space>', 'g')
      let l:key = substitute(l:key, '\\<Space>', '<Space>', 'g')
      let buffer_option=(buf_local_map.buffer == 0 ? '' : '<buffer>')
      sil! exe a:mode.'unmap '.buffer_option.' '.l:key
      let mappings[l:key] = !empty(buf_local_map)
            \     ? buf_local_map
            \     : {
            \ 'unmapped' : 1,
            \ 'buffer'   : 0,
            \ 'lhs'      : l:key,
            \ 'mode'     : a:mode,
            \ }
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
