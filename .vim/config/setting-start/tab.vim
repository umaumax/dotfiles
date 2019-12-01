function! s:nosmartindent_tab()
  " NOTE: for enable indent comment line (which stars with top of # (e.g. python file))
  if &smartindent == 1
    setlocal nosmartindent
    execute "normal! >>"
    setlocal smartindent
  else
    execute "normal! >>"
  endif
endfunction

function! s:Tab()
  if pumvisible()
    return "\<C-n>"
  endif
  if &rtp =~ 'neosnippet'
    if neosnippet#jumpable()
      silent! execute "normal a\<Plug>(neosnippet_jump)"
      let cursorPos = col(".")
      let maxColumn = col("$")
      if cursorPos == maxColumn - 1
        call feedkeys("\<Right>",'n')
      endif
      return ''
      "     return "\<Plug>(neosnippet_jump)"
    endif
  endif
  if &rtp =~ 'ultisnips'
    call UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res>0
      return
    endif
  endif

  " NOTE: default behavior

  let line = getline('.')
  " NOTE: for markdown
  if line =~ '\s*\*'
    if &expandtab == 0
      call setline('.', "\t" . line)
      call cursor('.', col('.')+1)
    else
      call setline('.', repeat(' ', &shiftwidth) . line)
      call cursor('.', col('.')+&shiftwidth)
    endif
    return ''
  endif

  call s:nosmartindent_tab()
  " NOTE: for empty line
  if getline('.')==''
    call setline(line('.'), &expandtab?repeat(' ', &shiftwidth):"\t")
    call cursor('.', col('$')+1)
  else
    call cursor('.', col('.')+(&expandtab?&shiftwidth:1))
  endif
  return ''
  " NOTE:
  " そのままtabを返すと中途半端なtab位置でindentした際に，幅がおかしくなる
  " return "\<tab>"
endfunction

function! s:UnTab()
  if pumvisible()
    return "\<C-p>"
  endif
  let line = getline('.')
  if line[0] == "\t"
    let line = line[1:]
    call setline('.', line)
    call cursor('.', col('.'))
    return ''
  endif
  if strlen(line) >= &shiftwidth && line[:&shiftwidth-1] == repeat(' ', &shiftwidth)
    let line = line[&shiftwidth:]
    " 移動してから削除すること(末尾にカーソルがある場合を考慮)
    call cursor('.', col('.')-&shiftwidth)
    call setline('.', line)
    return ''
  endif
  return ''
endfunction
" simple version
" inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <silent> <Tab> <C-r>=<SID>Tab()<CR>
inoremap <silent> <S-Tab> <C-r>=<SID>UnTab()<CR>

" for neosnippet [SELECT] mode
smap <buffer> <expr><TAB> &rtp =~ 'neosnippet' && neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<TAB>"
" なぜかvisualmodeに入るとインデントが可能
"   nmap <buffer> <expr><TAB> neosnippet#jumpable() ? "i\<Plug>(neosnippet_jump)" : "v>>"
" nmap <buffer> <expr><TAB> "v>>"

" [TabとCtrl\-iどちらを入力されたか区別する\(Linux限定\) \- Qiita]( https://qiita.com/norio13/items/9c05412796a7dea5cd91 )
" <Tab> == <C-i>
" insert new line at pre line
" nnoremap <C-o> mzO<ESC>`z
" insert new line at next line
" nnoremap <C-i> mzo<ESC>`z

" tab
function! s:count_tab()
  if v:count <= 1
    let line=getline('.')
    " NOTE: for empty line
    if line==''
      call setline(line('.'), &expandtab?repeat(' ', &shiftwidth):"\t")
      normal! $
      return
    endif
    let left_move_n=0
    for i in range(1,&shiftwidth)
      if col('.')-i>=0 && line[col('.')-i]=="\t"
        break
      endif
      let left_move_n+=1
    endfor

    call s:nosmartindent_tab()
    let left_move_n=left_move_n>0?left_move_n:1
    execute "normal! ".repeat("\<Right>",left_move_n)
  else
    for i in range(v:count)
      if i>0
        execute "normal! \<Down>"
      endif
      call s:nosmartindent_tab()
    endfor
  endif
endfunction
function! s:tab_wrapper() range
  if &rtp =~ 'neosnippet' && neosnippet#jumpable()
    call feedkeys("i\<Plug>(neosnippet_jump)", '')
    return
  endif
  if &rtp =~ 'ultisnips'
    call UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res>0
      return
    endif
  endif
  call s:count_tab()
endfunction
function! s:untab()
  let line=getline('.')
  if line == '' || (line[0] != ' ' && line[0] != "\t")
    return
  endif
  if line[col('.')-1]=="\t"
    execute "normal! <<"
    if col('.')>1
      execute "normal! \<Left>"
    endif
    return
  endif
  "   col('.')
  "   execute "normal! ".repeat("\<Left>",(&expandtab!=100&&col('.')-1>=&shiftwidth)?&shiftwidth:1)."<<"
  "   execute "normal! <<"
  "   execute "normal! ".repeat("\<Left>",(col('.')-1>=(&expandtab?1:&shiftwidth))?&shiftwidth:1)."<<"
  "   let left_move_n=(&expandtab?&shiftwidth:1)
  let left_move_n=&shiftwidth
  if col('.')>=col('$')-&shiftwidth
    let left_move_n=col('$')-col('.')-(&shiftwidth-1)
  endif
  call cursor('.', col('.')-left_move_n)
  execute "normal! <<"
  " execute "normal! ".repeat("\<Left>",left_move_n)
  "   execute "normal! ".repeat("\<Left>",(&expandtab?1:&shiftwidth))."<<"
  "   (col('.')-1>=(&expandtab?1:&shiftwidth))?&shiftwidth:1)
endfunction
nnoremap <Tab> :call <SID>tab_wrapper()<CR>
nnoremap <silent> <S-Tab> :call <SID>untab()<CR>

" vnoremap <Tab> >>
" vnoremap <S-Tab> <<
" NOTE: only for visual mode(not select mode)
xnoremap <silent> <Tab> >gv
xnoremap <silent> <S-Tab> <gv
