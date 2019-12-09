" auto toggle
" e.g. md    -> '* xxx'
"      c,cpp -> 'xxx:'
function! s:substitute(pat, sub, flags) range
  for l:n in range(a:firstline, a:lastline)
    let l:line=getline(l:n)
    let l:ret=substitute(l:line, a:pat, a:sub, a:flags)
    call setline(l:n, l:ret)
  endfor
  call cursor(a:lastline+1, 1)
endfunction

command! -nargs=0 -range SetMarkdownHead  <line1>,<line2>call s:substitute('^\(\s*\)\([^* \t].*\)$', '\1* \2', '')
command! -nargs=0 -range SetMarkdownQuote <line1>,<line2>call s:substitute('^\(\s*\)\([^> \t].*\)$', '\1> \2', '')
command! -nargs=0 -range SetCBottom       <line1>,<line2>call s:substitute('\(^.*[^;]\+\)\s*$', '\1;', '')
command! -nargs=0 -range SetPyBottom      <line1>,<line2>call s:substitute('\(^.*[^:]\+\)\s*$', '\1:', '')

augroup file_detection_for_toggle
  autocmd!
  au BufNewFile,BufRead *.md               nnoremap <silent> <Leader><Space> :SetMarkdownHead<CR>
  au BufNewFile,BufRead *.md               vnoremap <silent> <Leader><Space> :SetMarkdownHead<CR>
  au BufNewFile,BufRead *.md               nnoremap <silent> <Space>q        :SetMarkdownQuote<CR>
  au BufNewFile,BufRead *.md               vnoremap <silent> <Space>q        :SetMarkdownQuote<CR>
  au BufNewFile,BufRead *.{c,cc,cpp,h,hpp} nnoremap <silent> <Leader><Space> :SetCBottom<CR>
  au BufNewFile,BufRead *.{c,cc,cpp,h,hpp} vnoremap <silent> <Leader><Space> :SetCBottom<CR>
  au BufNewFile,BufRead *.py               nnoremap <silent> <Leader><Space> :SetPyBottom<CR>
  au BufNewFile,BufRead *.py               vnoremap <silent> <Leader><Space> :SetPyBottom<CR>
augroup END
