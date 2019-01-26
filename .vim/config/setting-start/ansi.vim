function! s:ansi_color_set()
	highlight Red cterm=reverse ctermfg=Red gui=reverse guifg=Red
	highlight Blue cterm=reverse ctermfg=Blue gui=reverse guifg=Blue
endfunction

" TODO: define other colors (auto generation?)
" [ANSI escape code \- Wikipedia]( https://en.wikipedia.org/wiki/ANSI_escape_code )
" if has('syntax')
" 	augroup ansi_color_group
" 		autocmd!
" 		autocmd ColorScheme       * call s:ansi_color_set()
" 		autocmd VimEnter,WinEnter * call matchadd("Red", '\\e\[31m.*\\e\[m')
" 		autocmd VimEnter,WinEnter * call matchadd("Red", 'red')
" 		autocmd VimEnter,WinEnter * call matchadd("Blue", '\\e\[34m.*\\e\[m')
" 		autocmd VimEnter,WinEnter * call matchadd("Blue", 'blue')
" 	augroup END
" 	call s:ansi_color_set()
" endif
