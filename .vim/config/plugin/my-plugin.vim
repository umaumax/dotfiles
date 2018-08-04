LazyPlug 'umaumax/autoread-vim'
" Plug 'umaumax/skeleton-vim'
Plug 'umaumax/comment-vim'
" :BenchVimrc
Plug 'umaumax/benchvimrc-vim', {'on': ['BenchVimrc']}
" fork元の'z0mbix/vim-shfmt'ではエラー時に保存できず，メッセージもなし
if Doctor('shfmt', 'umaumax/vim-shfmt')
	Plug 'umaumax/vim-shfmt',{'for': ['sh', 'zsh']}
endif
if Doctor('cmake-format', 'umaumax/vim-cmake-format')
	Plug 'umaumax/vim-cmake-format', {'for': 'cmake'}
endif
" let g:shfmt_fmt_on_save = 1

" input helper
" Plug 'kana/vim-smartinput'
" NOTE: don't use LazyPlug
Plug 'umaumax/vim-smartinput'

" Plug 'mattn/sonictemplate-vim'
LazyPlug 'umaumax/sonictemplate-vim'
" NOTE: :Template -> :T
let g:sonictemplate_commandname='T'
let g:sonictemplate_postfix_key='<C-x><C-p>'
let g:sonictemplate_vim_template_dir = [
			\ '~/dotfiles/template'
			\]
" if you want to add element, do like below
" let g:sonictemplate_vim_template_dir = g:sonictemplate_vim_template_dir + ['~/template']
