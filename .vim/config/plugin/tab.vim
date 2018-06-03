" tab for completion
" Plug 'ervandew/supertab'
" let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = "context"

function! s:Tab()
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
		call cursor('.', col('.')-1)
		return ''
	endif
	return ''
endfunction
" simple version
" inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <Tab> <C-r>=<SID>Tab()<CR>
inoremap <S-Tab> <C-r>=<SID>UnTab()<CR>
