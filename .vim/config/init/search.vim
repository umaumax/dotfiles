function! s:SearchWord(cmd, ...)
	let @+ = get(a:, 1, @+)
	let l:args = @+
	execute(':AsyncRun ' . a:cmd . ' ' . l:args)
endfunction
" [soimort/translate\-shell: Command\-line translator using Google Translate, Bing Translator, Yandex\.Translate, DeepL Translator, etc\.]( https://github.com/soimort/translate-shell )
" trans: brew install translate-shell || sudo apt-get install translate-shell
" [ERROR] Null response.
" [ERROR] Oops! Something went wrong and I can't translate it for you :(
" [translate\-shell doesn't work · Issue \#67 · soimort/translate\-shell]( https://github.com/soimort/translate-shell/issues/67 )
" 
" [zquestz/s: Open a web search in your terminal\.]( https://github.com/zquestz/s )
" s: brew install s-search
"
" [jarun/googler: Google from the terminal]( https://github.com/jarun/googler )
" googler: brew install googler || sudo apt-get install googler
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
