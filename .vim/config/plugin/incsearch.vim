" Require: 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim' | Plug 'haya14busa/incsearch-fuzzy.vim' | Plug 'haya14busa/incsearch-easymotion.vim'
function! s:config_fuzzyall(...) abort
	return extend(copy({
				\   'converters': [
				\     incsearch#config#fuzzy#converter(),
				\     incsearch#config#fuzzyspell#converter()
				\   ],
				\ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> z/ incsearch#go(<SID>config_fuzzyall())
noremap <silent><expr> z? incsearch#go(<SID>config_fuzzyall({'command': '?'}))
noremap <silent><expr> zg? incsearch#go(<SID>config_fuzzyall({'is_stay': 1}))
" incsearch.vim x fuzzy x vim-easymotion
function! s:config_easyfuzzymotion(...) abort
	return extend(copy({
				\   'converters': [incsearch#config#fuzzy#converter()],
				\   'modules': [incsearch#config#easymotion#module()],
				\   'keymap': {"\<CR>": '<Over>(easymotion)'},
				\   'is_expr': 0,
				\   'is_stay': 1
				\ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

" 日本語をローマ字で検索可能
" Plug 'rhysd/migemo-search.vim'
" if Doctor('cmigemo','rhysd/migemo-search.vim')
" 	cnoremap <expr><CR> migemosearch#replace_search_word()."\<CR>"
" endif
