set conceallevel=2
" NOTE: enable conceal which vim mode?
set concealcursor=nvic

augroup full_width_char_conceal_group
  autocmd!
  autocmd WinEnter,WinLeave,BufRead,BufNew,BufEnter,Syntax,ColorScheme * call FullwidthConceal()
augroup END

function! IsSyntaxMatchGroupRegistered(group)
  " NOTE: 現在のsyntaxにsyntax match groupが登録されているか否かの確認
  let result = ""
  silent! redir => result
  execute("silent! syntax list ".a:group)
  redir END
  return len(split(result, "\n")) >= 2
endfunction

function! FullwidthConceal()
  if IsSyntaxMatchGroupRegistered("FullwidthRectangle")
    return
  endif

  " NOTE: template
  "   syntax match HalfwidthHypen // display containedin=ALL conceal cchar=
  syntax match FullwidthRectangle /□/ display containedin=ALL conceal cchar=o
  syntax match HalfwidthMiddlePoint /·/ display containedin=ALL conceal cchar=.
  syntax match HalfwidthHypen /—/ display containedin=ALL conceal cchar=-
  syntax match HalfwidthHypen /‘/ display containedin=ALL conceal cchar='
  syntax match HalfwidthHypen /’/ display containedin=ALL conceal cchar='
  syntax match HalfwidthHypen /→/ display containedin=ALL conceal cchar=👉
  " NOTE: treeの表示は崩れない
  "   syntax match HalfwidthHypen /├/ display containedin=ALL conceal cchar=+
  "   syntax match HalfwidthHypen /─/ display containedin=ALL conceal cchar=-
  "   syntax match HalfwidthHypen /└/ display containedin=ALL conceal cchar=L
  "   syntax match HalfwidthHypen /│/ display containedin=ALL conceal cchar=|
  " NOTE: つじつまは合うが，treeの表示は崩れる
  syntax match HalfwidthHypen /├/ display containedin=ALL conceal cchar=＋
  syntax match HalfwidthHypen /─/ display containedin=ALL conceal cchar=ー
  syntax match HalfwidthHypen /└/ display containedin=ALL conceal cchar=Ｌ
  syntax match HalfwidthHypen /│/ display containedin=ALL conceal cchar=｜
  syntax match HalfwidthHypen /“/ display containedin=ALL conceal cchar="
  syntax match HalfwidthHypen /”/ display containedin=ALL conceal cchar="
endfunction
