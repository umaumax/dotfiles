" [Vimの便利な画面分割＆タブページと、それを更に便利にする方法 \- Qiita]( https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca )
" [kana/vim\-submode: Vim plugin: Create your own submodes]( https://github.com/kana/vim-submode )
nnoremap s <Nop>
nnoremap s= <C-w>=
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
" tab
" next tab
nnoremap sn gt
" prev tab
nnoremap sp gT
" nnoremap sN :<C-u>bn<CR>
" nnoremap sP :<C-u>bp<CR>
nnoremap sN :<C-u>call TorusTabMove(1)<CR>
nnoremap sP :<C-u>call TorusTabMove(-1)<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>

" NOTE: 巡回する円環tab機構
" NOTE: +1, -1
function! TorusTabMove(...)
	let str=get(a:, 1, '+1')
	if str=='1'
		let str='+1'
	endif
	if str!='+1' && str!='-1'
		echom ':TorusTabMove +1 or -1'
		return
	endif
	let prev_flag=str=='-1'
	let next_flag=str=='+1'

	" NOTE: 1~
	let current_tab_no=tabpagenr()
	let max_tab_no = tabpagenr('$')
	if current_tab_no==1 && prev_flag
		:tabmove
		return
	endif
	if current_tab_no==max_tab_no && next_flag
		:tabmove 0
		return
	endif
	execute ':tabmove '.str
endfunction

" split window of new buffer
nnoremap ss :new<CR>
nnoremap sv :vnew<CR>
" nnoremap ss :<C-u>sp<CR><C-w>w:enew<CR>
" nnoremap sv :<C-u>vs<CR><C-w>w:enew<CR>

nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

" move window
nnoremap sr <C-w>r
nnoremap sw <C-w>w
nnoremap s0 <C-w>=
nnoremap sW <C-w>W
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H

if &rtp =~ 'vim-submode'
	function! s:easy_submode_set(submode, modes, options, lhs, cmd)
		call submode#enter_with(a:submode, a:modes, a:options, a:lhs, a:cmd)
		call submode#map(a:submode, a:modes, a:options, a:lhs, a:cmd)
		call submode#map(a:submode, a:modes, a:options, a:lhs[1:], a:cmd)
	endfunction
	call s:easy_submode_set('bufmove', 'n', '', 's>', '<C-w>>')
	call s:easy_submode_set('bufmove', 'n', '', 's<', '<C-w><')
	call s:easy_submode_set('bufmove', 'n', '', 's+', '<C-w>+')
	call s:easy_submode_set('bufmove', 'n', '', 's-', '<C-w>-')
	call s:easy_submode_set('bufmove', 'n', '', 'sn', 'gt')
	call s:easy_submode_set('bufmove', 'n', '', 'sp', 'gT')
	call s:easy_submode_set('bufmove', 'n', '', 'sN', ':<C-u>call TorusTabMove(1)<CR>')
	call s:easy_submode_set('bufmove', 'n', '', 'sP', ':<C-u>call TorusTabMove(-1)<CR>')
	call s:easy_submode_set('bufmove', 'n', '', 'st', ':<C-u>tabnew<CR>')

	" NOTE: skip submode delay
	call submode#map('bufmove', 'n', '', ':', ':call feedkeys("::", "n")<CR>')
	call submode#map('bufmove', 'n', '', 'i', ':call feedkeys(":i", "n")<CR>')
	call submode#map('bufmove', 'n', '', 'a', ':call feedkeys(":a", "n")<CR>')
endif
