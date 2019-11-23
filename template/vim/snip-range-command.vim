function! XXX() range
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
  endfor
endfunction
command! -range XXX <line1>,<line2>call XXX()
