" syntax check
" 	Plug 'neomake/neomake'
Plug 'w0rp/ale'

" [NeovimでモダンなPython環境を構築する]( https://qiita.com/lighttiger2505/items/e0ada17634516c081ee7 )

" 'vim-airline/vim-airline'では変更不可(固定format)
" let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
" エラー行に表示するマーク
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
" エラー行にカーソルをあわせた際に表示されるメッセージフォーマット
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" エラー表示の列を常時表示
let g:ale_sign_column_always = 1

" ファイルを開いたときにlint実行
let g:ale_lint_on_enter = 1
" ファイルを保存したときにlint実行
let g:ale_lint_on_save = 1
" 編集中のlintはしない
let g:ale_lint_on_text_changed = 'never'

" lint結果をロケーションリストとQuickFixには表示しない
" 出てると結構うざいしQuickFixを書き換えられるのは困る
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0

" 有効にするlinter
" npm install jsonlint -g
let g:ale_linters = {
			\   'python': ['flake8'],
			\   'json': ['jsonlint'],
			\   'bash': ['shellcheck'],
			\   'vim': ['vint'],
			\}

" ALE用プレフィックス
nmap [ale] <Nop>
map <C-k> [ale]
" エラー行にジャンプ
nmap <silent> [ale]<C-P> <Plug>(ale_previous)
nmap <silent> [ale]<C-N> <Plug>(ale_next)

" 	" [シェルスクリプトを簡単にチェックできるShellCheck, Vimでも使える]( http://rcmdnk.github.io/blog/2014/11/26/computer-bash-zsh/ )
" 	if Doctor('shellcheck', 'vim-syntastic/syntastic')
" 		Plug 'vim-syntastic/syntastic', {'for': ['sh','zsh']}
" 	endif
