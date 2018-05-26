" git logのauthorが自分と一致する場合はプライベートなファイルであると仮定する
function! IsPrivateWork(...)
	let l:dir_path = get(a:, 1, expand('%:p:h'))
	" 	let l:author = system("git config user.name")

	" TODO: create function
	" cache data
	let l:tempfilename = 'git.config.user.name'
	" 	let l:tempfilepath = fnamemodify(tempname(), ":p") . l:tempfilename
	let l:tempfiledir = expand('~/.vim/tmp')
	call mkdir(l:tempfiledir, "p")
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

	let l:authors = system("cd " . l:dir_path . " && git log | grep 'Author' | cut -d' ' -f2 | sort | uniq")
	return l:authors == "" || l:authors == "fatal: not a git repository (or any of the parent directories): .git\n" || l:authors == l:author
endfunction

" [Vim:カーソル位置を移動せずにファイル全体を整形する \- ぼっち勉強会]( http://kannokanno.hatenablog.com/entry/2014/03/16/160109 )
function! s:format_file()
	let l:view = winsaveview()
	normal gg=G
	silent call winrestview(l:view)
endfunction

" (force) format
nnoremap fm :call <SID>format_file()<CR>

" [rhysd/vim-clang-format: Vim plugin for clang-format, a formatter for C, C++ and Obj-C code](https://github.com/rhysd/vim-clang-format)
if IsPrivateWork()
	augroup auto_compile
		autocmd!
		if executable('clang-format')
			autocmd BufWrite,FileWritePre,FileAppendPre *.[ch] :on
			autocmd BufWinEnter *.[ch] :ClangFormatAutoEnable
			autocmd BufWinEnter *.[ch]pp :ClangFormatAutoEnable
			autocmd BufWinEnter *.m :ClangFormatAutoEnable
		endif
		" tex auto compile
		if executable('latexmk')
			autocmd BufWritePost *.tex :!latexmk %
		endif

		if executable('jq')
			autocmd BufWrite,FileWritePre,FileAppendPre *.json :Jq
		endif

		" python formatter
		" pip install yapf
		if executable('yapf')
			autocmd FileType python autocmd BufWritePre <buffer> :0,$!yapf
		endif

		auto BufWritePre *.html :call s:format_file()
		auto BufWritePre *.css :setf css | call s:format_file()
		auto BufWritePre *.js :call s:format_file()
		auto BufWritePre *.tex :call s:format_file()
		auto BufWritePre *.cs :OmniSharpCodeFormat

		" vimのデフォルトのawkコマンドはバグがあるので required:Plug 'vim-scripts/awk.vim'
		auto BufWritePre *.awk :call s:format_file()
		auto BufWritePre *.{vim,vimrc} :call s:format_file()
		auto BufWritePre *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile} :Shfmt
	augroup END
endif
