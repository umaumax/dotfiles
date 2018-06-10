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

let s:local_vimrc = expand('~/.local.vimrc')

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
			\'cmigemo':'brew install cmigemo || sudo apt install cmigemo',
			\'clang-format':'',
			\'files':'go get -u github.com/mattn/files',
			\'git':'',
			\'go':'',
			\'gofmt':'',
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

" save cwd
let s:cwd = getcwd()
if $VIM_FAST_MODE == ''
	runtime! config/package_manager/*.vim
endif
command! Enhance :let $VIM_FAST_MODE='' | source ~/.vimrc
runtime! config/setting-start/*.vim
runtime! config/setting/*.vim
if filereadable(s:local_vimrc) | execute 'source' s:local_vimrc | endif
" load cwd
execute("lcd " . s:cwd)
" manly for colorscheme
" runtime! config/setting-end/*.vim

" ################ playground ######################

" ################ playground ######################
