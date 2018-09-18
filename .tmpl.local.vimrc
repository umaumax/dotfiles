let python2_path = substitute(system('which python2'), "\n", '', '')
let python3_path = substitute(system('which python3'), "\n", '', '')

let g:python_host_prog  = python2_path
let g:python3_host_prog = python3_path
let g:deoplete#sources#jedi#python_path = python3_path

" [deoplete\-clangで快適C\+\+エディット！！！ \- Qiita]( https://qiita.com/musou1500/items/3f0b139d37d78a18786f )
" for 'zchee/deoplete-clang'
if has('mac')
	let g:deoplete#sources#clang#libclang_path = '/usr/local/opt/llvm/lib/libclang.dylib'
	let g:deoplete#sources#clang#clang_header  = '/usr/local/opt/llvm/include/clang'

	let g:deoplete#sources#clang#flags = [
				\'-I/usr/local/Cellar/llvm/6.0.0/include',
				\'-stdlib=libc++',
				\ ]

	" NOTE: for my plugin
	let g:deoplete#sources#clang_with_pch#include_pathes = ['/usr/local/Cellar/llvm/6.0.0/include']
	let g:deoplete#sources#clang_with_pch#pch_pathes     = []
else
	" WIP ubuntu
	let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-5.0/lib/libclang.so'
	let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-5.0/include/clang'
	if !exists("g:deoplete#sources#clang#flags")
		let g:deoplete#sources#clang#flags = []
	endif
endif

let g:ale_cmake_cmakelint_options = '--filter=-linelength'
let g:ale_python_pylint_options = '--disable=C0111,C0301' " C0111:missing-docstring C0301:max-line-length

if exists('g:sonictemplate_vim_template_dir')
	if isdirectory(expand('~/template'))
		let g:sonictemplate_vim_template_dir += ['~/template']
	endif
endif
