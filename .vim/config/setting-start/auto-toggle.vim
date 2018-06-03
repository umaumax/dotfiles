" auto toggle
" e.g. md    -> '* xxx'
"      c,cpp -> 'xxx:'
function! Substitute(pat, sub, flags) range
	for l:n in range(a:firstline, a:lastline)
		let l:line=getline(l:n)
		let l:ret=substitute(l:line, a:pat, a:sub, a:flags)
		call setline(l:n, l:ret)
	endfor
	call cursor(a:lastline+1, 1)
endfunction
command! -nargs=0 -range SetMarkdownHead <line1>,<line2>call Substitute('^\([^*].*\)$', '* \1', '')
command! -nargs=0 -range SetCBottom      <line1>,<line2>call Substitute('\(^.*[^;]\+\)\s*$', '\1;', '')
augroup file_detection_for_toggle
	autocmd!
	au BufNewFile,BufRead *.md      nnoremap <silent> <Space>t :SetMarkdownHead<CR>
	au BufNewFile,BufRead *.{c,cpp} nnoremap <silent> <Space>t :SetCBottom<CR>
augroup END
