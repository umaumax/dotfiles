" tableの項目を各行毎にの項目の前後に" "のみとなるようにformat
" 自動formatで変更されうる"----"は':'と合わせて4個となるように
function! s:table_format_of_each_line()
	let firstline = 1
	let lastline = line("$")
	for n in range(firstline, lastline)
		let l:line=getline(n)
		if l:line[0] != '|'
			continue
		endif
		let line=substitute(line, '^|\s\+\(.\{-,}\)\s\+| ', '| \1 | ', 'g')
		let line=substitute(line, ' |\s\+\(.\{-,}\)\s\+|$', ' | \1 |', 'g')
		" NOTE: `int c = a   |   b`には非対応
		let cols=split(line, ' | ')
		for i in range(0, len(cols)-1)
			let cols[i]=substitute(cols[i], '^\s*\(.\{-,}\)\s*$', '\1', '')
		endfor
		let line=join(cols, ' | ')
		let line=substitute(line, '|\s*\([:-]-\)-*\(-[-:]\)\s*', '| \1\2 ', 'g')
		call setline(n, line)
	endfor
endfunction
command! -nargs=0 MyTableFormat call s:table_format_of_each_line()
