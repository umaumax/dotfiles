if !Doctor('go','fatih/vim-go')
	finish
endif
" NOTE:
" vim-goとdeopleteが混ざっているが，...
" golang
" 何もない場所で<C-x><C-o> or <C-Space>
" .のあとで<C-Space>tab(自動)

"[vim-goをインストールしてみた（所要時間：15分） - Qiita](http://qiita.com/luckyriver0/items/e4f21c507d3fd2c0ffe9)
"[VimでGo言語 - Humanity](http://tyru.hatenablog.com/entry/2015/07/09/010239)
"[vimのGolang環境設定 - プログラミングメモ](http://yukirinmk2.hatenablog.com/entry/2015/04/29/000344)

Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
let g:go_disable_autoinstall = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_interfaces = 1
":he go-settings
" Highlights commonly used library types (io.Reader, etc.).
let g:go_highlight_extra_types = 1

" 後にファイルがプライベートかどうかを判断し有効化する
let g:go_fmt_autosave = 0
" ***. の表記があるとその"***"パッケージを自動で探しに行くので保存が遅くなるので注意
let g:go_fmt_command = "gofmt"
"let g:go_lint_command = "golint"

let g:molokai_original = 1
let g:rehash256 = 1

augroup go_setting
	autocmd!
	" require 'tomasr/molokai'
	" NOTE:
	" colorschemeの設定タイミングによって't9md/vim-quickhl'が正常に反映されない
	" 	au BufRead,BufNewFile *.go colorscheme molokai

	" [Highlight go extra vars]( http://esola.co/posts/2016/highlight-go-extra-vars )
	autocmd FileType go :highlight goExtraVars cterm=bold ctermfg=136
	autocmd FileType go :match goExtraVars /\<ok\>\|\<err\>/
augroup END

Plug 'zchee/vim-goiferr'

" " for fatih/vim-go
" let g:go_asmfmt_autosave=0
" " .s -> Plan9形式でのformatとする
" "Plug 'vim-scripts/asm8051.vim'
" Plug 'Shirk/vim-gas'
" augroup filetypedetect
" 	au BufNewFile,BufRead *.s,*.inc,*.asm,*.S,*.ASM,*.INC,*.plan9,*.as,*.AS set ft=gas
" augroup END

