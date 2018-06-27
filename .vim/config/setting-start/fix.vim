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

if Doctor('gofix', 'wrong word fixer')
	function! FixLine()
		let line=getline('.')
		let ret = system('gofix -filetype='.&filetype, line)
		if s:success()
			call setline('.', split(ret,"\n"))
			return ret
		else
			call s:error_message(ret)
		endif
	endfunction
	" 	nnoremap <expr> <C-x>f FixLine()
	" 	inoremap <expr> <C-x>f FixLine()
	" 	nnoremap <C-x>f :call FixLine()<CR>
	command! FixLine :call FixLine()
	inoremap <C-x>f <C-o>:call FixLine()<CR>
endif
