" FYI: [カレントファイルにインクルードガードを書き込むvimスクリプト - Qiita](http://qiita.com/xeno1991/items/27d9aaf0501c41116aec)

" Insert include guard to the current file
" head, foot: list(["", ""]) or string
function! s:include_guard(head, foot)
  let l:view = winsaveview()
  silent! execute '1s/^/\=a:head'
  silent! execute '$s/$/\=a:foot'
  silent call winrestview(l:view)
endfunction

function! s:include_guard_c()
  let name = fnamemodify(expand('%'),':t')
  let name = toupper(name)
  let included = substitute(name,'\.\|-','_','g').'_INCLUDED'
  let s:head = [
        \ '#ifndef '.included,
        \ "#define ".included,
        \ ]
  let s:foot = [
        \ '#endif // '.included,
        \ ]
  call s:include_guard(join(s:head+["",""],"\n"), join(["",""]+s:foot,"\n"))
endfunction

function! s:include_guard_vim()
  let s:name = expand('%:r')
  let s:dirname = substitute(expand('%:p:h'),'.*/','','')
  let s:dirpath = expand('%:p:h')
  let plugin_flag = s:dirpath =~ 'plugin'
  let autoload_flag = s:dirpath =~ 'autoload'
  if !(plugin_flag || autoload_flag)
    return
  endif
  " NOTE: \{-}: min match
  let s:var_name = substitute(substitute(s:name,'\.\|-','_','g'),'.\{-}autoload/\|.\{-}plugin/','','')
  let exists_prefix = "!\0"[plugin_flag]
  let s:head = [
        \ "if ".exists_prefix."exists('g:loaded_".s:var_name."')",
        \ "  finish",
        \ "endif",
        \ "let g:loaded_".s:var_name." = 1",
        \ "",
        \ "let s:save_cpo = &cpo",
        \ "set cpo&vim",
        \ ]
  let s:foot=[
        \ "let &cpo = s:save_cpo",
        \ "unlet s:save_cpo",
        \ ]
  call s:include_guard(join(s:head+["",""],"\n"), join(["",""]+s:foot,"\n"))
endfunction

augroup include_guard
  autocmd!
  autocmd BufWinEnter *.{h,hpp} command! -nargs=0 IncGuard call <SID>include_guard_c()
  autocmd BufWinEnter *.vim     command! -nargs=0 IncGuard call <SID>include_guard_vim()
augroup END
