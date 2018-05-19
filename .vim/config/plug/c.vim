""""""""""""""""""""""""""""""""""""
" C,C++,(Objective-C)コード整形
""""""""""""""""""""""""""""""""""""
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user'

" syntax highlight
Plug 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
let g:cpp_concepts_highlight = 1

" すごい良い
" [clang-format を イイ感じに設定する - def yasuharu519(self):](http://yasuharu519.hatenablog.com/entry/2015/12/13/210825)
" [ClangFormatスタイルオプション — Algo13 2016.04.11 ドキュメント](http://algo13.net/clang/clang-format-style-oputions.html)
" [C や C++ のコードを自動で整形する clang-format を Vim で - sorry, uninuplemented:](http://rhysd.hatenablog.com/entry/2013/08/26/231858)

" http://rhysd.hatenablog.com/entry/2013/08/26/231858
" http://algo13.net/clang/clang-format-style-oputions.html
" http://qiita.com/termoshtt/items/00552cbd776348f75750
" https://github.com/rhysd/vim-clang-format
"
" "ColumnLimit" : 0,
" 通常は80:途中の改行が微妙,AAなどの文字列配列テーブルの表示が崩れる
" 0にするとこの問題が解決されるが、#include \ \n "sample.h" となってしまり
" つまり、文字列の手前で改行してしまうのだ...
" http://clang-developers.42468.n3.nabble.com/clang-format-and-quot-ASCII-art-quot-formatting-td4028766.html
" http://stackoverflow.com/questions/30057534/clang-format-binpackarguments-not-working-as-expected

" ========== vim-clang-format の設定 ============
" アクセス指定子は1インデント分下げる
" 短い if 文は1行にまとめる
" テンプレートの宣言(template<class ...>)後は必ず改行する
" C++11 の機能を使う
" {} の改行は Stroustrup スタイル（関数宣言時の { のみ括弧前で改行を入れる）
let g:clang_format#style_options = {
			\ "AccessModifierOffset" : -4,
			\ "AllowShortIfStatementsOnASingleLine" : "true",
			\ "AlignConsecutiveAssignments" : "true",
			\ "AlignTrailingComments" : "true",
			\ "AlwaysBreakTemplateDeclarations" : "true",
			\ "Standard" : "Cpp11",
			\ "BreakBeforeBraces" : "Stroustrup",
			\ "ColumnLimit" : 320,
			\ "CommentPragmas" : "^",
			\ "IndentWidth" : 4,
			\ "TabWidth" : 4,
			\ "ConstructorInitializerIndentWidth" : 2,
			\ "BreakConstructorInitializersBeforeComma" : "true",
			\ "ContinuationIndentWidth" : 2,
			\ }
let g:clang_format#code_style = "Google"

" C++
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/unite.vim'

" neocomplete.vim と併用して使用する場合
let g:marching_enable_neocomplete = 1

if !exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

" 処理のタイミングを制御する
" 短いほうがより早く補完ウィンドウが表示される
" ただし、marching.vim 以外の処理にも影響するので注意する
set updatetime=100

let g:marching_backend = "sync_clang_command"

" [本の虫: vim-clang: clangを使ったC++の静的補完Vimプラグイン](http://cpplover.blogspot.jp/2015/04/vim-clang-clangcvim.html)
" [C/C++の補完プラグインをclang_completeからvim-clangに乗り換えた - Qiita](http://qiita.com/koara-local/items/815b08ff5c6673d8a5c6)
Plug 'justmao945/vim-clang'
let g:clang_c_options = '-std=c11'
" include先のパスをココに指定するもしくは同じディレクトリに.clangファイルを
" 用意する (e.g. echo "-I." > .clang)
" [justmao945/vim-clang: Clang completion plugin for vim](https://github.com/justmao945/vim-clang)
" structはうまく補完されていないかもextern C?!
let g:clang_cpp_options = '-std=c++1z -stdlib=libc++ --pedantic-errors -I /Users/user/cpp/lib'

" disable auto completion for vim-clang
let g:clang_auto = 0

" default 'longest' can not work with neocomplete
let g:clang_c_completeopt   = 'menuone'
let g:clang_cpp_completeopt = 'menuone'

let g:clang_complete_copen=1
let g:clang_hl_errors=1

" b;;でboost::となる
augroup cpp-namespace
	autocmd!
	autocmd FileType cpp inoremap <buffer><expr>; <SID>expand_namespace()
augroup END
function! s:expand_namespace()
	let s = getline('.')[0:col('.')-1]
	if s =~# '\<b;$'
		return "\<BS>oost::"
	elseif s =~# '\<s;$'
		return "\<BS>td::"
	elseif s =~# '\<d;$'
		return "\<BS>etail::"
	else
		return ';'
	endif
endfunction

" [カレントファイルにインクルードガードを書き込むvimスクリプト - Qiita](http://qiita.com/xeno1991/items/27d9aaf0501c41116aec)
"----------------------------------------------------
" Insert include guard to the current file
"----------------------------------------------------
command!  -nargs=0 IncGuard call IncludeGuard()
function! IncludeGuard()
	let name = fnamemodify(expand('%'),':t')
	let name = toupper(name)
	let included = substitute(name,'\.','_','g').'_INCLUDED__'
	let res_head = '#ifndef '.included."\n#define ".included."\n\n"
	let res_foot = "\n".'#endif //'.included."\n"
	silent! execute '1s/^/\=res_head'
	silent! execute '$s/$/\=res_foot'
endfunction
