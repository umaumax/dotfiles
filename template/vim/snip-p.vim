function! s:p(text)
	let tmp = @a
	let @a = a:text
	execute 'normal "ap'
	let @a = tmp
endfunction
