" [Vimのマーク機能、使い方まとめ \- Qiita]( https://qiita.com/syui/items/442fd0905a1f2005c10e )
" Plug 'tacroe/unite-mark', {'on': 'Unite'}
" unite mark
" https://github.com/tacroe/unite-mark
" http://d.hatena.ne.jp/tacroe/20101119/1290115586
" nnoremap <silent> <Space>u :Unite mark<CR>
" command! Marks :Unite mark

" mark auto registration
" http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
if !exists('g:markrement_char')
	" ignore 'm', 's', 't' becase these are used other settings
	let g:markrement_char = [
				\     'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
				\     'n', 'o', 'p', 'q', 'r', 'u', 'v', 'w', 'x', 'y', 'z'
				\ ]
endif
nnoremap <silent>mm :<C-u>call <SID>AutoMarkrement()<CR>
nnoremap <silent><Space>m :MarkologyToggle<CR>
function! s:AutoMarkrement()
	if !exists('b:markrement_pos')
		let b:markrement_pos = 0
	else
		let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
	endif
	execute 'mark' g:markrement_char[b:markrement_pos]
	echo 'marked' g:markrement_char[b:markrement_pos]
endfunction
