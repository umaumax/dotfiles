" for toggle word under cursor
" :Switch
Plug 'AndrewRadev/switch.vim'
" 			\   {"\\([^']\\|^\\)'\\([^']\\|$\\)" :   '\1"\2', '\([^"]\|^\)"\([^"]\|$\)'   : "\\1'\\2"},
let g:switch_custom_definitions =
			\ [
			\   {'#include <\([a-zA-Z0-9/\-_.]\+\)>' : '#include "\1"', '#include "\([a-zA-Z0-9/\-_.]\+\)"' : '#include <\1>'},
			\   {"'\\([^']*\\)'" : '"\1"', '"\([^"]*\)"' : "'\\1'"},
			\   {"\\([^`]\\|^\\)`\\([^`]\\|$\\)" : '\1```\2', '\([^`]\|^\)```\([^`]\|$\)' : "\\1`\\2"},
			\   ['Nanoha', 'Fate', 'Hayate'],
			\   ['nanoha', 'fate', 'hayate'],
			\   ['foo', 'bar', 'baz'],
			\   ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
			\   ['hoge', 'piyo'],
			\   ['Hoge', 'Piyo'],
			\   ['Plug', 'NeoBundle'],
			\   ['Left', 'Up', 'Right', 'Down'],
			\   ['ja', 'en'],
			\   ['on', 'off'],
			\   ['ON', 'OFF'],
			\   ['yes', 'no'],
			\   ['YES', 'NO'],
			\   ['pulic', 'private', 'protected'],
			\   ['""', "''"],
			\   {"\\([^']\\|^\\)'\\([^']\\|$\\)" : '\1"\2', '\([^"]\|^\)"\([^"]\|$\)' : "\\1'\\2"},
			\   [':', ';'],
			\   ['.', ','],
			\   ['<', '>'],
			\   ['->', '.'],
			\   ['python', 'python2', 'python3'],
			\   ['(', '[', '{'],
			\   [')', ']', '}'],
			\   ['get', 'set'],
			\   ['Get', 'Set'],
			\   ['x', 'y', 'z'],
			\   ['X', 'Y', 'Z'],
			\   ['int', 'int32_t', 'uint32_t'],
			\   ['long', 'int64_t', 'uint64_t', 'size_t'],
			\   ['dynamic_cast', 'static_cast', 'const_cast', 'reinterpret_cast'],
			\   ['cout', 'cerr', 'clog'],
			\   ['let', 'var'],
			\   ['noremap', 'cnoremap', 'inoremap', 'nnoremap', 'vnoremap'],
			\   ['map', 'cmap', 'imap', 'nmap', 'vmap'],
			\   ['float', 'double'],
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
