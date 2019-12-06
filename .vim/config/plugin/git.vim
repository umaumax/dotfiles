if !Doctor('git', 'airblade/vim-gitgutter and so on')
  finish
endif

" FYI: [airblade/vim\-gitgutter: A Vim plugin which shows a git diff in the gutter \(sign column\) and stages/undoes hunks and partial hunks\.]( https://github.com/airblade/vim-gitgutter )
function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
    " NOTE: this prevent to skip first line hunk
    GitGutterPrevHunk
  endif
endfunction

function! GitGutterPrevHunkCycle()
  let line = line('.')
  silent! GitGutterPrevHunk
  if line('.') == line
    normal! G
    GitGutterPrevHunk
    " NOTE: this prevent to skip last line hunk
    GitGutterNextHunk
  endif
endfunction

nnoremap <Plug>(vim-gitgutter:next_hunk_cycle) :call GitGutterNextHunkCycle()<CR>
nnoremap <Plug>(vim-gitgutter:prev_hunk_cycle) :call GitGutterPrevHunkCycle()<CR>

LazyPlug 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines=1
" With Neovim 0.3.2 or higher
let g:gitgutter_highlight_linenrs=1
let g:gitgutter_enabled=1
command! -narg=0 G :GitGutterToggle
nnoremap <silent> ]h         :call GitGutterNextHunkCycle()<CR>
nnoremap <silent> [h         :call GitGutterPrevHunkCycle()<CR>
nnoremap <silent> <Leader>gh :call GitGutterNextHunkCycle()<CR>
nnoremap <silent> <Leader>gH :call GitGutterPrevHunkCycle()<CR>
nnoremap <silent> <Leader>]  :call GitGutterNextHunkCycle()<CR>
nnoremap <silent> <Leader>[  :call GitGutterPrevHunkCycle()<CR>
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
    " NOTE: if you enter submode, you cannot see cursor
    " call submode#enter_with('bufgit', 'n', 'r', '<Leader>gh', '<Plug>(vim-gitgutter:next_hunk_cycle)')
    " call submode#enter_with('bufgit', 'n', 'r', '<Leader>gH', '<Plug>(vim-gitgutter:prev_hunk_cycle)')
    " call submode#map('bufgit', 'n', 'r', 'h', '<Plug>(vim-gitgutter:next_hunk_cycle)')
    " call submode#map('bufgit', 'n', 'r', 'H', '<Plug>(vim-gitgutter:prev_hunk_cycle)')
    highlight GitGutterChangeLine ctermbg=53 guibg=#5f005f
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
