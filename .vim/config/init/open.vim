function! Is_invalid_ext()
  for pattern in ['^tu[^.]*', 'zip', 'tar.gz', 'gz', 'tar.bz2', 'bz2', 'jp[e]g', 'png', 'exe', 'pdf', 'pch', 'out']
    " NOTE: e: ext
    if expand('%:e') =~ pattern
      " NOTE: below command quit force even if multi buffer was opening
      return "[auto closed] Don't open ".expand('%:S')."!"
    endif
  endfor
  return ""
endfunction
function! Is_big_executable_file()
  " NOTE: disable executable file open
  " NOTE: e: ext
  if expand('%') != '' && expand('%:e') == '' && system('type '.expand('%:p:S').' >/dev/null 2>&1; echo $?')==0
    " NOTE: maybe you can use file and compare (e.g. mac os x 'Mach-O 64-bit executable x86_64')
    let filepath=fnamemodify(resolve(expand('%:p')), 'S')
    let filesize=system('du -k '.filepath.' | cut -f1')
    let maxsize_k=16
    if filesize > maxsize_k
      return "[auto closed] Don't open executable (more than ".filesize."k size) at [".filepath."]!"
    endif
  endif
  return ""
endfunction
function! s:disable_opening_file()
  let funcs=[function('Is_invalid_ext'), function('Is_big_executable_file')]
  for F in funcs
    let message = F()
    if message != ''
      " NOTE: vimの横幅によって，複数回表示される
      call input(message.'  [If you want to open it!(set VIM_FORCE_OPEN environment variable)]')
      :q!
      break
    endif
  endfor
endfunction

if $VIM_FORCE_OPEN == ''
  " NOTE: disable open
  augroup disable_opening_file_group
    autocmd!
    autocmd BufEnter * call <SID>disable_opening_file()
  augroup END
endif

" no plug plugin mode
" VIM_FAST_MODE='on' vim
if $VIM_FAST_MODE == ''
  if &readonly || $OS == "Windows_NT"
    let $VIM_FAST_MODE='on'
  endif

  let full_path = expand("%:p")
  " skip tmp file
  for pattern in ['^/tmp/.*$', '^/var/.*$', '^/private/.*$']
    if full_path =~ pattern
      let $VIM_FAST_MODE='on'
      break
    endif
  endfor
endif
