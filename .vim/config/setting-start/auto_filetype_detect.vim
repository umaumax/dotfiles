function! s:get_command()
  let head = getline('.')
  if head !~ "^#!/"
    return ''
  endif
  let tmps = split(head, ' ')
  if head !~ "^#!/usr/bin/env"
    " NOTE: basically file path has no space
    return fnamemodify(tmps[0], ":t")
  endif
  if len(tmps)>=2
    return tmps[1]
  endif
  return ''
endfunction

function! s:guess_filetype()
  let file_reg_list={
        \ 'cpp':["^#include"],
        \ 'go':["^package"],
        \ 'awk':["^BEGIN", "^END"],
        \ 'vim':["^command","^endif","^endfor","^function","^endfunction","^augroup","^augroup","^let"]
        \ }
  for n in range(1, line('$'))
    let line = getline(n)
    for key in keys(file_reg_list)
      for pattern in file_reg_list[key]
        if line =~ pattern
          return key
        endif
      endfor
    endfor
  endfor
  return ''
endfunction

function! AutoFiletypeDetect(orig_filetype)
  if &bt == 'terminal'
    return 'terminal'
  endif

  let cmd=s:get_command()
  if cmd == ""
    let cmd=s:guess_filetype()
  endif
  if cmd == "bash"
    let cmd = "sh"
  endif
  if cmd == ""
    let cmd = a:orig_filetype != "" ? a:orig_filetype : 'markdown'
  endif
  return cmd
endfunction

command! -bar FD execute 'setlocal filetype='.AutoFiletypeDetect(&filetype)
command! -bar FiletypeDetect execute 'setlocal filetype='.AutoFiletypeDetect(&filetype)
