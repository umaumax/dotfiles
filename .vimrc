" disable below plugins
let g:no_gvimrc_example=1
let g:no_vimrc_example=1

" disable loading below functions
let g:loaded_2html_plugin       = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_rrhelper           = 1
let g:loaded_shada_plugin       = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1

if has('nvim')
  set runtimepath+=~/.vim
else
  source $VIMRUNTIME/defaults.vim
endif

set noswapfile
set nobackup

" NOTE: <Leader> must be set before use
let mapleader = "\<Space>"

" NOTE: please set colorscheme which has no support of nvim-treesitter (this value must be no dependency on nvim-treesitter)
let g:default_colorscheme = 'molokai'

let g:colorscheme = 'OceanicNext'
" let g:colorscheme = 'tokyonight'

let g:plug_home         = expand('~/.vim/plugged')
let s:user_local_vimrc  = expand('~/.local.vimrc')
let g:vim_edit_log_path = expand('~/.vim_edit_log')
let g:tempfiledir       = expand('~/.vim/tmp')
if !isdirectory(g:tempfiledir)
  call mkdir(g:tempfiledir, 'p')
endif

runtime! config/init/*.vim

" let s:cwd = getcwd()

if $VIM_FAST_MODE == '' || $VIM_FAST_MODE == 'off'
  runtime! config/package_manager/*.vim
endif

command! Enhance :let $VIM_FAST_MODE='off' | source ~/.vimrc | call feedkeys("\<Plug>(vim_enter_draw_post)")

runtime! config/setting-start/*.vim
runtime! config/setting/*.vim
syntax on
runtime! config/setting-end/*.vim

" if isdirectory(s:cwd)
" execute('lcd ' . s:cwd)
" endif

function! s:filepathjoin(a,b)
  return substitute(a:a,'/$','','').'/'.a:b
endfunction

function! s:load_local_vimrc()
  if filereadable(s:user_local_vimrc)
    execute 'source' s:user_local_vimrc
  endif
  let s:local_vimrc = s:filepathjoin(expand('%:p:h'), '.local.vimrc')
  if s:local_vimrc != s:user_local_vimrc && filereadable(s:local_vimrc)
    execute 'source' s:local_vimrc
  endif
  if $VIM_PROJECT_ROOT != ''
    let s:vim_project_root_local_vimrc = s:filepathjoin($VIM_PROJECT_ROOT, '.local.vimrc')
    if s:vim_project_root_local_vimrc != s:user_local_vimrc && s:vim_project_root_local_vimrc != s:local_vimrc && filereadable(s:vim_project_root_local_vimrc)
      execute 'source' s:vim_project_root_local_vimrc
    endif
  endif
endfunction
call s:load_local_vimrc()

if $VIM_MAN_FLAG==1
  set filetype=neoman
  set syntax=man
  call plug#begin(g:plug_home)
  " NOTE: both vim and nvim is available, but maybe vim is better (because of no readonly warning message)
  Plug 'umaumax/neoman.vim'
  call plug#end()
  function! s:man_map_setting()
    nnoremap <silent> K  :execute  ":Nman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
    nnoremap <silent> ss :execute ":Snman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
    nnoremap <silent> sv :execute ":Vnman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
    nnoremap <silent> st :execute ":Tnman ".substitute(substitute(expand('<cword>'),'\(.\+\)', '\L\1',''),'^.\{-,}\([a-zA-Z0-9_-]\+\(([0-9]*)\)\?\).\{-,}$', '\1','')<CR>
    set iskeyword+=(,)
  endfunction
  augroup man_map_setting_group
    autocmd!
    autocmd VimEnter * call <SID>man_map_setting()
    autocmd FileType man,neoman nunmap <buffer> q
  augroup END
endif

" python command path setting
let python2_path = substitute(system('which python2'), "\n", '', '')
let python3_path = substitute(system('which python3'), "\n", '', '')

let g:python_host_prog  = python2_path
let g:python3_host_prog = python3_path
let g:deoplete#sources#jedi#python_path = python3_path

" e.g. .local.vimrc
" let g:ale_cpp_clang_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_clangcheck_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_clangtidy_options = "-std=c++11 -Wall -I/usr/local/Cellar/llvm/6.0.0/include"
" let g:ale_cpp_gcc_options = "-std=c++11 -Wall  -I/usr/local/Cellar/llvm/6.0.0/include"

" ################ playground ######################
" call plug#begin(g:plug_home)
" Plug 'xxx/yyy'
" call plug#end()
" ################ playground ######################
