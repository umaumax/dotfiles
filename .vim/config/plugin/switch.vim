" for toggle word under cursor
" :Switch
Plug 'AndrewRadev/switch.vim'
let g:switch_custom_definitions =
			\ [
			\   ['Nanoha', 'Fate', 'Hayate'],
			\   ['nanoha', 'fate', 'hayate'],
			\   ['foo', 'bar', 'baz'],
			\   ['hoge', 'piyo'],
			\   ['Hoge', 'Piyo'],
			\   ['/', '*'],
			\   [':', ';'],
			\   [', ', ': '],
			\   ['.', ','],
			\   ['<', '>'],
			\   ['->', '.'],
			\   ['python', 'python2', 'python3'],
			\   ["'", '"', '`'],
			\   ['(', '[', '{'],
			\   [')', ']', '}'],
			\   ['get', 'set'],
			\   ['Get', 'Set'],
			\   ['x', 'y', 'z'],
			\   ['X', 'Y', 'Z'],
			\   ['int', 'int32_t', 'uint32_t'],
			\   ['long', 'int64_t', 'uint64_t', 'size_t'],
			\   ['cout', 'cerr'],
			\   ['let', 'var'],
			\   ['noremap', 'cnoremap', 'inoremap', 'nnoremap', 'vnoremap'],
			\   ['map', 'cmap', 'imap', 'nmap', 'vmap'],
			\   ['float', 'double'],
			\   {'#include <\(\k\+\)>' : '#include "\1"', '#include "\(\k\+\)"' : '#include <\1>'},
			\   {"'\\([^']\\+\\)'" : '"\1"', '"\([^"]\+\)"' : "'\\1'"},
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
