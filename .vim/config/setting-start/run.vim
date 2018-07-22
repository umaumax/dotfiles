" [How can I execute the current line as Vim EX commands? \- Stack Overflow]( https://stackoverflow.com/questions/14385998/how-can-i-execute-the-current-line-as-vim-ex-commands )
" [vim\-batch\-source/batch\-source\.vim at master · taku\-o/vim\-batch\-source]( https://github.com/taku-o/vim-batch-source/blob/master/plugin/batch-source.vim )
function! Execute() range
	" 途中の行の"でそれ以降が無視される
	" 	execute join(getline(a:firstline,a:lastline),"\<Bar>")
	" if, forが実行できない
	" 	for n in range(a:firstline, a:lastline)
	" 		execute getline(n)
	" 	endfor
	" NOTE: tempファイルの削除はOS任せ(一定時間後のclean任せ)
	let tempfilepath=tempname()
	call writefile(getline(a:firstline,a:lastline), tempfilepath)
	execute "source ".tempfilepath
endfunction
command! -range Run <line1>,<line2>call Execute()
command! -range E <line1>,<line2>call Execute()
command! -range Ex <line1>,<line2>call Execute()
command! -range Execute <line1>,<line2>call Execute()
