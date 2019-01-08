function! s:init_color()
	highlight Search    ctermbg=15 guibg=#EEEEEE
	highlight IncSearch ctermbg=15 guibg=#EEEEEE

	if &rtp =~ 'vim-cpp-syntax-reserved_identifiers'
		highlight cReservedIdentifiers ctermfg=white ctermbg=red guifg=#ffffff guibg=#ff0000
	endif

	" completion menu color setting
	highlight Pmenu    ctermfg=white ctermbg=26  guifg=#ffffff guibg=#4169E1
	highlight PmenuSel cterm=bold    ctermfg=32 ctermbg=black gui=bold guifg=#4682B4 guibg=#000000

	" vim cursor color setting
	" NOTE: too noisy gui=underline
	highlight CursorLine   term=underline cterm=underline guibg=Black ctermbg=Black
	highlight CursorColumn guibg=Black ctermbg=Black

	" NOTE: visualize fullsidth space
	highlight TrailingSpaces term=underline guibg=#ff0000 ctermbg=Red
	match TrailingSpaces /　/
endfunction

augroup init_color_group
	autocmd!
	autocmd ColorScheme,BufWinEnter * call s:init_color()
	autocmd User VimEnterDrawPost     call s:init_color()
	autocmd FileType * syntax sync minlines=50 maxlines=500
	autocmd FileType log,text syntax sync minlines=10 maxlines=100
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
