" NOTE: auto download vim-plug
let b:plug_install_flag=0
if has('vim_starting')
  "   if !isdirectory(expand('~/.vim/plugged/vim-plug'))
  "     echo 'install vim-plug...'
  "     call system('mkdir -p ~/.vim/plugged/vim-plug')
  "     call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
  "   end
  "   if isdirectory(expand('~/.vim/plugged/vim-plug'))
  "     set rtp+=~/.vim/plugged/vim-plug
  "   endif
  if !filereadable(expand('~/.vim/autoload/plug.vim'))
    echo 'install vim-plug...'
    call system('mkdir -p ~/.vim/autoload')
    call system('curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    echo '[HINT] install vim plugins'
    let b:plug_install_flag=1
  end
endif

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

" ----

" NOTE: auto PlugInstall detecter
" NOTE: 一部修正しないと動かない
" [おい、NeoBundle もいいけど vim\-plug 使えよ \- Qiita]( https://qiita.com/b4b4r07/items/fa9c8cceb321edea5da0 )
function! s:plug_check_installation()
  if empty(g:plugs)
    return
  endif

  let list = []
  for [name, spec] in items(g:plugs)
    if !isdirectory(spec.dir)
      call add(list, spec.uri)
    endif
  endfor

  if len(list) > 0
    let unplugged = map(list, 'substitute(v:val, "^.*github\.com/\\(.*/.*\\)\.git$", "\\1", "g")')

    " Ask whether installing plugs like NeoBundle
    echomsg 'Not installed plugs: ' . string(unplugged)
    if confirm('Install plugs now?', "yes\nNo", 2) == 1
      PlugInstall
      " Close window for vim-plug
      silent! close
      " Restart vim
      " silent! !vim
      quit!
    endif
  endif
endfunction

function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
let g:lazy_plug_map={}
" NOTE: 主に'for'や'on'の指定がないものを対象とする
function! LazyPlug(repo, ...)
  let opts = get(a:000, 0, {})
  if !has_key(opts,'on')&& !has_key(opts,'for')
    let opts=extend(opts, { 'on': [], 'for': []})
  endif
  let g:lazy_plug_map[split(a:repo,'/')[1]]=0
  call plug#(a:repo, opts)
endfunction
command! -nargs=+ -bar LazyPlug call LazyPlug(<args>)
command! LazyPlugLoad call <SID>lazy_plug_load()
function! s:lazy_plug_load()
  for key in keys(g:lazy_plug_map)
    if (g:lazy_plug_map[key]==0)
      " NOTE: 可変長引数で文字列も指定可能
      call plug#load(key)
      let g:lazy_plug_map[key]=1
    endif
  endfor
endfunction
augroup load_after_vim_enter
  autocmd!
  autocmd User VimEnterDrawPost call <SID>lazy_plug_load()
        \| autocmd! load_after_vim_enter
augroup END

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

" NOTE: 適切にinstallされない?
" command! -nargs=0 PlugCheckInstall call <SID>plug_check_installation()
" augroup check-plug
"   autocmd!
"   autocmd User VimEnterDrawPost if !argc() | call <SID>plug_check_installation() | endif
" augroup END

call plug#begin(g:plug_home)
if has('nvim')
  " for consecutive shortcut input
  Plug 'kana/vim-submode'
endif
runtime! config/plugin/*.vim
call plug#end()
if b:plug_install_flag == 1
  PlugInstall
endif
