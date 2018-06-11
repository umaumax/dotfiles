inoremap <C-X><C-V> <C-R>=ClangLibToolingComp()<CR>

func! ClangLibToolingComp() abort
	let line=getline('.')
	let cursor_col=col('.')
	let ret = system('clang-libtooling-comp', line."\n".cursor_col)
	let rets = split(ret, '\n')
	let comp_list =[]
	" 	[
	" 				\ {'word': 'foo'},
	" 				\ {'word': 'bar'},
	" 				\ {'word': 'baz'},
	" 				\	]
	" 	call add(comp_list, {'word': 'foo', 'info': '1: foo'})
	for ret in rets
		let tmps = split(ret,'____')
		if len(tmps)==2
			"			comp_list += [{'word': len(tmps)}]
			" 		comp_list += [{'word': 'tmps[0]', 'info':'tmps[1]'}]
			call add(comp_list, {'word': tmps[0], 'menu': tmps[1]})
		endif
	endfor
	call complete(col('.'), comp_list)
	" NOTE: 自動選択状態の解除
	if pumvisible()
		return "\<C-p>"
	endif
	return ''
endfunc
