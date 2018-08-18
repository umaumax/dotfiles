" #### 表示設定 ####
set encoding=utf-8
"set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac
set t_Co=256
" If you have vim >=8.0 or Neovim >= 0.1.5
" vimが対応していても，terminalの方が非対応である可能性がある
if ($TERM_PROGRAM=="iTerm.app" && has("termguicolors")) | set termguicolors | endif
set background=dark
set list  " 不可視文字を表示
set ruler " 右下に表示される行・列の番号を表示する
" set wrap  " ウィンドウの幅より長い行は折り返され、次の行に続けて表示される
set nowrap
set listchars=tab:»_,trail:-,extends:»,precedes:«,nbsp:%,eol:↲ " 不可視文字を表示
set showcmd " コマンドを画面最下部に表示する
set shortmess+=I " 起動時のメッセージを消す
set number      "行番号を表示する
" [「Vimを使ってくれてありがとう」にさようなら]( https://qiita.com/ttdoda/items/903e85f07d58018c851d )
" title stack
let &t_ti .= "\e[22;0t"
let &t_te .= "\e[23;0t"
set title       "編集中のファイル名を表示
set showmatch   "括弧入力時の対応する括弧を表示
set matchtime=1 " 0.n sec 対応するカッコにカーソルが移動する
set pumheight=20 " 補完候補の表示数
set incsearch    "インクリメント検索(リアルタイム検索)
set wildmenu wildmode=list:full "入力補完機能
" set nohlsearch   "検索キーワードハイライト無効
set laststatus=2 "常に編集中ファイル名表示
set wildignore+=*/tmp/*,*.o,*.so,*.out,*.obj,.git,build,CMakeFiles,node_modules,vender,*.rbc,*.rbo,*.swp,*.zip,*.class,.svn,*.gem,*.png,*.jpg " disable vimgrep
set display=lastline " [個人的に便利だと思うVimの基本設定のランキングを発表します！ \- プログラムモグモグ]( https://itchyny.hatenablog.com/entry/2014/12/25/090000 )
set scrolloff=8 " 最低でも上下に表示する行数
set nostartofline " いろんなコマンドの後にカーソルを先頭に移動させない
" vim-abolish some commands can be reversible
" [vim\-abolish/abolish\.txt at master - tpope/vim\-abolish]( https://github.com/tpope/vim-abolish/blob/master/doc/abolish.txt#L167 )
setlocal iskeyword+=- " 単語境界の追加(any char is ok)

" default 1000, -1
set timeout timeoutlen=500 ttimeoutlen=50

"['cursorline' を必要な時にだけ有効にする \- 永遠に未完成]( https://thinca.hatenablog.com/entry/20090530/1243615055 ) 
" > CursorHold イベントは 'updatetime' オプションで発生するまでの時間を調節できる。ただし、'updatetime' は本来スワップファイルが更新されるまでの時間なので、設定する際は注意。
" set cursorline   "カーソル行ハイライト
" set cursorcolumn "カーソル列ハイライト
set updatetime=250 "スワップファイルの自動保存時間設定。 この時間の間 (ミリ秒単位) 入力がなければ、スワップファイルがディスクに書き込まれる。

" 検索中のみ，カーソルを目立たせる
function! s:auto_highlight()
	if v:hlsearch == 0
		setlocal nocursorline | setlocal nocursorcolumn
	else
		setlocal cursorline | setlocal cursorcolumn
	endif
endfunction
augroup vimrc-auto-cursorline
	autocmd!
	" FYI: [Vimの検索ハイライト,hlsearch,:nohlsearch,v:hlsearchがややこしい \- haya14busa]( http://haya14busa.com/vim_highlight_search/ )
	" :set hlsearch
	autocmd OptionSet hlsearch call s:auto_highlight()
	" NOTE: :nohでは上記は呼ばれない
	autocmd CursorHold,CursorHoldI * call s:auto_highlight()
augroup END

" these value are maybe ignored by 'tpope/vim-sleuth' without using augroup
" if textwidth == 0 no auto new line
augroup tab_setting
	autocmd!
	" NOTE: default tab setting
	" 	autocmd BufWinEnter * execute 'setlocal tabstop='.&shiftwidth | execute 'setlocal tabstop='.&shiftwidth | if &softtabstop==0 | set expandtab | else | set noexpandtab | endif
	" 	autocmd BufWinEnter *.py exec 'setlocal softtabstop='.&tabstop
augroup END
set smartindent
command! -nargs=1 SetTab call s:set_tab(<f-args>)
function! s:set_tab(n)
	setlocal expandtab
	execute "setlocal tabstop=".a:n 
	execute "setlocal shiftwidth=".&tabstop 
	execute "setlocal softtabstop=".&tabstop
endfunction
call s:set_tab(2)

" VimのUndoを永続化する（ファイルの変更を記録します）
set undofile
execute('set undodir=' . g:tempfiledir)

" completion menu color setting
highlight Pmenu ctermfg=white ctermbg=black
highlight PmenuSel ctermfg=white ctermbg=gray

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
set history=10000 " コマンド、検索パターンを10000個まで履歴に残す(max value:10000)

" [vimで文字が削除出来ないと思ったらバックスペースが効かなくなった - Qiita]( http://qiita.com/omega999/items/23aec6a7f6d6735d033f )
set backspace=indent,eol,start

" seamless line movement
" [vim のカーソル移動で欲しかったアレ \- Cat of AZ]( http://fisto.hatenablog.com/entry/2012/11/16/181349 )
set whichwrap=b,s,[,],<,>

" #### file setting ####
" ['viminfo' \- VimWiki]( http://vimwiki.net/?%27viminfo%27 )
" '	マークが復元されるファイル履歴の最大値。オプション 'viminfo'が空でないときは、常にこれを設定しなければならない。また、このオプションを設定するとジャンプリスト |jumplist| もviminfo ファイルに蓄えられることになる。
" /	保存される検索パターンの履歴の最大値。非0 の値を指定すると、前回の検索パターンと置換パターンも保存される。これが含まれないときは、'history' の値が使われる。
" %	これが含まれると、バッファリストを保存・復元する。Vimの起動時にファイル名が引数に含まれていると、バッファリストは復元されない。 Vimの起動時にファイル名が引数に含まれていないと、バッファリストが viminfo ファイルから復元される。ファイル名のないバッファとヘルプ用バッファは、viminfo ファイルには書き込まれない。
" \" old one of <
" <	Maximum number of lines saved for each register.  If zero then registers are not saved.  When not included, all lines are saved.  '"' is the old name for this item.
" f	Whether file marks need to be stored.  If zero, file marks ('0 to '9, 'A to 'Z) are not stored.  When not present or when non-zero, they are all stored.  '0 is used for the current cursor position (when exiting or when doing ":wviminfo"). 
" s	Maximum size of an item in Kbyte.  If zero then registers are not saved.  Currently only applies to registers.  The default "s10" will exclude registers with more than 10 Kbyte of text.  Also see the '<' item above: line count limit. 
" :	保存されるコマンドライン履歴の最大値。これが含まれないときは、'history' の値が使われる。
" c	When included, convert the text in the viminfo file from the 'encoding' used when writing the file to the current 'encoding'.  See |viminfo-encoding|. 
" h	Disable the effect of 'hlsearch' when loading the viminfo file.  When not included, it depends on whether ":nohlsearch" 
" !	When included, save and restore global variables that start with an uppercase letter, and don't contain a lowercase letter.  Thus "KEEPTHIS and "K_L_M" are stored, but "KeepThis" and "_K_L_M" are not.  Only String and Number types are stored. 
set viminfo='1000,/5000,%,<1000,f1,s100,:10000,c,h,!
set noswapfile | set nobackup
augroup reopen_cursor_position
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" NOTE: use .viminfo
" vim file open log
" let s:full_path = expand("%:p")
" let s:vim_edit_log_path = "$HOME/.vim_edit_log"
" let s:now = localtime()
" let s:time_str = strftime("%Y/%m/%d %H:%M:%S", s:now)
" execute ":redir! >> " . s:vim_edit_log_path
" silent! echon s:time_str . " " . s:full_path . "\n"
" redir END

"#### END ####
" old setting?
" filetype plugin indent on " enable
syntax on "コードの色分け

" load local setting file if exist
" e.g,
" " for 'zchee/deoplete-jedi'
" " pip install neovimをしたpythonのbinへのpathを設定すること
" let g:python_host_prog  = '/usr/local/bin/python2'
" let g:python3_host_prog = '/usr/local/bin/python3'
"
" " [deoplete\-clangで快適C\+\+エディット！！！ \- Qiita]( https://qiita.com/musou1500/items/3f0b139d37d78a18786f )
" " for 'zchee/deoplete-clang'
" let g:deoplete#sources#clang#libclang_path = '/usr/local/opt/llvm/lib/libclang.dylib'
" let g:deoplete#sources#clang#clang_header = '/usr/local/opt/llvm/include/clang'

" ################ end of setting ################

" [not work on Mac OSX Mavericks · Issue \#41 · suan/vim\-instant\-markdown]( https://github.com/suan/vim-instant-markdown/issues/41 )
" 上記の!コマンドでaliasを利用するときとの相性が悪い
" set shell=bash\ -i
" [vim の :\! コマンドでも \.bashrc のエイリアス設定を有効にする \- Qiita]( https://qiita.com/horiem/items/5f503af679d8aed24dd5 )
if filereadable(glob('~/.bashenv'))
	let $BASH_ENV=expand('~/.bashenv')
endif
" [dotfiles/dot\.zshenv at master · poppen/dotfiles]( https://github.com/poppen/dotfiles/blob/master/dot.zshenv )
" [How to run zsh aliased command from vim command mode? \- Vi and Vim Stack Exchange]( https://vi.stackexchange.com/questions/16186/how-to-run-zsh-aliased-command-from-vim-command-mode )
" One possible workaround is to move these things out of .zshrc. .zshrc is only sourced for interactive terminals, but .zshenv is sourced for any invocation of zsh (except with -f). Creating aliases in .zshenv will allow them to work when zsh is called by vim.
if filereadable(glob('~/.zshenv'))
	let $ZSH_ENV=expand('~/.zshenv')
endif

" colorscheme
if g:colorscheme == 'molokai'
	colorscheme molokai
	" for terminal transparent background color
	" 	highlight Normal ctermbg=none
	" 	highlight Normal ctermbg=235
	augroup visualmode_color
		autocmd!
		autocmd ColorScheme,BufWinEnter * highlight Visual ctermbg=55 guibg=#800080
	augroup END
elseif g:colorscheme == 'moonfly'
	colorscheme moonfly
elseif g:colorscheme == 'tender'
	colorscheme tender
	" set airline theme
	let g:airline_theme = 'tender'
endif
