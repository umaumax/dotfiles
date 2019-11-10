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
	let included = substitute(name,'\.\|-','_','g').'_INCLUDED__'
	let s:head = [
				\ '#ifndef '.included,
				\ "#define ".included,
				\ ]
	let s:foot = [
				\ '#endif // '.included,
				\ ]
	call IncludeGuard(join(s:head+["",""],"\n"), join(["",""]+s:foot,"\n"))
endfunction
function! IncludeGuardVim()
	let s:name = expand('%:r')
	let s:dirname = substitute(expand('%:p:h'),'.*/','','')
	let s:dirpath = expand('%:p:h')
	let plugin_flag = s:dirpath =~ 'plugin'
	let autoload_flag = s:dirpath =~ 'autoload'
	let ctrlp_flag = s:dirpath =~ 'autoload/ctrlp'
	if !(plugin_flag || autoload_flag || ctrlp_flag)
		return
	endif
	" NOTE: \{-}: min match
	let s:var_name = substitute(substitute(s:name,'\.\|-','_','g'),'.\{-}autoload/\|.\{-}plugin/','','')
	let exists_prefix = "!\0"[plugin_flag || ctrlp_flag]
	let s:head = ["if ".exists_prefix."exists('g:loaded_".s:var_name."')",
				\ "  finish",
				\ "endif",
				\ "let g:loaded_".s:var_name." = 1",
				\ "",
				\ "let s:save_cpo = &cpo",
				\ "set cpo&vim",
				\ ]
	let s:foot=[]
	if !ctrlp_flag
		let s:foot=[
					\ "let &cpo = s:save_cpo",
					\ "unlet s:save_cpo",
					\ ]
	endif
	call IncludeGuard(join(s:head+["",""],"\n"), join(["",""]+s:foot,"\n"))
endfunction
augroup include_guard
	autocmd!
	autocmd BufWinEnter *.h   command! -nargs=0 IncGuard call IncludeGuardC()
	autocmd BufWinEnter *.hpp command! -nargs=0 IncGuard call IncludeGuardC()
	autocmd BufWinEnter *.vim command! -nargs=0 IncGuard call IncludeGuardVim()
augroup END
