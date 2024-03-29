" Ref: 'rhysd/vim-clang-format' /autoload/clang_format.vim
function! s:has_vimproc() abort
  if !exists('s:exists_vimproc')
    try
      silent call vimproc#version()
      let s:exists_vimproc = 1
    catch
      let s:exists_vimproc = 0
    endtry
  endif
  return s:exists_vimproc
endfunction
function! s:success() abort
  let l:exit_success = (s:has_vimproc() ? vimproc#get_last_status() : v:shell_error) == 0
  return l:exit_success
endfunction

function! s:error_message(result) abort
  echohl ErrorMsg
  echomsg 'xxx has failed to yyy.'
  for l:line in split(a:result, "\n")[0:1]
    echomsg l:line
  endfor
  echohl None
endfunction

if Doctor('golfix', 'wrong word fixer')
  function! FixLine()
    let line=getline('.')
    let ret = system('golfix -filetype='.&filetype, line)
    if s:success()
      let newline = trim(ret,"\n")
      if line != newline
        call setline('.', split(ret,"\n"))
      endif
      return newline
    else
      call s:error_message(ret)
    endif
    return ''
  endfunction
  command! FixLine :call FixLine()
  command! Fix :call FixLine()
  command! FF :call FixLine()

  nnoremap <silent> gr :call FixLine()<CR>
  nnoremap <silent> <Space>f :call FixLine()<CR>
  inoremap <silent> <C-x>f <C-o>:call FixLine()<CR>
endif
