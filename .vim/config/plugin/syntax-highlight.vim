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

" jenkins
Plug 'martinda/Jenkinsfile-vim-syntax', {'for':'Jenkinsfile'}
Plug 'vim-scripts/groovyindent-unix', {'for':'Jenkinsfile'}

" docker
" for syntax file
Plug 'ekalinin/Dockerfile.vim', {'for':'dockerfile'}
" overwrite ft 'Dockerfile' -> 'dockerfile'
augroup dockerfiletype_group
  autocmd!
  autocmd FileType Dockerfile setlocal ft=dockerfile
augroup END

" web
" Plug 'vim-scripts/JavaScript-Indent', {'for': 'javascript'}
" Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
" Plug 'kchmck/vim-coffee-script', {'for': 'javascript'}
" Plug 'felixge/vim-nodejs-errorformat', {'for': 'javascript'}
Plug 'othree/html5.vim', {'for': ['html', 'javascript']}

" plantuml
Plug 'aklt/plantuml-syntax', {'for':'plantuml'}

" golang
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
let g:go_disable_autoinstall = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_interfaces = 1
":he go-settings
" Highlights commonly used library types (io.Reader, etc.).
let g:go_highlight_extra_types = 1

" 後にファイルがプライベートかどうかを判断し有効化する
let g:go_fmt_autosave = 0
" ***. の表記があるとその"***"パッケージを自動で探しに行くので保存が遅くなるので注意
let g:go_fmt_command = "gofmt"
"let g:go_lint_command = "golint"

let g:molokai_original = 1
let g:rehash256 = 1

augroup go_setting
  autocmd!
  " require 'tomasr/molokai'
  " NOTE:
  " colorschemeの設定タイミングによって't9md/vim-quickhl'が正常に反映されない
  "   au BufRead,BufNewFile *.go colorscheme molokai

  " [Highlight go extra vars]( http://esola.co/posts/2016/highlight-go-extra-vars )
  autocmd FileType go :highlight goExtraVars cterm=bold ctermfg=136
  autocmd FileType go :match goExtraVars /\<ok\>\|\<err\>/
augroup END

" for &ft='gas'
LazyPlug 'Shirk/vim-gas', {'for': 'gas'}
" for nasm use &ft='nasm'

" for nasm indent
LazyPlug 'philj56/vim-asm-indent', {'for': 'nasm'}

" toml
Plug 'cespare/vim-toml', {'for':'toml'}

" gnuplot
" to use this lib, you have to set filetype=gnuplot by autocmd
Plug 'vim-scripts/gnuplot.vim', {'for': 'gnuplot'}

" for Vue.js
Plug 'digitaltoad/vim-pug', {'for': ['javascript','json','css','html','vue','vue.html.javascript.css']}
Plug 'posva/vim-vue', {'for': ['html', 'vue', 'vue.html.javascript.css']}
Plug 'Shougo/context_filetype.vim', {'for': ['vue', 'vue.html.javascript.css']}
