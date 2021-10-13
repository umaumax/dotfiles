finish

" We don't need below code because we use nvim-treesitter.

" python
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

" c/c++
Plug 'octol/vim-cpp-enhanced-highlight', {'for':['c','cpp']}
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_no_function_highlight = 1
