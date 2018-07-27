" git logのauthorが自分と一致する場合はプライベートなファイルであると仮定する
let g:is_private_work_cache={}
function! IsPrivateWork(...)
	let l:dir_path = get(a:, 1, expand('%:p:h'))
	if has_key(g:is_private_work_cache, l:dir_path)
		return g:is_private_work_cache[l:dir_path]
	endif

	" 	let l:author = system("git config user.name")
	" TODO: create function
	" cache data
	let l:tempfilename = 'git.config.user.name'
	" 	let l:tempfilepath = fnamemodify(tempname(), ":p") . l:tempfilename
	let l:tempfiledir = expand('~/.vim/cache')
	if !isdirectory(l:tempfiledir)
		call mkdir(l:tempfiledir, "p")
	endif
	let l:tempfilepath = l:tempfiledir . '/' . l:tempfilename

	if filereadable(l:tempfilepath)
		let l:author = join(readfile(l:tempfilepath),'')
	else
		let l:author = system("git config user.name")
		if v:shell_error == 0
			call writefile(split(l:author, '\n'), l:tempfilepath)
		else
			let l:author = ''
		endif
	endif

	let l:authors = system("cd " . l:dir_path . " && git log | grep 'Author' | cut -d' ' -f2 | sort | uniq | tr -d '\n'")
	let l:ret= l:authors == "" || l:authors == "fatal: not a git repository (or any of the parent directories): .git\n" || l:authors == l:author
	let g:is_private_work_cache[l:dir_path] = l:ret
	return l:ret
endfunction

" default format command
function! s:format_file()
	" [Vim:カーソル位置を移動せずにファイル全体を整形する \- ぼっち勉強会]( http://kannokanno.hatenablog.com/entry/2014/03/16/160109 )
	let l:view = winsaveview()
	normal gg=G
	silent call winrestview(l:view)
endfunction
"nnoremap fm :call <SID>format_file()<CR>
command! Format call <SID>format_file()

function! IsAutoFormat()
	return g:auto_format_flag == 1
endfunction
let g:auto_format_flag=1
" NOTE: if command name startswith AutoFormat, there are many similar command to complete
command! NoAutoFormat let g:auto_format_flag=0
command! AutoFormat let g:auto_format_flag=1

" 下記のautocmdの統合は案外難しい
" FYI
" [vim\-codefmt/yapf\.vim at 5ede026bb3582cb3ca18fd4875bec76b98ce9a12 · google/vim\-codefmt]( https://github.com/google/vim-codefmt/blob/5ede026bb3582cb3ca18fd4875bec76b98ce9a12/autoload/codefmt/yapf.vim#L22 )

" register format command
augroup auto_format_setting
	autocmd!
	" default format command
	autocmd BufWinLeave * command! Format call <SID>format_file()

	if Doctor('clang-format', 'clang format')
		" :ClangFormatAutoEnable
		autocmd BufWinEnter * autocmd FileType cpp command! Format ClangFormat
		autocmd BufWritePre *.{c,h,cc,cpp,hpp} if IsAutoFormat() | call clang_format#replace(1, line('$')) | endif
	endif
	" python formatter
	" pip install yapf
	" 	if Doctor('yapf', 'python format')
	" 		autocmd BufWinEnter *.py command! Format 0,$!yapf
	" 		autocmd BufWritePre *.py                :0,$!yapf
	" 	endif
	" python formatter
	" pip install yapf
	if Doctor('autopep8', 'python format')
		autocmd BufWinEnter * autocmd FileType python command! Format call Autopep8()
		autocmd BufWritePre *.py if IsAutoFormat() |:call Autopep8() | endif
	endif

	" 'maksimr/vim-jsbeautify'
	if Doctor('npm', 'js,html,css format')
		autocmd BufWinEnter *.js   command! Format JsBeautify()
		autocmd BufWinEnter *.json command! Format JsonBeautify()
		autocmd BufWinEnter *.jsx  command! Format JsxBeautify()
		autocmd BufWinEnter *.html command! Format HtmlBeautify()
		autocmd BufWinEnter *.css  command! Format CSSBeautify()
		autocmd BufWritePre *.js   if IsAutoFormat() | :call JsBeautify() | endif
		autocmd BufWritePre *.json if IsAutoFormat() | :call JsonBeautify() | endif
		autocmd BufWritePre *.jsx  if IsAutoFormat() | :call JsxBeautify() | endif
		autocmd BufWritePre *.html if IsAutoFormat() | :call HtmlBeautify() | endif
		autocmd BufWritePre *.css  if IsAutoFormat() | :call CSSBeautify() | endif
	endif

	autocmd BufWinEnter * autocmd FileType awk command! Format <SID>format_file()
	autocmd BufWritePre *.awk if IsAutoFormat() | :call <SID>format_file() | endif
	" default format
	autocmd BufWritePre *.vim if IsAutoFormat() | :call <SID>format_file() | endif
	autocmd BufWritePre *vimrc if IsAutoFormat() | :call <SID>format_file() | endif
	autocmd BufWritePre *.tex  if IsAutoFormat() | :call <SID>format_file() | endif
	if Doctor('shfmt', 'shell format')
		autocmd BufWinEnter *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile} command! Format Shfmt
		autocmd BufWritePre *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile} if IsAutoFormat() | :Shfmt | endif
	endif
	if Doctor('cmake-format', 'cmake format')
		autocmd BufWinEnter *.{cmake} command! Format CmakeFormat
		autocmd BufWritePre *.{cmake} if IsAutoFormat() | :CmakeFormat | endif
		autocmd BufWinEnter CMakeLists.txt command! Format CmakeFormat
		autocmd BufWritePre CMakeLists.txt if IsAutoFormat() | :CmakeFormat | endif
	endif

	if Doctor('gofmt', 'go format')
		" let g:go_fmt_autosave = 1
		autocmd BufWinEnter * autocmd FileType go command! Format GoFmt
		" 		autocmd BufWritePre *.go if IsAutoFormat() | :GoFmt | endif
		autocmd BufWritePre *.go if IsAutoFormat() | :GoFmtWrapper | endif
	endif
augroup END
" NOTE: original GoFmt has no '-bar' option
command! -bar GoFmtWrapper :GoFmt

" error表示のwindowの制御方法が不明
" Plug 'tell-k/vim-autopep8'
function! Preserve(command)
	" Save the last search.
	let search = @/
	" Save the current cursor position.
	let cursor_position = getpos('.')
	" Save the current window position.
	normal! H
	let window_position = getpos('.')
	call setpos('.', cursor_position)
	" Execute the command.
	execute a:command
	" Restore the last search.
	let @/ = search
	" Restore the previous window position.
	call setpos('.', window_position)
	normal! zt
	" Restore the previous cursor position.
	call setpos('.', cursor_position)
endfunction

function! Autopep8()
	" [vimでpythonのコーディングスタイルを自動でチェック&自動修正する \- blog\.ton\-up\.net]( https://blog.ton-up.net/2013/11/26/vim-python-style-check-and-fix/ )
	call Preserve(':silent %!autopep8 --ignore=E501 -')
endfunction

" NOTE:
" 本来はautocmdでプライベート判定をするべきであるが，基本的に複数のgitをまたがなければ大丈夫
" [rhysd/vim-clang-format: Vim plugin for clang-format, a formatter for C, C++ and Obj-C code](https://github.com/rhysd/vim-clang-format)

function! s:work_setting()
	" NOTE: mark iconの色が変化する
	" ここで，初期化しないと下記の色変更コマンドが反映されない?
	" 	execute 'colorscheme '.g:colors_name
	if IsPrivateWork()
		let g:auto_format_flag=1
		augroup non_private
			autocmd!
		augroup END
	else
		let g:auto_format_flag=0
		" NOTE: disable chmod
		" shell file is exception
		let g:autochmodx_ignore_scriptish_file_patterns =[
					\      '\c.*\.pl$',
					\      '\c.*\.rb$',
					\      '\c.*\.py$',
					\	]
		" \      '\c.*\.sh$',

		" NOTE: BufWinEnterによってこの関数が呼び出され，その後にColorSchemeが呼ばれないため
		" 		augroup non_private
		" 			autocmd!
		" 			autocmd ColorScheme,BufWinEnter * highlight Normal ctermbg=0 guibg=#320000
		" 			autocmd ColorScheme,BufWinEnter * highlight LineNr ctermbg=167 guibg=#650000
		" 		augroup END
		highlight Normal ctermbg=0 guibg=#320000
		highlight LineNr ctermbg=167 guibg=#650000
	endif
endfunction

augroup private_or_public_work
	autocmd!
	autocmd BufWinEnter,TabEnter * :call <SID>work_setting()
	autocmd BufWinEnter,TabEnter *.go :let g:auto_format_flag=1
augroup END
