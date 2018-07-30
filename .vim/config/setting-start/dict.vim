let s:dict_delim='__CR__'
" NOTE: __CURSOR__が行末になるときに，1文字左側から入力が始まってしまう
let s:cursor='__CURSOR__'

function! s:dict_replacer()
	" NOTE: 本来は v:completed_item['word'] の範囲のみを対象に置換するべき
	let line=getline('.')
	if !(stridx(line, s:dict_delim) >=0 || stridx(line, s:cursor) >=0)
		return
	endif
	" 逆向きに検索
	" 		'__CURSOR__'の場所を検索
	let lines=split(substitute(line, s:dict_delim, char2nr('\n'), 'g'),char2nr('\n'))
	call append(line('.'), lines)
	execute 'normal! "_dd'
	if stridx(line, s:cursor) >=0 && search('__CURSOR__', 'b') != 0
		execute 'normal! '.len('__CURSOR__').'"_x'
	endif
endfunction
" NOTE: 関数などの補完後も役立つ情報を保持する
function! s:vimconsole_logger()
	" NOTE: for debug
	" PP v:completed_item
	let item = v:completed_item
	let menu = item['menu']
	let abbr = item['abbr']
	let ns_flag = menu =~ '^\[ns\] '
	" NOTE: deoplete環境ではsnippet機能は通常の補完機能となってしまい，一工夫必要
	" [deoplete環境でneosnippetを使えるようにする \- グレインの備忘録]( http://grainrigi.hatenablog.com/entry/2017/08/28/230029 )
	if ns_flag
		" NOTE: snippet自動展開
		execute "normal a\<Plug>(neosnippet_expand)"
		" 		execute "normal a\<Plug>(neosnippet_expand_or_jump)"
		return
	endif
	let vim_flag = menu == '[vim] '
	let clang_flag = menu == '[clang] ' || menu == '[PCH] '
	let flag = vim_flag || clang_flag
	if flag
		let func_flag = abbr =~ '.*(.*)'
		let template_flag = abbr =~ '.*<.*>'
		let log_flag = func_flag || template_flag
		" NOTE; is function?
		if func_flag
			if vim_flag
				execute "normal! i)"
			endif
			if clang_flag
				execute "normal! i()"
			endif
		endif
		if template_flag
			if clang_flag
				execute "normal! i<>"
			endif
		endif
		if log_flag
			call vimconsole#log('%s:%s', menu, abbr)
			if vimconsole#is_open()
				" NOTE: this is not needed because of let g:vimconsole#auto_redraw=1
				" call vimconsole#redraw()
			else
				call vimconsole#winopen()
			endif
		endif
	endif
endfunction
function! s:CompleteDone()
	" 	" 補完を行わなかった場合には空の辞書
	if v:completed_item != {}
		call s:dict_replacer()
		call s:vimconsole_logger()
	endif
endfunction
function! s:SetDictionary(filetype)
	let filetype=a:filetype
	if filetype == 'zsh'
		let filetype='sh'
	endif
	let dict_path=$HOME.'/dotfiles/dict'
	let dict_file_path=dict_path.'/'.filetype.'.dict'
	if filereadable(dict_file_path)
		execute 'setlocal dictionary+='.dict_file_path
	endif
endfunction
function! s:AutocmdSetDictionary()
	call s:SetDictionary(&ft)
	call s:SetDictionary('common')
endfunction
augroup dict_comp
	autocmd!
	autocmd FileType * call s:AutocmdSetDictionary()
	autocmd CompleteDone * call s:CompleteDone()
augroup END

" for dict file editting
function! s:DictJoin() range
	let lines = join(getline(a:firstline, a:lastline), s:dict_delim)
	execute 'normal '.(a:lastline-a:firstline+1).'"_dd'
	call append(a:firstline-1, lines)
endfunction
function! s:DictSplit()
	let lines=split(getline('.'), s:dict_delim)
	call append(line('.'), lines)
	normal "_dd
endfunction
command! -nargs=0 -range DictJoin  <line1>,<line2>call s:DictJoin()
command! -nargs=0        DictSplit                call s:DictSplit()
