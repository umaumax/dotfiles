set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set fileformats=unix,dos,mac
set t_Co=256
" FYI: [term \- Vim日本語ドキュメント]( https://vim-jp.org/vimdoc-ja/term.html#xterm-true-color )
if has("termguicolors")
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set background=dark

set list
set listchars=tab:»_,trail:-,extends:»,precedes:«,nbsp:%,eol:↲ 
set number
set ruler
set nowrap
set display=lastline
set scrolloff=16
set nostartofline
set showcmd
set laststatus=2 " show editing filename
" NOTE: suppress startup message
set shortmess+=I
" FYI: [「Vimを使ってくれてありがとう」にさようなら]( https://qiita.com/ttdoda/items/903e85f07d58018c851d )
" title stack
let &t_ti .= "\e[22;0t"
let &t_te .= "\e[23;0t"
set title
set showmatch
set matchtime=1
set incsearch
set ignorecase
set smartcase
set wrapscan

set pumheight=20
set pumblend=10
set winblend=10
set wildmenu
set wildmode=longest:full,full
" FYI: [Neovimさんのツイート: "Popup 'wildmenu' just landed in \#neovim HEAD 0\.4\.x\. :set wildoptions=pum It supports 'pumblend', don't worry\. :set pumblend=20… https://t\.co/sFy2dljE4i"]( https://twitter.com/Neovim/status/1107014096908664832 )
if has('nvim-0.4.0')
  set wildoptions+=pum
endif

" FYI: [vimdiffでより賢いアルゴリズム \(patience, histogram\) を使う \- Qiita]( https://qiita.com/takaakikasai/items/3d4f8a4867364a46dfa3#_reference-cfedfafefcc91395c637 )
if has('nvim') || (!has('vim') && v:version > 812)
  set diffopt=internal,filler,algorithm:histogram,indent-heuristic
endif

" NOTE: disable vimgrep, findfile(), finddir(), and so on
" set wildignore+=,xxx,yyy
" 上記のようなケースでは，先頭の','により，すべてがignore対象?となり，期待した動作とならないので注意
" */tmp/*を指定すると~/tmp上で`:e`のファイル名の補完もignoreされるので注意
set wildignore+=*.o,*.so,*.out,*.obj,.git,.svn,build,build*,CMakeFiles,node_modules,vender,*.rbc,*.rbo,*.swp,*.zip,*.class,*.gem,*.png,*.jpg,*.tu,*.pch

set backupskip=/tmp/*,/private/tmp/*

" NOTE: vim-abolish some commands can be reversible
" FYI: [vim\-abolish/abolish\.txt at master - tpope/vim\-abolish]( https://github.com/tpope/vim-abolish/blob/master/doc/abolish.txt#L167 )
setlocal iskeyword+=-
augroup iskeyword_group
  autocmd!
  " NOTE: to avoid 'var_name-' as word at var_name->func()
  autocmd FileType cpp setlocal iskeyword-=-
augroup END

" NOTE: to open file with line no
set isfname+=:

" to avoid die vim by too long line
set synmaxcol=512

" default 1000, -1
set timeout timeoutlen=500 ttimeoutlen=50

set updatetime=250

set cmdheight=2
set colorcolumn=80

" NOTE: this help user to find where is the cursor
setlocal cursorline | setlocal cursorcolumn

" NOTE: these value are maybe ignored by 'tpope/vim-sleuth' without using augroup
" if textwidth == 0 no auto new line
set smartindent
command! -nargs=1 SetTab call s:set_tab(<f-args>)
" NOTE: force set tab function
function! s:set_global_tab(n)
  setlocal expandtab
  execute 'set tabstop='    .a:n
  execute 'set shiftwidth=' .a:n
  execute 'set softtabstop='.a:n
endfunction
function! s:set_tab(n)
  setlocal expandtab
  execute 'setlocal tabstop='    .a:n
  execute 'setlocal shiftwidth=' .a:n
  execute 'setlocal softtabstop='.a:n
endfunction
function! s:Sleuth_wrapper(n)
  call s:set_tab(2)
  if &rtp =~ 'vim-sleuth'
    silent! Sleuth
  endif
  " NOTE: force tab fix
  if &expandtab==0 && &tabstop==8 && (&shiftwidth!=&tabstop || &softtabstop!=&tabstop)
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal softtabstop=2
  endif
endfunction
" default tab setting
call s:set_global_tab(2)
" FYI: [autocmd FileType \*]( https://github.com/tpope/vim-sleuth/blob/master/plugin/sleuth.vim#L196 )
augroup tab_setting
  autocmd!
  autocmd FileType * call s:Sleuth_wrapper(2)
  autocmd FileType python call s:set_tab(4)
  " NOTE: Makefile requires hard tab
  autocmd FileType make setlocal noexpandtab
  " NOTE: shell file requires soft tab (by google coding rule)
  autocmd FileType sh setlocal expandtab
augroup END

" NOTE: to disable `E828: Cannot open undo file for writing:`
" FYI: [undo file file name too long on linux · Issue \#346 · vim/vim]( https://github.com/vim/vim/issues/346 )
" FYI: [linux \- Limit on file name length in bash \- Stack Overflow]( https://stackoverflow.com/questions/6571435/limit-on-file-name-length-in-bash )
set undofile
" WARN: if undofile has 40MB, e.g. this takes 0.8sec to open...
execute 'set undodir='.g:tempfiledir
augroup noundofile_group
  autocmd!
  autocmd BufWritePre,FileWritePre,FileAppendPre * if len(expand('%:p')) >= 255 | setlocal noundofile | endif
augroup END

" NOTE: 以下のような複数行のコマンドをコピーして，コマンドラインに貼り付けるときに，強制的にset pasteとなるのでそれを戻す設定
" :echo 1
" :echo 2
augroup no_paste_group
  autocmd!
  autocmd CmdlineLeave * set nopaste
augroup END

set ambiwidth=double

set mouse=a
set history=10000

set backspace=indent,eol,start

set whichwrap=b,s,[,],<,>

" ['viminfo' \- VimWiki]( http://vimwiki.net/?%27viminfo%27 )
" ' マークが復元されるファイル履歴の最大値。オプション 'viminfo'が空でないときは、常にこれを設定しなければならない。また、このオプションを設定するとジャンプリスト |jumplist| もviminfo ファイルに蓄えられることになる。
" / 保存される検索パターンの履歴の最大値。非0 の値を指定すると、前回の検索パターンと置換パターンも保存される。これが含まれないときは、'history' の値が使われる。
" % これが含まれると、バッファリストを保存・復元する。Vimの起動時にファイル名が引数に含まれていると、バッファリストは復元されない。 Vimの起動時にファイル名が引数に含まれていないと、バッファリストが viminfo ファイルから復元される。ファイル名のないバッファとヘルプ用バッファは、viminfo ファイルには書き込まれない。
" \" old one of <
" < Maximum number of lines saved for each register.  If zero then registers are not saved.  When not included, all lines are saved.  '"' is the old name for this item.
" f Whether file marks need to be stored.  If zero, file marks ('0 to '9, 'A to 'Z) are not stored.  When not present or when non-zero, they are all stored.  '0 is used for the current cursor position (when exiting or when doing ":wviminfo").
" s Maximum size of an item in Kbyte.  If zero then registers are not saved.  Currently only applies to registers.  The default "s10" will exclude registers with more than 10 Kbyte of text.  Also see the '<' item above: line count limit.
" : 保存されるコマンドライン履歴の最大値。これが含まれないときは、'history' の値が使われる。
" c When included, convert the text in the viminfo file from the 'encoding' used when writing the file to the current 'encoding'.  See |viminfo-encoding|.
" h Disable the effect of 'hlsearch' when loading the viminfo file.  When not included, it depends on whether ":nohlsearch"
" ! When included, save and restore global variables that start with an uppercase letter, and don't contain a lowercase letter.  Thus "KEEPTHIS and "K_L_M" are stored, but "KeepThis" and "_K_L_M" are not.  Only String and Number types are stored.
set viminfo='1000,/5000,%,<1000,f1,s100,:10000,c,h,!
augroup reopen_cursor_position_group
  " NOTE: move cursor to last position if not specified
  autocmd BufReadPost * if getcurpos()[1] == 1 && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

if exists('$TMUX')
  augroup tmux
    autocmd!
    autocmd BufReadPost,FileReadPost,BufNewFile,FocusGained,WinEnter,TabEnter * call system("tmux rename-window " . expand("%:t"))
    autocmd VimLeave,FocusLost * call system("tmux set-window-option automatic-rename")
  augroup END
endif

function! s:is_git_mergetool_file()
  return expand('%:t') =~ '^.*_LOCAL_.*$'
endfunction

" NOTE: before VimEnter event, tabpagenr('$') is always 1
function! s:buffer_to_tab()
  " NOTE: for git mergetool
  if s:is_git_mergetool_file()
    execute '3 wincmd w'
    return
  endif

  let filename = expand('%:t')
  let full_path = expand('%:p')

  " skip tmp file
  for pattern in ['^/tmp/.*$', '^/var/.*$', '^/private/.*$']
    if full_path =~ pattern
      return
    endif
  endfor

  " NOTE: :PlugInstall or :PlugUpdate or :PlugUpgrade makes new buffer which name is '[Plugins]'
  if filename ==# '' || filename ==# '[Plugins]' || filename ==# 'COMMIT_EDITMSG'
    return
  endif

  if bufnr('$') <= 1
    return
  endif

  tab sball

  tabdo e!

  " move active tab to a first tab from a last tab
  tabfirst

  call GotolineStartup()
endfunction

augroup buffer_to_tab_group
  autocmd!
  autocmd User VimEnterDrawPost ++nested call <SID>buffer_to_tab()
augroup END

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

let valid_colorscheme = getcompletion('', 'color')
if index(valid_colorscheme, colorscheme) < 0
  let g:colorscheme = g:default_colorscheme
endif
execute 'colorscheme '. g:colorscheme
