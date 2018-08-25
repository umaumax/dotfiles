" NOTE: ignore yank blank string
nnoremap <silent> dd "zdd:if split(@z,"\n")!=[] \| let @+=@z \| endif<CR>
vnoremap <silent> d "zdd:if split(@z,"\n")!=[] \| let @+=@z \| endif<CR>

for i in range(0,9)
	execute "nnoremap y".i." :let @+=@".i."\<CR>:echo '[copyed]:'.split(@+, \"\\n\")[0]\<CR>"
endfor

finish

"-------------------------------- 
"-------------------------------- 
"-------------------------------- 

let s:yy=''
let s:dd=''

function! s:reg_uniq()
	if s:yy == @+ || s:dd == @1
		return
	endif

	" TODO: [eval \- Vim日本語ドキュメント]( https://vim-jp.org/vimdoc-ja/eval.html )
	" TODO: use call setreg('g', 'xxx', 'V'), getreg, getregtype

	" NOTE: load
	let regs=['dummy']
	for i in range(1,9)
		execute 'let regs+=[@'.i.']'
	endfor

	" NOTE: uniq
	for i in range(1,9)
		for j in range(i+1,9)
			if regs[i] == regs[j]
				let regs[j] = ''
			endif
		endfor
	endfor

	" NOTE: 昇順に詰める
	for i in range(1,9)
		if regs[i] == ''
			continue
		endif
		for j in range(1,i-1)
			if regs[j] == '' || regs[j] == "\n"
				let regs[j] = regs[i]
				let regs[i] = ''
			endif
		endfor
	endfor
	" NOTE: store
	for i in range(1,9)
		execute 'let @'.i.' = regs['.i.']'
	endfor
endfunction

" NOTE: rotate yy buffer like dd
function! s:reg_update_yank_ring()
	if @+ == '' && @+ == "\n"
		return
	endif
	for i in range(9,2,-1)
		execute 'let @'.i.' = @'.(i-1)
	endfor
	let @1=@+
endfunction

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
	call s:reg_update_yank_ring()
	call s:reg_uniq()
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
