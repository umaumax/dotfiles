" Required: mkdir -p ~/md/link
let g:md_dir = expand('~/md/')
let g:md_link_dirname = 'link/'
let g:mdlinkdir = g:md_dir.g:md_link_dirname
function! s:init_md()
  if !isdirectory(g:mdlinkdir)
    call mkdir(g:mdlinkdir, "p")
  endif
endfunction
function! s:mdopen()
  silent! call s:mdlink()
  let l:filepath=s:get_mdlink_filepath()
  " NOTE: open gms url
  let url = 'http://localhost:5021/'.l:filepath
  call OpenURL(url)
endfunction
function! s:mdlink()
  if s:is_in_md_dir()
    echo 'Already in md dir!'
    return
  endif

  call s:init_md()
  let l:linkname=s:get_mdlink_filepath()
  let l:cmd = "ln -sf ".shellescape(expand("%:p"))." ".shellescape(g:md_dir.l:linkname)
  echo l:cmd
  call system(l:cmd)
endfunction
function! s:is_in_md_dir()
  let l:linkname=expand("%:p")
  return stridx(l:linkname, g:md_dir) == 0
endfunction
function! s:get_mdlink_filepath()
  let l:linkname=expand("%:p")
  " NOTE: trim prefix
  let l:homedir=$HOME."/"
  if s:is_in_md_dir()
    return l:linkname[strlen(g:md_dir):]
  endif
  if stridx(l:linkname, l:homedir) == 0
    let l:linkname = l:linkname[strlen(l:homedir):]
  endif
  let l:linkname=substitute(l:linkname,"/","-","g")
  return g:md_link_dirname.l:linkname
endfunction
command! MdLink :call <SID>mdlink()
command! MdOpen :call <SID>mdopen()
