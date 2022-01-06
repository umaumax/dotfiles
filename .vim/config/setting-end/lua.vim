if &rtp !~ 'nvim-treesitter'
  finish
endif

let s:current_filepath=expand('<sfile>:p:h')

function! s:luafile_load(filename)
  execute 'luafile '.s:current_filepath.'/'.a:filename
endfunction

call s:luafile_load('setting.lua')

function! ShowPopup(title, lines)
  let b:title=a:title
  " You have to use g: because of creating new window buffer
  let g:lines=a:lines
  call s:luafile_load('popup.lua')
endfunction
