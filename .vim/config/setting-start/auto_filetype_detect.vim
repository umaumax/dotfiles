" this is for unnamed file
function! AutoFiletypeDetect(orig_filetype)
	" for test
	" let head='#!/usr/bin/env bash'
	if &bt == 'terminal'
		return 'terminal'
	endif
	let head = getline('.')
	let cmd = ""
	if head =~ "^#!/"
		let tmps = split(head, ' ')
		if head =~ "^#!/usr/bin/env"
			if len(tmps)>=2
				let cmd = tmps[1]
			endif
		else
			" NOTE: basically file path has no space
			let cmd = fnamemodify(tmp[0], ":t")
		endif
	endif
	if cmd == ""
		for n in range(1, line('$'))
			let line = getline(n)
			let file_reg_list={
						\ 'cpp':["^#include"],
						\ 'go':["^package"],
						\ 'awk':["^BEGIN", "^END"],
						\ 'vim':["^command","^endif","^endfor","^function","^endfunction","^augroup","^augroup","^let"]
						\ }
			for key in keys(file_reg_list)
				for pt in file_reg_list[key]
					if cmd != ""
						break
					endif
					if line =~ pt
						let cmd=key
						break
					endif
				endfor
			endfor
		endfor
	endif
	if cmd == "bash"
		let cmd = "sh"
	endif
	if cmd == ""
		let cmd = a:orig_filetype != "" ? a:orig_filetype : 'markdown'
	endif
	return cmd
endfunction

augroup auto_filedetection
	autocmd!
	autocmd InsertEnter,InsertLeave,CmdlineEnter,CmdlineLeave,BufWritePost * if &filetype == "" | :FiletypeDetect | endif
augroup END
command! -bar FD execute 'setlocal filetype='.AutoFiletypeDetect(&filetype)
command! -bar FiletypeDetect execute 'setlocal filetype='.AutoFiletypeDetect(&filetype)
