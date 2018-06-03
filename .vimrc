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

" save cwd
let s:cwd = getcwd()
if $VIM_FAST_MODE == ''
	runtime! config/package_manager/*.vim
endif
runtime! config/setting-start/*.vim
runtime! config/setting/*.vim
if filereadable(s:local_vimrc) | execute 'source' s:local_vimrc | endif
" load cwd
execute("lcd " . s:cwd)
" manly for colorscheme
runtime! config/setting-end/*.vim

" ################ playground ######################

" ################ playground ######################
