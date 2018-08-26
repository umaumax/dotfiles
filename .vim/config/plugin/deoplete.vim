" [Vimでの補完ツールプラグインをneocompleteからdeopleteへ]( https://rcmdnk.com/blog/2017/11/16/computer-vim/ )
" [vim-hug-neovim-rpc] failed executing: pythonx import neovim
" [vim-hug-neovim-rpc] Vim(pythonx):Traceback (most recent call last):
" [deoplete] [vim-hug-neovim-rpc] requires `:pythonx import neovim` command to work
" ===> pip3 install --upgrade neovim
if v:version >= 800 && has('python3')
	" NOTE: 普通のvimでも使用可能らしい
	LazyPlug 'autozimu/LanguageClient-neovim', {
				\ 'branch': 'next',
				\ 'do': 'bash install.sh',
				\ }
	" Required: 'autozimu/LanguageClient-neovim'
	" python: auopep8 linter -> ale
	let g:LanguageClient_serverCommands = {
				\ 'vue': ['vls'],
				\ 'python': ['pyls'],
				\ }
	" to choose deoplete <C-x>,<C-v>
	if has('nvim')
		" if error occurs, do :UpdateRemotePlugins
		LazyPlug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins'}
	else
		" NOTE: don't use lazy load
		Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins'}
		Plug 'roxma/nvim-yarp'
		Plug 'roxma/vim-hug-neovim-rpc'
	endif

	LazyPlug 'wokalski/autocomplete-flow'
	" For func argument completion
	LazyPlug 'Shougo/neosnippet'
	LazyPlug 'Shougo/neosnippet-snippets' " default snippets
	let g:neosnippet#snippets_directory=expand('~/dotfiles/neosnippet/')

	if Doctor('pyls','python lsp')
	else
		" NOTE: for no lsp env
		" 詳細な解析はできない(e.g. re.compile()の結果の補完は不可)
		" [Setting up Python for Neovim · zchee/deoplete\-jedi Wiki]( https://github.com/zchee/deoplete-jedi/wiki/Setting-up-Python-for-Neovim )
		Plug 'zchee/deoplete-jedi', {'for':'python'}
	endif

	if Doctor('go','zchee/deoplete-go')
		Plug 'zchee/deoplete-go', {'for': 'go', 'do': 'make'}
		let g:deoplete#sources#go#gocode_binary = substitute($GOPATH, ':.*', '', '') . '/bin/gocode'
	endif

	Plug 'umaumax/deoplete-docker', {'for':['dockerfile']}

	Plug 'Shougo/neco-vim', {'for': ['vi', 'vim']}
	" 	Plug 'zchee/deoplete-zsh', {'for': ['sh','zsh']}
	" NOTE: [KeyError\('runtimepath'\)  Issue \#9  zchee/deoplete\-zsh]( https://github.com/zchee/deoplete-zsh/issues/9 is not merged yet)
	Plug 'umaumax/deoplete-zsh', {'for': ['sh','zsh']}
	" filetypeのsyntaxファイルの中にある記述を見て 補完候補を追加
	" NOTE: カーソル移動速度低下の要因?
	LazyPlug 'Shougo/neco-syntax'
	if Doctor('clang','zchee/deoplete-clang')
		" NOTE: This doesn't work
		" This is a clang completer for deoplete.nvim that's faster than deoplete-clang. Instead of using libclang, it just uses clang -cc1 like most other clang plugins.
		" Plug 'tweekmonster/deoplete-clang2', {'for': ['c','cpp','cmake']}
		Plug 'zchee/deoplete-clang', {'for': ['c','cpp','cmake']}
		Plug 'umaumax/deoplete-clang-with-pch', {'for': ['c','cpp','cmake']}
	endif
	" [neovimの補完プラグインdeopleteが重い\(快適設定にする\) \- sinshutu\_kibotuの日記]( https://sinshutu-kibotu.hatenablog.jp/entry/2017/01/27/062757 )
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#auto_complete_delay = 0
	if Doctor('pyls','python lsp')
	else
		" NOTE: zchee/deoplete-jedi 利用時
		" 連続したキー入力がこの値以下の場合には補完を行わない
		" pythonのときに文字表示がおかしくなるときの対策として100ではなく200にするとわりと安定する?
		augroup deoplete_bug
			autocmd!
			autocmd FileType * let g:deoplete#auto_complete_delay = 0
			autocmd FileType python let g:deoplete#auto_complete_delay = 200
		augroup END
	endif
	let g:deoplete#auto_complete_start_length = 1
	let g:deoplete#enable_camel_case = 0
	let g:deoplete#enable_ignore_case = 0
	let g:deoplete#enable_refresh_always = 0
	let g:deoplete#enable_smart_case = 1
	let g:deoplete#file#enable_buffer_path = 1
	let g:deoplete#max_list = 10000
	" disable preview window(このウィンドウの影響である程度以上，候補が多いと点滅する(特に，中段~下段の候補を移動している時))
	set completeopt-=preview
	" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
	inoremap <expr><C-x><C-v> pumvisible() ? "\<C-n>" :
				\ neosnippet#expandable_or_jumpable() ?
				\    "\<Plug>(neosnippet_expand_or_jump)" : "\<tab>"
else
	LazyPlug 'Shougo/neocomplete.vim'
	if !exists('g:neocomplete#force_omni_input_patterns')
		let g:neocomplete#force_omni_input_patterns = {}
		let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
		let g:neocomplete#force_omni_input_patterns.python = '%([^. t].|^s*@|^s*froms.+import |^s*from |^s*import )w*'
	endif

	" FYI
	" [【Python環境整備】脱NeoBundle。超便利補完プラグインjedi\-vimの環境をdeinで整えて快適になる設定までやる \- Qiita]( https://qiita.com/bookun/items/125beff66e4106f7843c )
	" [VimでPythonのコード補完設定【cloudpack 大阪 BLOG】 \| cloudpack\.media]( https://cloudpack.media/18571 )
	Plug 'davidhalter/jedi-vim', {'for':'python'}
	let g:jedi#auto_initialization = 1
	let g:jedi#auto_vim_configuration = 1
	let g:jedi#rename_command = "<leader>r"
	let g:jedi#popup_on_dot = 1
endif

" for look command
" require: lock command
if Doctor('look','ujihisa/neco-look')
	Plug 'ujihisa/neco-look', {'for': [ 'markdown', 'gitrebase', 'gitcommit', 'text', 'help', 'tex']}
endif
