" tab for completion
" Plug 'ervandew/supertab'
" let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = "context"

function! s:Tab()
	if neosnippet#jumpable() && neosnippet#expandable_or_jumpable()
		execute "normal a\<Plug>(neosnippet_expand_or_jump)"
		return ''
		" 		return "\<Plug>(neosnippet_expand_or_jump)"
	endif
	if pumvisible()
		return "\<C-n>"
	endif

	let line = getline('.')
	if line =~ '\s*\*'
		call setline('.', "\t" . line)
		call cursor('.', col('.')+1)
		return ''
	endif
	return "\<tab>"
endfunction
function! s:UnTab()
	echo 'pum:'.pumvisible()
	if pumvisible()
		return "\<C-p>"
	endif
	let line = getline('.')
	if line[0] == "\t"
		let line = line[1:]
		call setline('.', line)
		call cursor('.', col('.'))
		return ''
	endif
	if strlen(line) >= &tabstop && line[:&tabstop-1] == repeat(' ', &tabstop)
		let line = line[&tabstop:]
		" 移動してから削除すること(末尾にカーソルがある場合を考慮)
		call cursor('.', col('.')-&tabstop)
		call setline('.', line)
		return ''
	endif
	return ''
endfunction
" simple version
" inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <Tab> <C-r>=<SID>Tab()<CR>
inoremap <S-Tab> <C-r>=<SID>UnTab()<CR>
" for neosnippet
smap <buffer> <expr><TAB> neosnippet#jumpable() ?  "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
nmap <buffer> <expr><TAB> neosnippet#jumpable() ?  "i\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
