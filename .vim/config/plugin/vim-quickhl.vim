" highlight word (on cursor)
LazyPlug 't9md/vim-quickhl'
nmap <Leader>h <Plug>(quickhl-manual-this)
xmap <Leader>h <Plug>(quickhl-manual-this)
nmap <Leader>H <Plug>(quickhl-manual-reset)
xmap <Leader>H <Plug>(quickhl-manual-reset)

" [Neovimで複数の単語をハイライト\(vim\-quickhl\.vim\) @Windows10 \- ぱちコマな日々]( http://pachicoma.hateblo.jp/entry/2017/03/08/Neovim%E3%81%A7%E8%A4%87%E6%95%B0%E3%81%AE%E5%8D%98%E8%AA%9E%E3%82%92%E3%83%8F%E3%82%A4%E3%83%A9%E3%82%A4%E3%83%88%28vim-quickhl_vim%29_%40Windows10 )
let g:quickhl_manual_enable_at_startup = 1
" \<: 単語始まり
" \>: 単語終わり
" NOTE: ubuntuではDELETEの色が黒になってしまっていたので，DUMMYを設けた
let g:quickhl_manual_keywords = [
                  \ {"pattern": '\<NOTE\>\c', "regexp": 1 },
                  \ {"pattern": '\<TODO\>\c', "regexp": 1 },
                  \ {"pattern": '\<MEMO\>\c', "regexp": 1 },
                  \ {"pattern": '\<FIX\>\c',  "regexp": 1 },
                  \ {"pattern": '\<FYI\>\c',  "regexp": 1 },
                  \ {"pattern": '\<WARN\>\c', "regexp": 1 },
                  \ {"pattern": '\<INFO\>\c', "regexp": 1 },
                  \ {"pattern": '\<WIP\>\c',  "regexp": 1 },
                  \ {"pattern": '\<HINT\>\c', "regexp": 1 },
                  \ {"pattern": '\<QUESTION\>\c', "regexp": 1 },
                  \ {"pattern": '\<DUMMY\>\c', "regexp": 1 },
                  \ {"pattern": '\<DELETE\>\c', "regexp": 1 },
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
