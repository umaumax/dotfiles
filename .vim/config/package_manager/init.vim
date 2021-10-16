" NOTE: auto download vim-plug
let b:plug_install_flag=v:false
if has('vim_starting')
  if !filereadable(expand('~/.vim/autoload/plug.vim'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/autoload')
    call system('curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    echo '[HINT] install vim plugins'
    let b:plug_install_flag=v:true
  end
endif

function! s:vim_enter_draw_post()
  let vim_enter_draw_post_view = winsaveview()
  doautocmd <nomodeline> User VimEnterDrawPost
  silent call winrestview(vim_enter_draw_post_view)
endfunction
nnoremap <silent> <Plug>(vim_enter_draw_post) :call <SID>vim_enter_draw_post()<CR>

augroup vim-enter-draw-post
  autocmd!
  autocmd VimEnter * call feedkeys("\<Plug>(vim_enter_draw_post)")
augroup END

let specialized_plugin_file_names=['git-rebase-todo', 'COMMIT_EDITMSG']
for name in specialized_plugin_file_names
  if expand('%:t') ==# name
    call plug#begin('~/.vim/plugged')
    command! -nargs=+ -bar LazyPlug Plug <args>
    runtime! config/plugin/specialized-common/*.vim
    execute "runtime! config/plugin/".name."/*.vim"
    call plug#end()
    finish
  endif
endfor

let g:lazy_plug_map={}
function! LazyPlug(repo, ...)
  let opts = get(a:000, 0, {})
  if !has_key(opts, 'on') && !has_key(opts, 'for')
    let opts=extend(opts, { 'on': [], 'for': []})
  endif
  let g:lazy_plug_map[split(a:repo,'/')[1]]=v:false
  call plug#(a:repo, opts)
endfunction

command! -nargs=+ -bar LazyPlug call LazyPlug(<args>)
command! LazyPlugLoad call <SID>lazy_plug_load()

function! s:lazy_plug_load()
  for key in keys(g:lazy_plug_map)
    if (g:lazy_plug_map[key]==v:false)
      call plug#load(key)
      let g:lazy_plug_map[key]=v:true
    endif
  endfor
endfunction

augroup lazy_load_after_vim_enter
  autocmd!
  autocmd User VimEnterDrawPost ++once call <SID>lazy_plug_load()
augroup END

call plug#begin(g:plug_home)
if has('nvim')
  " To detect if &rtp =~ 'vim-submode', load this at first.
  " this plugin is used for consecutive shortcut input
  Plug 'kana/vim-submode'
endif
runtime! config/plugin/*.vim
call plug#end()

if b:plug_install_flag == v:true
  PlugInstall
endif
