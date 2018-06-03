" [Vim: Quickfixを自動で閉じる \- Hail2u]( https://hail2u.net/blog/software/vim-auto-close-quickfix-window.html )
augroup QfAutoCommands
	autocmd!
	" Auto-close if there is only quickfix window
	autocmd WinEnter * if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif
	autocmd QuickFixCmdPost *grep* if len(getqflist()) != 0 | copen | endif
augroup END
" TODO: only for quickfix setting
augroup quickfix_color_group
	autocmd!
	" 	highlight default QuickhlTitle  ctermfg = Blue   cterm = none
	" 	highlight default QuickhlURL    ctermfg = Green   cterm = none
	" [Vim\-formatted regular expression to match a URL for syntax highlighting]( https://gist.github.com/tobym/584909 )
	" 	autocmd FileType qf
	if &rtp =~ 't9md/vim-quickhl'
		autocmd WinEnter,WinLeave,BufRead,BufNew,BufEnter,Syntax * call matchadd('QuickhlManual10', 'https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*')
		" 	autocmd FileType qf
		autocmd WinEnter,WinLeave,BufRead,BufNew,BufEnter,Syntax * call matchadd('QuickhlManual12','||\s\+[0-9]\+\s.*$')
	endif
augroup END

" for vimgrep quickfix
nmap <Space>n :cnext<CR>
nmap <Space>N :cprev<CR>

if &rtp =~ 'vim-submode'
	call submode#enter_with('vimgrep', 'n', '', '<Space>n', ':cnext<CR>')
	call submode#enter_with('vimgrep', 'n', '', '<Space>N', ':cprev<CR>')
	call submode#map('vimgrep', 'n', '', 'n', ':cnext<CR>')
	call submode#map('vimgrep', 'n', '', 'N', ':cprev<CR>')
endif
