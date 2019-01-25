" NOTE: help
" [fzf/README\-VIM\.md at master · junegunn/fzf]( https://github.com/junegunn/fzf/blob/master/README-VIM.md )

LazyPlug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim', {'on':['Ag', 'FZFTabOpen', 'FZFMru', 'FZFOpenFile']}

" --------------------------------

function! s:fzf_nvim_wrapper(lines, fzf_terminal_window_cmd)
	if ! has('nvim')
		return 1
	endif
	" NOTE:
	" fzfの画面をtabnewで開く場合には，editで開くことが前提なので，windowが必要
	if a:fzf_terminal_window_cmd==':tabnew'
		let keypress = a:lines[0]
		let query = a:lines[1]
		if l:keypress ==? 'ctrl-c'
			:q
			return 0
		endif
		return 1
	else
		" NOTE:
		" fzfの画面をtabnew以外で開く場合には，tabnewで開くことが前提なので，windowは不要
		:q
		return 1
	endif
endfunction
" NOTE: for 'sink*' [key, line] not for 'sink' [line]
function! s:fzf_nvim_wrapper_create(f, ...)
	let fzf_terminal_window_cmd=get(a:, 1, ':tabnew')
	if has('nvim')
		if expand('%')!=''
			execute l:fzf_terminal_window_cmd
		endif
	endif
	return { lines-> s:fzf_nvim_wrapper(lines, fzf_terminal_window_cmd) ? a:f(lines) : 0 }
endfunction

function! FZF_simple_tab_open_handler(lines)
	let keypress = a:lines[0]
	let query = a:lines[1]
	execute ':tabedit '. query
endfunction
function! FZF_simple_open_handler(lines)
	let keypress = a:lines[0]
	let query = a:lines[1]
	let cmd = get({
				\ 'ctrl-t': 'tabedit',
				\ },
				\ l:keypress, 'edit')
	execute l:cmd .' '. query
endfunction

" [Vimの:tabsからfzfで検索してタブを開く \- Qiita]( https://qiita.com/kmszk/items/16f6129c4732a053ace1 )
nnoremap <leader>tab :FZFTabOpen<CR>
command! FZFTabOpen call s:FZFTabOpenFunc()

function! s:FZFTabOpenFunc()
	" NOTE:
	" fzf_nvim_wrapper_createで移動候補のtabが新規に作成されるためここで取得
	let tab_list=s:GetTabList()
	silent! call fzf#run({
				\ 'sink*': s:fzf_nvim_wrapper_create(function('s:TabListSink'), ':belowright new'),
				\ 'source': l:tab_list,
				\ 'options': '-m -x +s --expect=ctrl-c',
				\ 'down':    '20%'
				\ })
endfunction

function! s:GetTabList()
	let s:tabList = execute('tabs')
	let s:textList = []
	for tabText  in split(s:tabList, '\n')
		let s:tabPageText = matchstr(tabText, '^Tab page')
		if !empty(s:tabPageText)
			let s:pageNum = matchstr(tabText, '[0-9]*$')
		else
			let s:textList = add(s:textList, printf('%d %s',
						\ s:pageNum,
						\ tabText,
						\   ))
		endif
	endfor
	return s:textList
endfunction

function! s:TabListSink(line)
	let parts = split(a:line[1], '\s')
	execute 'normal! ' . parts[0] . 'gt'
endfunction

" --------------------------------
" catgs
" [fzf\.vimを使ってctags検索をしてみる \- Qiita]( https://qiita.com/hisawa/items/fc5300a526cb926aef08 )
" :GenCtags
nnoremap <silent> <leader>tag :call fzf#vim#tags(expand('<cword>'))<CR>
" fzfからファイルにジャンプできるようにする
let g:fzf_buffers_jump = 1

" --------------------------------
command! FZFMru silent! call fzf#run({
			\ 'source':  reverse(s:all_files()),
			\ 'sink*': s:fzf_nvim_wrapper_create(function('FZF_simple_open_handler')),
			\ 'options': '-m -x +s --expect=ctrl-c',
			\ 'down':    '40%' })

function! s:all_files()
	return extend(
				\ filter(copy(v:oldfiles),
				\        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
				\ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

" --------------------------------
if Doctor('pt', 'find command')
	function! s:pt_to_qf(line)
		let parts = split(a:line, ':')
		return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
					\ 'text': join(parts[3:], ':')}
	endfunction

	function! s:pt_handler(lines)
		if len(a:lines) < 2 | return | endif

		let cmd = get({'ctrl-x': 'split',
					\ 'ctrl-v': 'vertical split',
					\ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
		let list = map(a:lines[1:], 's:pt_to_qf(v:val)')

		let first = list[0]
		execute cmd escape(first.filename, ' %#\')
		execute first.lnum
		execute 'normal!' first.col.'|zz'

		if len(list) > 1
			call setqflist(list)
			copen
			wincmd p
		endif
	endfunction

	command! -nargs=* Pt silent! call fzf#run({
				\ 'source':  printf('pt --nogroup --column --color "%s"',
				\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
				\ 'sink*':   s:fzf_nvim_wrapper_create(function('<sid>pt_handler')),
				\ 'options': '--ansi --expect=ctrl-c,ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
				\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
				\            '--color hl:68,hl+:110',
				\ 'down':    '50%'
				\ })
endif

" --------------------------------
" [Vimでカーソル下の不完全なファイルパスからファイルを開く\(fzf\) \- Qiita]( https://qiita.com/kmszk/items/75be6564532a90b79b8a )
nnoremap gf :FZFOpenFile<CR>
command! FZFOpenFile call FZFOpenFileFunc()

" NOTE: ファイルが一意に決定する場合には開き，そうでない場合には絞り込む
function! FZFOpenFileFunc()
	" カーソル下のファイルパスを取得
	let s:file_path = expand("<cfile>")
	" 空行などで実行されたりした場合の考慮
	if s:file_path == ''
		echo '[Error] <cfile> return empty string.'
		return 0
	endif

	let s:file_path_with_line=substitute(s:file_path,'\(:[0-9]*\).*','\1','')
	let s:file_path_without_line=substitute(s:file_path,':[0-9]*.*','','')
	if filereadable(s:file_path_without_line)
		" NOTE: my original plugin has function to open file with line no
		execute ':tabedit '.s:file_path_with_line
		return
	endif

	" fzf実行
	" .DS_Store はmacの不要なファイル
	silent! call fzf#run({
				\ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
				\ 'sink*': s:fzf_nvim_wrapper_create(function('FZF_simple_tab_open_handler'), ':belowright new'),
				\ 'options': '-x +s --expect=ctrl-c --query=' . shellescape(s:file_path_without_line),
				\ 'down':    '40%'})
endfunction

function! FZF_simple_open_with_dir_handler(dir, lines)
	let keypress = a:lines[0]
	let query = a:lines[1]
	let cmd = get({
				\ 'ctrl-t': 'tabedit',
				\ },
				\ l:keypress, 'edit')
	let open_filepath=query[0]=='/' ? query : a:dir.'/'.query
	execute l:cmd .' '. open_filepath
endfunction
function! FZF_find(dir)
	" FYI: [Examples \(vim\) · junegunn/fzf Wiki]( https://github.com/junegunn/fzf/wiki/Examples-(vim) )
	" NOTE:    e means :edit
	"       tabe means :tabedit
	" NOTE: current bufferが無名の場合にはeditで開き，すでにファイルを開いている場合にはtabeで開くように
	" NOTE: if vim: 'sink': expand('%')!='' ? 'tabe' : 'e'
	" NOTE: 関数内でfzf#runを呼び出す場合にはsinkのfunction内には'<sid>'は使えない(commandとして，定義して呼び出す場合には可能)
	" NOTE: below function is asynchronous
	silent! call fzf#run({
				\ 'source': substitute(g:ctrlp_user_command,'%s', '.', 'g'),
				\ 'sink*': s:fzf_nvim_wrapper_create(function('FZF_simple_open_with_dir_handler', [a:dir])),
				\ 'options': '-x +s --expect=ctrl-c',
				\ 'dir': a:dir,
				\ 'down': '100%'})
endfunction

" NOTE: 新規tabや新規ウィンドウでバッファを開いたときに，project root基準でのファイル検索となることの防止策で
"       直前のファイルパスを参考にする
let g:prev_filedirpath=expand('%:p:h')
augroup save_filedirpath_group
	autocmd!
	autocmd WinEnter,TabEnter,BufEnter * let g:prev_filedirpath = expand('%:p:h') != '' ? expand('%:p:h') : g:prev_filedirpath
augroup END

" NOTE: these fzf keymapping overload ctrl-p mappings
nnoremap <silent> <C-p><C-p> :call FZF_find(g:prev_filedirpath)<CR>
nnoremap <silent> <C-p><C-u> :call FZF_find(getcwd())<CR>
