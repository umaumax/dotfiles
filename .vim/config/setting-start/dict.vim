let s:dict_delim='__CR__'

function! s:CompleteDone()
	" 補完を行わなかった場合には空の辞書
	if v:completed_item != {}
		" NOTE: 本来は v:completed_item['word'] の範囲のみを対象に置換するべき
		let line=getline('.')
		let line=substitute(line, s:dict_delim, char2nr('\n'), 'g')
		call setline('.', split(line, char2nr('\n')))
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
	call append(getline('.')+1, lines)
	normal "_dd
endfunction
command! -nargs=0 -range DictJoin  <line1>,<line2>call s:DictJoin()
command! -nargs=0        DictSplit                call s:DictSplit()
