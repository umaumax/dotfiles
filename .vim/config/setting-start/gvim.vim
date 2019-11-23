augroup gui_vim
  autocmd!
  " NOTE: `defaults write org.vim.MacVim MMCellWidthMultiplier 0.9`
  " for [splhack/macvim\-kaoriya: MacVim\-KaoriYa]( https://github.com/splhack/macvim-kaoriya )
  if has('gui_running')
    "     autocmd ColorScheme,BufWinEnter * syntax on
    "     autocmd ColorScheme,BufWinEnter * set guifont=Monaco:h12
    autocmd BufWinEnter * syntax on
    " NOTE; guifontwideが有効でない?
    " NOTE: guioptions: r:right scroll bar, l:left scrool bar, T:tool bar
    autocmd BufWinEnter * set guioptions=egm
    if has('gui_macvim') && has('kaoriya')
      autocmd BufWinEnter * set guifont=Monaco:h12 | set guifontwide=Monaco:h12
      "       autocmd BufWinEnter * set transparency=10
    endif
  endif
augroup END
