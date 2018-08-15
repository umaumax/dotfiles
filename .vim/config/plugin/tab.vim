" tab for completion
" Plug 'ervandew/supertab'
" let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = "context"

function! s:Tab()
	if pumvisible()
		return "\<C-n>"
	endif
	if &rtp =~ 'neosnippet'
		if neosnippet#jumpable()
			execute "normal a\<Plug>(neosnippet_jump)"
			let cursorPos = col(".")
			let maxColumn = col("$")
			if cursorPos == maxColumn - 1
				call feedkeys("\<Right>",'n')
			endif
			return ''
			" 		return "\<Plug>(neosnippet_jump)"
		endif
	endif

	let line = getline('.')
	if line =~ '\s*\*'
		if &expandtab == 0
			call setline('.', "\t" . line)
			call cursor('.', col('.')+1)
		else
			call setline('.', repeat(' ', &shiftwidth) . line)
			call cursor('.', col('.')+&shiftwidth)
		endif
		return ''
	endif
	execute "normal! >>"
	return ''
	" NOTE:
	" そのままtabを返すと中途半端なtab位置でindentした際に，幅がおかしくなる
	" return "\<tab>"
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
	if strlen(line) >= &shiftwidth && line[:&shiftwidth-1] == repeat(' ', &shiftwidth)
		let line = line[&shiftwidth:]
		" 移動してから削除すること(末尾にカーソルがある場合を考慮)
		call cursor('.', col('.')-&shiftwidth)
		call setline('.', line)
		return ''
	endif
	return ''
endfunction
" simple version
" inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <Tab> <C-r>=<SID>Tab()<CR>
inoremap <S-Tab> <C-r>=<SID>UnTab()<CR>

if &rtp =~ 'neosnippet'
	" for neosnippet
	smap <buffer> <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" : "\<TAB>"
	" nmap <buffer> <expr><TAB> neosnippet#jumpable() ?  "i\<Plug>(neosnippet_jump)" : "\<TAB>"
	" なぜかvisualmodeに入るとインデントが可能
	nmap <buffer> <expr><TAB> neosnippet#jumpable() ? "i\<Plug>(neosnippet_jump)" : "v>>"
	" nmap <buffer> <expr><TAB> "v>>"
endif
