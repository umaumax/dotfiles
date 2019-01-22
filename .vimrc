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

let g:plug_home=$HOME."/.vim/plugged"

function! s:disable_opening_file()
	for pattern in ['tu[^.]*', 'zip', 'tar.gz', 'gz', 'jp[e]g', 'png', 'exe', 'pdf', 'pch']
		if expand('%:e') =~ pattern
			" NOTE: below command quit force even if multi buffer was opening
			echom "[auto closed] Don't open ".expand('%:S')."!\n"
			q!
			return
		endif
	endfor
	" NOTE: disable executable file open
	if expand('%:e') == '' && system('type '.expand('%:p:S').' >/dev/null 2>&1; echo $?')==0
		" NOTE: maybe you can use file and compare (e.g. mac os x 'Mach-O 64-bit executable x86_64')
		let filesize=system('du -k '.expand('%:p:S').' | cut -f1')
		echom filesize
		let maxsize_k=16
		if filesize > maxsize_k
			echom "[auto closed] Don't open executable (more than ".filesize."k size)".expand('%:S')."!\n"
			q!
		endif
		return
	endif
endfunction
" NOTE: disable open
augroup disable_opening_file_group
	autocmd!
	autocmd BufEnter * call <SID>disable_opening_file()
augroup END

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
if $VIM_FAST_MODE == ''
	if &readonly || $OS == "Windows_NT"
		let $VIM_FAST_MODE='on'
	endif

	let full_path = expand("%:p")
	" skip tmp file
	for pattern in ['^/tmp/.*$', '^/var/.*$', '^/private/.*$']
		if full_path =~ pattern
			let $VIM_FAST_MODE='on'
			break
		endif
	endfor
endif

" let g:colorscheme = 'default'
let g:colorscheme = 'molokai'
" let g:colorscheme = 'moonfly'
" let g:colorscheme = 'tender' " difficult to see visual mode

let s:user_local_vimrc = expand('~/.local.vimrc')
let g:vim_edit_log_path = expand('~/.vim_edit_log')

" [vimエディタが（勝手に）作成する、一見、不要に見えるファイルが何をしているか — 名無しのvim使い]( http://nanasi.jp/articles/howto/file/seemingly-unneeded-file.html#id8 )
let g:tempfiledir = expand('~/.vim/tmp')
if !isdirectory(g:tempfiledir)
	call mkdir(g:tempfiledir, "p")
endif

" TODO: add cmds and description for install
" \'yapf':'pip install yapf',
let s:doctor_map={
			\'ag':           'brew install ag || sudo apt install silversearcher-ag',
			\'autopep8':     'pip install autopep8',
			\'clang':        '',
			\'cmake-format': 'pip install https://github.com/umaumax/cmake_format/archive/master.tar.gz (pip install cmake_format)',
			\'cmakelint':    'pip install cmakelint',
			\'cmigemo':      'brew install cmigemo || sudo apt install cmigemo',
			\'clang-format': '',
			\'files':        'go get -u github.com/mattn/files',
			\'flake8':       'pip install flake8',
			\'git':          'brew install git || sudo apt-get install git',
			\'go':           'brew install go || sudo apt-get install go',
			\'gofmt':        '',
			\'golfix':       'go get -u github.com/umaumax/golfix',
			\'googler':      'brew install googler || sudo apt-get install googler',
			\'jsonlint':     'npm install jsonlint -g',
			\'look':         'maybe default command',
			\'npm':          'install node',
			\'pylint':       'pip install pylint',
			\'pyls':         'pip install python-language-server',
			\'s':            'brew install s-search',
			\'tig':          'brew install tig || build tig your self ( https://github.com/jonas/tig/releases )',
			\'trans':        'brew install translate-shell || sudo apt-get install translate-shell',
			\'textlint':     'use npm to install',
			\'shellcheck':   'apt-get install shellcheck || brew install shellcheck',
			\'shfmt':        'go get -u mvdan.cc/sh/cmd/shfmt',
			\'vint':         'pip install vim-vint',
			\}
let s:no_cmd_map={}
function! Doctor(cmd, description)
	if !executable(a:cmd)
		if $VIM_DOCTOR != ''
			echomsg 'Require:[' . a:cmd . '] for [' . a:description . ']'
			echomsg '    ' . get(s:doctor_map, a:cmd, '[no description]')
		endif
		if !has_key(s:no_cmd_map,a:cmd)
			let s:no_cmd_map[a:cmd]=a:description
		else
			let s:no_cmd_map[a:cmd].=', '.a:description
		endif
		return 0
	endif
	return 1
endfunction
function! s:print_doctor_result()
	for s:key in keys(s:no_cmd_map)
		let s:val = s:no_cmd_map[s:key]
		echomsg 'Require:[' . s:key . '] for [' . s:val . ']'
		echomsg '    ' . get(s:doctor_map, s:key, '[no description]')
	endfor
endfunction
command! Doctor call <SID>print_doctor_result()

" NOTE: <Leader> must be set before use
let mapleader = "\<Space>"

" save cwd
let s:cwd = getcwd()
if $VIM_FAST_MODE == '' || $VIM_FAST_MODE == 'off'
	runtime! config/package_manager/*.vim
endif
" NOTE: Enhanceする際に，VimEnter系のイベントが正常に発火するかどうかが未確認
command! Enhance :let $VIM_FAST_MODE='off' | source ~/.vimrc | call feedkeys("\<Plug>(vim_enter_draw_post)")
runtime! config/setting-start/*.vim
runtime! config/setting/*.vim
runtime! config/setting-end/*.vim
" load cwd
if isdirectory(s:cwd)
	execute("lcd " . s:cwd)
endif

function! s:filepathjoin(a,b)
	return substitute(a:a,'/$','','').'/'.a:b
endfunction

" FYI: [local\_vimrc の焼き直し localrc\.vim 書いた \- 永遠に未完成]( https://thinca.hatenablog.com/entry/20110108/1294427418 )
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

" NOTE: tab sballしたときのvimにsetされている状態がコピーされるような挙動のため，最後に行うこと
" NOTE: buffers -> tabs
" NOTE: bufnr() contains tabs
" NOTE: VimEnter前はtabpagenr('$') == 1 (always)
function! s:buffer_to_tab()
	let filename=expand('%')
	let full_path = expand("%:p")
	" skip tmp file
	for pattern in ['^/tmp/.*$', '^/var/.*$', '^/private/.*$']
		if full_path =~ pattern
			return
		endif
	endfor
	" NOTE: :PlugInstall or :PlugUpdate or :PlugUpgrade -> [Plugins]
	if filename != '' && filename != '[Plugins]' && tabpagenr('$') == 1 && winnr('$') == 1 && bufnr('$') >= 2
		:tab sball
		" NOTE: to kick autocmd
		call feedkeys(":tabdo e!\<CR>:tabfirst\<CR>", 'n')
	endif
endfunction
augroup buffer_to_tab_group
	autocmd!
	autocmd User VimEnterDrawPost call <SID>buffer_to_tab()
augroup END

" NOTE: only use some plugins for man
if $VIM_MAN_FLAG==1
	set ft=neoman
	" NOTE:
	" 詳しい理由は不明だが，おそらくcolorscheme変更処理によって，syntaxが反映されないので，defalut
	" man syntaxを利用する
	set syntax=man
	" NOTE: to adopt e.g. vimdiff(1)
	call plug#begin(g:plug_home)
	" NOTE: both vim and nvim is available, but maybe vim is better (because of no readonly warning message)
	Plug 'nhooyr/neoman.vim'
	call plug#end()
	nnoremap <silent> K  :execute  ":Nman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
	nnoremap <silent> ss :execute ":Snman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
	nnoremap <silent> sv :execute ":Vnman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
	nnoremap <silent> st :execute ":Tnman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
	set iskeyword+=(,)
endif


" e.g. .local.vimrc
" let g:ale_cpp_clang_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_clangcheck_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_clangtidy_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_gcc_options = "-std=c++11 -Wall  -I/usr/local/Cellar/llvm/6.0.0/include"

" ################ playground ######################
" ################ playground ######################
