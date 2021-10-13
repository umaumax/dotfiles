if Doctor('clang-rename', 'uplus/vim-clang-rename')
  " WARN: 実際に使用する場合には，対象ファイルをopenしてから編集してはならない
  " WARN: errorが発生してもlogにはでてこない
  "
  " NOTE: you can use below commands
  " :ClangRename
  " :ClangRenameCurrent, :ClangRenameQualifiedName
  Plug 'uplus/vim-clang-rename', {'for':['c','cpp']}
  augroup clang_rename_group
    autocmd!
    autocmd FileType c,cpp nmap <buffer><silent>,lr <Plug>(clang_rename-current)
  augroup END
endif

if Doctor('clang-format', 'rhysd/vim-clang-format')
  " NOTE: search .clang-format or _clang-format option ON
  let g:clang_format#detect_style_file=1
  Plug 'rhysd/vim-clang-format', {'for': ['c','cpp']}
  " NOTE: below style is used when no .clang-format
  let g:clang_format#code_style = "Google"
  let g:clang_format#style_options = {
        \ "AccessModifierOffset" : -4,
        \ "AllowShortIfStatementsOnASingleLine" : "true",
        \ "AlignConsecutiveAssignments" : "true",
        \ "AlignTrailingComments" : "true",
        \ "AlwaysBreakTemplateDeclarations" : "true",
        \ "Standard" : "Cpp11",
        \ "BreakBeforeBraces" : "Stroustrup",
        \ "ColumnLimit" : 320,
        \ "CommentPragmas" : "^",
        \ "IndentWidth" : 4,
        \ "TabWidth" : 4,
        \ "ConstructorInitializerIndentWidth" : 2,
        \ "BreakConstructorInitializersBeforeComma" : "true",
        \ "ContinuationIndentWidth" : 2,
        \ }
endif

Plug 'Shougo/neoinclude.vim', {'for': ['c','cpp']}

