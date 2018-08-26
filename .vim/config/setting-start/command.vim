function! s:get_visual_selection()
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

function! s:delete_visual_selection()
	let selected = s:get_visual_selection()
	call setpos('.', getpos("'<"))
	let Mlen = { s -> strlen(substitute(s, ".", "x", "g"))}
	let l = Mlen(selected)
	if l > 0
		execute "normal! v".(l-1)."\<Right>\"_x"
	endif
	return selected
endfunction

function! s:p(text)
	let tmp = @a
	let @a = a:text
	execute 'normal! "ap'
	let @a = tmp
endfunction

" for visual mode
function! CR() range
	let selected = s:delete_visual_selection()
	execute "normal! i\<CR>\<CR>\<Up>\<ESC>"
	call s:p(selected)
endfunction
command! -nargs=0 -range CR <line1>,<line2>call CR()
" NOTE: for c++
" 1行にまとまってしまった関数ボディの改行
function! CRBody() range
	execute "normal! 00f{\<Right>vt}:CR\<CR>"
endfunction
command! -nargs=0 -range CRBody <line1>,<line2>call CRBody()

function! CRSplit()
	let line = getline('.')
	" 	let array = matchstr(line, '^[^\[\],]*\[\([^,]*,\)\+[^,]*\][^\[\],]*$')
	" 	let func_args = matchstr(line, '^[^(,)]*(\([^,]*,\)\+[^,]*)[^(,)]*$')
	" 	if !empty(func_args)
	let delim="????????"
	let line = substitute(line, '\([^(]*(\)', '\1'.delim, '')
	let line = substitute(line, '\(<<\|>>\|&&\|||\)', delim.'\1'.delim, 'g')
	let line = substitute(line, '{', '{'.delim, 'g')
	let line = substitute(line, '}', delim.'}', 'g')
	let line = substitute(line, '\[\(.*\),', '['.delim.'\1,', 'g')
	let line = substitute(line, ',', ','.delim, 'g')
	let line = substitute(line, delim.'\s\+', delim, 'g')
	let lines = split(line,delim)
	for i in range(0, len(lines)-1)
		let lines[i] = substitute(lines[i], '\([^\[]\+\)\]$', '\1'.delim.']', 'g')
		let lines[i] = substitute(lines[i], '\()[^)]\+\)$', delim.'\1', '')
		let lines[i] = substitute(lines[i], '(\([^)]\+\),', '('.delim.'\1,', 'g')
	endfor
	let lines = split(join(lines,delim),delim)
	call s:setlines('.', lines)
endfunction
function! s:setlines(pos, lines)
	if len(a:lines)==0
		execute ':'.a:pos.'d'
		return
	endif
	call setline(a:pos, a:lines[0])
	call append(a:pos, a:lines[1:])
endfunction
command! -nargs=0 Split call CRSplit()
command! -nargs=0 CRSplit call CRSplit()
nnoremap zs :call CRSplit()<CR>
nnoremap gs :call CRSplit()<CR>
inoremap <C-x>s <C-o>:call CRSplit()<CR>
inoremap <C-x><C-s> <C-o>:call CRSplit()<CR>

" for string array
" :Sand " ",
function! Sand(prefix, suffix) range
	for n in range(a:firstline, a:lastline)
		let line = getline(n)
		call setline(n, a:prefix.line.a:suffix)
	endfor
endfunction
command! -nargs=+ -range Sand <line1>,<line2>call Sand(<f-args>)

" pick up arg
function! s:argsWithDefaultArg(index, default, ...)
	let l:arg = get(a:, a:index, a:default)
	if l:arg == ''
		return a:default
	endif
	return l:arg
endfunction

" NOTE: G: repeat replace with entire range
function! s:substitute(pat, sub, flags) range
	let Gflag=stridx(a:flags,'G')>=0 ? 1 : 0
	let flags=substitute(a:flags, '\CG', '', 'g')

	let change_flag = 1
	while Gflag == 0 || (Gflag == 1 && change_flag == 1)
		let change_flag = 0
		for l:n in range(a:firstline, a:lastline)
			let l:line=getline(l:n)
			let l:ret=substitute(l:line, a:pat, a:sub, flags)
			if l:line != l:ret
				let change_flag = 1
			endif
			call setline(l:n, l:ret)
		endfor
		if Gflag == 0
			break
		endif
	endwhile
	call cursor(a:lastline+1, 1)
endfunction
command! -nargs=* -range TableConv <line1>,<line2>call s:substitute('^\|'.s:argsWithDefaultArg(1, ' ',<q-args>).'\|$', '|', 'g')

" [Perform a non\-regex search/replace in vim \- Stack Overflow]( https://stackoverflow.com/questions/6254820/perform-a-non-regex-search-replace-in-vim )
command! -nargs=*        S      let @/='\V'.escape(s:argsWithDefaultArg(1, @+, <q-args>), '\/') | call feedkeys("/\<C-r>/\<CR>", 'n')
command! -nargs=* -range R      let @/='\V'.escape(s:argsWithDefaultArg(1, @+, <q-args>), '\/') | call feedkeys(':'.<line1>.','.<line2>."s/\<C-r>///g |:noh".repeat("<Left>",8), 'n')
command! -nargs=*        Search let @/='\V'.escape(s:argsWithDefaultArg(1, @+, <q-args>), '\/') | call feedkeys("/\<C-r>/\<CR>", 'n')
command! -nargs=* -range Rep    let @/='\V'.escape(s:argsWithDefaultArg(1, @+, <q-args>), '\/') | call feedkeys(':'.<line1>.','.<line2>."s/\<C-r>///g |:noh".repeat("<Left>",8), 'n')

command! -nargs=* -range Space2Tab let view = winsaveview() | <line1>,<line2>call s:substitute('^\(\t*\)'.repeat(' ', s:argsWithDefaultArg(1, &tabstop, <f-args>)), '\1\t', 'gG') | silent call winrestview(view)
command! -nargs=* -range Tab2Space let view = winsaveview() | <line1>,<line2>call s:substitute('^\( *\)\t', '\1'.repeat(' ', s:argsWithDefaultArg(1, &tabstop, <f-args>)), 'gG') | silent call winrestview(view)

" NOTE: 全角文字扱いだが，半角表示となるためにずれる
" command! -nargs=0 -range ReplaceInterpunct <line1>,<line2>call s:substitute('·', '-', 'g')

" NOTE: 匿名化コマンド
execute "command! -range Anonymous :%s:".$HOME.":\${HOME}:gc | :%s:".$USER."@:\${USER}@:gc"

" [editing \- How reverse selected lines order in vim? \- Super User]( https://superuser.com/questions/189947/how-reverse-selected-lines-order-in-vim )
command! -nargs=0 -bar -range=% Tac
			\       let save_mark_t = getpos("'t")
			\<bar>      <line2>kt
			\<bar>      exe "<line1>,<line2>g/^/m't"
			\<bar>  call setpos("'t", save_mark_t)
			\<bar>  nohlsearch

" TODO: enable pass arg which contains space as prefix or suffix
function s:join(...) range
	let delim=get(a:, 1, ' ')
	let lines = join(getline(a:firstline, a:lastline), delim)
	execute 'normal! '.(a:lastline-a:firstline+1).'"_dd'
	call append(a:firstline-1, lines)
endfunction
command! -nargs=? -bar -range=% Join :<line1>,<line2>call <SID>join(<f-args>)

command! -nargs=0 SaveAsTempfile :execute ':w '.tempname()
