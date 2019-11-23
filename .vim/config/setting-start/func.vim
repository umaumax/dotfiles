" NOTE: RunCommandToClipboard ls
" not use interactive command (e.g. peco) in this function
function! s:run_command_to_clipboard(...) abort
  let @+ = system(join(a:000,' '))
endfunction
command! -nargs=* -complete=command RunCommandToClipboard call s:run_command_to_clipboard(<f-args>)

" e.g.
" :Grep script command
function! s:grep(keyword, ...)
  redir => scriptn | sil exe join(a:000, ' ') | redir end | echo(system('grep -n -i '. a:keyword, scriptn))
endfunction
command! -nargs=+ -complete=command Grep call s:grep(<f-args>)
