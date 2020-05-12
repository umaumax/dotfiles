" for toggle word under cursor
" :Switch
let g:switch_mapping = ""
LazyPlug 'AndrewRadev/switch.vim'

" NOTE: if you switch rules between filetypes use autocmd
" [AndrewRadev/switch\.vim: A simple Vim plugin to switch segments of text with predefined replacements]( https://github.com/AndrewRadev/switch.vim/blob/master/README.md#dict-definitions )
let g:switch_custom_definitions =
      \ [
      \   ['~', "\$HOME"],
      \   'for c/c++ e.g. "xxx.hpp" <-> "xxx.h"',
      \   {'"\([a-zA-Z0-9/\-_.]*\).h"' : '"\1.hpp"', '"\([a-zA-Z0-9/\-_.]*\).hpp"' : '"\1.h"'},
      \   'for c/c++ e.g. #include "stdio" <-> #include <stdio>',
      \   {'#include <\([a-zA-Z0-9/\-_.]\+\)>' : '#include "\1"', '#include "\([a-zA-Z0-9/\-_.]\+\)"' : '#include <\1>'},
      \   'for general e.g. "xxx" '."<->"." 'xxx'",
      \   {"'\\([^']*\\)'" : '"\1"', '"\([^"]*\)"' : "'\\1'"},
      \   'for markdown e.g. ` '."<->"." ```",
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
      \   ['stop', 'start'],
      \   ['Stop', 'Start'],
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
      \   ['push_back', 'emplace_back'],
      \   ['True', 'False'],
      \   ['TRUE', 'FALSE'],
      \   ['true', 'false'],
      \   ['NE', 'EQ'],
      \   ['EXPECT', 'ASSERT'],
      \   ['let', 'var'],
      \   ['noremap', 'cnoremap', 'inoremap', 'nnoremap', 'vnoremap'],
      \   ['map', 'cmap', 'imap', 'nmap', 'vmap'],
      \   ['float', 'double'],
      \   ['else', 'elif', 'elseif'],
      \   ['typename', 'class'],
      \   ['begin', 'end'],
      \   ['first', 'second'],
      \   ['ifs', 'ofs'],
      \   'for shell e.g. $(ls) <-> `ls`',
      \   {'`\(.\+\)`' : '$(\1)', '$(\(.\+\))' : '`\1`'},
      \   'for c/c++ e.g. i++ <-> ++i',
      \   {'\(\w*\)++' : '++\1', '++\(\w*\)' : '\1++'},
      \   {'\(\w*\)--' : '--\1', '--\(\w*\)' : '\1--'},
      \   {
      \     "^[^']*'[^']*$" : {"'":'"'},
      \     "^[^\"]*\"[^\"]*$" : {'"':"'"},
      \   },
      \   'for rust e.g. &xxx <-> xxx',
      \   {'^&\([0-9a-zA-Z_]\+\)$' : '\1', '^\([0-9a-zA-Z_]\+\)$' : '\&\1'},
      \ ]

" NOTE: drop comment
call filter(g:switch_custom_definitions, "type(v:val) != type('comment')")

function! s:toggle(value)
  let opt= a:value >= 0 ? {} : {'reverse': a:value}
  if !switch#Switch(opt)
    " NOTE: no error handling
  endif
endfunction

nnoremap <C-a> :call <SID>toggle(1)<CR>
vnoremap <C-s> :call <SID>toggle(1)<CR>
" nnoremap <C-x> :call <SID>toggle(-1)<CR>

" nnoremap + :call <SID>toggle(1)<CR>
" nnoremap - :call <SID>toggle(-1)<CR>
