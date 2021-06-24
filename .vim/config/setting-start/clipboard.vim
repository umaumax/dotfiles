function! s:good_clipboard_setting()
  if has('windows')
    return 'unnamed,unnamedplus'
  elseif has('mac') " NOTE: mac also has 'unix'
    return 'unnamed,unnamedplus'
  elseif has('unix')
    return 'unnamedplus'
  endif
endfunction

function! s:set_clipboard()
  let clipboard_setting=s:good_clipboard_setting()
  if &clipboard != clipboard_setting
    execute "set clipboard=".clipboard_setting
    execute "setlocal clipboard=".clipboard_setting
  endif
endfunction
command! InitClipBoard :call s:set_clipboard()

" auto reset clipboard event workaround (But, I don't know what makes blank &clipboard setting.)
augroup clipboard_setting_group
  autocmd!
  " InsertLeave is used instead of when you entered normal mode
  autocmd VimEnter,InsertLeave * call s:set_clipboard()
augroup END
