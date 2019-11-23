" name: window name
" command: 'open', 'close'
" lines: []
function! Window(name, command, lines)
  let l:current_buff = bufnr("%")
  let l:current_win = bufwinnr(bufnr("%"))
  let l:command=a:command
  let l:name=a:name

  " 指定したバッファ番号を有するウィンドウ番号を取得
  let w = bufwinnr(bufnr(l:name))
  if w != -1
    " execute w . 'wincmd w'
    " q " quit window: same meaning as below command
    " execute l:current_win . 'wincmd w'
    execute w . 'wincmd c'
    if l:command == 'close'
      return
    endif
  endif
  if l:command != 'open'
    echo "set command 'open' or 'close'"
    return
  endif

  " reset window
  "   undo
  let winheight_max = 8
  let winheight = len(a:lines) > winheight_max ? winheight_max : len(a:lines)
  execute 'botright' winheight 'new ' . l:name
  setlocal nobuflisted bufhidden=unload buftype=nofile
  call setline(1, a:lines)
  " エラーメッセージ用バッファのundo履歴を削除(エラーメッセージをundoで消去しないため)
  "   let save_undolevels = &l:undolevels
  "   setlocal undolevels=-1
  "   execute "normal! a \<BS>\<Esc>"
  "   setlocal nomodified
  "   let &l:undolevels = save_undolevels
  " エラーメッセージ用バッファは読み取り専用にしておく
  setlocal readonly

  " 現在のウィンドウに指定したバッファを開く
  " execute l:current_buff.'buffer'
  " 指定したwindowへ移動
  execute l:current_buff.'wincmd w'
  " main windowを閉じる前に，サブウィンドウを閉じるように
  augroup close_sub_window_before_main_window
    autocmd! * <buffer>
    execute 'au BufWinLeave <buffer> silent! call Window("' . l:name . '", "close", [])'
  augroup END
endfunction

" set splitbelow
