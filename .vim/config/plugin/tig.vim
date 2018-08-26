" NOTE: for git
" LazyPlug 'tpope/vim-fugitive'

if Doctor('tig', 'Text-mode interface for git')
  if has('nvim')
    command! -nargs=0 Gblame execute ":Tig blame +".line('.')." ".expand('%:p:S')
  endif

  " FYI: [codeindulgence/vim\-tig: Do a tig in your vim]( https://github.com/codeindulgence/vim-tig )
  if has('nvim')
    if !exists('g:tig_executable')
      let g:tig_executable = 'tig'
    endif

    if !exists('g:tig_default_command')
      let g:tig_default_command = 'status'
    endif

    if !exists('g:tig_on_exit')
      let g:tig_on_exit = 'bw!'
    endif

    if !exists('g:tig_open_command')
      let g:tig_open_command = 'enew'
    endif

    function! s:tig(bang, ...)
      let s:callback = {}
      let current = expand('%')

      function! s:callback.on_exit(id, status, event)
        exec g:tig_on_exit
      endfunction

      function! s:tigopen(arg)
        call termopen(g:tig_executable . ' ' . a:arg, s:callback)
        redraw!
      endfunction

      " TODO: 要検証
      let start=strftime('%s')
      exec g:tig_open_command
      let end=strftime('%s')
      if end - start <= 1
        echom 'Maybe you need more screen space to use tig!'
      endif

      if a:bang > 0
        call s:tigopen(current)
      elseif a:0 > 0
        call s:tigopen(a:1)
      else
        call s:tigopen(g:tig_default_command)
      endif
      startinsert
    endfunction

    command! -bang -nargs=? Tig call s:tig(<bang>0, <f-args>)
  endif
endif
