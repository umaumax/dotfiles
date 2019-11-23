if &rtp =~ 'vim-submode'
  function! s:easy_submode_set(submode, modes, options, lhs, cmd)
    call submode#enter_with(a:submode, a:modes, a:options, a:lhs, a:cmd)
    call submode#map(a:submode, a:modes, a:options, a:lhs, a:cmd)
    call submode#map(a:submode, a:modes, a:options, a:lhs[1:], a:cmd)
  endfunction

  " NOTE: for no space line join
  call s:easy_submode_set('join_line', 'n', '', 'gJ', ":call J('gJ')<CR>")

  " NOTE: for only one space line join
  nnoremap J :call J()<CR>
  command! -range -nargs=0 J :<line1>,<line2>call J()
  command! -range -nargs=0 GJ :<line1>,<line2>call J('gJ')
  function J(...) range
    let join_cmd=get(a:, 1, 'J')
    for i in range(max([a:lastline-a:firstline,1]))
      call setline(line('.'), substitute(getline(line('.')), '\(.\{-}\)[ \t]*$', '\1', ''))
      call setline(line('.')+1, substitute(getline(line('.')+1), '^[ \t]*\(.*\)', '\1', ''))
      execute "normal! ".join_cmd
    endfor
  endfunction

  nnoremap gw w
  nnoremap gW W
  call s:easy_submode_set('goto', 'n', '', 'gw', 'w')
  call s:easy_submode_set('goto', 'n', '', 'gW', 'W')
  call submode#map('goto', 'n', '', 'b', 'b')
  call submode#map('goto', 'n', '', 'e', 'e')
  call submode#map('goto', 'n', '', 'B', 'B')
  call submode#map('goto', 'n', '', 'E', 'E')

  " jump list i:next, o:prev
  nnoremap gi :bn<CR>
  nnoremap go :bN<CR>
  call s:easy_submode_set('goto_buffer', 'n', '', 'gi', ':bn<CR>')
  call s:easy_submode_set('goto_buffer', 'n', '', 'go', ':bN<CR>')

  " NOTE: <C-i>はtabになるため，直接取得不可能
  call submode#enter_with('jump-motions', 'n', '', '<C-o>', '<C-o>')
  call submode#map('jump-motions', 'n', '', '<C-o>', '<C-o>')
  call submode#map('jump-motions', 'n', '', 'o', '<C-o>')
  call submode#map('jump-motions', 'n', '', 'i', '<C-i>')

  " 画面中心移動(1行ごと)
  nnoremap zj jzz
  nnoremap zk kzz
  call s:easy_submode_set('cursor-move', 'n', '', 'zj', 'jzz')
  call s:easy_submode_set('cursor-move', 'n', '', 'zk', 'kzz')

  " 画面中心移動(半画面ごと)
  nnoremap zu <C-u>
  nnoremap zd <C-d>
  call s:easy_submode_set('cursor-move', 'n', '', 'zu', '<C-u>')
  call s:easy_submode_set('cursor-move', 'n', '', 'zd', '<C-d>')

  " 画面中心移動(半画面ごと)
  nnoremap zb <C-b>
  nnoremap zf <C-f>
  call s:easy_submode_set('cursor-move', 'n', '', 'zf', '<C-b>')
  call s:easy_submode_set('cursor-move', 'n', '', 'zb', '<C-f>')

  if &rtp =~ 'comfortable-motion.vim'
    " NOTE: 急には停止できなくなるため，おすすめしない
    "     noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(60)<CR>
    "     noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-60)<CR>
    let g:comfortable_motion_scroll_down_key = "j"
    let g:comfortable_motion_scroll_up_key = "k"
    "     let g:comfortable_motion_interval = 1000.0 / 60
    let g:comfortable_motion_friction = 640.0
    let g:comfortable_motion_air_drag = 1.0
    let g:comfortable_motion_no_default_key_mappings = 1
    let g:comfortable_motion_impulse_multiplier = 2  " Feel free to increase/decrease this value.
    nnoremap <silent> <S-Down> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
    nnoremap <silent> <S-Up>   :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
    " NOTE: submode doesn't move properly
    nnoremap <silent> g<Down> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
    nnoremap <silent> g<Up> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>
  endif
endif
