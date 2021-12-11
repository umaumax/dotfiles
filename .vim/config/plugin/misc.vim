LazyPlug 'rbtnn/vimconsole.vim'
let g:vimconsole#height = 8
let g:vimconsole#auto_redraw=1
" NOTE: reverse cat
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
let g:shebang#shebangs = {
      \ 'awk': '#!/usr/bin/awk -f',
      \ 'sh':  '#!/usr/bin/env bash',
      \ 'python':  '#!/usr/bin/env python3',
      \ 'bats':  '#!/usr/bin/env bats',
      \ 'javascript': '#!/usr/bin/env node'
      \ }

" NOTE: cpp is not supported
" NOTE: get function name by cfi#get_func_name()
Plug 'tyru/current-func-info.vim', {'for':['c','go','vim','python','vim','sh','zsh']}

" vim lint
if Doctor('vint', 'Kuniwak/vint')
  Plug 'Kuniwak/vint', {'do': 'pip install vim-vint', 'for':'vim'}
endif

if Doctor('nextword', 'deoplete-plugins/deoplete-nextword')
  Plug 'deoplete-plugins/deoplete-nextword'
endif

" auto tab indent detector
" [editor \- Can vim recognize indentation styles \(tabs vs\. spaces\) automatically? \- Stack Overflow]( https://stackoverflow.com/questions/9609233/can-vim-recognize-indentation-styles-tabs-vs-spaces-automatically )
LazyPlug 'tpope/vim-sleuth'
let g:sleuth_neighbor_limit=0
" sleuth plugin settings are called explicitly at another file
let g:sleuth_automatic=0

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
augroup END


Plug 'umaumax/vim-auto-fix'
imap <C-x><C-x> <Plug>(vim-auto-fix:fix)
nnoremap <silent> <C-x><C-x> :call vim_auto_fix#auto_fix()<CR>

" Required: ctags
" :Tlist
Plug 'vim-scripts/taglist.vim', {'for':['c','cpp']}
nnoremap <Space>T :Tlist<CR>

" gtags
Plug 'lighttiger2505/gtags.vim', {'for':['c','cpp']}
" Options
let g:Gtags_Auto_Map = 0
let g:Gtags_OpenQuickfixWindow = 1

" FYI: [Feature request: When jumping to a definition, increment the tag stack · Issue \#517 · autozimu/LanguageClient\-neovim]( https://github.com/autozimu/LanguageClient-neovim/issues/517 )
function! DefinitionFunc()
  if &rtp =~ 'LanguageClient-neovim' && !empty(LanguageClient_runSync('LanguageClient#textDocument_definition', {'handle': v:true,'gotoCmd': 'tabnew'}))
    return
  endif
  " Show definetion of function cousor word on quickfix
  exe("Gtags ".expand('<cword>'))
endfunction
function! ReferencesFunc()
  if &rtp =~ 'LanguageClient-neovim' && !empty(LanguageClient_runSync('LanguageClient#textDocument_references', {'handle': v:true,'gotoCmd': 'tabnew'}))
    return
  endif
  " Show reference of cousor word on quickfix
  exe("Gtags -r ".expand('<cword>'))
endfunction

noremap <silent> _ :call LanguageClient_textDocument_typeDefinition({'gotoCmd': 'tabnew'})<CR>
noremap <silent> K :call DefinitionFunc()<CR>
noremap <silent> R :call ReferencesFunc()<CR>
" NORT: goto current file symbols
" :Gtags -f %
" :Tlist
noremap <silent> S :call LanguageClient_textDocument_documentSymbol()<CR>
command! RenameRefactor :call LanguageClient#textDocument_rename()<CR>

" ctags not found
" gen_tags.vim need ctags to generate tags
Plug 'jsfaint/gen_tags.vim', {'for':['c','cpp']}
let g:gen_tags#gtags_auto_gen = 1

" rtags
Plug 'lyuts/vim-rtags', {'for':['c','cpp']}

" WARN: doesn't work well
" Vista!!
" LazyPlug 'liuchengxu/vista.vim'

" ---- tags ----

" mark viewer
Plug 'jeetsukumaran/vim-markology'
let g:markology_enable=1

" Require: node?
" NOTE: npm js-beautify is builtin this package
if Doctor('npm', 'maksimr/vim-jsbeautify')
  Plug 'maksimr/vim-jsbeautify', {'for': ['javascript','css','html','vue','vue.html.javascript.css']}
endif

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
" NOTE: don't use lazy load to avoid below error
" Error detected while processing function cursorword#timer_callback[1]..cursorword#matchadd:
" line   14:
" E28: No such highlight group name: CursorWord0
Plug 'itchyny/vim-cursorword', {'do': 'git checkout . && git apply ~/.vim/patch/vim-cursorword.patch'}
" PlugUpdate vim-cursorword

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
" call extend(Abolish.Coercions, { 'c': Abolish.camelcase,
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

" NOTE: [Support lowercase color names? · Issue #17 · norcalli/nvim-colorizer.lua]( https://github.com/norcalli/nvim-colorizer.lua/issues/17 )
" hit Blue only not blue
Plug 'norcalli/nvim-colorizer.lua'
augroup nvim-colorizer_group
  autocmd!
  autocmd FileType html,css,javascript,vim :ColorizerAttachToBuffer
augroup END

" for ascii color code
Plug 'vim-scripts/AnsiEsc.vim', {'on': ['AnsiEsc']}

" NOTE: vim match-up: even better %
let g:matchup_matchparen_enabled = 1
LazyPlug 'andymass/vim-matchup'

" visualize space at the end of line
" :FixWhitespace command remove that space
LazyPlug 'bronson/vim-trailing-whitespace'

Plug 'lukas-reineke/indent-blankline.nvim'

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

Plug 'elzr/vim-json', {'for': 'json'}

let g:airline_extensions = []
LazyPlug 'vim-airline/vim-airline'
" NOTE: default settings
" [vim\-airline/init\.vim at 59f3669a42728406da6d1b948608cae120d1453f · vim\-airline/vim\-airline · GitHub]( https://github.com/vim-airline/vim-airline/blob/59f3669a42728406da6d1b948608cae120d1453f/autoload/airline/init.vim#L165 )
function! AirlineInit()
  let spc = g:airline_symbols.space
  " NOTE: condition: $HOME doesn't include regex
  let g:airline_section_c = airline#section#create(["%{substitute(getcwd(),$HOME,'~','')}", ' ', 'file', spc, 'readonly'])
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

" required nvim-treesitter
LazyPlug 'p00f/nvim-ts-rainbow'

" NOTE: highlight () pair
" disable default matchparen plugin
let g:loaded_matchparen = 1
LazyPlug 'sgur/vim-hlparen'
let g:hlparen_highlight_delay = 100
" NOTE: parenthesis: only paren highlight
" NOTE: expression: + between paran highlight
let g:hlparen_highlight_style = 'expression'

" NOTE: cmdline alias command
" NOTE: don't use lazy
Plug 'tyru/vim-altercmd'

" NOTE: This plugin makes scrolling nice and smooth.
LazyPlug 'psliwka/vim-smoothie'
silent! map <PageDown> <Plug>(SmoothieForwards)
silent! map <PageUp>   <Plug>(SmoothieBackwards)

" WARN: terminal input <S-Down> and <S-Up> are captured at out of vim and
" send page down and page up
" NOTE: move visual selection itself
LazyPlug 't9md/vim-textmanip'
vmap <S-Down>  <Plug>(textmanip-move-down)
vmap <S-Up>    <Plug>(textmanip-move-up)
vmap <PageDown>  <Plug>(textmanip-move-down)
vmap <PageUp>    <Plug>(textmanip-move-up)
vmap <S-Left>  <Plug>(textmanip-move-left)
vmap <S-Right> <Plug>(textmanip-move-right)

" NOTE: this plugin is newer than above
" MoveBlockRight -> MoveBlockLeft create extra space at the end of line
" Plug 'matze/vim-move'
" vmap <S-Down>   <Plug>MoveBlockDown
" vmap <S-Up>     <Plug>MoveBlockUp
" vmap <PageDown> <Plug>MoveBlockDown
" vmap <PageUp>   <Plug>MoveBlockUp
" vmap <S-Left>   <Plug>MoveBlockLeft
" vmap <S-Right>  <Plug>MoveBlockRight

" NOTE: for add tab number to tab title bar
" add [+] mark, if the current buffer has been modified for tabline
" NOTE: This repository has been archived.
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
      \ '/': { 'pattern':    '//\+\|/\*\|\*/',
      \     'delimiter_align': 'l',
      \     'ignore_groups':   ['!Comment'] },
      \ ']': { 'pattern':    '[[\]]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ ')': { 'pattern':    '[()]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ 'd': { 'pattern':   ' \(\S\+\s*[;=]\)\@=',
      \     'left_margin':  0,
      \     'right_margin': 0
      \   }
      \ }

" NOTE: nvim-treesitter can not highlight log file
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

" enforce . repeat actions
Plug 'tpope/vim-repeat'

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

" NOTE: for goyacc
Plug 'rhysd/vim-goyacc', {'for':'goyacc'}

" NOTE: for remote file editing
" e.g. :VimFiler ssh://localhost/$HOME/tmp/README.md
" To open absolute path, you must use "ssh://HOSTNAME//" instead of "ssh://HOSTNAME/".
Plug 'Shougo/neossh.vim', {'on': ['VimFiler']}
Plug 'Shougo/vimfiler.vim', {'on': ['VimFiler']}

" NOTE: vim plugin to dim inactive windows (highlight active window background)
LazyPlug 'blueyed/vim-diminactive'

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

" color scheme which support nvim-treesitter
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'mhartington/oceanic-next'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" A Vim plugin that shows the context of the currently visible buffer contents.
Plug 'romgrk/nvim-treesitter-context'
" WARN: I don't know this plugin works well or not.
Plug 'lewis6991/spellsitter.nvim'

Plug 'MunifTanjim/nui.nvim'
Plug 'VonHeikemen/fine-cmdline.nvim'
nnoremap <C-p> :lua require('fine-cmdline').open()<CR>

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
" let s:menus.zsh.file_candidates = [ ['zshrc', '~/.zshrc'], ['zplug', '~/.init.zplug']]
" let s:menus.my_commands = { 'description': 'my commands' }
" let s:menus.my_commands.command_candidates = [ ['Split the window', 'vnew'], ['Open zsh menu', 'Denite menu:zsh']]
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
