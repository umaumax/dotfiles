" ##############
" #### plug ####
call plug#begin('~/.vim/plugged')
runtime! config/plugin/*.vim

" ###################
" #### my plugin ####
Plug 'umaumax/autoread-vim'
Plug 'umaumax/skeleton-vim'
Plug 'umaumax/comment-vim'
" :BenchVimrc
Plug 'umaumax/benchvimrc-vim'
" fork元の'z0mbix/vim-shfmt'ではエラー時に保存できず，メッセージもなし
if Doctor('shfmt', 'umaumax/vim-shfmt')
	Plug 'umaumax/vim-shfmt'
endif
if Doctor('cmake-format', 'umaumax/vim-cmake-format')
	Plug 'umaumax/vim-cmake-format'
endif
" let g:shfmt_fmt_on_save = 1

" input helper
" Plug 'kana/vim-smartinput'
Plug 'umaumax/vim-smartinput'

" Plug 'mattn/sonictemplate-vim'
Plug 'umaumax/sonictemplate-vim'
" NOTE: :Template -> :T
let g:sonictemplate_commandname='T'
let g:sonictemplate_postfix_key='<C-x><C-p>'
let g:sonictemplate_vim_template_dir = [
			\ '~/dotfiles/template'
			\]
" if you want to add element, do like below
" let g:sonictemplate_vim_template_dir = g:sonictemplate_vim_template_dir + ['~/template']

" #### my plugin ####
" ###################

" [Vim scriptでのイミディエイトウィンドウを作った。 \- Qiita]( https://qiita.com/rbtnn/items/89c78baf3556e33c880f )
Plug 'rbtnn/vimconsole.vim'

" :ShebangInsert
Plug 'sbdchd/vim-shebang'
" override and append
let g:shebang#shebangs = {
			\'sh':'#!/usr/bin/env bash',
			\'awk':'#!/usr/bin/env awk -f'
			\}

" python formatter
" error表示のwindowの制御方法が不明
" Plug 'tell-k/vim-autopep8'

" vim lint
" pip install vim-vint
if Doctor('vint', 'Kuniwak/vint')
endif
Plug 'Kuniwak/vint', {'do': 'pip install vim-vint'}

" auto indent detector
" [editor \- Can vim recognize indentation styles \(tabs vs\. spaces\) automatically? \- Stack Overflow]( https://stackoverflow.com/questions/9609233/can-vim-recognize-indentation-styles-tabs-vs-spaces-automatically )
Plug 'tpope/vim-sleuth'

" NOTE: 必要とあらば試してみる
" [Vimで自動的にファイルタイプを設定してくれる便利プラグインvim\-autoftを作りました！ \- プログラムモグモグ]( https://itchyny.hatenablog.com/entry/2015/01/15/100000 )
" Plug 'itchyny/vim-autoft'

" <C-N> on word
" repeat <C-N> or <C-X>:skip, <C-p>:prev
" c,s: change text
" I: insert at start of range
" A: insert at end of range
Plug 'terryma/vim-multiple-cursors'

Plug 'Shougo/unite.vim'

" no dependency on vim swapfile option
Plug 'LeafCage/autobackup.vim'
let g:autobackup_backup_dir = g:tempfiledir
let g:autobackup_backup_limit = 1024

" " start screen
" Plug 'mhinz/vim-startify'
" " startifyのヘッダー部分に表示する文字列をdateの結果に設定する
" let g:startify_custom_header =''
" " set file key short cut (i:insert, e:empty, q:quit)
" let s:key_mapping = "asdfghjklzxcvbnmwrtyuop"
" if v:version >= 800
" 	let g:startify_custom_indices = map(range(len(s:key_mapping)), { index, val -> s:key_mapping[val] })
" endif
" " bookmark example
" let g:startify_bookmarks = [
" 			\ '~/.vimrc',
" 			\ ]

" high light word when replacing
" command line window modeでの動作しない?
" Plug 'osyo-manga/vim-over'

" color picker
" :VCoolor
" :VCoolIns r		" For rgb color insertion
" :VCoolIns h		" For hsl color insertion
" :VCoolIns ra	" For rgba color insertion
Plug 'KabbAmine/vCoolor.vim'

" IMEがOFFにならない...
" Plug 'fuenor/im_control.vim'

" quickly select the closest text object plugin
" Plug 'gcmt/wildfire.vim'
" let g:wildfire_fuel_map = "<ENTER>"
" let g:wildfire_water_map = "<BS>"

" auto auto type detector
" this takes a little time to install
" plug 'rhysd/libclang-vim'
" plug 'libclang-vim/clang-type-inspector.vim'

" too late
" plug 'valloric/youcompleteme'
" let g:ycm_filetype_blacklist = {'go': 1}
" let g:ycm_global_ycm_extra_conf = expand('~/.vim/plugged/youcompleteme/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py')

" A comprehensive Vim utility functions for Vim plugins
" Plug 'vim-jp/vital.vim'

Plug 'ekalinin/Dockerfile.vim'

" gtags
Plug 'lighttiger2505/gtags.vim'
" Options
let g:Gtags_Auto_Map = 0
let g:Gtags_OpenQuickfixWindow = 1
" Keymap
" Show definetion of function cousor word on quickfix
nmap <silent> K :<C-u>exe("Gtags ".expand('<cword>'))<CR>
" Show reference of cousor word on quickfix
nmap <silent> R :<C-u>exe("Gtags -r ".expand('<cword>'))<CR>
" ctags not found
" gen_tags.vim need ctags to generate tags
Plug 'jsfaint/gen_tags.vim'
let g:gen_tags#gtags_auto_gen = 1

" rtags
Plug 'lyuts/vim-rtags'

" mark viewer
" 'airblade/vim-gitgutter'と同様にsign機能を使うため，表示と競合するので，基本的にOFFにしてtoggleして使用する
Plug 'jeetsukumaran/vim-markology'
let g:markology_enable=1
" normal modeでddすると表示が一時的にずれる
" Plug 'kshenoy/vim-signature'
" highlight SignColumn ctermbg=Black guibg=#000000

" 本体close時にbarがcloseしない...
" Plug 'hisaknown/nanomap.vim'
" " More scrollbar-ish behavior
" let g:nanomap_auto_realign = 1
" let g:nanomap_auto_open_close = 1
" let g:nanomap_highlight_delay = 100

" Plug 'reireias/vim-cheatsheet'
" " TODO:拡張子によって，ファイルを変更する? or all for vim?
" let g:cheatsheet#cheat_file = expand('~/.cheatsheet.md')

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
" Require: node?
" NOTE: npm js-beautify is builtin this package
if Doctor('npm', 'maksimr/vim-jsbeautify')
	Plug 'maksimr/vim-jsbeautify', {'for': ['javascript','json','css','html']}
endif

" color sheme
" NOTE: if文を使用していると，Plugで一括installができない
if g:colorscheme == 'molokai'
	Plug 'tomasr/molokai'
	if !isdirectory(expand('~/.vim/colors'))
		call mkdir(expand('~/.vim/colors'), "p")
	endif
	if !filereadable(expand('~/.vim/colors/molokai.vim'))
		call system('ln -s ~/.vim/plugged/molokai/colors/molokai.vim ~/.vim/colors/molokai.vim')
	endif
elseif g:colorscheme == 'moonfly'
	Plug 'bluz71/vim-moonfly-colors'
elseif g:colorscheme == 'tender'
	Plug 'jacoborus/tender.vim'
endif

" auto chmod +x
Plug 'tyru/autochmodx.vim'

" file manager
" Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree'
let g:NERDTreeShowHidden = 1
nnoremap <silent><C-e> :NERDTreeToggle<CR>
Plug 'Xuyuanp/nerdtree-git-plugin'
" Require: fontforge
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" let g:NERDTreeLimitedSyntax = 1

" :help NERDTree-t
" CD: set root
" u:up a dir
" r,R: refresh
let g:NERDTreeMapOpenSplit='h' " 'i'
let g:NERDTreeMapOpenVSplit='v' " 's'

" set lines of words on cursor
Plug 'itchyny/vim-cursorword'

" Doxygen
" :Dox
Plug 'vim-scripts/DoxygenToolkit.vim'

Plug 'tpope/vim-surround'
" :S/{pattern}/{string}/[flags]
" crs	"SnakeCase" → "snake_case"
" crm	"mixed_case" → "MixedCase"
" crc	"camel_case" → "camelCase"
" cru	"upper_case" → "UPPER_CASE"
" call extend(Abolish.Coercions, {
"       \ 'c': Abolish.camelcase,
"       \ 'm': Abolish.mixedcase,
"       \ 's': Abolish.snakecase,
"       \ '_': Abolish.snakecase,
"       \ 'u': Abolish.uppercase,
"       \ 'U': Abolish.uppercase,
"       \ '-': Abolish.dashcase,
"       \ 'k': Abolish.dashcase,
"       \ '.': Abolish.dotcase,
"       \ ' ': Abolish.spacecase,
"       \ 't': Abolish.titlecase,
"       \ "function missing": s:function("s:unknown_coercion")
"       \}, "keep")
Plug 'tpope/vim-abolish'
Plug 'lervag/vimtex', {'for': 'tex'}
" css
Plug 'lilydjwg/colorizer', {'for': ['html', 'css', 'javascript', 'vim']}
" this plugin fix vim's awk bugs
Plug 'vim-scripts/awk.vim', {'for': 'awk'}

" for ascii color code
Plug 'vim-scripts/AnsiEsc.vim'
" 行末の半角スペース/tabを可視化
" :FixWhitespaceというコマンドを実行すると、そうしたスペースを自動的に削除
Plug 'bronson/vim-trailing-whitespace'

" ```のあとで<CR>するとindentされてしまう問題がある
" Plug 'gabrielelana/vim-markdown', {'for': 'markdown'}

" table formatter
" カーソル下のテーブルが対象
" :Tabularize /|/r<# of space of right side>
" :TableFormat
Plug 'godlygeek/tabular', {'for': 'markdown'} " The tabular plugin must come before vim-markdown.
command! -nargs=0 TF :TableFormat
" NOTE: indentがたまにおかしい
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
let g:vim_markdown_folding_disabled = 1
" Plug 'rcmdnk/vim-markdown', {'for': 'markdown'}
Plug 'dhruvasagar/vim-table-mode', {'for': 'markdown'}
" For Markdown-compatible tables use
let g:table_mode_corner="|"

" for consecutive shortcut input
Plug 'kana/vim-submode'

" [Vimメモ : vim\-expand\-regionでビジュアルモードの選択領域を拡大／縮小 \- もた日記]( https://wonderwall.hatenablog.com/entry/2016/03/31/231621 )
" il: 'kana/vim-textobj-line'
" ie: 'kana/vim-textobj-entire'
Plug 'terryma/vim-expand-region'
vmap j <Plug>(expand_region_expand)
vmap k <Plug>(expand_region_shrink)
let g:expand_region_text_objects = {
			\ 'iw'  :0,
			\ 'iW'  :0,
			\ 'i"'  :0,
			\ 'a"'  :0,
			\ 'i''' :0,
			\ 'a''' :0,
			\ 'i]'  :1,
			\ 'a]'  :1,
			\ 'ib'  :1,
			\ 'ab'  :1,
			\ 'iB'  :1,
			\ 'aB'  :1,
			\ 'il'  :0,
			\ 'ip'  :0,
			\ 'ie'  :0,
			\ }

" NOTE: oによるカーソル位置によってはexapnd or shrink
" expand range one char both side
function! s:expand_visual_range(n)
	let pos=getpos('.')
	if a:n > 0
		execute "normal gv\<Right>o\<Left>o"
	elseif a:n < 0
		execute "normal gv\<Left>o\<Right>o"
	endif
endfunction
vnoremap J :<C-u>call <SID>expand_visual_range(1)<CR>
vnoremap K :<C-u>call <SID>expand_visual_range(-1)<CR>

" autocomplete
" Plug 'vim-scripts/L9'
" Plug 'othree/vim-autocomplpop'

Plug 'elzr/vim-json', {'for': 'json'}
" :NeatJson			Format
" :NeatRawJson		EncodedFormat
Plug '5t111111/neat-json.vim', {'for': 'json'}

" to use this lib, you have to set filetype=gnuplot by autocmd
Plug 'vim-scripts/gnuplot.vim', {'for': 'gnuplot'}

if Doctor('git', 'airblade/vim-gitgutter')
	Plug 'airblade/vim-gitgutter'
	let g:gitgutter_highlight_lines = 1
	let g:gitgutter_enabled=0
	nnoremap <Space>g :GitGutterToggle<CR>
	" hunk
	nmap ]h <Plug>GitGutterNextHunk
	nmap [h <Plug>GitGutterPrevHunk
	" stage, unstage, preview
	" NOTE: stage hunkの仕様が不明瞭(一部のデータが消える)
	nmap <Leader>sh <Plug>GitGutterStageHunk
	" NOTE: how to use undo hunk?
	nmap <Leader>uh <Plug>GitGutterUndoHunk
	nmap <Leader>ph <Plug>GitGutterPreviewHunk
endif
call plug#end()
" #### plug ####
" ##############
