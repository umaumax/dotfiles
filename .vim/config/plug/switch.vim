" for toggle word under cursor
" :Switch
Plug 'AndrewRadev/switch.vim'
let g:switch_custom_definitions =
			\ [
			\   ['foo', 'bar', 'baz'],
			\   ['x', 'y', 'z'],
			\   ['X', 'Y', 'Z'],
			\ ]
function! s:toggle(value)
	let opt= a:value >= 0 ? {} : {'reverse': a:value}
	if !switch#Switch(opt)
	endif
endfunction
nnoremap <C-a> :call <SID>toggle(1)<CR>
nnoremap <C-s> :call <SID>toggle(1)<CR>
nnoremap <C-x> :call <SID>toggle(-1)<CR>
nnoremap + :call <SID>toggle(1)<CR>
nnoremap - :call <SID>toggle(-1)<CR>
