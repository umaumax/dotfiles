Plug 'kana/vim-textobj-user'

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
	autocmd VimEnter * omap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9.]\+')
	autocmd VimEnter * xmap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9.]\+')
	" comma
	autocmd VimEnter * omap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
	autocmd VimEnter * xmap <expr> ih textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
	" file path
	autocmd VimEnter * omap <expr> if textobj#from_regexp#mapexpr('[A-Za-z0-9-./ ~$_]\+')
	autocmd VimEnter * xmap <expr> if textobj#from_regexp#mapexpr('[A-Za-z0-9-./ ~$_]\+')
	" url (not complete regexp for comfortableness)
	autocmd VimEnter * omap <expr> iu textobj#from_regexp#mapexpr('[A-Za-z0-9-./~$_:?=%!*()<>#:@&]\+')
	autocmd VimEnter * xmap <expr> iu textobj#from_regexp#mapexpr('[A-Za-z0-9-./~$_:?=%!*()<>#:@&]\+')
augroup END
