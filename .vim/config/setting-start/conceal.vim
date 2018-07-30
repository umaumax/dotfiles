" conceal の表示を有効にする
set conceallevel=1
" どのモードで conceal の文字にするか
set concealcursor=nvic

augroup full-width-char-conceal-group
	autocmd!
	autocmd WinEnter,WinLeave,BufRead,BufNew,BufEnter,Syntax * call FullwidthConceal()
augroup END

function! FullwidthConceal()
	syntax match FullwidthRectangle /□/ display containedin=ALL conceal cchar=o
	syntax match HalfwidthMiddlePoint /·/ display containedin=ALL conceal cchar=.
endfunction
