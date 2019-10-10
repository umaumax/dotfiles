" NOTE: for git
" LazyPlug 'tpope/vim-fugitive'

if Doctor('tig', 'Text-mode interface for git')
  if has('nvim')
    " NOTE: don't use full path, use relative path
    command! -nargs=0 Gblame execute ":Tig blame +".line('.')." ".expand('%:S')
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
        echom '[Failed][tig] id:'.a:id.', exit_code:'.a:status.' event:'.a:event
      endfunction

      function! s:tigopen(arg)
        call termopen(g:tig_executable . ' ' . a:arg, s:callback)
        redraw!
      endfunction

      exec g:tig_open_command

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
