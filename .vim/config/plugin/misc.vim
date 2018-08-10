" [Vim scriptでのイミディエイトウィンドウを作った。 \- Qiita]( https://qiita.com/rbtnn/items/89c78baf3556e33c880f )
LazyPlug 'rbtnn/vimconsole.vim'
let g:vimconsole#height = 8
let g:vimconsole#auto_redraw=1
" NOTE: 出力を逆順に表示
function! s:tac(context)
	let firstline=1
	let lastline=line('$')-1 " NOTE: last line is let s:PROMPT_STRING = 'VimConsole>'
	let source=getline(firstline, lastline)
	let rev_source=reverse(source)
	normal! ggVG"_x
	call setline(1, rev_source[0])
	call append(1, rev_source[1:])
endfunction
let g:vimconsole#hooks = {'on_post_redraw' : function('s:tac')}
Plug 'thinca/vim-prettyprint', {'on':'PP'}

" :ShebangInsert
Plug 'sbdchd/vim-shebang', {'on':['ShebangInsert']}
" override and append
" NOTE: mac's env command can deal multiple args by env, but linux can't
let g:shebang#shebangs = {
			\ 'awk': '#!/usr/bin/awk -f',
			\ 'sh':  '#!/usr/bin/env bash',
			\ 'python':  '#!/usr/bin/env python3',
			\ }

" NOTE: cpp is not supported
Plug 'tyru/current-func-info.vim', {'for':['c','go','vim','python','vim','sh','zsh']}

" python formatter
" error表示のwindowの制御方法が不明
" Plug 'tell-k/vim-autopep8'

" vim lint
" pip install vim-vint
if Doctor('vint', 'Kuniwak/vint')
endif
Plug 'Kuniwak/vint', {'do': 'pip install vim-vint', 'for':'vim'}

" NOTE: tab visualization
" Plug 'nathanaelkane/vim-indent-guides', {'on':'IndentGuidesEnable'}
" augroup vim-indent-guides
" 	autocmd!
" 	autocmd User VimEnterDrawPost IndentGuidesEnable
" augroup END
" let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1
" let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']

" NOTE: 反映されない
" Plug 'Yggdroot/indentLine'
" let g:indentLine_color_term = 111
" let g:indentLine_color_gui = '#708090'
" let g:indentLine_char = '|' "use ¦, ┆ or │

" auto indent detector
" [editor \- Can vim recognize indentation styles \(tabs vs\. spaces\) automatically? \- Stack Overflow]( https://stackoverflow.com/questions/9609233/can-vim-recognize-indentation-styles-tabs-vs-spaces-automatically )
LazyPlug 'tpope/vim-sleuth'

" NOTE: 必要とあらば試してみる
" [Vimで自動的にファイルタイプを設定してくれる便利プラグインvim\-autoftを作りました！ \- プログラムモグモグ]( https://itchyny.hatenablog.com/entry/2015/01/15/100000 )
" Plug 'itchyny/vim-autoft'

" <C-N> on word
" repeat <C-N> or <C-X>:skip, <C-p>:prev
" c,s: change text
" I: insert at start of range
" A: insert at end of range
LazyPlug 'terryma/vim-multiple-cursors'

LazyPlug 'Shougo/unite.vim'

" no dependency on vim swapfile option
LazyPlug 'LeafCage/autobackup.vim'
let g:autobackup_backup_dir = g:tempfiledir
let g:autobackup_backup_limit = 1024

LazyPlug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = -1
augroup vim_highlightedyank_color_group
	autocmd!
	autocmd ColorScheme,BufWinEnter * highlight HighlightedyankRegion ctermbg=237 guibg=#404040
	" 	autocmd ColorScheme,BufWinEnter * highlight HighlightedyankRegion cterm=reverse gui=reverse
	" 	autocmd ColorScheme,BufWinEnter * highlight def link HighlightedyankRegion Visual
augroup END

" NOTE: this plugin remap (),[],{}
" Plug 'vim-scripts/Highlight-UnMatched-Brackets'

" jenkins script formatter
" jenkinsfile indent require groovy format
Plug 'martinda/Jenkinsfile-vim-syntax', {'for':'Jenkinsfile'}
" Plug 'modille/groovy.vim'
Plug 'vim-scripts/groovyindent-unix', {'for':'Jenkinsfile'}

" 検索ワード入力中に、タブで入力ワード補完
" nmap / が上書きされる
" Plug 'vim-scripts/SearchComplete'
" <C-n> <C-p>で補完(最後に不要な文字列が出現する可能性がある)
" Plug 'vim-scripts/CmdlineComplete'

" コマンドライン補完を拡張し、ユーザ定義コマンドの短縮名を展開
" 置換中はエラーとなり，あくまでコマンド名の入力中のみ
LazyPlug 'LeafCage/cheapcmd.vim'
"for cmdline
cmap <Tab> <Plug>(cheapcmd-expand)

"for cmdwin
aug cheapcmd-cmdwin
	autocmd!
	autocmd CmdwinEnter * call s:define_cmdwin_mappings()
aug END
function! s:define_cmdwin_mappings()
	nmap <buffer><Tab> <Plug>(cheapcmd-expand)
	imap <buffer><Tab> <Plug>(cheapcmd-expand)
endfunction

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
Plug 'KabbAmine/vCoolor.vim', {'on':['VCoolor','VCoolIns']}

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

" NOTE: syntax file
Plug 'ekalinin/Dockerfile.vim', {'for':'Dockerfile'}

" ---- tags ----

" Required: ctags
" :Tlist
Plug 'vim-scripts/taglist.vim', {'for':['c','cpp']}
nnoremap <Space>T :Tlist<CR>
" let Tlist_Ctags_Cmd='/path/to/gtags'

" gtags
Plug 'lighttiger2505/gtags.vim', {'for':['c','cpp']}
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
Plug 'jsfaint/gen_tags.vim', {'for':['c','cpp']}
let g:gen_tags#gtags_auto_gen = 1

" rtags
Plug 'lyuts/vim-rtags', {'for':['c','cpp']}

" ---- tags ----

" mark viewer
" 'airblade/vim-gitgutter'と同様にsign機能を使うため，表示と競合するので，基本的にOFFにしてtoggleして使用する
" NOTE:
" 遅延読み込みをするとsign機能の反映が遅れるため，画面が無駄に動いてしまう
" ALEのlintの結果が見にくくなる
" マークを設定すると，その行のhighlightがおかしくなる(真っ白になる)
Plug 'jeetsukumaran/vim-markology', {'on':['MarkologyToggle','MarkologyEnable']}
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

" required
" npm -g install instant-markdown-d
" Plug 'suan/vim-instant-markdown'
" :InstantMarkdownPreview
" let g:instant_markdown_autostart = 0

" [vim で JavaScript の開発するときに最近いれた設定やプラグインとか - 憧れ駆動開発](http://atasatamatara.hatenablog.jp/entry/2013/03/09/211908)
" Plug 'vim-scripts/JavaScript-Indent', {'for': 'javascript'}
" Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" Plug 'kchmck/vim-coffee-script', {'for': 'javascript'}
" Plug 'felixge/vim-nodejs-errorformat', {'for': 'javascript'}
Plug 'othree/html5.vim', {'for': ['html', 'javascript']}
" Require: node?
" NOTE: npm js-beautify is builtin this package
if Doctor('npm', 'maksimr/vim-jsbeautify')
	Plug 'maksimr/vim-jsbeautify', {'for': ['javascript','json','css','html','vue','vue.html.javascript.css']}
endif

" for Vue.js
" [Neovim/Vim8で快適Vue\.js開発\(Vue Language Server\)]( https://muunyblue.github.io/520bae6649b42ff5a3c8c58b7fcfc5a9.html )
" npm install -g neovim
" npm install -g vue-language-server
Plug 'digitaltoad/vim-pug', {'for': ['javascript','json','css','html','vue','vue.html.javascript.css']}
Plug 'posva/vim-vue', {'for': ['html', 'vue', 'vue.html.javascript.css']}
Plug 'Shougo/context_filetype.vim', {'for': ['vue', 'vue.html.javascript.css']}
" Required: 'autozimu/LanguageClient-neovim'
let g:LanguageClient_serverCommands = {
			\ 'vue': ['vls'],
			\ }

" color sheme
" NOTE: if文を使用していると，Plugで一括installができない
if g:colorscheme == 'molokai'
	LazyPlug 'tomasr/molokai'
	if !isdirectory(expand('~/.vim/colors'))
		call mkdir(expand('~/.vim/colors'), "p")
	endif
	if !filereadable(expand('~/.vim/colors/molokai.vim'))
		call system('ln -s ~/.vim/plugged/molokai/colors/molokai.vim ~/.vim/colors/molokai.vim')
	endif
elseif g:colorscheme == 'moonfly'
	LazyPlug 'bluz71/vim-moonfly-colors'
elseif g:colorscheme == 'tender'
	LazyPlug 'jacoborus/tender.vim'
endif

" auto chmod +x
Plug 'tyru/autochmodx.vim', {'for':['sh','zsh','python','awk']}

" file manager
" Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree', {'on':['NERDTreeToggle','NERDTree']}
let g:NERDTreeShowHidden = 1
nnoremap <silent><C-e> :NERDTreeToggle<CR>
Plug 'Xuyuanp/nerdtree-git-plugin', {'on':['NERDTreeToggle','NERDTree']}
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
LazyPlug 'itchyny/vim-cursorword'

" Doxygen
" :Dox
Plug 'vim-scripts/DoxygenToolkit.vim', {'on': ['Dox']}

" Plug 'tpope/vim-surround'

" NOTE: vim-abolish
" :S/{pattern}/{string}/[flags]
" crs	"SnakeCase" -> "snake_case"
" crm	"mixed_case" -> "MixedCase"
" crc	"camel_case" -> "camelCase"
" cru	"upper_case" -> "UPPER_CASE"
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
LazyPlug 'tpope/vim-abolish'

Plug 'lervag/vimtex', {'for': 'tex'}
" css
Plug 'lilydjwg/colorizer', {'for': ['vim', 'html', 'css', 'javascript', 'vue', 'vue.html.javascript.css']}
" this plugin fix vim's awk bugs
Plug 'vim-scripts/awk.vim', {'for': 'awk'}

" for ascii color code
Plug 'vim-scripts/AnsiEsc.vim', {'for': ['sh', 'zsh']}
" 行末の半角スペース/tabを可視化
" :FixWhitespaceというコマンドを実行すると、そうしたスペースを自動的に削除
Plug 'bronson/vim-trailing-whitespace', {'on':['FixWhitespace']}

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
" to avoid conceal of `xxx` ```xxx``` and so on
let g:vim_markdown_conceal = 0
" Plug 'rcmdnk/vim-markdown', {'for': 'markdown'}
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

if Doctor('git', 'airblade/vim-gitgutter')
	Plug 'airblade/vim-gitgutter', {'on':['GitGutterToggle']}
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

" NOTE: 0.1秒ほど起動時間がかかる
" status line
" NOTE:エラー表示がこのプラグインですぐに消えてしまって見えなくなっているかもしれない
" Plug 'vim-airline/vim-airline', {'on':[]}
LazyPlug 'vim-airline/vim-airline'

" NOTE: cmake v.s. rainbow
" [Syntax highlighting not working as expected · Issue \#5 · pboettch/vim\-cmake\-syntax]( https://github.com/pboettch/vim-cmake-syntax/issues/5 )
" [plugin cmake\.vim \- CMake syntax highlighting not working as expected \- Vi and Vim Stack Exchange]( https://vi.stackexchange.com/questions/14803/cmake-syntax-highlighting-not-working-as-expected/14811 )
" The issue it turns out is a conflict with the Rainbow Parenthesis plugin: 
" NOTE' for raibow ()
" If you want to lazy load run :RainbowToggle after loaded
Plug 'luochen1990/rainbow'
let g:rainbow_active = 0 "0 if you want to enable it later via :RainbowToggle
function! s:rainbow_group_func(action)
	if &ft=='cmake'
		if a:action=='enter'
			call rainbow_main#clear()
		endif
	else
		if a:action=='enter'
			call rainbow_main#load()
		endif
	endif
endfunction
augroup rainbow_group
	autocmd!
	autocmd User VimEnterDrawPost call <SID>rainbow_group_func('enter')
	autocmd BufEnter * call <SID>rainbow_group_func('enter')
	" 	autocmd BufLeave * call <SID>rainbow_group_func('leave')
augroup END
