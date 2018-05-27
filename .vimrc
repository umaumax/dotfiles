" old seting?
" filetype off | filetype plugin indent off " temporarily disable
" set nocompatible

" NOTE: doctor mode
" VIM_DOCTOR='on' vim

" let s:colorscheme = 'default'
let s:colorscheme = 'molokai'
" let s:colorscheme = 'moonfly'
" difficult to see visual mode
" let s:colorscheme = 'tender'

" save cwd
let s:cwd = getcwd()

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

let s:local_vimrc = expand('~/.local.vimrc')

function! Docter(plugin_name, cmd, description)
	if !executable(a:cmd)
		if $VIM_DOCTOR != ''
			echo 'Require:'. a:cmd. ' for '. a:plugin_name
			echo '    ' . a:description
		endif
	endif
endfunction

augroup set_filetype
	autocmd!
	au BufRead,BufNewFile *.{gp,gnu,plt,gnuplot} set filetype=gnuplot
	au BufNewFile,BufRead *.md :set syntax=markdown | :set filetype=markdown
	au BufRead,BufNewFile *.js set ft=javascript syntax=jquery
	au BufRead,BufNewFile *.{sh,bashrc,bashenv,bash_profile} set ft=sh
	au BufRead,BufNewFile *.{zsh,zshrc,zshenv,zprofile} set ft=zsh
	" 	au BufRead,BufNewFile *.py let g:indent_guides_enable_on_vim_startup=1 | let g:indent_guides_guide_size=2
augroup END

" ##############
" #### plug ####
call plug#begin('~/.vim/plugged')
runtime! config/plug/*.vim

" ###################
" #### my plugin ####
Plug 'umaumax/autoread-vim'
Plug 'umaumax/skeleton-vim'
Plug 'umaumax/comment-vim'
" :BenchVimrc
Plug 'umaumax/benchvimrc-vim'
" fork元の'z0mbix/vim-shfmt'ではエラー時に保存できず，メッセージもなし
Plug 'umaumax/vim-shfmt'
" let g:shfmt_fmt_on_save = 1
" #### my plugin ####
" ###################

Plug 'Shougo/unite.vim'

" :ShebangInsert
Plug 'sbdchd/vim-shebang'
Plug 'mhinz/vim-startify'
" startifyのヘッダー部分に表示する文字列をdateの結果に設定する
let g:startify_custom_header =''
" set file key short cut (i:insert, e:empty, q:quit)
let s:key_mapping = "asdfghjklzxcvbnmwrtyuop"
let g:startify_custom_indices = map(range(len(s:key_mapping)), { index, val -> s:key_mapping[val] })
" bookmark example
let g:startify_bookmarks = [
			\ '~/.vimrc',
			\ ]

" high light word when replacing
" command line window modeでの動作しない?
" Plug 'osyo-manga/vim-over'

" for correct shell format
" Plug 'z0mbix/vim-shfmt'
" let g:shfmt_fmt_on_save = 1

" input helper
Plug 'kana/vim-smartinput'

" auto auto type detector
" this takes a little time to install
" Plug 'rhysd/libclang-vim'
" Plug 'libclang-vim/clang-type-inspector.vim'

" too late
" Plug 'Valloric/YouCompleteMe'
" let g:ycm_filetype_blacklist = {'go': 1}
" let g:ycm_global_ycm_extra_conf = expand('~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py')

" A comprehensive Vim utility functions for Vim plugins
Plug 'vim-jp/vital.vim', {'for': ['vi', 'vim']}

" tab for completion
Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = "context"

" mark viewer
" 'airblade/vim-gitgutter'と同様にsign機能を使うため，表示と競合するので，基本的にOFFにしてtoggleして使用する
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
" NOTE:エラー表示がこのプラグインですぐに消えてしまって見えなくなっているかもしれない
Plug 'vim-airline/vim-airline'

" required
" npm -g install instant-markdown-d
" Plug 'suan/vim-instant-markdown'
" :InstantMarkdownPreview
" let g:instant_markdown_autostart = 0

" [vim で JavaScript の開発するときに最近いれた設定やプラグインとか - 憧れ駆動開発](http://atasatamatara.hatenablog.jp/entry/2013/03/09/211908)
Plug 'vim-scripts/JavaScript-Indent', {'for': 'javascript'}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
Plug 'kchmck/vim-coffee-script', {'for': 'javascript'}
Plug 'felixge/vim-nodejs-errorformat', {'for': 'javascript'}
Plug 'othree/html5.vim', {'for': ['html', 'javascript']}

" color sheme
if s:colorscheme == 'molokai'
	Plug 'tomasr/molokai'
elseif s:colorscheme == 'moonfly'
	Plug 'bluz71/vim-moonfly-colors'
elseif s:colorscheme == 'tender'
	Plug 'jacoborus/tender.vim'
endif

" auto chmod +x
Plug 'tyru/autochmodx.vim'
" file manager
Plug 'scrooloose/nerdtree'
let g:NERDTreeShowHidden = 1
nnoremap <silent><C-e> :NERDTreeToggle<CR>

Plug 'tpope/vim-surround'
" for consecutive shortcut input
Plug 'kana/vim-submode'
" :S/{pattern}/{string}/[flags]
" crs	"SnakeCase" → "snake_case"
" crm	"mixed_case" → "MixedCase"
" crc	"camel_case" → "camelCase"
" cru	"upper_case" → "UPPER_CASE"
Plug 'tpope/vim-abolish'
Plug 'lervag/vimtex', {'for': 'tex'}
" css
Plug 'lilydjwg/colorizer', {'for': ['html', 'css', 'javascript']}
" this plugin fix vim's awk bugs
Plug 'vim-scripts/awk.vim', {'for': 'awk'}

" for ascii color code
" Plug 'vim-scripts/AnsiEsc.vim'
" 行末の半角スペース/tabを可視化
" :FixWhitespaceというコマンドを実行すると、そうしたスペースを自動的に削除
Plug 'bronson/vim-trailing-whitespace'

Plug 'gabrielelana/vim-markdown', {'for': 'markdown'}
Plug 'dhruvasagar/vim-table-mode', {'for': 'markdown'}
" For Markdown-compatible tables use
let g:table_mode_corner="|"

" autocomplete
" Plug 'vim-scripts/L9'
" Plug 'othree/vim-autocomplpop'

Plug 'elzr/vim-json', {'for': 'json'}
" :NeatJson			Format
" :NeatRawJson		EncodedFormat
Plug '5t111111/neat-json.vim', {'for': 'json'}

" to use this lib, you have to set filetype=gnuplot by autocmd
Plug 'vim-scripts/gnuplot.vim', {'for': 'gnuplot'}

Plug 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines = 1
let g:markology_enable=0
let mapleader = "\<Space>"
" hunk
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
" stage, unstage, preview
" NOTE: stage hunkの仕様が不明瞭(一部のデータが消える)
nmap <Leader>sh <Plug>GitGutterStageHunk
" NOTE: how to use undo hunk?
nmap <Leader>uh <Plug>GitGutterUndoHunk
nmap <Leader>ph <Plug>GitGutterPreviewHunk
call plug#end()
" #### plug ####
" ##############

runtime! config/init/*.vim

" #### 表示設定 ####
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileformats=unix,dos,mac
set t_Co=256
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors")) | set termguicolors | endif
set background=dark
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
set updatetime=250

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
set textwidth=0 " 自動改行解除
set history=10000 " コマンド、検索パターンを10000個まで履歴に残す

" [vimで文字が削除出来ないと思ったらバックスペースが効かなくなった - Qiita]( http://qiita.com/omega999/items/23aec6a7f6d6735d033f )
set backspace=indent,eol,start

" seamless line movement
" [vim のカーソル移動で欲しかったアレ \- Cat of AZ]( http://fisto.hatenablog.com/entry/2012/11/16/181349 )
set whichwrap=b,s,[,],<,>

" #### file setting ####
set viminfo='100,/50,%,<1000,f50,s100,:100,c,h,!
set noswapfile | set nobackup
augroup reopen_cursor_position
	au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
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
" syntax on "コードの色分け

" ################ playground ######################
" ################ playground ######################

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
if filereadable(s:local_vimrc) | execute 'source' s:local_vimrc | endif

" ################ end of setting ################

" load cwd
execute("lcd " . s:cwd)

" colorscheme
if s:colorscheme == 'molokai'
	colorscheme molokai
	" for terminal transparent background color
	highlight Normal ctermbg=none
elseif s:colorscheme == 'moonfly'
	colorscheme moonfly
elseif s:colorscheme == 'tender'
	colorscheme tender
	" set airline theme
	let g:airline_theme = 'tender'
endif

" for 'airblade/vim-gitgutter'
call submode#enter_with('bufgit', 'n', 'r', 'gh', '<Plug>GitGutterNextHunk')
call submode#enter_with('bufgit', 'n', 'r', 'gH', '<Plug>GitGutterPrevHunk')
call submode#map('bufgit', 'n', 'r', 'h', '<Plug>GitGutterNextHunk')
call submode#map('bufgit', 'n', 'r', 'H', '<Plug>GitGutterPrevHunk')
highlight GitGutterChangeLine cterm=bold ctermfg=7 ctermbg=16 gui=bold guifg=#ffffff guibg=#2c4f1f
