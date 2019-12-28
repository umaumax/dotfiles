" for toggle word under cursor
" :Switch
let g:switch_mapping = ""
LazyPlug 'AndrewRadev/switch.vim'
"       \   {"\\([^']\\|^\\)'\\([^']\\|$\\)" :   '\1"\2', '\([^"]\|^\)"\([^"]\|$\)'   : "\\1'\\2"},
" NOTE: you can't use $ as char \   ['~', "$HOME"],
let g:switch_custom_definitions =
      \ [
      \   {'"\([a-zA-Z0-9/\-_.]*\).h"' : '"\1.hpp"', '"\([a-zA-Z0-9/\-_.]*\).hpp"' : '"\1.h"'},
      \   {'#include <\([a-zA-Z0-9/\-_.]\+\)>' : '#include "\1"', '#include "\([a-zA-Z0-9/\-_.]\+\)"' : '#include <\1>'},
      \   {"'\\([^']*\\)'" : '"\1"', '"\([^"]*\)"' : "'\\1'"},
      \   {"\\([^`]\\|^\\)`\\([^`]\\|$\\)" : '\1```\2', '\([^`]\|^\)```\([^`]\|$\)' : "\\1`\\2"},
      \   ['Nanoha', 'Fate', 'Hayate'],
      \   ['nanoha', 'fate', 'hayate'],
      \   ['foo', 'bar', 'baz'],
      \   ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
      \   ['next', 'prev'],
      \   ['Next', 'Prev'],
      \   ['width', 'height'],
      \   ['Width', 'Height'],
      \   ['start', 'end'],
      \   ['Start', 'End'],
      \   ['top', 'bottom'],
      \   ['Top', 'Bottom'],
      \   ['hoge', 'piyo'],
      \   ['Hoge', 'Piyo'],
      \   ['Plug', 'NeoBundle'],
      \   ['Left', 'Up', 'Right', 'Down'],
      \   ['ja', 'en'],
      \   ['on', 'off'],
      \   ['ON', 'OFF'],
      \   ['yes', 'no'],
      \   ['YES', 'NO'],
      \   ['Input', 'Output'],
      \   ['input', 'output'],
      \   ['Read', 'Write'],
      \   ['read', 'write'],
      \   ['public', 'private', 'protected'],
      \   ['""', "''"],
      \   [':', ';'],
      \   ['.', ','],
      \   ['<<', '>>'],
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
      \   ['unique_ptr', 'shared_ptr'],
      \   ['make_unique', 'make_shared'],
      \   ['dynamic_cast', 'static_cast', 'const_cast', 'reinterpret_cast'],
      \   ['cout', 'cerr', 'clog'],
      \   ['let', 'var'],
      \   ['noremap', 'cnoremap', 'inoremap', 'nnoremap', 'vnoremap'],
      \   ['map', 'cmap', 'imap', 'nmap', 'vmap'],
      \   ['float', 'double'],
      \   ['else', 'elif', 'elseif'],
      \   ['typename', 'class'],
      \   ['begin', 'end'],
      \   ['first', 'second'],
      \   ['ifs', 'ofs'],
      \   {'`\(.\+\)`' : '$(\1)', '$(\(.\+\))' : '`\1`'},
      \   {'\(\w*\)++' : '++\1', '++\(\w*\)' : '\1++'},
      \   {'\(\w*\)--' : '--\1', '--\(\w*\)' : '\1--'},
      \   {
      \     "^[^']*'[^']*$" : {"'":'"'},
      \     "^[^\"]*\"[^\"]*$" : {'"':"'"},
      \   },
      \ ]
function! s:toggle(value)
  let opt= a:value >= 0 ? {} : {'reverse': a:value}
  if !switch#Switch(opt)
  endif
endfunction
nnoremap <C-a> :call <SID>toggle(1)<CR>
vnoremap <C-s> :call <SID>toggle(1)<CR>
" nnoremap <C-x> :call <SID>toggle(-1)<CR>

" nnoremap + :call <SID>toggle(1)<CR>
" nnoremap - :call <SID>toggle(-1)<CR>
