if has('terminal') " nvim return 0
	command! Term  :vertical rightbelow terminal
	command! Termv :vertical rightbelow terminal
	command! Terms :rightbelow terminal
endif
if has('nvim')
	" for terminal
	tnoremap <silent> <ESC> <C-\><C-n>
	command! Term  :vertical rightbelow vnew | terminal
	command! Termv :vertical rightbelow vnew | terminal
	command! Terms :rightbelow new | terminal
	command! Terms :tabnew | terminal
endif
