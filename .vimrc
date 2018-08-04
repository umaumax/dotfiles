" disable plugins
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1

if !has('gui_running')
	let g:loaded_matchparen = 1
endif

if has('nvim')
	set runtimepath+=~/.vim
else
	source $VIMRUNTIME/defaults.vim
endif
" old seting?
" filetype off | filetype plugin indent off " temporarily disable
" set nocompatible

" NOTE: doctor mode
" VIM_DOCTOR='on' vim
" no plug plugin mode
" VIM_FAST_MODE='on' vim

" let g:colorscheme = 'default'
let g:colorscheme = 'molokai'
" let g:colorscheme = 'moonfly'
" let g:colorscheme = 'tender' " difficult to see visual mode

let s:user_local_vimrc = expand('~/.local.vimrc')

" [vimエディタが（勝手に）作成する、一見、不要に見えるファイルが何をしているか — 名無しのvim使い]( http://nanasi.jp/articles/howto/file/seemingly-unneeded-file.html#id8 )
let g:tempfiledir = expand('~/.vim/tmp')
if !isdirectory(g:tempfiledir)
	call mkdir(g:tempfiledir, "p")
endif

" TODO: add cmds and description for install
" \'yapf':'pip install yapf',
let s:doctor_map={
			\'autopep8':'pip install autopep8',
			\'clang':'',
			\'cmake-format':'pip install cmake_format',
			\'cmigemo':'brew install cmigemo || sudo apt install cmigemo',
			\'clang-format':'',
			\'files':'go get -u github.com/mattn/files',
			\'git':'',
			\'go':'',
			\'gofmt':'',
			\'golfix':'go get -u github.com/umaumax/golfix',
			\'googler':'brew install googler || sudo apt-get install googler',
			\'jsonlint':'npm install jsonlint -g',
			\'look':'maybe default command',
			\'npm':'install node',
			\'pylint':'pip install pylint',
			\'s':'brew install s-search',
			\'trans':'brew install translate-shell || sudo apt-get install translate-shell',
			\'shellcheck':'apt-get install shellcheck || brew install shellcheck',
			\'shfmt':'go get -u mvdan.cc/sh/cmd/shfmt',
			\'vint':'pip install vim-vint',
			\}
let s:no_cmd_map={}
function! Doctor(cmd, description)
	if !executable(a:cmd)
		if $VIM_DOCTOR != ''
			echomsg 'Require:[' . a:cmd . '] for [' . a:description . ']'
			echomsg '    ' . s:doctor_map[a:cmd]
		endif
		if !has_key(s:no_cmd_map,a:cmd)
			let s:no_cmd_map[a:cmd]=''
		endif
		let s:no_cmd_map[a:cmd].=a:description.' '
		return 0
	endif
	return 1
endfunction
function! s:print_doctor_result()
	for s:key in keys(s:no_cmd_map)
		let s:val = s:no_cmd_map[s:key]
		echomsg 'Require:[' . s:key . '] for [' . s:val . ']'
		echomsg '    ' . s:doctor_map[s:key]
	endfor
endfunction
command! Doctor call <SID>print_doctor_result()

augroup vim-enter-draw-post
	autocmd VimEnter * call feedkeys(":doautocmd <nomodeline> User VimEnterDrawPost\<CR>",'n')
augroup END

" save cwd
let s:cwd = getcwd()
if $VIM_FAST_MODE == ''
	runtime! config/package_manager/*.vim
endif
command! Enhance :let $VIM_FAST_MODE='' | source ~/.vimrc
runtime! config/setting-start/*.vim
runtime! config/setting/*.vim
" load cwd
if isdirectory(s:cwd)
	execute("lcd " . s:cwd)
endif

function! s:filepathjoin(a,b)
	return substitute(a:a,'/$','','').'/'.a:b
endfunction

" load local vimrc
if filereadable(s:user_local_vimrc) | execute 'source' s:user_local_vimrc | endif
let s:local_vimrc=s:filepathjoin(expand('%:p:h'), '.local.vimrc')
" NOTE: fileが存在するディレクトリのlocal vimrc
if s:local_vimrc != s:user_local_vimrc && filereadable(s:local_vimrc) | execute 'source' s:local_vimrc | endif
if $VIM_PROJECT_ROOT != ''
	let s:vim_project_root_local_vimrc = s:filepathjoin($VIM_PROJECT_ROOT, '.local.vimrc')
	if s:vim_project_root_local_vimrc != s:user_local_vimrc && s:vim_project_root_local_vimrc != s:local_vimrc && filereadable(s:vim_project_root_local_vimrc)
		execute 'source' s:vim_project_root_local_vimrc
	endif
endif

" e.g. .local.vimrc
" let g:ale_cpp_clang_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_clangcheck_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_clangtidy_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_gcc_options = "-std=c++11 -Wall  -I/usr/local/Cellar/llvm/6.0.0/include"
" manly for colorscheme
" runtime! config/setting-end/*.vim

" ################ playground ######################
" ################ playground ######################
