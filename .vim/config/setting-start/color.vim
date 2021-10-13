function! s:init_color()
  highlight Search    term=reverse ctermfg=0 ctermbg=222 guifg=#000000 guibg=#FFE792
  highlight IncSearch term=reverse ctermfg=0 ctermbg=222 guifg=#000000 guibg=#FFE792

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
  " function matchadd high priority compared than 2match or 3match
  " 2match TrailingSpaces /　/
  call matchadd("TrailingSpaces", '　')

  highlight FilePath term=underline guifg=#5faf87 ctermfg=72
  highlight SnippetDecl term=underline guifg=#D75FD7 ctermfg=170
  highlight SnippetCommand term=underline guifg=#87FF87 ctermfg=120

  highlight Visual ctermbg=55 guibg=#800080

  " NOTE: Don't set foreground color, because whole line style is overwritten by that color
  highlight DiffAdd        ctermfg=NONE ctermbg=24  guifg=NONE guibg=#13354A cterm=NONE gui=NONE
  highlight DiffChange     ctermfg=NONE ctermbg=239 guifg=NONE guibg=#003200 cterm=NONE gui=NONE
  highlight GitGutterChangeLine ctermbg=55 guibg=#003200
  highlight DiffDelete     ctermfg=NONE ctermbg=233 guifg=NONE guibg=#b22222 cterm=NONE gui=NONE
  highlight DiffText       ctermfg=NONE ctermbg=102 guifg=NONE guibg=#4C4745 cterm=NONE gui=NONE
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

let b:syntax_highlighting_list=[]
function! s:reset_syntax_highlighting() abort
  " clear all matching patterns
  for m in b:syntax_highlighting_list
    call matchdelete(m)
  endfor
  let b:syntax_highlighting_list=[]
endfunction

function! s:init_syntax_highlighting(ext) abort
  call s:reset_syntax_highlighting()

  " cpp
  highlight NoColor guibg=NONE ctermbg=Red
  highlight ReservedIdentifiers term=underline guibg=#ff0000 ctermbg=Red

  let rules = {
        \ "cpp":[
        \   {"group":'ReservedIdentifiers', 'pattern': '\([^[:alnum:]]\zs_\w\+\)\|\(\w*__\w*\)'},
        \   {"group":'NoColor', 'pattern': '__asm__\|__restrict'},
        \ ],
        \ }
  for rule in rules[a:ext]
    let m = matchadd(rule['group'], rule['pattern'])
    call add(b:syntax_highlighting_list, m)
  endfor
endfunction

augroup syntax_highlighting_group
  autocmd!
  autocmd FileType c,cpp call s:init_syntax_highlighting("cpp")
augroup END
