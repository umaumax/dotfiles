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
" apply patch for Apple M1
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash -c \"[[ $(uname -sm) == \\"Darwin arm64\\" ]] && git checkout . && git apply ~/.vim/patch/LanguageClient-neovim.patch; bash install.sh\"',
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

" not essential
let g:deoplete#enable_camel_case = 0
let g:deoplete#enable_ignore_case = 0
call plug#end()

call deoplete#custom#var('file', 'enable_buffer_path', v:true)
call deoplete#custom#option({
      \ 'auto_complete_start_length': 1,
      \ 'enable_smart_case': v:true,
      \ 'enable_refresh_always': v:false,
      \ 'max_list': 10000,
      \ })

inoremap <expr><Tab> pumvisible() ? "\<C-n>" :
      \ neosnippet#expandable_or_jumpable() ?
      \    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
