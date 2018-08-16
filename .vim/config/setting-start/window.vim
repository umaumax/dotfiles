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
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>

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
	call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
	call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
	call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
	call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
	call submode#map('bufmove', 'n', '', '>', '<C-w>>')
	call submode#map('bufmove', 'n', '', '<', '<C-w><')
	call submode#map('bufmove', 'n', '', '+', '<C-w>+')
	call submode#map('bufmove', 'n', '', '-', '<C-w>-')

	call submode#enter_with('bufmove', 'n', '', 'sn', 'gt')
	call submode#enter_with('bufmove', 'n', '', 'sp', 'gT')
	call submode#enter_with('bufmove', 'n', '', 'st', ':<C-u>tabnew<CR>')
	call submode#map('bufmove', 'n', '', 'sn', 'gt')
	call submode#map('bufmove', 'n', '', 'sp', 'gT')
	call submode#map('bufmove', 'n', '', 'st', ':<C-u>tabnew<CR>')
	call submode#map('bufmove', 'n', '', 'n', 'gt')
	call submode#map('bufmove', 'n', '', 'p', 'gT')
	call submode#map('bufmove', 'n', '', 't', ':<C-u>tabnew<CR>')
	" NOTE: skip submode delay
	call submode#map('bufmove', 'n', '', ':', ':call feedkeys("::", "n")<CR>')
	call submode#map('bufmove', 'n', '', 'i', ':call feedkeys(":i", "n")<CR>')
	call submode#map('bufmove', 'n', '', 'a', ':call feedkeys(":a", "n")<CR>')
endif
