" NOTE: help
" [fzf/README\-VIM\.md at master · junegunn/fzf]( https://github.com/junegunn/fzf/blob/master/README-VIM.md )

LazyPlug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim', {'on':['Ag', 'FZFTabOpen', 'FZFMru', 'FZFOpenFile']}

" --------------------------------
" [Vimの:tabsからfzfで検索してタブを開く \- Qiita]( https://qiita.com/kmszk/items/16f6129c4732a053ace1 )
nnoremap <leader>tab :FZFTabOpen<CR>
command! FZFTabOpen call s:FZFTabOpenFunc()

function! s:FZFTabOpenFunc()
	silent! call fzf#run({
				\ 'sink':    function('s:TabListSink'),
				\ 'source':  s:GetTabList(),
				\ 'options': '-m -x +s',
				\ 'down':    '40%'
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
	let parts = split(a:line, '\s')
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
			\ 'sink':    'edit',
			\ 'options': '-m -x +s',
			\ 'down':    '40%' })

function! s:all_files()
	return extend(
				\ filter(copy(v:oldfiles),
				\        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
				\ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

" --------------------------------
if Doctor('ag', 'find command')
	function! s:ag_to_qf(line)
		let parts = split(a:line, ':')
		return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
					\ 'text': join(parts[3:], ':')}
	endfunction

	function! s:ag_handler(lines)
		if len(a:lines) < 2 | return | endif

		let cmd = get({'ctrl-x': 'split',
					\ 'ctrl-v': 'vertical split',
					\ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
		let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

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

	command! -nargs=* Ag silent! call fzf#run({
				\ 'source':  printf('ag --nogroup --column --color "%s"',
				\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
				\ 'sink*':    function('<sid>ag_handler'),
				\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
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
		execute ':e '.s:file_path_with_line
		return
	endif

	" fzf実行
	" .DS_Store はmacの不要なファイル
	silent! call fzf#run({
				\ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
				\ 'sink': 'e',
				\ 'options': '-x +s --query=' . shellescape(s:file_path_without_line),
				\ 'down':    '40%'})
endfunction

function! FZF_find(dir)
	silent! call fzf#run({
				\ 'source': substitute(g:ctrlp_user_command,'%s', '.', 'g'),
				\ 'sink': 'e',
				\ 'options': '-x +s',
				\ 'dir': a:dir,
				\ 'down':    '40%'})
endfunction

" NOTE: these fzf keymapping overload ctrl-p mappings
nnoremap <silent> <C-p><C-p> :call FZF_find(expand('%:p:h'))<CR>
nnoremap <silent> <C-p><C-u> :call FZF_find(getcwd())<CR>
