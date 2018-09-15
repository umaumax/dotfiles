function! s:init_color()
	highlight Search    ctermbg=15 guibg=#EEEEEE
	highlight IncSearch ctermbg=15 guibg=#EEEEEE

	if &rtp =~ 'vim-cpp-syntax-reserved_identifiers'
		highlight cReservedIdentifiers ctermfg=white ctermbg=red guifg=#ffffff guibg=#ff0000
	endif

	" completion menu color setting
	highlight Pmenu    ctermfg=white ctermbg=26  guifg=#ffffff guibg=#4169E1
	highlight PmenuSel cterm=bold    ctermfg=32 ctermbg=black gui=bold guifg=#4682B4 guibg=#000000

	" NOTE: visualize fullsidth space
	highlight TrailingSpaces term=underline guibg=#ff0000 ctermbg=Red
	match TrailingSpaces /　/

	" for speedup
	" syntax sync maxlines=10 minlines=10
endfunction

augroup init_color_group
	autocmd!
	autocmd ColorScheme,BufWinEnter * call s:init_color()
	autocmd User VimEnterDrawPost     call s:init_color()
augroup END

if &rtp =~ 'rainbow'
	function! s:rainbow_group_func(action)
		if &ft=='cmake'
			if a:action=='enter'
				call rainbow_main#clear()
			endif
		else
			if a:action=='enter'
				call rainbow_main#load()
			endif
		endif
	endfunction
	augroup rainbow_group
		autocmd!
		autocmd User VimEnterDrawPost call <SID>rainbow_group_func('enter')
		autocmd BufEnter * call <SID>rainbow_group_func('enter')
		" 	autocmd BufLeave * call <SID>rainbow_group_func('leave')
	augroup END
endif
