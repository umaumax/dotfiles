function! s:init_color()
  highlight Search    term=reverse ctermfg=0 ctermbg=222 guifg=#000000 guibg=#FFE792
  highlight IncSearch term=reverse ctermfg=0 ctermbg=222 guifg=#000000 guibg=#FFE792

  if &rtp =~ 'vim-cpp-syntax-reserved_identifiers'
    highlight cReservedIdentifiers ctermfg=white ctermbg=red guifg=#ffffff guibg=#ff0000
  endif

  " NOTE: below color effect floating windows
  " completion menu color setting
  " highlight Pmenu    ctermfg=white ctermbg=26  guifg=#ffffff guibg=#4169E1
  " highlight PmenuSel cterm=bold    ctermfg=32 ctermbg=black gui=bold guifg=#4682B4 guibg=#000000

  " vim cursor color setting
  " NOTE: too noisy gui=underline
  highlight CursorLine   term=underline cterm=underline guibg=Black ctermbg=Black
  highlight CursorColumn guibg=Black ctermbg=Black

  " NOTE: visualize fullwidth space
  highlight TrailingSpaces term=underline guibg=#ff0000 ctermbg=Red
  match TrailingSpaces /　/

  highlight FilePath term=underline guifg=#5faf87 ctermfg=72
  highlight SnippetDecl term=underline guifg=#D75FD7 ctermfg=170
  highlight SnippetCommand term=underline guifg=#87FF87 ctermfg=120
endfunction

augroup init_color_group
  autocmd!
  autocmd ColorScheme,BufWinEnter * call s:init_color()
  autocmd User VimEnterDrawPost     call s:init_color()
  autocmd FileType * syntax sync minlines=50 maxlines=500
  autocmd FileType log,text syntax sync minlines=10 maxlines=100
  autocmd FileType log,text call matchadd('FilePath','\(^\|[^/0-9a-zA-Z_.~-]\)\zs[/0-9a-zA-Z_.~-]*\.[0-9a-zA-Z_~-]\+\(:[0-9]\+\)\?\ze\([^/0-9a-zA-Z_.~-]\|$\)')
  autocmd BufEnter snippet.txt call matchadd('SnippetDecl','^\[[^]]*\]')
  autocmd BufEnter snippet.txt call matchadd('SnippetCommand','^\[[^]]*\]\zs *[^ ]\+')
augroup END

if &rtp =~ 'rainbow'
  function! s:rainbow_group_func(action)
    if &ft=='cmake' || &ft=='bats'
      if a:action=='enter'
        call rainbow_main#clear()
      endif
    else
      if a:action=='enter'
        " NOTE:
        " pluginの行儀が良くないので，同じ&ftで複数回loadするとその分増えていく
        call rainbow_main#clear()
        call rainbow_main#load()
      endif
    endif
  endfunction
  augroup rainbow_group
    autocmd!
    autocmd User VimEnterDrawPost call <SID>rainbow_group_func('enter')
    autocmd BufEnter * call <SID>rainbow_group_func('enter')
    "   autocmd BufLeave * call <SID>rainbow_group_func('leave')
  augroup END
endif

function! s:ansi_color_set()
  highlight Red cterm=reverse ctermfg=Red gui=reverse guifg=Red
  highlight Blue cterm=reverse ctermfg=Blue gui=reverse guifg=Blue
endfunction
