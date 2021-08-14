" NOTE: python syntax highlight
if has('nvim')
  Plug 'numirias/semshi', {'for':['python'], 'do': ':UpdateRemotePlugins'}
  augroup semshi_group
    autocmd!
    autocmd BufWritePost *.py :Semshi highlight
  augroup END
else
  Plug 'hdima/python-syntax', {'for':['python']}
  let g:python_highlight_all = 1
endif

" NOTE: below plugins are only for python package import command
" NOTE: 'davidhalter/jedi-vim' has 'Pyimport', but this command open module source and this plugin is
" incompatible with pyls completion
Plug 'umaumax/python-imports.vim', {'for':['python'], 'on': ['PyImport']}
