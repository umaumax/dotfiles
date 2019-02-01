Plug 'octol/vim-cpp-enhanced-highlight', {'for':['c','cpp']}
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_no_function_highlight = 1

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

" [C/C\+\+ で予約済み識別子をシンタックスハイライトする Vimプラグインつくった \- Qiita]( https://qiita.com/pink_bangbi/items/5df92c35c3a5a41879f0 )
Plug 'umaumax/vim-cpp-syntax-reserved_identifiers', {'for': ['c','cpp']}
