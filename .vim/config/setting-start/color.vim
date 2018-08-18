function! s:init_color()
	highlight Search    ctermbg=15 guibg=#EEEEEE
	highlight IncSearch ctermbg=15 guibg=#EEEEEE

	highlight PmenuSel cterm=bold ctermfg=darkcyan  ctermbg=lightgray gui=bold guifg=#ffffff guibg=#4169E1
	highlight Pmenu    cterm=bold ctermfg=lightblue ctermbg=black     gui=bold guifg=#4682B4 guibg=#000000

	if &rtp =~ 'vim-cpp-syntax-reserved_identifiers'
		highlight cReservedIdentifiers ctermfg=white ctermbg=red guifg=#ffffff guibg=#ff0000
	endif

	" for speedup
	" syntax sync maxlines=10 minlines=10
endfunction
augroup init_color_group
	autocmd!
	autocmd ColorScheme,BufWinEnter * call s:init_color()
augroup END
