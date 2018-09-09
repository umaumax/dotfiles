" conceal の表示を有効にする
set conceallevel=1
" どのモードで conceal の文字にするか
set concealcursor=nvic

augroup full-width-char-conceal-group
	autocmd!
	autocmd WinEnter,WinLeave,BufRead,BufNew,BufEnter,Syntax * call FullwidthConceal()
augroup END

function! FullwidthConceal()
	" NOTE: template
	" 	syntax match HalfwidthHypen // display containedin=ALL conceal cchar=
	syntax match FullwidthRectangle /□/ display containedin=ALL conceal cchar=o
	syntax match HalfwidthMiddlePoint /·/ display containedin=ALL conceal cchar=.
	syntax match HalfwidthHypen /—/ display containedin=ALL conceal cchar=-
	syntax match HalfwidthHypen /‘/ display containedin=ALL conceal cchar='
	syntax match HalfwidthHypen /’/ display containedin=ALL conceal cchar='
	syntax match HalfwidthHypen /→/ display containedin=ALL conceal cchar=👉
	" NOTE: treeの表示は崩れない
	" 	syntax match HalfwidthHypen /├/ display containedin=ALL conceal cchar=+
	" 	syntax match HalfwidthHypen /─/ display containedin=ALL conceal cchar=-
	" 	syntax match HalfwidthHypen /└/ display containedin=ALL conceal cchar=L
	" 	syntax match HalfwidthHypen /│/ display containedin=ALL conceal cchar=|
	" NOTE: つじつまは合うが，treeの表示は崩れる
	syntax match HalfwidthHypen /├/ display containedin=ALL conceal cchar=＋
	syntax match HalfwidthHypen /─/ display containedin=ALL conceal cchar=ー
	syntax match HalfwidthHypen /└/ display containedin=ALL conceal cchar=Ｌ
	syntax match HalfwidthHypen /│/ display containedin=ALL conceal cchar=｜
	syntax match HalfwidthHypen /“/ display containedin=ALL conceal cchar="
	syntax match HalfwidthHypen /”/ display containedin=ALL conceal cchar="
endfunction
