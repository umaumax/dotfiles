" NOTE: this treesitter setting must be called after plug#end()
if &rtp !~ 'nvim-treesitter'
  finish
endif

let s:current_filepath=expand('<sfile>:p:h')

function! s:luafile_load(filename)
  execute 'luafile '.s:current_filepath.'/'.a:filename
endfunction

call s:luafile_load('nvim-treesitter.lua')
