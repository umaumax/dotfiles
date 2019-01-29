" NOTE:
" :w <filepath>で新規に保存したときにはFileTypeイベントの発行前なので，vim format plugがまだ起動しないため，保存時にエラーとなるため，
" まず，autocmd FileType 駆動で初回のみイベントを登録する
" FileTypeイベントを発行させるために，:e!をすることを推奨

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

	let l:authors = system("cd " . l:dir_path . " && git rev-parse --is-inside-work-tree > /dev/null 2>&1 && (git log --format='%an' > /dev/null 2>&1 | sort | uniq | tr -d '\n')")
	let l:is_private = l:authors == "" || l:authors == l:author
	let g:is_private_work_cache[l:dir_path] = l:is_private
	return l:is_private
endfunction

" default format command
function! s:format_file()
	" [Vim:カーソル位置を移動せずにファイル全体を整形する \- ぼっち勉強会]( http://kannokanno.hatenablog.com/entry/2014/03/16/160109 )
	let l:view = winsaveview()
	normal! gg=G
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
augroup END

if Doctor('clang-format', 'clang format')
	augroup cpp_group
		autocmd!
		" :ClangFormatAutoEnable
		autocmd FileType cpp autocmd BufWinEnter *.{c,h,cc,cxx,cpp,hpp} command! Format ClangFormat
		autocmd FileType cpp autocmd BufWritePre *.{c,h,cc,cxx,cpp,hpp} if IsAutoFormat() | call clang_format#replace(1, line('$')) | endif
		autocmd FileType cpp autocmd! cpp_group FileType
	augroup END
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
	augroup python_group
		autocmd!
		autocmd FileType python autocmd BufWinEnter *.py command! Format call Autopep8()
		autocmd FileType python autocmd BufWritePre *.py if IsAutoFormat() |:call Autopep8() | endif
		autocmd FileType python autocmd! python_group FileType
	augroup END
endif

" 'maksimr/vim-jsbeautify'
if Doctor('npm', 'js,html,css format')
	augroup javascript_group
		autocmd!
		autocmd FileType javascript autocmd BufWinEnter *.js command! Format         JsBeautify()
		autocmd FileType javascript autocmd BufWritePre *.js if       IsAutoFormat() | :call JsBeautify() | endif
		autocmd FileType javascript autocmd! javascript_group FileType
	augroup END
	augroup json_group
		autocmd!
		autocmd FileType json autocmd BufWinEnter *.json command! Format         JsonBeautify()
		autocmd FileType json autocmd BufWritePre *.json if       IsAutoFormat() | :call JsonBeautify() | endif
		autocmd FileType json autocmd! json_group FileType
	augroup END
	" 		augroup jsx_group
	" 			autocmd!
	" 		autocmd FileType jsx      autocmd BufWinEnter *.jsx        command! Format JsxBeautify()
	" 		autocmd FileType jsx      autocmd BufWritePre *.jsx        if IsAutoFormat() | :call JsxBeautify()  | endif
	" 		autocmd FileType jsx autocmd! jsx_group FileType
	" 		augroup END
	augroup html_vue_group
		autocmd!
		autocmd FileType html,vue autocmd BufWinEnter *.{html,vue} command! Format HtmlBeautify()
		autocmd FileType html,vue autocmd BufWritePre *.{html,vue} if IsAutoFormat() | :call HtmlBeautify() | endif
		autocmd FileType html,vue autocmd! html_vue_group FileType
	augroup END
	augroup css_group
		autocmd!
		autocmd FileType css autocmd  BufWinEnter *.css command! Format         CSSBeautify()
		autocmd FileType css autocmd  BufWritePre *.css if       IsAutoFormat() | :call CSSBeautify() | endif
		autocmd FileType css autocmd! css_group   FileType
	augroup END
endif

augroup awk_group
	autocmd!
	autocmd FileType awk autocmd BufWinEnter *.awk command! Format <SID>format_file()
	autocmd FileType awk autocmd BufWritePre *.awk if IsAutoFormat() | :call <SID>format_file() | endif
	autocmd FileType awk autocmd! awk_group FileType
augroup END

augroup vim_group
	autocmd!
	autocmd FileType vim autocmd BufWritePre *.vim  if IsAutoFormat() | :call <SID>format_file() | endif
	autocmd FileType vim autocmd BufWritePre *vimrc if IsAutoFormat() | :call <SID>format_file() | endif
	autocmd FileType vim autocmd! vim_group FileType
augroup END

augroup tex_group
	autocmd!
	autocmd FileType plaintex autocmd BufWritePre *.tex  if IsAutoFormat() | :call <SID>format_file() | endif
	autocmd FileType plaintex autocmd! tex_group FileType
augroup END

if Doctor('shfmt', 'shell format')
	augroup shell_group
		autocmd!
		autocmd FileType sh,zsh autocmd BufWinEnter *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile} command! Format Shfmt
		autocmd FileType sh,zsh autocmd BufWritePre *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile} if IsAutoFormat() | :Shfmt | endif
		autocmd FileType sh,zsh autocmd! shell_group FileType
	augroup END
endif

if Doctor('cmake-format', 'cmake format')
	augroup cmake_format_group
		autocmd!
		autocmd FileType cmake autocmd BufWinEnter *.{cmake}      command! Format         CmakeFormat
		autocmd FileType cmake autocmd BufWinEnter CMakeLists.txt command! Format         CmakeFormat
		autocmd FileType cmake autocmd BufWritePre *.{cmake}      if       IsAutoFormat() | :CmakeFormat | endif
		autocmd FileType cmake autocmd BufWritePre CMakeLists.txt if       IsAutoFormat() | :CmakeFormat | endif
		autocmd FileType cmake autocmd! cmake_format_group FileType
	augroup END
endif

if Doctor('gofmt', 'go format')
	augroup go_format_group
		autocmd!
		" let g:go_fmt_autosave = 1
		autocmd FileType go autocmd BufWinEnter * command! Format GoFmt
		autocmd FileType go autocmd BufWritePre *.go if IsAutoFormat() | :GoFmtWrapper | endif
		autocmd FileType go autocmd! go_format_group FileType
	augroup END
endif
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
		let g:auto_format_flag= exists('g:auto_format_force_flag') ? g:auto_format_force_flag : 1
		augroup non_private
			autocmd!
		augroup END
	else
		let g:auto_format_flag= exists('g:auto_format_force_flag') ? g:auto_format_force_flag : 0
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

" NOTE: to speed up starting
function! s:private_or_public_work_set()
	augroup private_or_public_work
		autocmd!
		autocmd BufWinEnter,TabEnter * :call <SID>work_setting()
		autocmd BufWinEnter,TabEnter *.go :let g:auto_format_flag=1
	augroup END
	call <SID>work_setting()
	if &filetype=='go'
		let g:auto_format_flag=1
	endif
endfunction
augroup private_or_public_work_set
	autocmd!
	autocmd User VimEnterDrawPost call <SID>private_or_public_work_set()
augroup END
