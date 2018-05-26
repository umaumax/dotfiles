" [Vimのマーク機能、使い方まとめ \- Qiita]( https://qiita.com/syui/items/442fd0905a1f2005c10e )
Plug 'tacroe/unite-mark'
" unite mark
" https://github.com/tacroe/unite-mark
" http://d.hatena.ne.jp/tacroe/20101119/1290115586
nnoremap <silent> m<Space> :Unite mark<CR>
Plug 'zhisheng/visualmark.vim'

" mark auto reg
" http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
if !exists('g:markrement_char')
	" 'm', 's', 't'
	let g:markrement_char = [
				\     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
				\     'n', 'o', 'p', 'q', 'r', 'u', 'v', 'w', 'x', 'y', 'z'
				\ ]
endif
nnoremap <silent>mm :<C-u>call <SID>AutoMarkrement()<CR>
nnoremap <silent>mt :MarkologyToggle<CR>
function! s:AutoMarkrement()
	if !exists('b:markrement_pos')
		let b:markrement_pos = 0
	else
		let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
	endif
	execute 'mark' g:markrement_char[b:markrement_pos]
	echo 'marked' g:markrement_char[b:markrement_pos]
endfunction

" visualmark.vim
" http://nanasi.jp/articles/vim/visualmark_vim.html
" map <unique> <C-F3> <Plug>Vm_toggle_sign
