filetype off | filetype plugin indent off " temporarily disable

" [vim の :\! コマンドでも \.bashrc のエイリアス設定を有効にする \- Qiita]( https://qiita.com/horiem/items/5f503af679d8aed24dd5 )
if filereadable(glob('~/.bashenv'))
	let $BASH_ENV=expand('~/.bashenv')
endif
" [dotfiles/dot\.zshenv at master · poppen/dotfiles]( https://github.com/poppen/dotfiles/blob/master/dot.zshenv )
if filereadable(glob('~/.zshenv'))
	let $ZSH_ENV=expand('~/.zshenv')
endif

" [not work on Mac OSX Mavericks · Issue \#41 · suan/vim\-instant\-markdown]( https://github.com/suan/vim-instant-markdown/issues/41 )
" 上記の!コマンドでaliasを利用するときとの相性が悪い
" set shell=bash\ -i

let s:local_vimrc = expand('~/.local.vim')


call plug#begin('~/.vim/plugged')
runtime! config/plug/*.vim

Plug 'umaumax/autoread-vim'
Plug 'umaumax/skeleton-vim'
Plug 'umaumax/comment-vim'

" tab for completion
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = "context"

" mark viewer
Plug 'jeetsukumaran/vim-markology'
" normal modeでddすると表示が一時的にずれる
" Plug 'kshenoy/vim-signature'
" highlight SignColumn ctermbg=Black guibg=#000000

" 本体close時にbarがcloseしない...
" Plug 'hisaknown/nanomap.vim'
" " More scrollbar-ish behavior
" let g:nanomap_auto_realign = 1
" let g:nanomap_auto_open_close = 1
" let g:nanomap_highlight_delay = 100

Plug 'reireias/vim-cheatsheet'
" TODO:拡張子によって，ファイルを変更する? or all for vim?
let g:cheatsheet#cheat_file = expand('~/.cheatsheet.md')

" status line
Plug 'vim-airline/vim-airline'

" required
" npm -g install instant-markdown-d
" Plug 'suan/vim-instant-markdown'
" :InstantMarkdownPreview
" let g:instant_markdown_autostart = 0

" [vim で JavaScript の開発するときに最近いれた設定やプラグインとか - 憧れ駆動開発](http://atasatamatara.hatenablog.jp/entry/2013/03/09/211908)
Plug 'vim-scripts/JavaScript-Indent'
Plug 'jelera/vim-javascript-syntax'
Plug 'kchmck/vim-coffee-script'
Plug 'felixge/vim-nodejs-errorformat'
Plug 'othree/html5.vim'

Plug 'davidhalter/jedi-vim'
let g:jedi#auto_initialization = 1
let g:jedi#rename_command = "<leader>r"
let g:jedi#popup_on_dot = 1

" auto chmod +x
Plug 'tyru/autochmodx.vim'
Plug 'scrooloose/nerdtree'
nnoremap <silent><C-e> :NERDTreeToggle<CR>

Plug 'tpope/vim-surround'
Plug 'kana/vim-submode'
" :S/{pattern}/{string}/[flags]
" crs	"SnakeCase" → "snake_case"
" crm	"mixed_case" → "MixedCase"
" crc	"camel_case" → "camelCase"
" cru	"upper_case" → "UPPER_CASE"
Plug 'tpope/vim-abolish'
Plug 'lervag/vimtex'
" css
Plug 'lilydjwg/colorizer'
" this plugin fix vim's awk bugs
Plug 'vim-scripts/awk.vim'

" for ascii color code
Plug 'vim-scripts/AnsiEsc.vim'
" 行末の半角スペース/tabを可視化
" :FixWhitespaceというコマンドを実行すると、そうしたスペースを自動的に削除
Plug 'bronson/vim-trailing-whitespace'

Plug 'gabrielelana/vim-markdown'
Plug 'dhruvasagar/vim-table-mode'
" For Markdown-compatible tables use
let g:table_mode_corner="|"

" autocomplete
" Plug 'vim-scripts/L9'
" Plug 'othree/vim-autocomplpop'

Plug 'elzr/vim-json'
" :NeatJson			Format
" :NeatRawJson		EncodedFormat
Plug '5t111111/neat-json.vim'

" to use this lib, you have to set filetype=gnuplot by autocmd
Plug 'vim-scripts/gnuplot.vim'

" [シェルスクリプトを簡単にチェックできるShellCheck, Vimでも使える]( http://rcmdnk.github.io/blog/2014/11/26/computer-bash-zsh/ )
" with shellcheck (brew install shellcheck)
Plug 'vim-syntastic/syntastic'

" highlight word (on cursor)
Plug 't9md/vim-quickhl'
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
" [Neovimで複数の単語をハイライト\(vim\-quickhl\.vim\) @Windows10 \- ぱちコマな日々]( http://pachicoma.hateblo.jp/entry/2017/03/08/Neovim%E3%81%A7%E8%A4%87%E6%95%B0%E3%81%AE%E5%8D%98%E8%AA%9E%E3%82%92%E3%83%8F%E3%82%A4%E3%83%A9%E3%82%A4%E3%83%88%28vim-quickhl_vim%29_%40Windows10 )
let g:quickhl_manual_enable_at_startup = 1
let g:quickhl_manual_keywords = [
			\ {"pattern": 'NOTE\c', "regexp": 1 },
			\ {"pattern": 'TODO\c', "regexp": 1 },
			\ {"pattern": 'MEMO\c', "regexp": 1 },
			\ {"pattern": 'FIX\c', "regexp": 1 },
			\ {"pattern": 'FYI\c', "regexp": 1 },
			\ {"pattern": 'WARN\c', "regexp": 1 },
			\ {"pattern": 'INFO\c', "regexp": 1 },
			\ ]

" " for fatih/vim-go
" let g:go_asmfmt_autosave=0
" " .s -> Plan9形式でのformatとする
" "Plug 'vim-scripts/asm8051.vim'
" Plug 'Shirk/vim-gas'
" augroup filetypedetect
" 	au BufNewFile,BufRead *.s,*.inc,*.asm,*.S,*.ASM,*.INC,*.plan9,*.as,*.AS set ft=gas
" augroup END

call plug#end()

" GNU Global
" ソースファイル中に定義されている関数一覧
" nnoremap gf :Gtags -f %<CR>
" grep
" nnoremap gr :Gtags -g
" 現在のカーソル下の宣言部にjmp
" nnoremap gc :GtagsCursor<CR>
" next/pre
" nnoremap gn :cn<CR>
" nnoremap gp :cp<CR>

runtime! config/init/*.vim

" #### 表示設定 ####
set t_Co=256
set encoding=utf8
set fileencoding=utf-8
set list  " 不可視文字を表示
set ruler " 右下に表示される行・列の番号を表示する
set wrap  " ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲ " 不可視文字を表示
set showcmd " コマンドを画面最下部に表示する
set shortmess+=I " 起動時のメッセージを消す
set number      "行番号を表示する
set title       "編集中のファイル名を表示
set showmatch   "括弧入力時の対応する括弧を表示
set tabstop=4   "インデントをスペース4つ分に設定
set shiftwidth=4 "自動的に挿入されるインデント
set smartindent  "オートインデント
set incsearch    "インクリメント検索(リアルタイム検索)
set wildmenu wildmode=list:full "入力補完機能
set nohlsearch   "検索キーワードハイライト無効
set cursorline   "カーソル行ハイライト
set laststatus=2 "常に編集中ファイル名表示

" 全角スペースに色を付加
hi ZenkakuSpace gui=underline guibg=DarkBlue cterm=underline ctermfg=LightBlue " 全角スペースの定義
match ZenkakuSpace /　/ 			" 全角スペースの色を変更

" 全角記号問題対策
" Terminal or iTerm の対策も必要
" [vim,iTerm2で★とか■とか※とかがずれるのでなんとかした \- Qiita]( https://qiita.com/macoshita/items/f7e0f5eda02f45736b52 )
" [Mac OS X \(Mountain Lion\)のTerminalで全角記号の表示ズレを直す方法 \- ソバガラマクラ]( http://t1macrggs.hatenablog.jp/entry/2012/08/08/171717 )
set ambiwidth=double

" #### 検索設定 ####
" [vim smartcaseとignorecaseで検索をよりよくする方法](http://kaworu.jpn.org/kaworu/2010-11-24-1.php)
set ignorecase "大文字/小文字の区別なく検索する
set smartcase  "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan   "検索時に最後まで行ったら最初に戻る

" #### 動作設定 ####
set mouse=a " マウスの設定をすべて有効にする
set textwidth=0 " 自動改行解除
set history=10000 " コマンド、検索パターンを10000個まで履歴に残す

" [vimで文字が削除出来ないと思ったらバックスペースが効かなくなった - Qiita]( http://qiita.com/omega999/items/23aec6a7f6d6735d033f )
set backspace=indent,eol,start

" #### file setting ####
set nocompatible | set noswapfile | set nobackup
augroup reopen_cursor_position
	au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
augroup END

" vim file open log
let s:full_path = expand("%:p")
let s:vim_edit_log_path = "$HOME/.vim_edit_log"
let s:now = localtime()
let s:time_str = strftime("%Y/%m/%d %H:%M:%S", s:now)
execute ":redir! >> " . s:vim_edit_log_path
silent! echon s:time_str . " " . s:full_path . "\n"
redir END

" ################ playground ######################
" 現在の行の中央へ移動
" [vimで行の中央へ移動する - Qiita]( http://qiita.com/masayukiotsuka/items/683ffba1e84942afbb97?utm_campaign=popular_items&utm_medium=referral&utm_source=popular_items )
" go to center
nnoremap gc :call cursor(0,strlen(getline("."))/2)<CR>

" #### spell check ####
" [Vim のスペルチェッカ早わかり - Alone Like a Rhinoceros Horn]( http://d.hatena.ne.jp/h1mesuke/20100803/p1 )
" ]s : next (zn)
" [s : back (zN)
" z= : list(fix)
" zg : good
" zw : wrong
" cjk disable asian language check
" f:fix
nnoremap zf z=
set spelllang=en,cjk
set spell
" [Vimのスペルチェックのハイライトを止めて下線だけにする方法 - ジャバ・ザ・ハットリの日記]( http://tango-ruby.hatenablog.com/entry/2015/09/04/175729 )
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=9
" [Toggle spellcheck on/off in vim]( https://gist.github.com/brandonpittman/9d15134057c7267a88a8 )
function! ToggleSpellCheck()
	set spell!
	if &spell
		set spell
	else
		set nospell
	endif
endfunction
" English Check
nnoremap <silent> ec :call ToggleSpellCheck()<CR>

call submode#enter_with('bufmove', 'n', '', 'zn', ']s')
call submode#map       ('bufmove', 'n', '',  'n', ']s')
call submode#enter_with('bufmove', 'n', '', 'zN', '[s')
call submode#map       ('bufmove', 'n', '',  'N', '[s')

" git logのauthorが自分と一致する場合はプライベートなファイルであると仮定する
function! IsPrivateWork(...)
	let l:dir_path = get(a:, 1, expand('%:p:h'))
	let l:author = system("git config user.name")
	let l:authors = system("cd " . l:dir_path . " && git log | grep 'Author' | cut -d' ' -f2 | sort | uniq")
	return l:authors == "" || l:authors == "fatal: not a git repository (or any of the parent directories): .git\n" || l:authors == l:author
endfunction

" [Vim:カーソル位置を移動せずにファイル全体を整形する \- ぼっち勉強会]( http://kannokanno.hatenablog.com/entry/2014/03/16/160109 )
function! s:format_file()
	let view = winsaveview()
	normal gg=G
	silent call winrestview(view)
endfunction

" (force) format
nnoremap fm :call <SID>format_file()<CR>

" [rhysd/vim-clang-format: Vim plugin for clang-format, a formatter for C, C++ and Obj-C code](https://github.com/rhysd/vim-clang-format)
if IsPrivateWork()
	augroup auto_compile
		autocmd!
		if executable('clang-format')
			autocmd BufWrite,FileWritePre,FileAppendPre *.[ch] :on
			autocmd BufWinEnter *.[ch] :ClangFormatAutoEnable
			autocmd BufWinEnter *.[ch]pp :ClangFormatAutoEnable
			autocmd BufWinEnter *.m :ClangFormatAutoEnable
		endif
		" tex auto compile
		if executable('latexmk')
			autocmd BufWritePost *.tex :!latexmk %
		endif

		if executable('jq')
			autocmd BufWrite,FileWritePre,FileAppendPre *.json :Jq
		endif

		auto BufWritePre *.html :call s:format_file()
		auto BufWritePre *.css :setf css | call s:format_file()
		auto BufWritePre *.js :call s:format_file()
		auto BufWritePre *.tex :call s:format_file()
		auto BufWritePre *.cs :OmniSharpCodeFormat

		" vimのデフォルトのawkコマンドはバグがあるので required:Plug 'vim-scripts/awk.vim'
		auto BufWritePre *.awk :call s:format_file()
		auto BufWritePre *.sh :call s:format_file()
		auto BufWritePre *.{vim,vimrc} :call s:format_file()
		auto BufWritePre *.bashrc :call s:format_file()
		auto BufWritePre *.bashenv :call s:format_file()
		auto BufWritePre *.bash_profile :call s:format_file()
		auto BufWritePre *.zshrc :call s:format_file()
		auto BufWritePre *.zshenv :call s:format_file()
		auto BufWritePre *.zprofile :call s:format_file()
	augroup END
endif
augroup set_filetype
	autocmd!
	au BufRead,BufNewFile *.{gp,gnu,plt,gnuplot} set filetype=gnuplot
	au BufNewFile,BufRead *.md :set syntax=markdown | :set filetype=markdown
	au BufRead,BufNewFile *.js set ft=javascript syntax=jquery
	" 	au BufRead,BufNewFile *.py let g:indent_guides_enable_on_vim_startup=1 | let g:indent_guides_guide_size=2
augroup END

" not use interactive command (e.g. peco) in this function
function! s:pipe(...) abort
	let @+ = system(join(a:000,' '))
endfunction
command! -nargs=* -complete=command Pipe call s:pipe(<f-args>)
command! -nargs=* -complete=command P call s:pipe(<f-args>)
" ################ playground ######################

"#### END ####
filetype plugin indent on " enable
syntax on "コードの色分け

" seamless line movement
" [vim のカーソル移動で欲しかったアレ \- Cat of AZ]( http://fisto.hatenablog.com/entry/2012/11/16/181349 )
set whichwrap=b,s,[,],<,>

if filereadable(s:local_vimrc)
	execute 'source' s:local_vimrc
endif
