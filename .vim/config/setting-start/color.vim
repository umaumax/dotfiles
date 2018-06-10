augroup my_color
	autocmd!
	autocmd ColorScheme,BufWinEnter * highlight IncSearch ctermbg=15 guibg=#FFFFFF
	autocmd ColorScheme,BufWinEnter * highlight Search ctermbg=15 guibg=#FFFFFF
	" for speedup
	autocmd ColorScheme,BufWinEnter * syntax sync maxlines=10 minlines=10
augroup END
