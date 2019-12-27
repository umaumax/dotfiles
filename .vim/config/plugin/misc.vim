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

" auto tab indent detector
" [editor \- Can vim recognize indentation styles \(tabs vs\. spaces\) automatically? \- Stack Overflow]( https://stackoverflow.com/questions/9609233/can-vim-recognize-indentation-styles-tabs-vs-spaces-automatically )
LazyPlug 'tpope/vim-sleuth'
let g:sleuth_neighbor_limit=0
" NOTE: 別の箇所で明示的に呼び出し
let g:sleuth_automatic=0
" Plug 'ciaranm/detectindent'

" NOTE: 必要とあらば試してみる
" [Vimで自動的にファイルタイプを設定してくれる便利プラグインvim\-autoftを作りました！ \- プログラムモグモグ]( https://itchyny.hatenablog.com/entry/2015/01/15/100000 )
" Plug 'itchyny/vim-autoft'

Plug 'Shougo/unite.vim', {'on':['Unite']}
" mainly for markdown
" :Unite outline
Plug 'Shougo/unite-outline', {'on':['Unite'], 'for': ['markdown']}

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
  "   autocmd ColorScheme,BufWinEnter * highlight HighlightedyankRegion cterm=reverse gui=reverse
  "   autocmd ColorScheme,BufWinEnter * highlight def link HighlightedyankRegion Visual
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
" LazyPlug 'LeafCage/cheapcmd.vim'

" FYI: [autocompletion in command line/search \- Vi and Vim Stack Exchange]( https://vi.stackexchange.com/questions/11974/autocompletion-in-command-line-search )
" [Autocomplete search word in vim \- Stack Overflow]( https://stackoverflow.com/questions/32068958/autocomplete-search-word-in-vim )
" Plug 'ervandew/supertab'
" let g:SuperTabContextDefaultCompletionType = "context"
" let g:SuperTabDefaultCompletionType = "<c-n>"

" Plug 'vim-scripts/CmdlineComplete'
" cmap <S-Tab> <Plug>CmdlineCompleteBackward
" cmap <Tab> <Plug>CmdlineCompleteForward

" Plug 'vim-scripts/SearchComplete'
" cnoremap <Tab> <C-C>:call SearchComplete()<CR>/<C-R>s

" Add completion in command line for '/', '?' and ':.../'
" LazyPlug 'vim-scripts/sherlock.vim'
" " NOTE: for avoid She[tab] to show menu for my ShebangInsert
" augroup sherlock_group
" autocmd!
" autocmd User VimEnterDrawPost delcommand SherlockVimball
" augroup END
" NOTE:
" 補完のpopupが出現するのではなく，入力場所にそのまま出現する
" /\Vの後には対応していない
" <C-\>esherlock#completeBackward()<CR>

" FYI: [cheapcmd\.vim/cheapcmd\.vim at master · LeafCage/cheapcmd\.vim]( https://github.com/LeafCage/cheapcmd.vim/blob/master/autoload/cheapcmd.vim#L22 )
function! s:default_expand()
  cnoremap <Plug>(cheapcmd:tab)  <Tab>
  cnoremap <expr><Plug>(cheapcmd:rest-wcm) <SID>default_expand_rest_wcm()
  let s:save_wcm = &wcm
  set wcm=<Tab>
  call feedkeys("\<Plug>(cheapcmd:tab)\<Plug>(cheapcmd:rest-wcm)", 'm')
  return ''
endfunction
function! s:default_expand_rest_wcm()
  cunmap <Plug>(cheapcmd:tab)
  cunmap <Plug>(cheapcmd:rest-wcm)
  let &wcm = s:save_wcm
  unlet s:save_wcm

  " NOTE: no expand by defualt tab key
  if getcmdline()[-1:] == "\t"
    cnoremap <silent><expr> <Plug>(launch_command_line_completion:tab) Launch_command_line_completion()
    call feedkeys("\<BS>\<Plug>(launch_command_line_completion:tab)", 'm')
  endif
  return ''
endfunction
cmap <silent><expr> <Tab> <SID>default_expand()

" cmap <expr> <Tab> getcmdtype() != ':' ? "\<C-\>esherlock#completeForward()\<CR>" : "<Plug>(cheapcmd-expand)"

" cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

function! Backword_delete_word()
  let cmd = getcmdline()
  let cmdpos = getcmdpos()
  let lbuffer=cmd[:cmdpos-1-1]
  let rbuffer=cmd[cmdpos-1:]
  let lbuffer=substitute(lbuffer, '\([^/#\-+ (),.:"'."'".']*\( \)*\|.\)$', '', '')
  " NOTE: The first position is 1.
  call setcmdpos(1+len(lbuffer))
  let buffer=lbuffer.rbuffer
  return buffer
endfunction
function! s:un_tab()
  if pumvisible()
    return "\<C-p>"
  endif
  return "\<C-\>eBackword_delete_word()\<CR>"
endfunction
cnoremap <expr> <S-Tab> <SID>un_tab()

Plug 'umaumax/vim-auto-fix'
imap <C-x><C-x> <Plug>(vim-auto-fix:fix)
nnoremap <silent> <C-x><C-x> :call vim_auto_fix#auto_fix()<CR>

" Plug 'rust-lang/rust.vim', {'for':'rust'}

" start screen
" Plug 'mhinz/vim-startify'
" " FYI: [vim\-startifyでvimのロゴを起動画面に設定する \- Devlion Memo]( http://mjhd.hatenablog.com/entry/recommendation-of-vim-startify )
" function! s:filter_header(lines) abort
" let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
" let centered_lines = map(copy(a:lines),
" \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
" return centered_lines
" endfunction
"
" let g:startify_custom_header=s:filter_header([
" \'ヽ(*゜д゜)ノ (」・ω・)」 (/・ω・)/',
" \])

" " startifyのヘッダー部分に表示する文字列をdateの結果に設定する
" let g:startify_custom_header =''
" " set file key short cut (i:insert, e:empty, q:quit)
" let s:key_mapping = "asdfghjklzxcvbnmwrtyuop"
" if v:version >= 800
"   let g:startify_custom_indices = map(range(len(s:key_mapping)), { index, val -> s:key_mapping[val] })
" endif
" " bookmark example
" let g:startify_bookmarks = [
"       \ '~/.vimrc',
"       \ ]

" high light word when replacing
" command line window modeでの動作しない?
" Plug 'osyo-manga/vim-over'

" NOTE: 特に必要ではなさそうなので，temporarily disabled
" color picker
" :VCoolor
" :VCoolIns r   " For rgb color insertion
" :VCoolIns h   " For hsl color insertion
" :VCoolIns ra  " For rgba color insertion
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

" FYI: [Feature request: When jumping to a definition, increment the tag stack · Issue \#517 · autozimu/LanguageClient\-neovim]( https://github.com/autozimu/LanguageClient-neovim/issues/517 )
function! DefinitionFunc()
  if &rtp =~ 'LanguageClient-neovim' && !empty(LanguageClient_runSync('LanguageClient#textDocument_definition', {'handle': v:true}))
    return
  endif
  " Show definetion of function cousor word on quickfix
  exe("Gtags ".expand('<cword>'))
endfunction
function! ReferencesFunc()
  if &rtp =~ 'LanguageClient-neovim' && !empty(LanguageClient_runSync('LanguageClient#textDocument_references', {'handle': v:true}))
    return
  endif
  " Show reference of cousor word on quickfix
  exe("Gtags -r ".expand('<cword>'))
endfunction

" nmap <buffer> gd <plug>DeopleteRustGoToDefinitionDefault
" nmap <buffer> K  <plug>DeopleteRustShowDocumentation

noremap <silent> K :call DefinitionFunc()<CR>
noremap <silent> R :call ReferencesFunc()<CR>
" NORT: goto current file symbols
" :Gtags -f %
" :Tlist
noremap <silent> S :call LanguageClient_textDocument_documentSymbol()<CR>

" ctags not found
" gen_tags.vim need ctags to generate tags
Plug 'jsfaint/gen_tags.vim', {'for':['c','cpp']}
let g:gen_tags#gtags_auto_gen = 1

" rtags
Plug 'lyuts/vim-rtags', {'for':['c','cpp']}

" Vista!!
LazyPlug 'liuchengxu/vista.vim'

" ---- tags ----

" mark viewer
" 'airblade/vim-gitgutter'と同様にsign機能を使うため，表示と競合するので，基本的にOFFにしてtoggleして使用する
" NOTE:
" 遅延読み込みをするとsign機能の反映が遅れるため，画面が無駄に動いてしまう
" ALEのlintの結果が見にくくなる
" マークを設定すると，その行のhighlightがおかしくなる(真っ白になる)
Plug 'jeetsukumaran/vim-markology' ", {'on':['MarkologyToggle','MarkologyEnable']}
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
" crs "SnakeCase" -> "snake_case"
" crm "mixed_case" -> "MixedCase"
" crc "camel_case" -> "camelCase"
" cru "upper_case" -> "UPPER_CASE"
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

" NOTE: vim match-up: even better %
let g:matchup_matchparen_enabled = 1
LazyPlug 'andymass/vim-matchup'

" 行末の半角スペース/tabを可視化
" :FixWhitespaceというコマンドを実行すると、そうしたスペースを自動的に削除
LazyPlug 'bronson/vim-trailing-whitespace'

" NOTE: A vim plugin to display the indention levels with thin vertical lines
let g:indentLine_char_list = ['|', '¦']
LazyPlug 'Yggdroot/indentLine'

" ```のあとで<CR>するとindentされてしまう問題がある
" Plug 'gabrielelana/vim-markdown', {'for': 'markdown'}

" table formatter
" カーソル下のテーブルが対象
" :Tabularize /|/r<# of space of right side>
" :TableFormat
Plug 'godlygeek/tabular', {'for': 'markdown', 'on':['TableFormat']} " The tabular plugin must come before vim-markdown.
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
" :NeatJson     Format
" :NeatRawJson    EncodedFormat
Plug '5t111111/neat-json.vim', {'for': 'json'}

" to use this lib, you have to set filetype=gnuplot by autocmd
Plug 'vim-scripts/gnuplot.vim', {'for': 'gnuplot'}

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
      \ 'guifgs': ["#ca8080", "#ff5e5e","#ffaa77", "#dddd77", "#80ee80", "#66bbff", "#da6bda", "#afafaf", "#f0f0f0"],
      \ 'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta', 'lightgreen', 'lightred', 'lightgray', 'darkgray', 'white'],
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
" NOTE: don't use lazy
Plug 'tyru/vim-altercmd'

" NOTE:選択範囲ごと移動
LazyPlug 't9md/vim-textmanip'
xmap <S-Down>  <Plug>(textmanip-move-down)
xmap <S-Up>    <Plug>(textmanip-move-up)
xmap <S-Left>  <Plug>(textmanip-move-left)
xmap <S-Right> <Plug>(textmanip-move-right)

" NOTE: for tab number and [+] if the current buffer has been modified for tabline
LazyPlug 'mkitt/tabline.vim'
" %!Tabline()

" function! Tabline()
" let s = ''
" for i in range(tabpagenr('$'))
" let tab = i + 1
" let winnr = tabpagewinnr(tab)
" let buflist = tabpagebuflist(tab)
" let bufnr = buflist[winnr - 1]
" let bufname = bufname(bufnr)
" let bufmodified = getbufvar(bufnr, "&mod")
"
" let s .= '%' . tab . 'T'
" let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
" let s .= ' ' . tab .':'
" let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')
"
" if bufmodified
" let s .= '[+] '
" endif
" endfor
"
" let s .= '%#TabLineFill#'
" if (exists("g:tablineclosebutton"))
" let s .= '%=%999XX'
" endif
" return s
" endfunction
" set tabline=%!Tabline()

" FYI: [タブページ数に応じて幅が変わる tabline プラグインを作成しました \- Qiita]( https://qiita.com/yami_beta/items/6c999fe18fa3fa154cd3 )
" WARN: tabに画面内分割したbufferも含まれてしまう
" LazyPlug 'yami-beta/vim-responsive-tabline'
if 0
  let g:responsive_tabline_enable = 0
  set tabline=%!responsive_tabline#get_tabline()

  function! s:is_bufmodified(i)
    let tab = a:i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(v:val.bufnr, "&mod")
    return bufmodified
  endfunction

  " FYI: [tabline\.vim/tabline\.vim at master · mkitt/tabline\.vim]( https://github.com/mkitt/tabline.vim/blob/master/plugin/tabline.vim )
  function! s:show_buffers_to_tabline()
    let buffers = getbufinfo({ 'buflisted': 1 })
    let bufnr2tabnr_dict = {}
    for i in range(tabpagenr('$'))
      let tab = i + 1
      let winnr = tabpagewinnr(tab)
      let buflist = tabpagebuflist(tab)
      let bufnr = buflist[winnr - 1]
      let bufnr2tabnr_dict[bufnr]=string(tab)
    endfor
    " NOTE:
    " 同じファイルを開いているときにtabがひとまとめになってしまう問題がある
    return filter(map(copy(buffers), {
          \   index,val-> {
          \     "active": val.bufnr == bufnr("%"),
          \     "name": get(bufnr2tabnr_dict,val.bufnr,"-")." ".fnamemodify(val.name, ":t")." ". (getbufvar(val.bufnr, "&mod") ? "[+]" : "")
          \   }
          \ }),{->v:val['name']!~'^-'})
  endfunction
  let g:Responsive_tabline_custom_label_func = function('s:show_buffers_to_tabline')
endif

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
" :w suda://%
LazyPlug 'lambdalisue/suda.vim'

" Plug 'tpope/vim-repeat'

" NOTE: for git mergetool
LazyPlug 'rickhowe/diffchar.vim'
" let g:DiffUnit = 'Char' " any single character
let g:DiffUnit = 'Word1' " \w\+ word and any \W single character (default)
" let g:DiffColors = 3 " 16 colors in fixed order
let g:DiffColors = 100 " all colors defined in highlight option in dynamic random order

" run :RainbowDelim command when the cursor is just on delim char
Plug 'mechatroner/rainbow_csv', {'for':'csv', 'on':['RainbowDelim']}

" NOTE: for install only (below libraries are enable other script)
Plug 'umaumax/neoman.vim', {'on':[]}

" NOTE: interactive renamer at directory
Plug 'qpkorr/vim-renamer', {'on':'Renamer'}
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

" NOTE: Reorder delimited items.
" g<
" g>
" gs: interactive mode
LazyPlug 'machakann/vim-swap'

if has('nvim-0.3.8')
  Plug 'willelz/badapple.nvim', {'on':['BadAppleNvim']}

  " FYI: [float\-preview\.nvimで画面がリサイズされたときにいい感じに設定を切り替える \- Qiita]( https://qiita.com/htlsne/items/44acbef80c70f0a161e5 )
  LazyPlug 'ncm2/float-preview.nvim'
  let g:float_preview#docked = 1
  let g:float_preview#auto_close = 0
  " NOTE: call float_preview#close() to close preview

  " FYI: [deol\.nvim で簡単にターミナルを使う \- KUTSUZAWA Ryo \- Medium]( https://medium.com/@bookun/vim-advent-calendar-2019-12-20-63a12396211f )
  Plug 'Shougo/deol.nvim',{'on':['Deol']}

  function! DeolTerminal(w,h)
    " NOTE: 横幅を大きく指定する分にはエラーにはならず，resize後の挙動も想定通りになる
    execute printf(':Deol -split=floating -winwidth=%s -winheight=%s',a:w,a:h)
  endfunction
  command! FloatingTerm :call DeolTerminal()
  function! Nnoremap_deol_terminal(w,h)
    if &ft!='deol'
      call DeolTerminal(a:w,a:h)
    else
      :q
    endif
  endfunction
  inoremap <silent><C-x>t <ESC>:call DeolTerminal(256,25)<CR>
  cnoremap <silent><C-x>t <ESC>:call DeolTerminal(256,25)<CR>
  nnoremap <silent><C-x>t :call Nnoremap_deol_terminal(256,25)<CR>
  tnoremap <silent><C-x>t <C-\><C-n>:q<CR>

  nnoremap <silent>dt :call Nnoremap_deol_terminal(256,25)<CR>
  nnoremap <silent>df :call Nnoremap_deol_terminal(256,40)<CR>
  nnoremap <silent>dv :Deol -split=vertical<CR>
  nnoremap <silent>ds :Deol -split=horizontal<CR>
endif

" NOTE: filetype support for LLVM IR
Plug 'rhysd/vim-llvm'", {'for':'llvm'}

Plug 'umaumax/vim-lcov', {'for': ['c', 'cpp']}

" if has('nvim')
" Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
" endif

" :SaveSession
" :LoadSession
" :DeleteSession
Plug 'umaumax/vsession', {'on':['SaveSession','LoadSession','DeleteSession']}
let g:vsession_use_fzf = 1

" NOTE: A vim plugin that simplifies the transition between multiline and single-line code
" default maaping: gS, gJ
" let g:splitjoin_split_mapping = 'gS'
let g:splitjoin_join_mapping = ''
LazyPlug 'AndrewRadev/splitjoin.vim'

" select line by visual mode twice by :Linediff
Plug 'AndrewRadev/linediff.vim', {'on':['Linediff','LinediffReset']}

" NOTE: :Capture echo 123
LazyPlug 'tyru/capture.vim'

" WARN: lazy load cause no &rtp
Plug 'umaumax/vim-blink'

Plug 'mbbill/undotree', {'on':['UndotreeToggle']}

" if has('nvim')
" Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" else
" Plug 'Shougo/denite.nvim'
" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'
" endif
"
" " [【Vim】新しい Denite に爆速で対応する \- Qiita]( https://qiita.com/delphinus/items/de15250b39ac08e9c0b9 )
" " Define mappings
" autocmd FileType denite call s:denite_my_settings()
" function! s:denite_my_settings() abort
" nnoremap <silent><buffer><expr> <CR>
" \ denite#do_map('do_action')
" nnoremap <silent><buffer><expr> d
" \ denite#do_map('do_action', 'delete')
" nnoremap <silent><buffer><expr> p
" \ denite#do_map('do_action', 'preview')
" nnoremap <silent><buffer><expr> q
" \ denite#do_map('quit')
" nnoremap <silent><buffer><expr> i
" \ denite#do_map('open_filter_buffer')
" nnoremap <silent><buffer><expr> <Space>
" \ denite#do_map('toggle_select').'j'
" endfunction
" autocmd FileType denite-filter call s:denite_filter_my_setting()
" function! s:denite_filter_my_setting() abort
" " " 一つ上のディレクトリを開き直す
" " inoremap <silent><buffer><expr> <BS>    denite#do_map('move_up_path')
" " Denite を閉じる
" inoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
" nnoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
" endfunction
"
" let s:menus = {}
" let s:menus.zsh = { 'description': 'zsh configuration' }
" let s:menus.zsh.file_candidates = [
" \ ['zshrc', '~/.zshrc'], ['zplug', '~/.init.zplug']]
" let s:menus.my_commands = { 'description': 'my commands' }
" let s:menus.my_commands.command_candidates = [
" \ ['Split the window', 'vnew'], ['Open zsh menu', 'Denite menu:zsh']]
"
" augroup dinite_group
" autocmd!
" autocmd VimEnter * call s:denite_startup()
" augroup END
" function! s:denite_startup()
" " WARN: TMP
" " call deoplete#disable()
" call denite#custom#var('menu', 'menus', s:menus)
"
" call denite#custom#action('menu.zsh', 'vimfiler', 'my#denite#action#vimfiler')
" endfunction
" function! my#denite#action#vimfiler(context)
" echo a:context
" execute 'VimFiler ' . a:context.targets[0].action__path
" endfunction
