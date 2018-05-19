" 自動補完有効化
set completeopt=menuone
"for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.",'\zs')
"  exec "imap <expr> " . k . " pumvisible() ? '" . k . "' : '" . k . "\<C-X>\<C-P>\<C-N>'"
"endfor

for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.",'\zs')
exec "imap " . k . " " . k . "<C-N><C-P>"
endfor

function! OmniDotSet()
	" . の時だけオムニ補完
	imap <expr> . pumvisible() ? "\<C-E>.\<C-X>\<C-O>\<C-P>" : ".\<C-X>\<C-O>\<C-P>"
endfunction

function! OmniColonArrowSet()
	" cppの::も補完したいので一部修正
	imap <expr> :: pumvisible() ? "\<C-E>::\<C-X>\<C-O>\<C-P>" : "::\<C-X>\<C-O>\<C-P>"
	" cppの->も補完したいので一部修正
	imap <expr> -> pumvisible() ? "\<C-E>-\>\<C-X>\<C-O>\<C-P>" : "-\>\<C-X>\<C-O>\<C-P>"
endfunction

" au BufNewFile 後に複数のコマンドを記述する方法がわからなかったので、
" 無理やり関数化     "\" を用いればよいのではないかと思っているが...
" -> 最悪 "|" でもいけるかも
function! OmniCSet()
	call OmniDotSet()
	call OmniColonArrowSet()
endfunction

" 拡張子ごとにOmni補完のタイミングを調整
augroup filetypedetect
	au BufNewFile,BufRead *.{go,c,cpp,h,hpp} :call OmniDotSet()
	au BufNewFile,BufRead *.{c,cpp,cu,h,hpp}    :call OmniCSet()
	au BufNewFile,BufRead *.{cs}    :call OmniCSet()
augroup END
