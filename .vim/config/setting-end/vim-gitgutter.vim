if &rtp =~ 'vim-submode'
  " for 'airblade/vim-gitgutter'
  call submode#enter_with('bufgit', 'n', 'r', 'gh', '<Plug>GitGutterNextHunk')
  call submode#enter_with('bufgit', 'n', 'r', 'gH', '<Plug>GitGutterPrevHunk')
  call submode#map('bufgit', 'n', 'r', 'h', '<Plug>GitGutterNextHunk')
  call submode#map('bufgit', 'n', 'r', 'H', '<Plug>GitGutterPrevHunk')
  highlight GitGutterChangeLine cterm=bold ctermfg=7 ctermbg=16 gui=bold guifg=#ffffff guibg=#2c4f1f
endif
