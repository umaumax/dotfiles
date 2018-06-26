if &rtp =~ 'vim-submode'
	" for no space line join
	call submode#enter_with('join_line', 'n', '', 'gJ', 'gJ')
	call submode#map('join_line', 'n', '', 'J', 'gJ')

	nnoremap gw w
	nnoremap gW W
	call submode#enter_with('goto', 'n', '', 'gw', 'w')
	call submode#enter_with('goto', 'n', '', 'gW', 'W')
	call submode#map('goto', 'n', '', 'w', 'w')
	call submode#map('goto', 'n', '', 'W', 'W')
	call submode#map('goto', 'n', '', 'b', 'b')
	call submode#map('goto', 'n', '', 'e', 'e')
	call submode#map('goto', 'n', '', 'B', 'B')
	call submode#map('goto', 'n', '', 'E', 'E')

	" jump list i:next, o:prev
	nnoremap gi :bn<CR>
	nnoremap go :bN<CR>
	call submode#enter_with('goto_buffer', 'n', '', 'gi', ':bn<CR>')
	call submode#enter_with('goto_buffer', 'n', '', 'go', ':bN<CR>')
	call submode#map('goto_buffer', 'n', '', 'i', ':bn<CR>')
	call submode#map('goto_buffer', 'n', '', 'gi', ':bn<CR>')
	call submode#map('goto_buffer', 'n', '', 'o', ':bN<CR>')
	call submode#map('goto_buffer', 'n', '', 'go', ':bN<CR>')

	" NOTE: <C-i>はtabになるため，直接取得不可能
	call submode#enter_with('jump-motions', 'n', '', '<C-o>', '<C-o>')
	call submode#map('jump-motions', 'n', '', '<C-o>', '<C-o>')
	call submode#map('jump-motions', 'n', '', 'o', '<C-o>')
	call submode#map('jump-motions', 'n', '', 'i', '<C-i>')
endif
