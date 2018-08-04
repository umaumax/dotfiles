Plug 'octol/vim-cpp-enhanced-highlight', {'for':['c','cpp']}
let g:cpp_class_scope_highlight = 1
let g:cpp_concepts_highlight = 1

if Doctor('clang-format', 'rhysd/vim-clang-format')
	Plug 'rhysd/vim-clang-format', {'for': ['c','cpp']}
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
	let g:clang_format#code_style = "Google"
endif

Plug 'Shougo/neoinclude.vim', {'for': ['c','cpp']}
