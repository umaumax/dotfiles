if $VIM_PROJECT_ROOT == ''
	finish
endif

let s:wd=expand('%:p:h')

function! SymbolicLink(file)
	let orig_path=$VIM_PROJECT_ROOT.'/'.a:file
	let sym_path=s:wd.'/'.a:file
	if filereadable(orig_path) && !filereadable(sym_path)
		let cmd='ln -sf '.orig_path.' '.sym_path
		echom cmd
		call system(cmd)
	endif
endfunction

augroup cpp_file_event
	autocmd!
	autocmd Filetype cpp :call SymbolicLink('.clang-format')
augroup END

let s:include_dir=$VIM_PROJECT_ROOT.'/include'
let g:deoplete#sources#clang#flags += ['-I'.s:include_dir]

let s:options='-std=c++11 -Wall -I'.s:include_dir
let g:ale_cpp_clang_options = s:options
let g:ale_cpp_gcc_options = s:options
