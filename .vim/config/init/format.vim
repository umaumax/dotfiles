" git logのauthorが自分と一致する場合はプライベートなファイルであると仮定する
function! IsPrivateWork(...)
	let l:dir_path = get(a:, 1, expand('%:p:h'))
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
	return l:authors == "" || l:authors == "fatal: not a git repository (or any of the parent directories): .git\n" || l:authors == l:author
endfunction

" default format command
function! s:format_file()
	" [Vim:カーソル位置を移動せずにファイル全体を整形する \- ぼっち勉強会]( http://kannokanno.hatenablog.com/entry/2014/03/16/160109 )
	let l:view = winsaveview()
	normal gg=G
	silent call winrestview(l:view)
endfunction
nnoremap fm :call <SID>format_file()<CR>

" register format command
augroup auto_format_setting
	autocmd!
	if executable('clang-format')
		" :ClangFormatAutoEnable
		autocmd BufWinEnter *.{c,h,cc,cpp,hpp} nnoremap fm :ClangFormat<CR>
		autocmd BufWritePre *.{c,h,cc,cpp,hpp} :ClangFormat
	endif
	" python formatter
	" pip install yapf
	if executable('yapf')
		autocmd BufWinEnter *.py nnoremap fm :0,$!yapf<CR>
		autocmd BufWritePre *.py :0,$!yapf
	endif

	" 'maksimr/vim-jsbeautify'
	autocmd BufWinEnter *.js   nnoremap fm :JsBeautify()<CR>
	autocmd BufWinEnter *.json nnoremap fm :JsonBeautify()<CR>
	autocmd BufWinEnter *.jsx  nnoremap fm :JsxBeautify()<CR>
	autocmd BufWinEnter *.html nnoremap fm :HtmlBeautify()<CR>
	autocmd BufWinEnter *.css  nnoremap fm :CSSBeautify()<CR>
	autocmd BufWritePre *.js   :call JsBeautify()
	autocmd BufWritePre *.json :call JsonBeautify()
	autocmd BufWritePre *.jsx  :call JsxBeautify()
	autocmd BufWritePre *.html :call HtmlBeautify()
	autocmd BufWritePre *.css  :call CSSBeautify()

	autocmd BufWinEnter *.awk nnoremap fm :g:format_file()<CR>
	autocmd BufWritePre *.awk        :call g:format_file()
	autocmd BufWinEnter *.{vim,vimrc} nnoremap fm :g:format_file()<CR>
	autocmd BufWritePre *.{vim,vimrc}        :call g:format_file()
	autocmd BufWinEnter *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile} nnoremap fm :Shfmt<CR>
	autocmd BufWritePre *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile}             :Shfmt

	" let g:go_fmt_autosave = 1
	autocmd BufWinEnter *.go nnoremap fm :GoFmt<CR>
	autocmd BufWritePre *.go             :GoFmt
augroup END

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
		autocmd ColorScheme,BufWinEnter * highlight Normal ctermbg=58 guibg=#320000
		autocmd ColorScheme,BufWinEnter * highlight LineNr ctermbg=34 guibg=#650000
	augroup END
endif
