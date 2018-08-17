Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" --------------------------------
" [Vimの:tabsからfzfで検索してタブを開く \- Qiita]( https://qiita.com/kmszk/items/16f6129c4732a053ace1 )
nnoremap <leader>tab :FZFTabOpen<CR>
command! FZFTabOpen call s:FZFTabOpenFunc()

function! s:FZFTabOpenFunc()
	call fzf#run({
				\ 'source':  s:GetTabList(),
				\ 'sink':    function('s:TabListSink'),
				\ 'options': '-m -x +s',
				\ 'down':    '40%'})
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
	execute 'normal ' . parts[0] . 'gt' 
endfunction

" --------------------------------
" catgs
" [fzf\.vimを使ってctags検索をしてみる \- Qiita]( https://qiita.com/hisawa/items/fc5300a526cb926aef08 )
" :GenCtags
nnoremap <silent> <leader>tag :call fzf#vim#tags(expand('<cword>'))<CR>
" fzfからファイルにジャンプできるようにする
let g:fzf_buffers_jump = 1

" --------------------------------
command! FZFMru call fzf#run({
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

command! -nargs=* Ag call fzf#run({
			\ 'source':  printf('ag --nogroup --column --color "%s"',
			\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
			\ 'sink*':    function('<sid>ag_handler'),
			\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
			\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
			\            '--color hl:68,hl+:110',
			\ 'down':    '50%'
			\ })
