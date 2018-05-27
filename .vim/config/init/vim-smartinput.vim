" auto paired char insertion
" for alternative for 'kana/vim-smartinput'
" [Vim 8\.0 Advent Calendar 13 日目 undo を分割せずにカーソルを移動 \- Qiita]( https://qiita.com/thinca/items/792f3a92930d79402d2c )
" s: set
" inoremap {s {}<C-g>U<Left>
" inoremap [s []<C-g>U<Left>
" inoremap (s ()<C-g>U<Left>
" inoremap "s ""<C-g>U<Left>
" inoremap 's ''<C-g>U<Left>
" inoremap <s <><C-g>U<Left>
" 
" inoremap {} {}<C-g>U<Left>
" inoremap [] []<C-g>U<Left>
" inoremap () ()<C-g>U<Left>
" inoremap "" ""<C-g>U<Left>
" inoremap '' ''<C-g>U<Left>
" inoremap <> <><C-g>U<Left>

" [vim\-smartinput/smartinput\.txt at master · kana/vim\-smartinput]( https://github.com/kana/vim-smartinput/blob/master/doc/smartinput.txt )
" [vim\-smartinput のスマートか分からない設定 \- はやくプログラムになりたい]( https://rhysd.hatenablog.com/entry/20121017/1350444269 )
" orignal trigger <BS>, <CR>
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
" BUG: (sample)(test) -> ( sample)(test )
call smartinput#define_rule({
			\   'at'    : '(\%#.*)',
			\   'char'  : '<Space>',
			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '(\\(.*\\))', '( \\1 )', ''))<CR>",
			\   })
call smartinput#define_rule({
			\   'at'    : '( \%#.* )',
			\   'char'  : '<BS>',
			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '( \\(.*\\) )', '(\\1)', ''))<CR>",
			\   })
" no bug but, only for no string between ()
" call smartinput#define_rule({
" 			\   'at'    : '(\%#)',
" 			\   'char'  : '<Space>',
" 			\   'input' : '<Space><Space><Left>',
" 			\   })
" call smartinput#define_rule({
" 			\   'at'    : '( \%# )',
" 			\   'char'  : '<BS>',
" 			\   'input' : '<Del><BS>',
" 			\   })

" override default rules
for s:set in ['()','\[\]','{}','``','``````','""',"''"]
	let s:left=s:set[:len(s:set)/2-1]
	let s:right=s:set[len(s:set)/2:]
	call smartinput#define_rule({'at': s:left.'\%#'.s:right, 'char': '<BS>', 'input': '<BS>'})
	call smartinput#define_rule({'at': s:set.'\%#',          'char': '<BS>', 'input': '<BS>'})
endfor
call smartinput#define_rule({'at': '```\%#', 'char': '<CR>', 'input': '<CR><CR>'})
" 改行時に行末のスペース除去
call smartinput#define_rule({
			\   'at': '\s\+\%#',
			\   'char': '<CR>',
			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
			\   })

" NOTE: 置き換え時に特殊キーに注意
" '\<': 単語境界でなければならない
let s:replace_map = {
			\ '||': ['or', 'dp', 'dpp'],
			\ '&&': ['and'],
			\ '~/': ['hd'],
			\ '~/.': ['hdd'],
			\ 'boost::': ['b::','b;;'],
			\ 'std::': ['s::','s;;'],
			\ '=~': ['req','regeq'],
			\
			\ '!': ['ex'],
			\ '"': ['dq'],
			\ '#': ['sp', 'shar', 'sharp'],
			\ '$': ['dl', 'doll', 'doller'],
			\ '%': ['pc', 'perc', 'percent', 'rem'],
			\ '&': ['amp', 'ad', 'ampersand'],
			\ "'": ['sq'],
			\ '(': ['pt', 'pts', 'pa', 'pas', 'parenth'],
			\ ')': [      'pte',       'pae'],
			\ '=': ['eq', 'equal'],
			\ '-': ['mn', 'hy', 'minus', 'hyphen'],
			\ '~': ['ti', 'tl', 'tilde', 'home'],
			\ '^': ['ha', 'hat'],
			\ '| ': ['pp', 'pipe'],
			\ '\': ['bsl', 'backs'],
			\ '_': ['un', 'ub'],
			\ '{': ['br', 'brs', 'mp' ,'mps','brace'],
			\ '}': [      'bre',       'mpe', 'brace'],
			\ '[': ['sb', 'sbs', 'ary', 'arys'],
			\ ']': [      'sbe',        'arye'],
			\ '[[': ['dsb', 'dsbs', 'shif', 'shifs'],
			\ ']]': [       'dsbe',         'shife'],
			\ '`': ['bq'],
			\ '```': ['tbq'],
			\ '@': ['att'],
			\ '*': ['ast', 'asterisk'],
			\ '+': ['pl', 'plus'],
			\ ';': ['sc'],
			\ ':': ['cl'],
			\ '::': ['dcl'],
			\ '?': ['qu'],
			\ '/': ['sl', 'rd', 'di', 'division'],
			\ '<': ['lt'],
			\ '>': ['gt'],
			\ '<= ': ['le'],
			\ '>= ': ['ge'],
			\ '.': ['\<d', 'dot', 'pe', 'period'],
			\ ',': ['cm', 'comma'],
			\ '->': ['po', 'pointer'],
			\
			\ 'void': ['vd'],
			\ 'signed': ['si'],
			\ 'unsigned': ['uns'],
			\ 'func': ['fu'],
			\ 'function': ['funct'],
			\ 'endfunction': ['endf'],
			\ 'define': ['defi'],
			\ 'include': ['inclu'],
			\ 'example': ['exa'],
			\ 'sample': ['sam'],
			\ 'replace': ['rep'],
			\ }
" 			\ '': [''],
" <Nul> = <C-Space>
" let s:gtrigger = '<Nul>'
let s:gtrigger = '<C-c>'
" let s:gtrigger = '<S-Down>'
for s:key in keys(s:replace_map)
	let s:srcs=s:replace_map[s:key]
	let s:dst=s:key
	for s:src in s:srcs
		let s:n = len(substitute(s:src,'^\\<', '', ''))
		let s:at = s:src
		let s:trigger = s:gtrigger
		" [vim\-smartinput/smartinput\.txt at master · kana/vim\-smartinput]( https://github.com/kana/vim-smartinput/blob/master/doc/smartinput.txt#L221 )
" 		" 		for s:mode in split('i.:./.?', '.')
"  		for s:mode in split('i', '.')
" 			call smartinput#map_to_trigger(s:mode, s:trigger, s:trigger, s:trigger)
" 		endfor
		call smartinput#define_rule({'at': s:at.'\%#', 'char': s:trigger, 'input': repeat('<BS>', s:n).s:dst})
	endfor
endfor
" NOTE:登録済のトリガを大量に登録すると反応しないので注意
call smartinput#map_to_trigger('i', s:gtrigger, s:gtrigger, s:gtrigger)
" call smartinput#map_to_trigger('i', s:gtrigger, s:gtrigger, '<C-i>')

" " no lib command
" " b;; -> boost::
" " s;; -> std::
" " d;; -> detail::
" augroup cpp-namespace
" 	autocmd!
" 	autocmd FileType cpp inoremap <buffer><expr>; <SID>expand_namespace(';')
" 	autocmd FileType cpp inoremap <buffer><expr>: <SID>expand_namespace(':')
" augroup END
" function! s:expand_namespace(char)
" 	let s = getline('.')[0:col('.')-1]
" 
" 	if s =~# '\<b:'
" 		return "\<BS>oost::"
" 	elseif s =~# '\<s:'
" 		return "\<BS>td::"
" 	elseif s =~# '\<d:'
" 		return "\<BS>etail::"
" 	endif
" 	if s =~# '\<b;'
" 		return "\<BS>oost::"
" 	elseif s =~# '\<s;'
" 		return "\<BS>td::"
" 	elseif s =~# '\<d;'
" 		return "\<BS>etail::"
" 	endif
" 	" 	if s =~# '\<b;$'
" 	" 		return "\<BS>oost::"
" 	" 	elseif s =~# '\<s;$'
" 	" 		return "\<BS>td::"
" 	" 	elseif s =~# '\<d;$'
" 	" 		return "\<BS>etail::"
" 	" 	else
" 	" 		return ';'
" 	" 	endif
" 	return a:char
" endfunction
