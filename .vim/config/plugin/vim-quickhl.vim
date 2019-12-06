" highlight word (on cursor)
LazyPlug 't9md/vim-quickhl'
nmap <Leader>h <Plug>(quickhl-manual-this)
xmap <Leader>h <Plug>(quickhl-manual-this)
nmap <Leader>H <Plug>(quickhl-manual-reset)
xmap <Leader>H <Plug>(quickhl-manual-reset)

" NOTE: 設定した色数を超過してハイライトはできないので注意
" use :ColorHighlight for confirmation
let g:quickhl_manual_colors = [
   \ "gui=none ctermfg=7  ctermbg=1   guibg=#cd4040 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=208 guibg=#ff8700 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=203 guibg=#f08080 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=164 guibg=#dd0add guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=2   guibg=#70a040 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=3   guibg=#ffa500 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=4   guibg=#6a5acd guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=6   guibg=#20b2aa guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=16  guibg=#a9a9a9 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=21  guibg=#e0c67c guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=54  guibg=#5f0087 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=22  guibg=#2e8b57 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=57  guibg=#5f00ff guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=94  guibg=#875f00 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=91  guibg=#8700af guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=110 guibg=#87afd7 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=148 guibg=#afd700 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=220 guibg=#ffd700 guifg=#ffffff",
   \ "gui=none ctermfg=7  ctermbg=212 guibg=#ff87d7 guifg=#ffffff",
   \ ]
" [Neovimで複数の単語をハイライト\(vim\-quickhl\.vim\) @Windows10 \- ぱちコマな日々]( http://pachicoma.hateblo.jp/entry/2017/03/08/Neovim%E3%81%A7%E8%A4%87%E6%95%B0%E3%81%AE%E5%8D%98%E8%AA%9E%E3%82%92%E3%83%8F%E3%82%A4%E3%83%A9%E3%82%A4%E3%83%88%28vim-quickhl_vim%29_%40Windows10 )
let g:quickhl_manual_enable_at_startup = 1
" \<: 単語始まり
" \>: 単語終わり
let g:quickhl_manual_keywords = [
      \ {"pattern": '\<TODO\>\c',     "regexp": 1 },
      \ {"pattern": '\<WARN\>\c',     "regexp": 1 },
      \ {"pattern": '\<ERROR\>\c',    "regexp": 1 },
      \ {"pattern": '\<FAILED\>\c',   "regexp": 1 },
      \ {"pattern": '\<DELETE\>\c',   "regexp": 1 },
      \ {"pattern": '\<NOTE\>\c',     "regexp": 1 },
      \ {"pattern": '\<MEMO\>\c',     "regexp": 1 },
      \ {"pattern": '\<FIX\>\c',      "regexp": 1 },
      \ {"pattern": '\<FYI\>\c',      "regexp": 1 },
      \ {"pattern": '\<INFO\>\c',     "regexp": 1 },
      \ {"pattern": '\<WIP\>\c',      "regexp": 1 },
      \ {"pattern": '\<HINT\>\c',     "regexp": 1 },
      \ {"pattern": '\<QUESTION\>\c', "regexp": 1 },
      \ {"pattern": '\<REQUIRED\>\c', "regexp": 1 },
      \ ]

" NOTE: same kind of plugin
" Plug 'lfv89/vim-interestingwords'
" nnoremap <silent> <leader>h :call InterestingWords('n')<cr>
" nnoremap <silent> <leader>h :call InterestingWords('v')<cr>
" " nnoremap <silent> <leader>K :call UncolorAllWords()<cr>
" let g:interestingWordsGUIColors = [
" \ '#8CCBEA', '#A4E57E', '#FFDB72', '#FF7272', '#FFB3FF', '#9999FF',
" \'#4C6B7A', '#54753E', '#7F6B32', '#7F3232', '#7F537F', '#49497F',
" \]
