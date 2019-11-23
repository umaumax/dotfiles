let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$\|bin$\|build$\|CMakeFiles$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }

" [mattn/files: Fast file find]( https://github.com/mattn/files )
if Doctor('files', 'ctrlp.vim user command by files')
  let g:ctrlp_user_command = 'files -a -i "^(\\.git|\\.hg|\\.svn|_darcs|\\.bzr|\\.tags|.*\\.DS_Store|.*\\.so|.*\\.zip|.*\\.png|.*\\.jpg|.*\\.bag|build|bin|node_modules|vendor|CMakeFiles|install|devel)$" %s'
else
  let g:ctrlp_user_command = 'find %s -type f'
endif
if $HOME == expand('%:p:h')
  let g:ctrlp_user_command = 'find %s -type f -maxdepth 1'
endif

finish

" ################
" ################
" ################
" ################

" selecter
" C-P
Plug 'ctrlpvim/ctrlp.vim', {'on':['CtrlP','CtrlPGitLog','CtrlPRegister','CtrlPYankRegister']}
" :CtrlPGitLog
Plug 'kaneshin/ctrlp-git-log', {'on':['CtrlPGitLog']}
" NOTE: 選択したものをすぐにペーストする
" :CtrlPRegister
Plug 'mattn/ctrlp-register', {'on':['CtrlPRegister']}
" :CtrlPYankRegister
Plug 'umaumax/ctrlp-yank-register', {'on':['CtrlPYankRegister']}

" let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed']
let g:ctrlp_extensions = ['quickfix', 'git_log']
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:18'
let g:ctrlp_map = '<Nop>'

" [ctrlpvim/ctrlp\.vim: Active fork of kien/ctrlp\.vim—Fuzzy file, buffer, mru, tag, etc finder\.]( https://github.com/ctrlpvim/ctrlp.vim )
" 'c' - the directory of the current file.
nnoremap <C-p><C-p> :<C-u>let g:ctrlp_working_path_mode = 'c' \| :CtrlP<CR>
" 'a' - the directory of the current file, unless it is a subdirectory of the cwd
" 'r' - the nearest ancestor of the current file that contains one of these directories or files: .git .hg .svn .bzr _darcs
nnoremap <C-p><C-u> :<C-u>let g:ctrlp_working_path_mode = 'ra' \| :CtrlP<CR>
nnoremap <C-p><C-y> :<C-u>CtrlPYankRegister<CR>
" nnoremap <C-p><C-g> :<C-u>CtrlPQuickfix<CR>
" augroup ctrlp_key_setting
"   autocmd!
"   " TODO: 通常のquickfixのwindowを一時的に閉じたい
"   autocmd FileType qf nnoremap <C-p> :<C-u>CtrlPQuickfix<CR>
" augroup END
