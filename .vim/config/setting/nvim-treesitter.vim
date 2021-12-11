" NOTE: this treesitter setting must be called after plug#end()
if &rtp !~ 'nvim-treesitter'
  finish
endif

function! s:luafile_load(filename)
  execute 'luafile ' .expand('~/dotfiles/.vim/config/setting/').a:filename
endfunction

call s:luafile_load('nvim-treesitter.lua')
