if !Doctor('git', 'airblade/vim-gitgutter')
  finish
endif

LazyPlug 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines=1
" With Neovim 0.3.2 or higher
let g:gitgutter_highlight_linenrs=1
let g:gitgutter_enabled=1
command! -narg=0 G :GitGutterToggle
" hunk
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
" stage, unstage, preview
" NOTE: stage hunkの仕様が不明瞭(一部のデータが消える)
" nmap <Leader>sh <Plug>(GitGutterStageHunk)
" NOTE: how to use undo hunk?
" nmap <Leader>uh <Plug>(GitGutterUndoHunk)
" NOTE: diffの削除された行の表示が可能
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)
" NOTE: for avoid same maping for 'pocke/vim-textobj-markdown' or 'christoomey/vim-textobj-codeblock'
" ic,ac for markdown code block

omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

function! s:vim_gitgutter_group()
  if &rtp =~ 'vim-submode'
    " NOTE: hunk間の移動を巡回させたい
    call submode#enter_with('bufgit', 'n', 'r', '<Leader>gh', '<Plug>(GitGutterNextHunk)')
    call submode#enter_with('bufgit', 'n', 'r', '<Leader>gH', '<Plug>(GitGutterPrevHunk)')
    call submode#map('bufgit', 'n', 'r', 'h', '<Plug>(GitGutterNextHunk)')
    call submode#map('bufgit', 'n', 'r', 'H', '<Plug>(GitGutterPrevHunk)')
    highlight GitGutterChangeLine cterm=bold ctermfg=7 ctermbg=16 gui=bold guifg=#ffffff guibg=#2c4f1f
  endif
endfunction

augroup vim_gitgutter_group
  autocmd!
  autocmd User VimEnterDrawPost call s:vim_gitgutter_group()
augroup END

" NOTE: for .gitignore color highlighting
Plug 'fszymanski/fzf-gitignore', {'for': 'gitignore'}

" NOTE: reveal the commit messages under the cursor like git blame
Plug 'rhysd/git-messenger.vim', {'on': 'GitMessenger'}
let g:git_messenger_include_diff='current'
" <Leader>gm: defualt for Plug load trigger
nmap <Leader>gm :<C-u>GitMessenger<CR>
augroup git_messenger_vim_color_group
  autocmd!
  autocmd ColorScheme,BufWinEnter * highlight gitmessengerHash term=None guifg=#f0eaaa ctermfg=229 |
        \ highlight gitmessengerPopupNormal term=None guifg=#eeeeee guibg=#666666 ctermfg=255 ctermbg=234 |
        \ highlight link diffRemoved   Identifier |
        \ highlight link diffAdded     Type
augroup END
