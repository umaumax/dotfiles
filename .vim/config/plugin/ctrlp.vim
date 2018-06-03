" selecter
" C-P
Plug 'ctrlpvim/ctrlp.vim'
" :CtrlPGitLog
Plug 'kaneshin/ctrlp-git-log'
" let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed']
let g:ctrlp_extensions = ['quickfix', 'git_log']
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:18'
let g:ctrlp_map = '<Nop>'
nnoremap <C-p> :<C-u>CtrlP<CR>
" nnoremap <C-p><C-g> :<C-u>CtrlPQuickfix<CR>
augroup ctrlp_key_setting
	autocmd!
	" TODO: 通常のquickfixのwindowを一時的に閉じたい
	autocmd FileType qf nnoremap <C-p> :<C-u>CtrlPQuickfix<CR>
augroup END

let g:ctrlp_custom_ignore = {
			\ 'dir':  '\v[\/]\.(git|hg|svn)$',
			\ 'file': '\v\.(exe|so|dll)$',
			\ 'link': 'some_bad_symbolic_links',
			\ }

" [mattn/files: Fast file find]( https://github.com/mattn/files )
if Doctor('files', 'ctrlp.vim user command by files')
	let g:ctrlp_user_command = 'files -a %s'
else
	let g:ctrlp_user_command = 'find %s -type f'
endif
if $HOME == expand('%:p:h')
	let g:ctrlp_user_command = 'find %s -type f -maxdepth 1'
endif
