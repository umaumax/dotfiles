" [\.vim/\.vimrc at master · cohama/\.vim]( https://github.com/cohama/.vim/blob/master/.vimrc )

" インサートモードから出るときにカーソルを後退させない
function! FixedInsertLeave()
	" 行末だった場合は通常と同じく後退させる
	let cursorPos = col(".")
	let maxColumn = col("$")
	if cursorPos < maxColumn && cursorPos != 1
		return "\<Esc>l"
	else
		return "\<Esc>"
	endif
endfunction

" 自分以外の特定のウィンドウを閉じる
nnoremap Q :<C-u>call CloseAnyOther()<CR>
function! CloseAnyOther()
	let w = 0
	let w:current_win = 1
	for w in reverse(range(1, winnr('$')))
		let ft = getwinvar(w, '&filetype')
		let bt = getwinvar(w, '&buftype')
		let bufnr = winbufnr(w)
		let name = bufname(bufnr)
		if (ft ==# 'quickrun' && name ==# 'QuickRunOut')
					\ || (ft ==# 'vimfiler')
					\ || (ft ==# 'vimshell')
					\ || (name =~# '^fugitive:')
					\ || (bt ==# 'help')
					\ || (bt ==# 'quickfix')
					\ || (bt ==# 'nofile')
			execute w . 'wincmd w'
			q
			break
		endif
	endfor
	for w in range(1, winnr('$'))
		let was_current = getwinvar(w, 'current_win')
		if was_current
			execute w . 'wincmd w'
			unlet w:current_win
			break
		endif
	endfor
endfunction
