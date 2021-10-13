" NOTE: below plugins are only for python package import command
" NOTE: 'davidhalter/jedi-vim' has 'Pyimport',
" but this command open module source and this plugin is incompatible with pyls completion
Plug 'umaumax/python-imports.vim', {'for':['python'], 'on': ['PyImport']}
