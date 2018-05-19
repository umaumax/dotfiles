Plug 'easymotion/vim-easymotion'

let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionShade  ctermbg=none ctermfg=blue

let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Turn on case insensitive feature('a' or 'A')
let g:EasyMotion_smartcase = 1

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap ff <Plug>(easymotion-overwin-f)
" `s{char}{char}{label}`
nmap fs <Plug>(easymotion-overwin-f2)

nmap fj <Plug>(easymotion-j)
nmap fk <Plug>(easymotion-k)
nmap fl <Plug>(easymotion-lineforward)
nmap fh <Plug>(easymotion-linebackward)
nmap fw <Plug>(easymotion-overwin-w)
