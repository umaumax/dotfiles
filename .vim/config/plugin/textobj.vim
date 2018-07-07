Plug 'kana/vim-textobj-user'
" il
Plug 'kana/vim-textobj-line'
" ie
Plug 'kana/vim-textobj-entire'

Plug 'sgur/vim-textobj-parameter'
" i,
" a,
" i2,
" let g:vim_textobj_parameter_mapping = ','

Plug 'osyo-manga/vim-textobj-from_regexp'
augroup textobj
	autocmd!
	" number
	autocmd VimEnter * omap <expr> in textobj#from_regexp#mapexpr('\d\+')
	autocmd VimEnter * xmap <expr> in textobj#from_regexp#mapexpr('\d\+')
	" hyphen
	autocmd VimEnter * omap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9-]\+')
	autocmd VimEnter * xmap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9-]\+')
	" dot
	autocmd VimEnter * omap <expr> id textobj#from_regexp#mapexpr('[A-Za-z0-9.]\+')
	autocmd VimEnter * xmap <expr> id textobj#from_regexp#mapexpr('[A-Za-z0-9.]\+')
	" comma
	autocmd VimEnter * omap <expr> ic textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
	autocmd VimEnter * xmap <expr> ic textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
	" file path
	autocmd VimEnter * omap <expr> if textobj#from_regexp#mapexpr('[A-Za-z0-9-./~$_+]\+')
	autocmd VimEnter * xmap <expr> if textobj#from_regexp#mapexpr('[A-Za-z0-9-./~$_+]\+')
	" url (not complete regexp for comfortableness)
	autocmd VimEnter * omap <expr> iu textobj#from_regexp#mapexpr('[A-Za-z0-9\-./~$_:?=%!*()<>#:@&]\+')
	autocmd VimEnter * xmap <expr> iu textobj#from_regexp#mapexpr('[A-Za-z0-9\-./~$_:?=%!*()<>#:@&]\+')
	" regexp
	autocmd VimEnter * omap <expr> ir textobj#from_regexp#mapexpr('/.*/')
	autocmd VimEnter * xmap <expr> ir textobj#from_regexp#mapexpr('/.*/')
	" message
	" ()内の`|`は\\が必要みたい
	" つまり，`|`を使いたいときには`'\(xxx\\|yyy\)'`
	autocmd VimEnter * omap <expr> im textobj#from_regexp#mapexpr('\("\([^\\"]\\|\\.\)*"'.'\\|'."'.*'\\)")
	autocmd VimEnter * xmap <expr> im textobj#from_regexp#mapexpr('\("\([^\\"]\\|\\.\)*"'.'\\|'."'.*'\\)")
	" space
	autocmd VimEnter * omap <expr> i<Space> textobj#from_regexp#mapexpr('\S\+')
	autocmd VimEnter * xmap <expr> i<Space> textobj#from_regexp#mapexpr('\S\+')
augroup END
