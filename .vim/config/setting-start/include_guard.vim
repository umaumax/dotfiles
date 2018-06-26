" [カレントファイルにインクルードガードを書き込むvimスクリプト - Qiita](http://qiita.com/xeno1991/items/27d9aaf0501c41116aec)
" Insert include guard to the current file
" head, foot: list(["", ""]) or string
function! IncludeGuard(head, foot)
	let l:view = winsaveview()
	silent! execute '1s/^/\=a:head'
	silent! execute '$s/$/\=a:foot'
	silent call winrestview(l:view)
endfunction
function! IncludeGuardC()
	let name = fnamemodify(expand('%'),':t')
	let name = toupper(name)
	let included = substitute(name,'\.','_','g').'_INCLUDED__'
	let res_head = '#ifndef '.included."\n#define ".included."\n\n"
	let res_foot = "\n".'#endif //'.included."\n"
	call IncludeGuard(res_head, res_foot)
endfunction
function! IncludeGuardVim()
	let s:name = expand('%:r')
	let s:dirname = substitute(expand('%:p:h'),'.*/','','')
	echo s:dirname
	if !(s:dirname == 'plugin' || s:dirname == 'autoload')
		return
	endif
	let s:var_name = substitute(s:name,'\.','_','g')
	let s:head = "if ". "!\0"[s:dirname == 'plugin']."exists('g:loaded_".s:var_name."')\n"
				\."\tfinish\n"
				\."endif\n"
				\."let g:loaded_".s:var_name." = 1\n"
	let s:foot="\n"."let &cpo = s:save_cpo\n"
				\."unlet s:save_cpo"
	call IncludeGuard(s:head, s:foot)
endfunction
augroup include_guard
	autocmd!
	autocmd BufWinEnter *.h   command! -nargs=0 IncGuard call IncludeGuardC()
	autocmd BufWinEnter *.hpp command! -nargs=0 IncGuard call IncludeGuardC()
	autocmd BufWinEnter *.vim command! -nargs=0 IncGuard call IncludeGuardVim()
augroup END
