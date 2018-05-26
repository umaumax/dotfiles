" [Vimでの補完ツールプラグインをneocompleteからdeopleteへ]( https://rcmdnk.com/blog/2017/11/16/computer-vim/ )
" [vim-hug-neovim-rpc] failed executing: pythonx import neovim
" [vim-hug-neovim-rpc] Vim(pythonx):Traceback (most recent call last):
" [deoplete] [vim-hug-neovim-rpc] requires `:pythonx import neovim` command to work
" ===> pip3 install --upgrade neovim
if has('python3')
	if has('nvim')
		Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	else
		Plug 'Shougo/deoplete.nvim'
		Plug 'roxma/nvim-yarp'
		Plug 'roxma/vim-hug-neovim-rpc'
	endif
	Plug 'wokalski/autocomplete-flow'
	" For func argument completion
	Plug 'Shougo/neosnippet'
	Plug 'Shougo/neosnippet-snippets'
	" let g:autocomplete_flow#insert_paren_after_function = 0
	" [Setting up Python for Neovim · zchee/deoplete\-jedi Wiki]( https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim )
	Plug 'zchee/deoplete-jedi', {'for':'python'}

	Plug 'Shougo/neco-vim', {'for': ['vi', 'vim']}
	Plug 'zchee/deoplete-zsh', {'for': ['sh','zsh']}
	Plug 'Shougo/neco-syntax'
	" for look command
	Plug 'ujihisa/neco-look', {'for': 'markdown'}
	Plug 'zchee/deoplete-clang', {'for': ['c','cpp','cmake']}
	" [neovimの補完プラグインdeopleteが重い\(快適設定にする\) \- sinshutu\_kibotuの日記]( https://sinshutu-kibotu.hatenablog.jp/entry/2017/01/27/062757 )
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#auto_complete_delay = 100
	let g:deoplete#auto_complete_start_length = 1
	let g:deoplete#enable_camel_case = 0
	let g:deoplete#enable_ignore_case = 0
	let g:deoplete#enable_refresh_always = 0
	let g:deoplete#enable_smart_case = 1
	let g:deoplete#file#enable_buffer_path = 1
	let g:deoplete#max_list = 10000
	inoremap <expr><tab> pumvisible() ? "\<C-n>" :
				\ neosnippet#expandable_or_jumpable() ?
				\    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"
elseif
	Plug 'Shougo/neocomplete.vim'
	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
		let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
	endif

	Plug 'davidhalter/jedi-vim', {'for':'python'}
	let g:jedi#auto_initialization = 1
	let g:jedi#rename_command = "<leader>r"
	let g:jedi#popup_on_dot = 1
endif
