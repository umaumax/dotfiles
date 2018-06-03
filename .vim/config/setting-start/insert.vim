" below command name are named after grep command option
" 先頭に文字列を追加
command! -range -nargs=1 A :<line1>,<line2>call PrefixInseart("<args>")
function! PrefixInseart(str)
	let tmp = substitute(getline("."), '\(.*\)', a:str . '\1', 'g')
	call setline('.', tmp)
endfunction

" 末尾に文字列を追加
command! -range -nargs=1 B :<line1>,<line2>call SuffixInseart("<args>")
function! SuffixInseart(str)
	let tmp = substitute(getline("."), '\(.*\)', '\1' . a:str, 'g')
	call setline('.', tmp)
endfunction

" 先頭・末尾に文字列を追加
command! -range -nargs=+ C :<line1>,<line2>call PrefixSuffixInseart(<f-args>)
function! PrefixSuffixInseart(pre, suf)
	let tmp = substitute(getline("."), '\(.*\)', a:pre . '\1' . a:suf, 'g')
	call setline('.', tmp)
endfunction
