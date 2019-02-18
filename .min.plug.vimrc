if has('nvim')
  set runtimepath+=~/.vim
else
  source $VIMRUNTIME/defaults.vim
endif

call plug#begin('~/.vim/plugged')

" NOTE: deoplete and neosnippet
let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'
" endif

let python3_path = substitute(system('which python3'),"\n","","")
let g:deoplete#sources#jedi#python_path = python3_path

" NOTE: pylsのlinterの結果がソースコード上に表示されるのは仕様?
" ただし，その結果がredrawしないと消えないのは他の設定の影響?
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }
" Required: 'autozimu/LanguageClient-neovim'
" python: auopep8 linter -> ale
let g:LanguageClient_serverCommands = {
      \ 'vue': ['vls'],
      \ 'python': ['pyls'],
      \ }

if has('nvim')
  " if error occurs, do :UpdateRemotePlugins
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins'}
else
  " NOTE: don't use lazy load
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins'}
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" WARN: next commit 381bc21 has bug, be careful!
Plug 'Shougo/neosnippet', {'commit': 'a943f93'}
Plug 'Shougo/neosnippet-snippets' " default snippets
let g:neosnippet#snippets_directory=expand('~/dotfiles/neosnippet/')

" not essencial

let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_camel_case = 0
let g:deoplete#enable_ignore_case = 0
let g:deoplete#enable_refresh_always = 0
let g:deoplete#enable_smart_case = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#max_list = 10000

call plug#end()

inoremap <expr><Tab> pumvisible() ? "\<C-n>" :
      \ neosnippet#expandable_or_jumpable() ?
      \    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
