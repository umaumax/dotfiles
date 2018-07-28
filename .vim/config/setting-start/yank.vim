function! s:set_non_blank_content()
	if @+ == '' || @+ == "\n"
		for v in range(1,9)
			execute 'let reg=@'.v
			if @+ == '' || @+ == "\n" && reg != "\n"
				let @+ = reg
				break
			endif
		endfor
	endif
	if @+ != '' && @+ != "\n" && @1 != @+ | let @1 = @+ | endif
endfunction
augroup text-yank-post-group
	autocmd!
	" NOTE: disable blank or only "\n" copy
	" NOTE: 処理速度との兼ね合いで，カーソルホールド時のみ
	autocmd CursorHold,CursorHoldI * call s:set_non_blank_content()
	" NOTE: TextYankPost:only yank(no dd)
	" NOTE: yank use @+, dd use @1 (auto @2~9)
	" NOTE: yankした内容も@1~9に保存させる(TextYankPost内で@+を変更すると無限ループ?)
	" 	autocmd TextYankPost * if @+ != '' && @+ != "\n" && @1 != @+ | let @1 = @+ | endif
augroup END

