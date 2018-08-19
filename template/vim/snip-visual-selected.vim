" [vim \- How to get visually selected text in VimScript \- Stack Overflow]( https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript )
function! s:get_visual_selection()
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

function! s:delete_visual_selection()
	let selected = s:get_visual_selection()
	call setpos('.', getpos("'<"))
	let Mlen = { s -> strlen(substitute(s, ".", "x", "g"))}
	let l = Mlen(selected)
	if l > 0
		execute "normal! v".(l-1)."\<Right>\"_x"
	endif
	return selected
endfunction
