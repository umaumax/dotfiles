if has('terminal') " nvim return 0
	command! Term  :vertical rightbelow terminal
	command! Termv :vertical rightbelow terminal
	command! Terms :rightbelow terminal
endif
if has('nvim')
	" for terminal
	tnoremap <silent> <ESC> <C-\><C-n>
	command! Term  :vertical rightbelow vnew | call feedkeys('i','n') | terminal
	command! Termv :vertical rightbelow vnew | call feedkeys('i','n') | terminal
	command! Terms :rightbelow new | call feedkeys('i','n') | terminal
	command! Terms :tabnew | call feedkeys('i','n') | terminal
endif

augroup terminal_autogroup
	autocmd!
	if has('nvim')
		autocmd WinEnter * if &buftype ==# 'terminal' | echom 'terminal' | startinsert | endif
	else
		autocmd WinEnter * if &buftype ==# 'terminal' | normal i | endif
	endif
augroup END
