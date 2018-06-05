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
		autocmd BufWinEnter *.{c,h,cc,cpp,hpp} command! Format ClangFormat
		autocmd BufWritePre *.{c,h,cc,cpp,hpp} if IsPrivateWork() | :ClangFormat | endif
	endif
	" python formatter
	" pip install yapf
	if Doctor('yapf', 'python format')
		autocmd BufWinEnter *.py command! Format 0,$!yapf
		autocmd BufWritePre *.py                :0,$!yapf
	endif

	" 'maksimr/vim-jsbeautify'
	if Doctor('npm', 'js,html,css format')
		autocmd BufWinEnter *.js   command! Format JsBeautify()
		autocmd BufWinEnter *.json command! Format JsonBeautify()
		autocmd BufWinEnter *.jsx  command! Format JsxBeautify()
		autocmd BufWinEnter *.html command! Format HtmlBeautify()
		autocmd BufWinEnter *.css  command! Format CSSBeautify()
		autocmd BufWritePre *.js   :call JsBeautify()
		autocmd BufWritePre *.json :call JsonBeautify()
		autocmd BufWritePre *.jsx  :call JsxBeautify()
		autocmd BufWritePre *.html :call HtmlBeautify()
		autocmd BufWritePre *.css  :call CSSBeautify()
	endif

	autocmd BufWinEnter *.awk command! Format <SID>format_file()
	autocmd BufWritePre *.awk           :call <SID>format_file()
	" default format
	autocmd BufWritePre *.vim  if IsPrivateWork() | :call <SID>format_file() | endif
	autocmd BufWritePre *vimrc :call <SID>format_file()
	autocmd BufWritePre *.tex  :call <SID>format_file()
	if Doctor('shfmt', 'shell format')
		autocmd BufWinEnter *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile} command! Format Shfmt
		autocmd BufWritePre *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile}                :Shfmt
	endif

	if Doctor('gofmt', 'go format')
		" let g:go_fmt_autosave = 1
		autocmd BufWinEnter *.go command! Format GoFmt
		autocmd BufWritePre *.go                :GoFmt
	endif
augroup END

" NOTE:
" 本来はautocmdでプライベート判定をするべきであるが，基本的に複数のgitをまたがなければ大丈夫
" [rhysd/vim-clang-format: Vim plugin for clang-format, a formatter for C, C++ and Obj-C code](https://github.com/rhysd/vim-clang-format)
if IsPrivateWork()
	augroup private_write_post
		autocmd!
		" tex auto compile
		if executable('latexmk')
			autocmd BufWritePost *.tex :!latexmk %
		endif
	augroup END
else
	augroup non_private
		autocmd!
		autocmd ColorScheme,BufWinEnter * highlight Normal ctermbg=0 guibg=#320000
		autocmd ColorScheme,BufWinEnter * highlight LineNr ctermbg=167 guibg=#650000
	augroup END
endif
