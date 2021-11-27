LazyPlug 'umaumax/autoread-vim'
" Plug 'umaumax/skeleton-vim'
Plug 'umaumax/comment-vim'
" :BenchVimrc
Plug 'umaumax/benchvimrc-vim', {'on': ['BenchVimrc']}
" fork元の'z0mbix/vim-shfmt'ではエラー時に保存できず，メッセージもなし
" if Doctor('shfmt', 'umaumax/vim-shfmt')
" Plug 'umaumax/vim-shfmt',{'for': ['sh', 'zsh']}
" endif
" let g:shfmt_fmt_on_save = 1

" NOTE: コメントが消える不具合がある
" Plug 'tarekbecker/vim-yaml-formatter', {'for':'yaml'}
" let g:yaml_formatter_indent_collection=1

" NOTE: indentの整形がない
" Plug 'umaumax/vim-yaml-format', {'for':'yaml'}

for command in ['cmake-format', 'jq', 'shfmt', 'autopep8', 'nasmfmt', 'gofmt', 'rustfmt', 'goenkins-format', 'align', 'prettier']
  call Doctor(command, 'umaumax/vim-format')
endfor
Plug 'umaumax/vim-format'

" input helper
" Plug 'kana/vim-smartinput'
" NOTE: don't use LazyPlug
" let g:smartinput_no_default_key_mappings=1
Plug 'umaumax/vim-smartinput'

" Plug 'mattn/sonictemplate-vim'
LazyPlug 'umaumax/sonictemplate-vim'
" NOTE: :Template -> :T
let g:sonictemplate_commandname='T'
let g:sonictemplate_postfix_key='<C-x><C-p>'
let g:sonictemplate_vim_template_dir = [ '~/dotfiles/template']
" if you want to add element, do like below
" let g:sonictemplate_vim_template_dir = g:sonictemplate_vim_template_dir + ['~/template']
