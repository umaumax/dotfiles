let python2_path = substitute(system('which python2'), "\n", '', '')
let python3_path = substitute(system('which python3'), "\n", '', '')

let g:python_host_prog  = python2_path
let g:python3_host_prog = python3_path
let g:deoplete#sources#jedi#python_path = python3_path

" for 'zchee/deoplete-clang'
if has('mac')
	let g:deoplete#sources#clang#libclang_path = '/opt/homebrew/opt/llvm/lib/libclang.dylib'
	let g:deoplete#sources#clang#clang_header  = '/opt/homebrew/opt/llvm/include/clang'

	let g:deoplete#sources#clang#flags = [
				\'-I/opt/homebrew/Cellar/llvm/12.0.0_1/include',
				\'-stdlib=libc++',
				\ ]

	" NOTE: for my plugin
	let g:deoplete#sources#clang_with_pch#include_pathes = ['/opt/homebrew/Cellar/llvm/12.0.0_1/include']
	let g:deoplete#sources#clang_with_pch#pch_pathes     = []
else
	" WIP ubuntu
	let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-8/lib/libclang.so.1'
	let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-8/include/llvm'

	if !exists("g:deoplete#sources#clang#flags")
		let g:deoplete#sources#clang#flags = []
	endif
endif

let g:ale_cmake_cmakelint_options = '--filter=-linelength'
let g:ale_python_pylint_options = '--disable=C0111,C0301' " C0111:missing-docstring C0301:max-line-length
