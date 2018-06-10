" Required: mkdir -p ~/md/link
function! s:mdlink()
	let l:mdlinkdir = expand('~/md/link/')
	if !isdirectory(l:mdlinkdir)
		call mkdir(l:mdlinkdir, "p")
	endif
	let l:linkname=expand("%:p")

	" NOTE: trim prefix
	let l:homedir=$HOME."/"
	if stridx(l:linkname, l:homedir) ==0
		let l:linkname = l:linkname[strlen(l:homedir):]
	endif
	let l:linkname=substitute(l:linkname,"/","-","g")
	let l:cmd = "ln -sf ".expand("%:p")." ".l:mdlinkdir.l:linkname
	echo l:cmd
	call system("ln -sf ".expand("%:p")." ".l:mdlinkdir.l:linkname)
endfunction
command! MdLink :call <SID>mdlink()

