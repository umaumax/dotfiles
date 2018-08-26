" NOTE: python syntax highlight
if has('nvim')
  Plug 'numirias/semshi', {'for':['python'], 'do': ':UpdateRemotePlugins'}
else
  Plug 'hdima/python-syntax', {'for':['python']}
  let g:python_highlight_all = 1
endif
Plug 'umaumax/python-imports.vim', {'for':['python']}
