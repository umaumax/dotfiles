" not use interactive command (e.g. peco) in this function
function! s:pipe(...) abort
	let @+ = system(join(a:000,' '))
endfunction
command! -nargs=* -complete=command Pipe call s:pipe(<f-args>)
command! -nargs=* -complete=command P call s:pipe(<f-args>)

" :Grep script command
function! s:grep(keyword, ...)
	redir => scriptn | sil exe join(a:000, ' ') | redir end | echo(system('grep -n -i '. a:keyword, scriptn))
endfunction
command! -nargs=+ -complete=command Grep call s:grep(<f-args>)
