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
" NOTE: [Shell Style Guide]( http://google.github.io/styleguide/shell.xml?showone=File_Header#File_Header )
" use below shebang
" #!/bin/bash
" by using env, you can use new version of command
let g:shebang#shebangs = {
      \ 'awk': '#!/usr/bin/awk -f',
      \ 'sh':  '#!/usr/bin/env bash',
      \ 'python':  '#!/usr/bin/env python3',
      \ 'bats':  '#!/usr/bin/env bats',
      \ 'javascript': '#!/usr/bin/env node'
      \ }

" NOTE: cpp is not supported
" NOTE: get function name
Plug 'tyru/current-func-info.vim', {'for':['c','go','vim','python','vim','sh','zsh']}

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

" auto tab indent detector
" [editor \- Can vim recognize indentation styles \(tabs vs\. spaces\) automatically? \- Stack Overflow]( https://stackoverflow.com/questions/9609233/can-vim-recognize-indentation-styles-tabs-vs-spaces-automatically )
Plug 'tpope/vim-sleuth'
let g:sleuth_neighbor_limit=0
" NOTE: 別の箇所で明示的に呼び出し
let g:sleuth_automatic=0
" Plug 'ciaranm/detectindent'

" NOTE: 必要とあらば試してみる
" [Vimで自動的にファイルタイプを設定してくれる便利プラグインvim\-autoftを作りました！ \- プログラムモグモグ]( https://itchyny.hatenablog.com/entry/2015/01/15/100000 )
" Plug 'itchyny/vim-autoft'

Plug 'Shougo/unite.vim', {'on':['Unite']}

" no dependency on vim swapfile option
LazyPlug 'umaumax/autobackup.vim'
let g:autobackup_backup_dir = g:tempfiledir
" NOTE: # of each file backups
let g:autobackup_backup_limit = 256

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
Plug 'vim-scripts/groovyindent-unix', {'for':'Jenkinsfile'}
" Plug 'modille/groovy.vim'

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

function! s:backword_delete_word()
  let cmd = getcmdline()
  return substitute(cmd, '.[^ (),.:"'."'".']*$', '', '')
endfunction
cnoremap <S-Tab> <C-\>e<SID>backword_delete_word()<CR>

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

" NOTE: 特に必要ではなさそうなので，temporarily disabled
" color picker
" :VCoolor
" :VCoolIns r		" For rgb color insertion
" :VCoolIns h		" For hsl color insertion
" :VCoolIns ra	" For rgba color insertion
" Plug 'KabbAmine/vCoolor.vim', {'on':['VCoolor','VCoolIns']}

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
Plug 'ekalinin/Dockerfile.vim', {'for':'dockerfile'}
" overwrite ft 'Dockerfile' -> 'dockerfile'
augroup dockerfiletype_group
  autocmd!
  autocmd FileType Dockerfile setlocal ft=dockerfile
augroup END

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
  Plug 'maksimr/vim-jsbeautify', {'for': ['javascript','css','html','vue','vue.html.javascript.css']}
endif

" NOTE: use 'umaumax/vim-format'
" NOTE: for json but below plugin has no error...
" Plug 'Chiel92/vim-autoformat'
" NOTE: I don't like default jsbeautify_json format
" let g:formatters_json = ['fixjson', 'prettier']

" for Vue.js
" [Neovim/Vim8で快適Vue\.js開発\(Vue Language Server\)]( https://muunyblue.github.io/520bae6649b42ff5a3c8c58b7fcfc5a9.html )
" npm install -g neovim
" npm install -g vue-language-server
Plug 'digitaltoad/vim-pug', {'for': ['javascript','json','css','html','vue','vue.html.javascript.css']}
Plug 'posva/vim-vue', {'for': ['html', 'vue', 'vue.html.javascript.css']}
Plug 'Shougo/context_filetype.vim', {'for': ['vue', 'vue.html.javascript.css']}

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
Plug 'tyru/autochmodx.vim', {'for':['sh','zsh','python','awk','bats','javascript','ruby','perl','php']}

" file manager
" Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdtree', {'on':['NERDTreeToggle','NERDTree']}
let g:NERDTreeShowHidden = 1
" NOTE: NERDTreeでルートを変更したらchdirする
let g:NERDTreeChDirMode = 2
let g:NERDTreeIgnore = ['.[oa]$', '.cm[aiox]$', '.cmxa$', '.(aux|bbl|blg|dvi|log)$', '.(tgz|gz|zip)$', 'Icon' ]
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

" NOTE: slow
" Plug 'lilydjwg/colorizer', {'for': ['vim', 'html', 'css', 'javascript', 'vue', 'vue.html.javascript.css', 'markdown', 'yaml']}
" augroup unmap_colorizer
" autocmd!
" autocmd VimEnter * silent! nunmap <Leader>tc
" augroup END
" NOTE:
" ある程度の速度だが，起動時には時間がかかる(tab移動時にはそれほど時間を消費しない)
let filetype_list=['vim', 'html', 'css', 'javascript', 'yaml']
" NOTE:
" auto=1とするとTextChangedIなどにもeventが登録されてしまうため危険
" 'terryma/vim-multiple-cursors'と同時に使用するとCPU使用率が100%ほどになる
let g:colorizer_auto_color = 0
" NOTE: 下記は必要ない?
" augroup colorizer_group
" autocmd!
" autocmd WinEnter, BufEnter * if len(filter(filetype_list, {index,val -> val == &ft})>=1) call Colorizer#ColorWinEnter() | endif
" augroup END
Plug 'chrisbra/Colorizer', {'for': filetype_list, 'on':['ColorHighlight']}
" NOTE: 例えば，format.vimを開くととても遅くなるためdisableしている
" let g:colorizer_auto_filetype=join(filetype_list,',')
let g:colorizer_disable_bufleave = 1

" this plugin fix vim's awk bugs
Plug 'vim-scripts/awk.vim', {'for': 'awk'}

" for ascii color code
Plug 'vim-scripts/AnsiEsc.vim', {'on': ['AnsiEsc']}

" 行末の半角スペース/tabを可視化
" :FixWhitespaceというコマンドを実行すると、そうしたスペースを自動的に削除
LazyPlug 'bronson/vim-trailing-whitespace'

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
" FYI: https://github.com/plasticboy/vim-markdown/blob/be5e60fa2d85fec3b585411844846678a775a5d3/ftplugin/markdown.vim#L663
" disable overwrite 'gx'
let g:vim_markdown_no_default_key_mappings=1
let g:vim_markdown_folding_disabled = 1
" to avoid conceal of `xxx` ```xxx``` and so on
let g:vim_markdown_conceal = 0 " for `
let g:vim_markdown_conceal_code_blocks = 0 " for ```
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
  Plug 'airblade/vim-gitgutter'
  let g:gitgutter_highlight_lines=1
  " With Neovim 0.3.2 or higher
  let g:gitgutter_highlight_linenrs=1
  let g:gitgutter_enabled=1
  command -narg=0 G :GitGutterToggle
  " hunk
  nmap ]h <Plug>(GitGutterNextHunk)
  nmap [h <Plug>(GitGutterPrevHunk)
  " stage, unstage, preview
  " NOTE: stage hunkの仕様が不明瞭(一部のデータが消える)
  " nmap <Leader>sh <Plug>(GitGutterStageHunk)
  " NOTE: how to use undo hunk?
  " nmap <Leader>uh <Plug>(GitGutterUndoHunk)
  " NOTE: diffの削除された行の表示が可能
  nmap <Leader>gp <Plug>(GitGutterPreviewHunk)

  function! s:vim_gitgutter_group()
    if &rtp =~ 'vim-submode'
      " NOTE: hunk間の移動を巡回させたい
      call submode#enter_with('bufgit', 'n', 'r', '<Leader>gh', '<Plug>(GitGutterNextHunk)')
      call submode#enter_with('bufgit', 'n', 'r', '<Leader>gH', '<Plug>(GitGutterPrevHunk)')
      call submode#map('bufgit', 'n', 'r', 'h', '<Plug>(GitGutterNextHunk)')
      call submode#map('bufgit', 'n', 'r', 'H', '<Plug>(GitGutterPrevHunk)')
      highlight GitGutterChangeLine cterm=bold ctermfg=7 ctermbg=16 gui=bold guifg=#ffffff guibg=#2c4f1f
    endif
  endfunction

  augroup vim_gitgutter_group
    autocmd!
    autocmd VimEnter * call s:vim_gitgutter_group()
  augroup END

  " NOTE: for .gitignore color highlighting
  Plug 'fszymanski/fzf-gitignore', {'for': 'gitignore'}

  " NOTE: reveal the commit messages under the cursor like git blame
  Plug 'rhysd/git-messenger.vim', {'on': 'GitMessenger'}
  let g:git_messenger_include_diff='current'
  " <Leader>gm: defualt for Plug load trigger
  nmap <Leader>gm :<C-u>GitMessenger<CR>
  augroup git_messenger_vim_color_group
    autocmd!
    autocmd ColorScheme,BufWinEnter * highlight gitmessengerHash term=None guifg=#f0eaaa ctermfg=229 |
          \ highlight gitmessengerPopupNormal term=None guifg=#eeeeee guibg=#666666 ctermfg=255 ctermbg=234 |
          \ highlight link diffRemoved   Identifier |
          \ highlight link diffAdded     Type
  augroup END
endif

LazyPlug 'vim-airline/vim-airline'
" NOTE: default settings
" [vim\-airline/init\.vim at 59f3669a42728406da6d1b948608cae120d1453f · vim\-airline/vim\-airline · GitHub]( https://github.com/vim-airline/vim-airline/blob/59f3669a42728406da6d1b948608cae120d1453f/autoload/airline/init.vim#L165 )
function! AirlineInit()
  let spc = g:airline_symbols.space
  let emoji_flag=0
  let emoji = ' '
  if has('mac')
    " NOTE: 星座: ♈おひつじ座、♉おうし座、♊ふたご座、♋かに座、♌しし座、♍おとめ座、♎てんびん座、♏さそり座、♐いて座、♑やぎ座、♒みずがめ座、♓うお座
    " NOTE: 干支: 🐭ね、🐮うし、🐯とら、🐰う、🐲たつ、🐍み、🐴うま、🐏ひつじ、🐵さる、🐔とり、🐶いぬ、🐗い
    let emojis='♈♉♊♋♌♍♎♏♐♑♒♓🐭🐮🐯🐰🐲🐍🐴🐏🐵🐔🐶🐗🍺🍣'
    let Len = { s -> strlen(substitute(s, ".", "x", "g"))}
    let rand = reltimestr(reltime())[matchend(reltimestr(reltime()), '\d\+\.') + 1 : ] % (Len(emojis))
    let emoji = split(emojis, '\zs')[rand]
  endif
  if emoji_flag==0
    let emoji = ' '
  endif
  " NOTE: condition: $HOME doesn't include regex
  let g:airline_section_c = airline#section#create(["%{substitute(getcwd(),$HOME,'~','')}", emoji, 'file', spc, 'readonly'])
  let g:airline_section_y = ''
  let g:airline_symbols.linenr=':'
  let g:airline_section_z = airline#section#create(['%2p%%', 'linenr', '/%L', ':%3v'])
  let g:airline_section_warning=''
  let g:airline_skip_empty_sections = 1
endfunction
augroup vim-airline_group
  autocmd!
  autocmd User AirlineAfterInit call AirlineInit()
augroup END

" NOTE: cmake v.s. rainbow
" [Syntax highlighting not working as expected · Issue \#5 · pboettch/vim\-cmake\-syntax]( https://github.com/pboettch/vim-cmake-syntax/issues/5 )
" [plugin cmake\.vim \- CMake syntax highlighting not working as expected \- Vi and Vim Stack Exchange]( https://vi.stackexchange.com/questions/14803/cmake-syntax-highlighting-not-working-as-expected/14811 )
" The issue it turns out is a conflict with the Rainbow Parenthesis plugin:
" NOTE' for raibow ()
" If you want to lazy load run :RainbowToggle after loaded
" NOTE: 場合によっては複数の同じsyntax matchが実行される
" ~/.vim/plugged/rainbow/autoload/rainbow.vim:36
" NOTE: fix error by pull request
Plug 'luochen1990/rainbow', {'do': 'git remote add pull-request-KushNee https://github.com/KushNee/rainbow.git && git fetch pull-request-KushNee && git merge pull-request-KushNee/master'}
let g:rainbow_active = 0 "0 if you want to enable it later via :RainbowToggle
" [Emacs のカッコの色を抵抗のカラーコードにしてみる \- Qiita]( https://qiita.com/gnrr/items/8f9efd5ced058e576f5e )
let g:rainbow_conf = {
      \	'guifgs': ["#ca8080", "#ff5e5e","#ffaa77", "#dddd77", "#80ee80", "#66bbff", "#da6bda", "#afafaf", "#f0f0f0"],
      \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta', 'lightgreen', 'lightred', 'lightgray', 'darkgray', 'white'],
      \}

" NOTE: 対応する()をhighlight
" disable default matchparen plugin
let g:loaded_matchparen = 1
LazyPlug 'sgur/vim-hlparen'
let g:hlparen_highlight_delay = 100
" NOTE: parenthesis: only paren highlight
" NOTE: expression: + between paran highlight
let g:hlparen_highlight_style = 'expression'

" NOTE: cmdlineの決め打ちショートカット機能
Plug 'tyru/vim-altercmd'

" NOTE:選択範囲ごと移動
LazyPlug 't9md/vim-textmanip'

" NOTE: for tab no. for tabline
LazyPlug 'mkitt/tabline.vim'

LazyPlug 'junegunn/vim-easy-align'
xmap e<Space> <Plug>(EasyAlign)*<Space>
xmap e=       <Plug>(EasyAlign)*=
xmap e#       <Plug>(EasyAlign)*#
xmap e"       <Plug>(EasyAlign)*"
xmap e/       <Plug>(EasyAlign)*/
xmap e\       <Plug>(EasyAlign)*<Bslash>
xmap e,       <Plug>(EasyAlign)*,
xmap e.       <Plug>(EasyAlign)*.
xmap e:       <Plug>(EasyAlign)*:
xmap e\|      <Plug>(EasyAlign)*<Bar>

let g:easy_align_delimiters = {
      \ '>': { 'pattern': '>>\|=>\|>' },
      \ '\': { 'pattern': '\\' },
      \ '/': {
      \     'pattern':         '//\+\|/\*\|\*/',
      \     'delimiter_align': 'l',
      \     'ignore_groups':   ['!Comment'] },
      \ ']': {
      \     'pattern':       '[[\]]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ ')': {
      \     'pattern':       '[()]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ 'd': {
      \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
      \     'left_margin':  0,
      \     'right_margin': 0
      \   }
      \ }

" NOTE: スムーズに画面をスクロール可能
" NOTE: don't use load lazy
Plug 'yuttie/comfortable-motion.vim'

Plug 'mtdl9/vim-log-highlighting', {'for':'log'}

" NOTE: vim-open-googletranslate requires open-browser
Plug 'tyru/open-browser.vim', {'on':'OpenGoogleTranslate'}
Plug 'umaumax/vim-open-googletranslate', {'on':'OpenGoogleTranslate'}

" only for :PlugInstall
Plug 'rhysd/committia.vim', {'on':[]}
Plug 'hotwatermorning/auto-git-diff', {'on':[]}

" NOTE: sudo write for Neovim
LazyPlug 'lambdalisue/suda.vim'

" NOTE: for git mergetool
LazyPlug 'rickhowe/diffchar.vim'
let g:DiffUnit = 'Char' " any single character
let g:DiffColors = 3 " 16 colors in fixed order

" run :RainbowDelim command when the cursor is just on delim char
Plug 'mechatroner/rainbow_csv', {'for':'csv', 'on':['RainbowDelim']}

" NOTE: for install only (below libraries are enable other script)
Plug 'nhooyr/neoman.vim', {'on':[]}

" NOTE: interactive renamer at directory
Plug 'qpkorr/vim-renamer'
let g:RenamerWildIgnoreSetting=''

Plug 'umaumax/bats.vim', {'for':'bats'}

Plug 'cespare/vim-toml', {'for':'toml'}

" NOTE: for goyacc
Plug 'rhysd/vim-goyacc', {'for':'goyacc'}

" NOTE: for remote file editing
" e.g. :VimFiler ssh://localhost/$HOME/tmp/README.md
" To open absolute path, you must use "ssh://HOSTNAME//" instead of "ssh://HOSTNAME/".
Plug 'Shougo/neossh.vim', {'on': ['VimFiler']}
Plug 'Shougo/vimfiler.vim', {'on': ['VimFiler']}

" NOTE: vim plugin to dim inactive windows (highlight active window background)
LazyPlug 'blueyed/vim-diminactive'

Plug 'aklt/plantuml-syntax', {'for':'plantuml'}

Plug 'machakann/vim-swap'

if has('nvim-0.3.8')
  LazyPlug 'willelz/badapple.nvim', {'on':['BadAppleNvim']}

  " FYI: [float\-preview\.nvimで画面がリサイズされたときにいい感じに設定を切り替える \- Qiita]( https://qiita.com/htlsne/items/44acbef80c70f0a161e5 )
  Plug 'ncm2/float-preview.nvim'
  let g:float_preview#docked = 1
  let g:float_preview#auto_close = 0
  " NOTE: call float_preview#close() to close preview

  Plug 'Shougo/deol.nvim'
  "
  function! DeolTerminal()
    " 横幅が大きい分にはエラーにはならず，resize後の挙動も想定通りになる
    :Deol -split=floating -winheight=25 -winwidth=256
    " openときのwindow sizeに依存
    " execute(':Deol -split=floating -winheight=25 -winwidth='.&columns)
  endfunction
  command! FloatingTerm :call DeolTerminal()
  nnoremap <silent><C-x>t :call DeolTerminal()<CR>
endif

" NOTE: filetype support for LLVM IR
Plug 'rhysd/vim-llvm'", {'for':'llvm'}
