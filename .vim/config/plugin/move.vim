" enhances the builtin F f , T t
Plug 'rhysd/clever-f.vim'

Plug 'easymotion/vim-easymotion'

let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=blue

let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Turn on case insensitive feature('a' or 'A')
let g:EasyMotion_smartcase = 1

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" map xxx <Plug>(easymotion-overwin-f)
" `s{char}{char}{label}`
" cannot use 'easymotion-overwin-f2' at visual mode
map g<Space> <Plug>(easymotion-overwin-f2)
map gj       <Plug>(easymotion-j)
map gk       <Plug>(easymotion-k)
map gl       <Plug>(easymotion-lineforward)
map gh       <Plug>(easymotion-linebackward)
map gw       <Plug>(easymotion-overwin-w)
