let g:vim_edit_log_map={'':1}
function! s:edit_log()
	let full_path = expand("%:p")
	if has_key(g:vim_edit_log_map, full_path)
		return
	endif
	" skip tmp file
	if full_path =~ '^/tmp/.*$' || full_path =~ '^/var/.*$'|| full_path =~ '^/private/.*$'
		return
	endif
	let g:vim_edit_log_map[full_path]=1

	" NOTE: home dirpathには正規表現が含まれていないと仮定
	let full_path = substitute(full_path, '^'.$HOME, '~','')

	" 	let now = localtime()
	" 	let time_str = strftime("%Y/%m/%d %H:%M:%S", now)
	execute ":redir! >> " . g:vim_edit_log_path
	" 	silent! echo time_str . " " . full_path
	silent! echo full_path
	redir END

	call s:clean_vim_edit_file_log()
endfunction

function! s:clean_vim_edit_file_log()
	" NOTE:
	" 重複削除(後の重複位置を優先)(本来ならば，追加時に先頭に追記したいが，sedのプラットフォームの互換性がないので断念)
	" tac | uniq | tac で無理やり実現
	let content = system("cat ".g:vim_edit_log_path." | awk '{a[i++]=$0} END{for(j=i-1; j>=0;) print a[j--]}' | awk '!a[$0]++' | awk '{a[i++]=$0} END{for(j=i-1; j>=0;) print a[j--]}'")
	execute ":redir! >" . g:vim_edit_log_path
	" NOTE: 存在しないファイル削除
	for file in split(content, "\n")
		if filereadable(expand(file))
			silent! echo file
		endif
	endfor
	redir END
	echo 'cleaned!'
endfunction

command! CleanVimEditFileLog call <SID>clean_vim_edit_file_log()

augroup edit_log_group
	autocmd!
	autocmd VimEnter,BufRead,BufWrite * call <SID>edit_log() 
augroup END
