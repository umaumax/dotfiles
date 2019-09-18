" NOTE: help
" [fzf/README\-VIM\.md at master · junegunn/fzf]( https://github.com/junegunn/fzf/blob/master/README-VIM.md )

LazyPlug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
" NOTE: don't use on option(because you can't find fzf#vim#with_preview function)
Plug 'junegunn/fzf.vim' ", {'on':['Pt', 'FZFTabOpen', 'FZFMru', 'FZFOpenFile']}

" WARN
" ファイルパスに'binary'が含まれている場合には，fzf#vim#with_previewではbinary file扱いされてしまうため，previewできない

" --------------------------------

augroup terminal_disable_ambiwidth_group
	autocmd! FileType fzf
	function! s:fzf_init()
		let b:ambiwidth = &ambiwidth
		let b:laststatus = &laststatus
		setlocal laststatus=0 noshowmode noruler
		" NOTE: fzfのterminalの表示はbelow settingが必要
		setlocal ambiwidth=single
		autocmd BufLeave <buffer> call s:fzf_term()
	endfunction
	function! s:fzf_term()
		execute 'setlocal laststatus='.b:laststatus
		execute 'setlocal ambiwidth='.b:ambiwidth
		autocmd! BufLeave <buffer>
	endfunction
	autocmd FileType fzf call s:fzf_init()
augroup END

" NOTE: 下記の設定は他のpluginとの競合を解除したため，不要
" function! s:fzf_nvim_wrapper(lines, fzf_terminal_window_cmd)
" 	if ! has('nvim')
" 		return 1
" 	endif
" 	" NOTE:
" 	" fzfの画面をtabnewで開く場合には，editで開くことが前提なので，windowが必要
" 	if a:fzf_terminal_window_cmd==':tabnew'
" 		let keypress = a:lines[0]
" 		let query = a:lines[1]
" 		if l:keypress ==? 'ctrl-c'
" 			:q
" 			return 0
" 		endif
" 		return 1
" 	else
" 		" NOTE:
" 		" fzfの画面をtabnew以外で開く場合には，tabnewで開くことが前提なので，windowは不要
" 		:q
" 		return 1
" 	endif
" endfunction
" " NOTE: for 'sink*' [key, line] not for 'sink' [line]
" function! s:fzf_nvim_wrapper_create(f, ...)
" 	let fzf_terminal_window_cmd=get(a:, 1, ':tabnew')
" 	if has('nvim')
" 		if expand('%')!=''
" 			execute l:fzf_terminal_window_cmd
" 		endif
" 	endif
" 	return { lines-> s:fzf_nvim_wrapper(lines, fzf_terminal_window_cmd) ? a:f(lines) : 0 }
" endfunction
" 
" function! FZF_simple_tab_open_handler(lines)
" 	let keypress = a:lines[0]
" 	let query = a:lines[1]
" 	execute ':tabedit '. query
" endfunction
" function! FZF_simple_open_handler(lines)
" 	let keypress = a:lines[0]
" 	let query = a:lines[1]
" 	let cmd = get({
" 				\ 'ctrl-t': 'tabedit',
" 				\ },
" 				\ l:keypress, 'edit')
" 	execute l:cmd .' '. query
" endfunction
" function! FZF_simple_open_with_dir_handler(dir, lines)
" 	let keypress = a:lines[0]
" 	let query = a:lines[1]
" 	let cmd = get({
" 				\ 'ctrl-t': 'tabedit',
" 				\ },
" 				\ l:keypress, 'edit')
" 	let open_filepath=query[0]=='/' ? query : a:dir.'/'.query
" 	execute l:cmd .' '. open_filepath
" endfunction

" NOTE: e.g.
" 	silent! call fzf#run({
" 				\ 'source': substitute(g:ctrlp_user_command,'%s', '.', 'g'),
" 				\ 'sink*': s:fzf_nvim_wrapper_create(function('FZF_simple_open_with_dir_handler', [a:dir])),
" 				\ 'options': '-x +s --expect=ctrl-c',
" 				\ 'dir': a:dir,
" 				\ 'down': '100%'})

" --------------------------------
" --------------------------------
" --------------------------------
" --------------------------------

let g:fzf_my_bind='--bind=ctrl-x:cancel,btab:backward-kill-word,ctrl-g:jump,ctrl-f:backward-delete-char,ctrl-h:backward-char,ctrl-l:forward-char,shift-left:preview-page-up,shift-right:preview-page-down,shift-up:preview-up,shift-down:preview-down'

" [Vimの:tabsからfzfで検索してタブを開く \- Qiita]( https://qiita.com/kmszk/items/16f6129c4732a053ace1 )
nnoremap <leader>tab :FZFTabOpen<CR>
command! FZFTabOpen call s:FZFTabOpenFunc()

function! s:FZFTabOpenFunc()
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
	" NOTE:
	" fzf_nvim_wrapper_createで移動候補のtabが新規に作成されるためここで取得
	let tab_list=s:GetTabList()
	silent! call fzf#run({
				\ 'sink*': function('s:TabListSink'),
				\ 'source': l:tab_list,
				\ 'options': '-m -x +s --expect=ctrl-c '.g:fzf_my_bind,
				\ 'down':    '20%'
				\ })
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
			\ 'sink': 'tabe',
			\ 'options': '-m -x +s',
			\ 'down':    '100%' })

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

	" 	command! -nargs=* Pt silent! call fzf#run({
	" 				\ 'source':  printf('pt --nogroup --column --color "%s"',
	" 				\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
	" 				\ 'sink*':   s:fzf_nvim_wrapper_create(function('<sid>pt_handler')),
	" 				\ 'options': '--ansi --expect=ctrl-c,ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
	" 				\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
	" 				\            '--color hl:68,hl+:110',
	" 				\ 'down':    '50%'
	" 				\ })
	command! -bang -nargs=* Pt
				\ call fzf#vim#grep(
				\   'pt --column --ignore=.git --global-gitignore '.shellescape(<q-args>), 1,
				\   <bang>0 ? fzf#vim#with_preview('up:100%')
				\           : fzf#vim#with_preview({ 'dir': Find_git_root(),'up':'100%' }),
				\   <bang>0)
endif

" --------------------------------
" [Vimでカーソル下の不完全なファイルパスからファイルを開く\(fzf\) \- Qiita]( https://qiita.com/kmszk/items/75be6564532a90b79b8a )
nnoremap gf :FZFOpenFile<CR>
command! FZFOpenFile call FZFOpenFileFunc()

" NOTE: ファイルが一意に決定する場合には開き，そうでない場合には絞り込む
function! FZFOpenFileFunc()
	" カーソル下のファイルパスを取得
	" NOTE: outer exapnd extract ~ to $HOME
	let s:file_path = expand(expand("<cfile>"))
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
	let s:file_path=s:file_path_without_line

	" .DS_Store はmacの不要なファイル
	silent! call fzf#run({
				\ 'source': 'if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then git ls-files; else find . -type d -name .git -prune -o ! -name .DS_Store; fi',
				\ 'sink': 'tabedit',
				\ 'options': '-x +s --multi '.g:fzf_my_bind.' --query=' . shellescape(s:filepath),
				\ 'down':    '100%'})
endfunction

" FYI: [junegunn/fzf: A command\-line fuzzy finder]( https://github.com/junegunn/fzf#git-ls-tree-for-fast-traversal )
let $FZF_DEFAULT_COMMAND='(git ls-tree -r --name-only HEAD || find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//) 2> /dev/null'
function! FZF_find(dir, query)
	let query_option='--query=' . shellescape(a:query)
	" FYI: [Examples \(vim\) · junegunn/fzf Wiki]( https://github.com/junegunn/fzf/wiki/Examples-(vim) )
	" NOTE:    e means :edit
	"       tabe means :tabedit
	" NOTE: current bufferが無名の場合にはeditで開き，すでにファイルを開いている場合にはtabeで開くように
	let sink = expand('%')!='' ? 'tabe' : 'e'
	" NOTE: 関数内でfzf#runを呼び出す場合にはsinkのfunction内には'<sid>'は使えない(commandとして，定義して呼び出す場合には可能)
	" NOTE: below function is asynchronous
	" 	silent! call fzf#run({
	" 				\ 'source': substitute(g:ctrlp_user_command,'%s', '.', 'g'),
	" 				\ 'sink': sink,
	" 				\ 'options': '-x +s --multi '.query_option,
	" 				\ 'dir': a:dir,
	" 				\ 'down': '100%'})
	let fullscreen=1
	silent! call fzf#vim#files('', fzf#vim#with_preview({'options': '--prompt='.shellescape(a:dir.'> ').' --reverse '.g:fzf_my_bind.' --query='.shellescape(a:query), 'dir': a:dir, 'down':'100%'},'down:50%'), fullscreen)
endfunction

function! FZF_grep(dir, query)
	let ret=system('cd '.shellescape(a:dir).' && git rev-parse --is-inside-work-tree | tr -d "\n"')
	let is_git_repo = ret == 'true'
	let nth_opt='--nth 4..'
	let cmd='pt --column --ignore=.git --global-gitignore '.shellescape(a:query)
	if is_git_repo
		let cmd='git grep --color=always '.shellescape(a:query)
		let nth_opt='--nth 3..'
	endif
	" NOTE: --nth 4..: only match file content (not filepath)
	let fullscreen=1
	silent! call fzf#vim#grep(
				\ cmd, 0,
				\ fzf#vim#with_preview({'options': '--prompt='.shellescape(a:dir.'> ').' --reverse '.g:fzf_my_bind.' --delimiter : '.nth_opt, 'dir': a:dir, 'down':'100%'},'down:50%'),fullscreen)
endfunction

" NOTE: 新規tabや新規ウィンドウでバッファを開いたときに，project root基準でのファイル検索となることの防止策で
"       直前のファイルパスを参考にする
let g:prev_filedirpath=expand('%:p:h')
augroup save_filedirpath_group
	autocmd!
	autocmd WinEnter,TabEnter,BufEnter * let g:prev_filedirpath = expand('%:p:h') != '' ? expand('%:p:h') : g:prev_filedirpath
augroup END

" NOTE: these fzf keymapping overload ctrl-p mappings
" nnoremap <silent> <C-p><C-p> :call FZF_find(g:prev_filedirpath)<CR>
" nnoremap <silent> <C-p><C-u> :call FZF_find(getcwd())<CR>

function! Find_git_root()
	return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

" pick up arg
function! s:argsWithDefaultArg(index, default, ...)
	let l:arg = get(a:, a:index, a:default)
	if l:arg == ''
		return a:default
	endif
	return l:arg
endfunction

let g:fzf_action = {
			\ 'enter': 'tab split',
			\ 'ctrl-s': 'split',
			\ 'ctrl-x': 'vsplit' }
" let g:fzf_buffers_jump = 0

function! s:clean_filepath(orig_filepath)
	let filepath=substitute(a:orig_filepath, ':.*$', '', '')
	let prev_filepath=''
	while prev_filepath != filepath
		let prev_filepath=filepath
		let filepath=substitute(filepath, '//\+', '/', 'g')
		let filepath=substitute(filepath, '\(\([^/]*/\)\?\.\./\|\./\)', '', 'g')
	endwhile
	return filepath
endfunction

nnoremap <C-p> :FZF
inoremap <c-x><c-f> <ESC>:FZFf
inoremap <c-x>f     <ESC>:FZFf
nnoremap <c-x><c-f> :FZFf
nnoremap <c-x>f     :FZFf
command! -nargs=* -complete=file FZFf  call FZF_find(g:prev_filedirpath, s:clean_filepath(s:argsWithDefaultArg(1, '', <f-args>)))
command! -nargs=* -complete=file FZFfc call FZF_find(getcwd(),           s:clean_filepath(s:argsWithDefaultArg(1, '', <f-args>)))
command! -nargs=* -complete=file FZFfg call FZF_find(Find_git_root(),    s:clean_filepath(s:argsWithDefaultArg(1, '', <f-args>)))

" NOTE: :cnext <leader>g
" NOTE: :cprev <leader>G
inoremap <c-x><c-g> <ESC>:FZFg
inoremap <c-x>g     <ESC>:FZFg
nnoremap <c-x><c-g> :FZFg
nnoremap <c-x>g     :FZFg
command! -nargs=1 FZFg  call FZF_grep(g:prev_filedirpath, s:argsWithDefaultArg(1, '', <f-args>))
command! -nargs=1 FZFgc call FZF_grep(getcwd(),           s:argsWithDefaultArg(1, '', <f-args>))
command! -nargs=1 FZFgg call FZF_grep(Find_git_root(),    s:argsWithDefaultArg(1, '', <f-args>))

command! -nargs=0 FZFt       call s:FZFTabOpenFunc()
command! -nargs=0 FZFtabs    call s:FZFTabOpenFunc()
inoremap <c-x><c-b> <ESC>:FZFb<CR>
inoremap <c-x>b     <ESC>:FZFb<CR>
command! -nargs=0 FZFb       :Buffers
command! -nargs=0 FZFbuffers :Buffers
inoremap <c-x><c-h> <ESC>:FZFh<CR>
inoremap <c-x>h     <ESC>:FZFh<CR>
command! -nargs=0 FZFh       :History
command! -nargs=0 FZFhistory :History
command! -nargs=0 FZFtags    :Tags

nnoremap sbn :cnext<CR>
nnoremap sbp :cprev<CR>

" ----

" Mapping selecting mappings
nmap <leader><tab> <Plug>(fzf-maps-n)
xmap <leader><tab> <Plug>(fzf-maps-x)
omap <leader><tab> <Plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <Plug>(fzf-complete-word)
imap <c-x><c-p> <Plug>(fzf-complete-path)
" imap <c-x><c-j> <Plug>(fzf-complete-file-ag)
imap <c-x><c-l> <Plug>(fzf-complete-line)
imap <c-x>k     <Plug>(fzf-complete-word)
imap <c-x>p     <Plug>(fzf-complete-path)
" imap <c-x>j <Plug>(fzf-complete-file-ag)
imap <c-x>l     <Plug>(fzf-complete-line)

" function! s:join_lines(lines)
" 	return join(a:lines, "\n")."\n"
" endfunction
" inoremap <expr> <c-x><c-l> fzf#vim#complete({
" 			\ 'source':  'bat --style=plain --color always '.shellescape(expand('%:p')),
" 			\ 'reducer': function('<sid>join_lines'),
" 			\ 'options': '--ansi --multi --reverse --margin 15%,0',
" 			\ 'down':    50})

function! FZF_include_header_reducer(lines)
	let ret=[]
	for header in a:lines
		let header = substitute(header, ' *#.*$', '', '')
		let ret+=['#include <'.header.'>']
	endfor
	if len(ret)>0
		let ret+=['']
	endif
	return join(ret, "\n")
endfunction
function! FZF_cpp_include_header()
	call feedkeys("i\<Plug>(fzf#cpp_include_header)", '')
	return ''
endfunction

" NOTE:
" vimのfzfのpluginとしては，completeとpreview_windowの両立はできなさそうなため，
" 無理やり，--preview optionを追加して利用
function! fzf#cpp_include_header()
	return fzf#vim#complete({
				\ 'source':  'cat ~/dotfiles/dict/cpp/headers/c++11-headers.txt',
				\ 'reducer': function('FZF_include_header_reducer'),
				\ 'options': '--multi --reverse '."--query=\"'\""." --preview 'echo {}' --preview-window 'right:20%'",
				\ 'up':    '50%'})
endfunction

" NOTE: call function of inoremap expr
inoremap <silent><expr> <Plug>(fzf#cpp_include_header) fzf#cpp_include_header()
command FZFCppIncludeHeader :call FZF_cpp_include_header()

function! FZF_ansi_color_reducer(lines)
	let ret=[]
	for line in a:lines
		let ret+=[split(line, ':')[1]]
	endfor
	return join(ret, " ")
endfunction
function! FZF_hex_color_reducer(lines)
	let ret=[]
	for line in a:lines
		let ret+=[split(line, ':')[2]]
	endfor
	return join(ret, " ")
endfunction
function! FZF_ansi_color()
	call feedkeys("i\<Plug>(fzf#ansi_color)", '')
	return ''
endfunction
function! FZF_ansi_color_256()
	call feedkeys("i\<Plug>(fzf#ansi_color_256)", '')
	return ''
endfunction
function! FZF_hex_color_256()
	call feedkeys("i\<Plug>(fzf#hex_color_256)", '')
	return ''
endfunction
function! FZF_hex_color()
	call feedkeys("i\<Plug>(fzf#hex_color)", '')
	return ''
endfunction
function! fzf#ansi_color()
	return fzf#vim#complete({
				\ 'source':  'cat ~/dotfiles/dict/color/ansi_color.txt',
				\ 'reducer': function('FZF_ansi_color_reducer'),
				\ 'options': '--ansi --multi --reverse '."--query=\"'\"",
				\ 'up':    '50%'})
endfunction
function! fzf#ansi_color_256()
	return fzf#vim#complete({
				\ 'source':  'cat ~/dotfiles/dict/color/ansi_color_256.txt',
				\ 'reducer': function('FZF_ansi_color_reducer'),
				\ 'options': '--ansi --multi --reverse '."--query=\"'\"",
				\ 'up':    '50%'})
endfunction
function! fzf#hex_color_256()
	return fzf#vim#complete({
				\ 'source':  'cat ~/dotfiles/dict/color/ansi_color_256.txt',
				\ 'reducer': function('FZF_hex_color_reducer'),
				\ 'options': '--ansi --multi --reverse '."--query=\"'\"",
				\ 'up':    '50%'})
endfunction
function! fzf#hex_color()
	return fzf#vim#complete({
				\ 'source':  'cat ~/dotfiles/dict/color/color_full.txt',
				\ 'reducer': function('FZF_hex_color_reducer'),
				\ 'options': '--ansi --multi --reverse '."--query=\"'\"",
				\ 'up':    '50%'})
endfunction

" NOTE: call function of inoremap expr
inoremap <silent><expr> <Plug>(fzf#ansi_color) fzf#ansi_color()
inoremap <silent><expr> <Plug>(fzf#ansi_color_256) fzf#ansi_color_256()
inoremap <silent><expr> <Plug>(fzf#hex_color_256) fzf#hex_color_256()
inoremap <silent><expr> <Plug>(fzf#hex_color) fzf#hex_color()
command FZFAnsiColorHeader :call FZF_ansi_color()

" NOTE: for :FZFxxx
" NOTE: type ff and xxx and tab
cnoremap ff fzf
