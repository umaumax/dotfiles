" disable below plugins
let g:no_gvimrc_example=1
let g:no_vimrc_example=1

" disable loading below functions
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
let g:did_install_default_menus = 1
let g:skip_loading_mswin        = 1
let g:did_install_syntax_menu   = 1
if !has('gui_running')
  let g:loaded_matchparen = 1
endif

if has('nvim')
  set runtimepath+=~/.vim
else
  source $VIMRUNTIME/defaults.vim
endif

set noswapfile
set nobackup

" NOTE: <Leader> must be set before use
let mapleader = "\<Space>"

" NOTE: please set colorscheme which has no support of nvim-treesitter (this value is used no nvim-treesitter)
let g:default_colorscheme = 'molokai'

let g:colorscheme = 'OceanicNext'
" let g:colorscheme = 'tokyonight'

let g:plug_home=$HOME.'/.vim/plugged'
let s:user_local_vimrc = expand('~/.local.vimrc')
let g:vim_edit_log_path = expand('~/.vim_edit_log')

" [vimエディタが（勝手に）作成する、一見、不要に見えるファイルが何をしているか — 名無しのvim使い]( http://nanasi.jp/articles/howto/file/seemingly-unneeded-file.html#id8 )
let g:tempfiledir = expand('~/.vim/tmp')
if !isdirectory(g:tempfiledir) " auto mkdir
  call mkdir(g:tempfiledir, 'p')
endif

runtime! config/init/*.vim

let s:cwd = getcwd()

if $VIM_FAST_MODE == '' || $VIM_FAST_MODE == 'off' || v:version < 800
  runtime! config/package_manager/*.vim
endif

command! Enhance :let $VIM_FAST_MODE='off' | source ~/.vimrc | call feedkeys("\<Plug>(vim_enter_draw_post)")

runtime! config/setting-start/*.vim
runtime! config/setting/*.vim
runtime! config/setting-end/*.vim

syntax on

" this treesitter setting must be called after plug#end()
if &rtp =~ 'nvim-treesitter'
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
  enable = true,              -- false will disable the whole extension
  disable = {},  -- list of language that will be disabled
  -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  -- Using this option may slow down your editor, and you may see some duplicate highlights.
  -- Instead of true it can also be a list of languages
  additional_vim_regex_highlighting = false,
  },
}
EOF
endif

if isdirectory(s:cwd)
  execute('lcd ' . s:cwd)
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
  let filename = expand('%')
  let full_path = expand('%:p')
  " skip tmp file
  for pattern in ['^/tmp/.*$', '^/var/.*$', '^/private/.*$']
    if full_path =~ pattern
      return
    endif
  endfor
  " NOTE: :PlugInstall or :PlugUpdate or :PlugUpgrade -> [Plugins]
  if filename != '' && filename != '[Plugins]' && winnr('$') == 1 && bufnr('$') >= 2
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
  set filetype=neoman
  " NOTE:
  " 詳しい理由は不明だが，おそらくcolorscheme変更処理によって，syntaxが反映されないので，defalut
  " man syntaxを利用する
  set syntax=man
  " NOTE: to adopt e.g. vimdiff(1)
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

" python path setting
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
