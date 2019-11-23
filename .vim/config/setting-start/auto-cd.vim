" let g:auto_lcd_basedir = get(g:, 'auto_lcd_basedir', 1)
" augroup grlcd
"   autocmd!
"   autocmd VimEnter * if g:auto_lcd_basedir == 1 && isdirectory(expand('%:p:h')) | lcd %:p:h | endif
" augroup END
