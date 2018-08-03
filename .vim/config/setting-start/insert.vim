" below command name are named after grep command option
command! -range -nargs=1 A :<line1>,<line2>call PrefixInsert("<args>")
function! PrefixInsert(str)
	let tmp = substitute(getline("."), '\(.*\)', a:str . '\1', 'g')
	call setline('.', tmp)
endfunction

command! -range -nargs=1 B :<line1>,<line2>call SuffixInsert("<args>")
function! SuffixInsert(str)
	let tmp = substitute(getline("."), '\(.*\)', '\1' . a:str, 'g')
	call setline('.', tmp)
endfunction

command! -range -nargs=+ C :<line1>,<line2>call PrefixSuffixInsert(<f-args>)
function! PrefixSuffixInsert(pre, suf)
	let tmp = substitute(getline("."), '\(.*\)', a:pre . '\1' . a:suf, 'g')
	call setline('.', tmp)
endfunction
