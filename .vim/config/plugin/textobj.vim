" NOTE:
" textobj-userを予め読み込まないと以下のpluginではエラーとなるためLazyPlugは使用できない
Plug 'kana/vim-textobj-user'
" il
LazyPlug 'kana/vim-textobj-line'
" ie
LazyPlug 'kana/vim-textobj-entire'

LazyPlug 'sgur/vim-textobj-parameter'
" i,
" a,
" i2,
" let g:vim_textobj_parameter_mapping = ','

LazyPlug 'pocke/vim-textobj-markdown'
" ic, ac

function! s:init_textobj()
	call textobj#user#plugin('php', {
				\   'code': {
				\     'pattern': ['<?php\>', '?>'],
				\     'select-a': 'aP',
				\     'select-i': 'iP',
				\   },
				\ })
endfunction

LazyPlug 'osyo-manga/vim-textobj-from_regexp'
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
	" autocmd VimEnter * omap <expr> ic textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
	" autocmd VimEnter * xmap <expr> ic textobj#from_regexp#mapexpr('[A-Za-z0-9,]\+')
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
	autocmd VimEnter * call s:init_textobj()
augroup END

" [Vimメモ : vim\-expand\-regionでビジュアルモードの選択領域を拡大／縮小 \- もた日記]( https://wonderwall.hatenablog.com/entry/2016/03/31/231621 )
" il: 'kana/vim-textobj-line'
" ie: 'kana/vim-textobj-entire'
" 'ih' my command
" 'id' my command
" ic, ac: 'pocke/vim-textobj-markdown'
LazyPlug 'terryma/vim-expand-region'
vmap j <Plug>(expand_region_expand)
vmap k <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
			\ 'iw'  :0,
			\ 'iW'  :0,
			\ 'ih'  :0,
			\ 'id'  :0,
			\ 'i<'  :0,
			\ 'a<'  :0,
			\ 'i"'  :0,
			\ 'a"'  :0,
			\ 'i''' :0,
			\ 'a''' :0,
			\ 'i`'  :0,
			\ 'a`'  :0,
			\ 'ic'  :0,
			\ 'ac'  :0,
			\ 'i]'  :1,
			\ 'a]'  :1,
			\ 'ib'  :1,
			\ 'ab'  :1,
			\ 'iB'  :1,
			\ 'aB'  :1,
			\ 'il'  :0,
			\ 'ip'  :0,
			\ 'ie'  :0,
			\ }

" NOTE: oによるカーソル位置によってはexapnd or shrink
" expand range one char both side
function! s:expand_visual_range(n)
	" NOTE: up and down move
	if visualmode() ==# 'V'
		if a:n > 0
			execute "normal! gv\<Down>"
		elseif a:n < 0
			execute "normal! gv\<Up>"
		endif
		return
	endif

	let pos=getpos('.')
	if a:n > 0
		execute "normal! gv\<Right>o\<Left>o"
	elseif a:n < 0
		execute "normal! gv\<Left>o\<Right>o"
	endif
endfunction
vnoremap <silent> J :<C-u>call <SID>expand_visual_range(1)<CR>
vnoremap <silent> K :<C-u>call <SID>expand_visual_range(-1)<CR>
