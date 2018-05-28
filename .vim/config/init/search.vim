function! s:SearchWord(cmd, ...)
	let @+ = get(a:, 1, @+)
	let l:args = @+
	execute(':AsyncRun ' . a:cmd . ' ' . l:args)
endfunction
" brew install translate-shell || sudo apt-get install translate-shell
command! -nargs=? En call s:SearchWord('trans :en', <f-args>)
command! -nargs=? Ja call s:SearchWord('trans :ja', <f-args>)
command! -nargs=? S  call s:SearchWord('s', <f-args>)
command! -nargs=? Go call s:SearchWord('echo q | googler --nocolor -n 10', <f-args>)
nnoremap <Space>en viwv:En<CR>
nnoremap <Space>ja viwv:Ja<CR>
nnoremap <Space>s  viwv:S<CR>
nnoremap <Space>go viwv:Go<CR>
vnoremap <Space>en v:En<CR>
vnoremap <Space>ja v:Ja<CR>
vnoremap <Space>s  v:S<CR>
vnoremap <Space>go v:Go<CR>
