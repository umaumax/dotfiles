let cache_dir = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
if !isdirectory(cache_dir)
  call mkdir(cache_dir, 'p')
endif

set autoindent
set expandtab
set incsearch
set number
set shiftwidth=4
set showmatch
set smartcase
set smartindent
set smarttab
set tabstop=4
set whichwrap=b,s,h,l,<,>,[,]
set t_Co=256
colorscheme desert

augroup vimrcExtend
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""
augroup END
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
