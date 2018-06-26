finish

inoremap <C-X><C-V> <C-R>=ClangLibToolingComp()<CR>

func! ClangLibToolingComp() abort
	let l:line=getline('.')
	let [buf, row, col, off] = getpos(".") 
	" 	let l:cursor_row=row('.')
	" 	let l:cursor_col=col('.')
	" 	let l:ret = system('clang-libtooling-comp', l:line."\n".l:cursor_col)
	" 	let l:rets = split(l:ret, '\n')
	let l:comp_list =[]

	" 	let l:source = join(getline(1, '$'), "\n")
	let l:tempfilepath=tempname()
	" NOTE: ext must be one of cpp types
	let l:tempfilepath='.tmp.cpp'
	call writefile(getline(1, '$'), l:tempfilepath)

	let l:pch_filepath='loop-con.h.pch'
	let l:cmds = [
				\'clang++',
				\'-cc1','-include-pch', l:pch_filepath,
				\'-fsyntax-only', '-code-completion-at='.l:tempfilepath.':'.row.':'.col,
				\'-std=c++11',
				\l:tempfilepath,
				\]
	let l:cmd=join(l:cmds, ' ')
	let l:include_pathes=['/usr/local/Cellar/llvm/6.0.0/include']
	for l:include_path in l:include_pathes
		let l:cmd = l:cmd.' -I'.l:include_path
	endfor
	" 	echom l:cmd

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
		echomsg 'xxx has failed to format.'
		for l:line in split(a:result, "\n")[0:1]
			echomsg l:line
		endfor
		echohl None
	endfunction

	let l:cmd_output = system(l:cmd)
	if s:success()
		for l:line in split(l:cmd_output, '\n')
			call add(l:comp_list, {'word': l:line, 'menu': 'menu'})
		endfor
	else
		call s:error_message(l:cmd_output)
	endif

	call complete(col('.'), l:comp_list)
	" NOTE: 自動選択状態の解除
	if pumvisible()
		return "\<C-p>"
	endif
	return ''
	" 	let line=getline('.')
	" 	let cursor_col=col('.')
	" 	let ret = system('clang-libtooling-comp', line."\n".cursor_col)
	" 	let rets = split(ret, '\n')
	" 	let comp_list =[]
	" 	" 	[
	" 	" 				\ {'word': 'foo'},
	" 	" 				\ {'word': 'bar'},
	" 	" 				\ {'word': 'baz'},
	" 	" 				\	]
	" 	" 	call add(comp_list, {'word': 'foo', 'info': '1: foo'})
	" 	for ret in rets
	" 		let tmps = split(ret,'____')
	" 		if len(tmps)==2
	" 			"			comp_list += [{'word': len(tmps)}]
	" 			" 		comp_list += [{'word': 'tmps[0]', 'info':'tmps[1]'}]
	" 			call add(comp_list, {'word': tmps[0], 'menu': tmps[1]})
	" 		endif
	" 	endfor
	" 	call complete(col('.'), comp_list)
	" 	" NOTE: 自動選択状態の解除
	" 	if pumvisible()
	" 		return "\<C-p>"
	" 	endif
	" 	return ''
endfunc
