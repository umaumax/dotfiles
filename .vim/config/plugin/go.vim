if !Doctor('go','fatih/vim-go')
  finish
endif

Plug 'zchee/vim-goiferr', {'for': 'go'}
Plug 'mattn/vim-gomod', {'for': 'go'}
Plug 'mattn/vim-goimports', {'for': 'go'}

" " for fatih/vim-go
" let g:go_asmfmt_autosave=0
" " .s -> Plan9形式でのformatとする
" "Plug 'vim-scripts/asm8051.vim'
" Plug 'Shirk/vim-gas'
" augroup filetypedetect
"   au BufNewFile,BufRead *.s,*.inc,*.asm,*.S,*.ASM,*.INC,*.plan9,*.as,*.AS set ft=gas
" augroup END

