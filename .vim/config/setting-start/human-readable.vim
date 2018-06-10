function! s:nr2bin(nr)
	let n = a:nr
	let r = ""
	while n
		let r = '01'[n % 2] . r
		let n = n / 2
	endwhile
	return r
endfunc
function! s:humanreadable()
	let l:w= expand("<cword>") " word_under_cursor
	" TODO: 100G, 10.0Kb, ...
	let l:is_hex = l:w =~ '^0x[0-9a-fA-F]\+$' || l:w =~ '^[0-9a-fA-F]\+h$'
	let l:is_decimal = l:w =~ '^[0-9]\+$'
	let l:ret = ''
	if l:is_decimal
		let l:n = l:w
		let l:hex = printf('%x', l:n)
		let l:decimal = l:w
		" Fix: binary expression
		" [Vim 8\.0 Advent Calendar 9 日目 2 進数のサポート \- Qiita]( https://qiita.com/thinca/items/9343437440898c54d2be )
		let l:binary = s:nr2bin(l:n)
		let l:ret = l:decimal . ', ' . l:hex . ', 0b' . l:binary
	endif
	if l:is_hex
		let l:n = substitute(l:w, '\(0x|h\)', '', '')
		let l:hex = l:w
		let l:decimal = str2nr(l:n, 16)
		let l:binary = s:nr2bin(l:n)
		let l:ret = l:decimal . ', ' . l:hex . ', 0b' . l:binary
	endif
	if l:ret != ''
		echom l:ret
	endif
endfunction
augroup auto_human_readable_number
	autocmd!
	autocmd CursorMoved <buffer> call s:humanreadable()
	autocmd CursorMoved * call s:humanreadable()
augroup END
