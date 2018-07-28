if !(&rtp =~ 'vim-smartinput')
	finish
endif

let s:trigger_map={}
function! s:map_to_trigger(mode, trigger)
	let key=a:mode.':'.a:trigger
	if has_key(s:trigger_map, key)
		return
	endif
	let s:trigger_map[key]=1
	call smartinput#map_to_trigger(a:mode, a:trigger, a:trigger, a:trigger)
endfunction
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
" orignal trigger <BS>
" BUG: (sample)(test) -> ( sample)(test )
" call smartinput#define_rule({
" 			\   'at'    : '(\%#.*)',
" 			\   'char'  : '<Space>',
" 			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '(\\(.*\\))', '( \\1 )', ''))<CR>",
" 			\   })
" call smartinput#define_rule({
" 			\   'at'    : '( \%#.* )',
" 			\   'char'  : '<BS>',
" 			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '( \\(.*\\) )', '(\\1)', ''))<CR>",
" 			\   })
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

call s:map_to_trigger('i', '<Space>')
" call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
" NOTE: [対応する括弧等を入力する生活に疲れた\(Vim 編\) \- TIM Labs]( http://labs.timedia.co.jp/2012/09/vim-smartinput.html )
" >  競合時の優先度: 基本的には「 at がやたら長いものはそれだけ複雑な文脈の指定になっている」という前提で at の長いルールの優先度が高くなるように設定されています。
call smartinput#define_rule({
			\'at': '\[\[\%#\]\]', 'char': '<Space>', 'input': '<Space><Space><left>',
			\ 'filetype': ['sh','bash','zsh'],
			\})
call smartinput#define_rule({
			\'at': 'if \[\[\%#\]\]', 'char': '<Space>',
			\ 'input': "<Space><Space><Left><C-o>:call setline('.', substitute(getline('.'), '$', '; then', ''))<CR>",
			\ 'filetype': ['sh','bash','zsh'],
			\})

" override default rules
for s:set in ['()','\[\]','{}','``','``````','""',"''"]
	let s:left=s:set[:len(s:set)/2-1]
	let s:right=s:set[len(s:set)/2:]
	call smartinput#define_rule({'at': s:left.'\%#'.s:right, 'char': '<BS>', 'input': '<Right><BS>'})
	call smartinput#define_rule({'at': s:set.'\%#',          'char': '<BS>', 'input': '<BS>'})
endfor
call smartinput#define_rule({'at': '```\%#', 'char': '<CR>', 'input': '<CR><ESC>O'})

call s:map_to_trigger('i', '{')
" call smartinput#map_to_trigger('i', '{', '{', '{')

" NOTE: 下記の方法では相殺できなかったため，cloneして改変する方法に
" override default rule
" call smartinput#define_rule({'at': '\%#\_s*)', 'char': ')', 'input': ')'})
" call smartinput#define_rule({'at': '\%#\_s*\]', 'char': ']', 'input': ']'})
call s:map_to_trigger('i', ']')
call s:map_to_trigger('i', ')')
call s:map_to_trigger('i', '}')
" call smartinput#map_to_trigger('i', ']', ']', ']')
" call smartinput#map_to_trigger('i', ')', ')', ')')
" call smartinput#map_to_trigger('i', '}', '}', '}')
call smartinput#define_rule({'at': '\[\%#\]', 'char': ']', 'input': '<Right>'})
call smartinput#define_rule({'at': '(\%#)', 'char': ')', 'input': '<Right>'})
call smartinput#define_rule({'at': '{\%#}', 'char': '}', 'input': '<Right>'})

" 改行時に行末のスペース除去
call s:map_to_trigger('i', '<CR>')
" call smartinput#map_to_trigger('i', '<CR>', '<CR>', '<CR>')
call smartinput#define_rule({
			\   'at': '\s\+\%#',
			\   'char': '<CR>',
			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
			\   })
" 			\   'at': 'def.*[^:]\%#',
" 			\   'at': 'def.*\%#',
call smartinput#define_rule({
			\   'at': '\(for\|if\|def\|while\|else\|elif\).*[^:]\%#$',
			\   'char': '<CR>',
			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '$', ':', ''))<CR><C-o>$<CR>",
			\   'filetype': ['python'],
			\   })

" call smartinput#map_to_trigger('i', '\|', '\|', '\|')
call s:map_to_trigger('i', '\|')
call smartinput#define_rule({
			\   'at': '|\%#$',
			\   'char': '|',
			\   'input': "<BS>or",
			\   'filetype': ['python'],
			\   })

" call smartinput#map_to_trigger('i', '&', '&', '&')
call s:map_to_trigger('i', '&')
call smartinput#define_rule({
			\   'at': '&\%#$',
			\   'char': '&',
			\   'input': "<BS>and",
			\   'filetype': ['python'],
			\   })

call s:map_to_trigger('i', '>')
" call smartinput#map_to_trigger('i', '>', '>', '>')
" <>_ ===> <_>
call smartinput#define_rule({'at': '<\%#', 'char': '>', 'input': '><Left>'})

" NOTE: 置き換え時に特殊キーに注意
" '\<': 単語境界でなければならない
let s:replace_map = {
			\ '||': ['or', 'dp', 'dpp'],
			\ '&&': ['and'],
			\ '~/': ['hd'],
			\ '~/.': ['hdd'],
			\ 'boost::': ['b::','b;;'],
			\ 'std::': ['s::','s;;', 'std'],
			\ '=~': ['req','regeq'],
			\ "{'':''}<Left><Left><Left><Left><Left>": ['dict'],
			\ ''':': ['key'],
			\ ', ': ['arg'],
			\ 'ヽ(*゜д゜)ノ': ['kaiba'],
			\
			\ '!': ['ex'],
			\ '"': ['dq'],
			\ '""<Left>': ['ddq', 'str', 'string'],
			\ '#': ['sp', 'sha', 'shar', 'sharp'],
			\ '$': ['dl', 'doll', 'doller'],
			\ '%': ['pc', 'perc', 'percent', 'rem'],
			\ '&': ['amp', 'ad', 'ampersand'],
			\ "'": ['sq'],
			\ "''<Left>": ['dsq'],
			\ '(': ['pt', 'pts', 'pa', 'pas', 'parenth'],
			\ ')': [      'pte',       'pae'],
			\ '()<Left>': ['spt', 'spa', 'sparenth', 'kakko'],
			\ '=': ['eq', 'equal'],
			\ '==': ['deq', 'dequal'],
			\ '-': ['mn', 'hy', 'minus', 'hyphen'],
			\ '~': ['ti', 'tl', 'tilde', 'home','nyo'],
			\ '^': ['ha', 'hat'],
			\ '|': ['pi', 'pp', 'pipe'],
			\ '\': ['bs', 'bsl', 'backs'],
			\ '_': ['un', 'und', 'ub', 'us'],
			\ '{': ['br', 'brs', 'mp' ,'mps','brace'],
			\ '}': [      'bre',       'mpe', 'brace'],
			\ '{}<Left>': ['sbr', 'smp', 'sbrace', 'func'],
			\ '[': ['sb', 'sbs'],
			\ ']': [      'sbe'],
			\ '[]<Left>': ['ary'],
			\ '[[': ['dsb', 'dsbs'],
			\ ']]': [       'dsbe'],
			\ '[[  ]]<Left><Left><Left>': ['shif'],
			\ '`': ['bq'],
			\ '``<Left>': ['dbq'],
			\ '```': ['tbq', 'cd', 'code'],
			\ '@': ['at', 'att','atto', 'atm'],
			\ '*': ['ast', 'asterisk'],
			\ '+': ['pl', 'plus'],
			\ ';': ['sc'],
			\ ':': ['cl'],
			\ '::': ['dcl'],
			\ '?': ['qu', 'qs'],
			\ '/': ['sl', 'rd', 'di', 'division'],
			\ '// ': ['dsl', 'com', 'comment'],
			\ '<': ['lt'],
			\ '<<': ['dlt'],
			\ '>': ['gt'],
			\ '>>': ['dgt'],
			\ '> ': ['quote'],
			\ '<><Left>': ['te', 'temp', 'tmpl'],
			\ '<=': ['le'],
			\ '>=': ['ge'],
			\ '.': ['\<d', 'dot', 'pe', 'period'],
			\ ',': ['cm', 'comma'],
			\ '->': ['po', 'pointer'],
			\ '0': ['zero'],
			\ '1': ['one'],
			\ '2': ['two'],
			\ '3': ['three'],
			\ '4': ['four'],
			\ '5': ['five'],
			\ '6': ['six'],
			\ '7': ['seven'],
			\ '8': ['eight'],
			\ '9': ['nine'],
			\
			\ '\t': ['tab'],
			\ '\r': ['cr','ent','enter'],
			\ '\n': ['lf'],
			\ }
" 			\ '': [''],
" <Nul> = <C-Space>
" let s:gtrigger = '<Nul>'
let s:gtrigger = '<C-x><C-x>'
" let s:gtrigger = '<S-Down>'

function! RegisterSmartinputRules(replace_map)
	for s:key in keys(a:replace_map)
		let s:srcs=a:replace_map[s:key]
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
endfunction
call RegisterSmartinputRules(s:replace_map)

" NOTE:登録済のトリガを大量に登録すると反応しないので注意
" call smartinput#map_to_trigger('i', s:gtrigger, s:gtrigger, s:gtrigger)
call s:map_to_trigger('i', s:gtrigger)

" クラス定義や enum 定義の場合は末尾に;を付け忘れないようにする
call smartinput#define_rule({
			\   'at'       : '\(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#',
			\   'char'     : '<Space>',
			\   'input'    : '<Space>{};<Left><Left><CR><Left><CR>',
			\   'filetype' : ['cpp'],
			\   })
" call smartinput#map_to_trigger('i', '<', '<', '<')
call s:map_to_trigger('i', '<')
" template に続く <> を補完
call smartinput#define_rule({
			\   'at'       : '\<template\>\s*\%#',
			\   'char'     : '<',
			\   'input'    : '<><Left>',
			\   'filetype' : ['cpp'],
			\   })

" [dogfiles/vimrc at master · rhysd/dogfiles]( https://github.com/rhysd/dogfiles/blob/master/vimrc#L2086 )
" \s= を入力したときに空白を挟む
" call smartinput#map_to_trigger('i', '=', '=', '=')
call s:map_to_trigger('i', '=')
call smartinput#define_rule(
			\ { 'at'    : '\s\%#'
			\ , 'char'  : '='
			\ , 'input' : '= '
			\ })

" でも連続した == となる場合には空白は挟まない
call smartinput#define_rule(
			\ { 'at'    : '=\s\%#'
			\ , 'char'  : '='
			\ , 'input' : '<BS>= '
			\ })

" でも連続した =~ となる場合には空白は挟まない
" call smartinput#map_to_trigger('i', '~', '~', '~')
call s:map_to_trigger('i', '~')
call smartinput#define_rule(
			\ { 'at'    : '=\s\%#'
			\ , 'char'  : '~'
			\ , 'input' : '<BS>~ '
			\ })

" Vim は ==# と =~# がある
" call smartinput#map_to_trigger('i', '#', '#', '#')
call s:map_to_trigger('i', '#')
call smartinput#define_rule(
			\ { 'at'    : '=[~=]\s\%#'
			\ , 'char'  : '#'
			\ , 'input' : '<BS># '
			\ })

call s:map_to_trigger('i', '-')
call smartinput#define_rule(
			\ { 'at'    : '\S\%#'
			\ , 'char'  : '-'
			\ , 'input' : '->'
			\ , 'filetype' : ['cpp']
			\ })

call smartinput#define_rule(
			\ { 'at'    : '\(#\s*include\s*\|vector\|shared_ptr\|unique_ptr\|weak_ptr\|map\|unordered_map\|array\|list\|forward_list\|dequre\|priority_queue\|set\|multiset\|unordered_set\|unordered_multiset\|multimap\|unordered_multimap\|stack\|queue\|template\)\%#'
			\ , 'char'  : '<'
			\ , 'input' : '<><Left>'
			\ , 'filetype' : ['cpp']
			\ })

call s:map_to_trigger('i', 'r')
call smartinput#define_rule(
			\ { 'at'    : '\%(^#include <\)\@<!vecto\%#'
			\ , 'char'  : 'r'
			\ , 'input' : 'r<><Left>'
			\ , 'filetype' : ['cpp']
			\ })

call s:map_to_trigger('i', ':')
" 確実なマッピング
call smartinput#define_rule(
			\ { 'at'    : '\(std\|clang\|llvm\|internal\|detail\|boost\)\%#'
			\ , 'char'  : ':'
			\ , 'input' : '::'
			\ , 'filetype' : ['cpp']
			\ })
" NOTE: 文字列内である可能性では排除
call smartinput#define_rule(
			\ { 'at'    : '^[^"]*\w\%#'
			\ , 'char'  : ':'
			\ , 'input' : '::'
			\ , 'filetype' : ['cpp']
			\ })
" NOTE: 誤入力防止
call smartinput#define_rule(
			\ { 'at'    : '::\%#'
			\ , 'char'  : ':'
			\ , 'input' : ''
			\ , 'filetype' : ['cpp']
			\ })
call smartinput#define_rule(
			\ { 'at'    : 'public\s*\%#'
			\ , 'char'  : '<CR>'
			\ , 'input' : '<><Left>'
			\ , 'filetype' : ['cpp']
			\ })

call smartinput#define_rule(
			\ { 'at'    : '\(cout\|cerr\|clog\|stream\|ss\).*\%#'
			\ , 'char'  : '<'
			\ , 'input' : '<<'
			\ , 'filetype' : ['cpp']
			\ })

call smartinput#define_rule(
			\ { 'at'    : '\%#.*\(cin\|stream\|ss\)'
			\ , 'char'  : '>'
			\ , 'input' : '>>'
			\ , 'filetype' : ['cpp']
			\ })

" NOTE: lambda(変数に代入を想定)
call smartinput#define_rule(
			\ { 'at'    : '\%((\)\@<!\[\]\%#'
			\ , 'char'  : '('
			\ , 'input' : '(){<Left><Left><C-o>:call append(".", ["","};"])<CR>'
			\ , 'filetype' : ['cpp']
			\ })
" NOTE: lambda(thread([](){}))
call smartinput#define_rule(
			\ { 'at'    : '\%((\)\@<=\[\]\%#'
			\ , 'char'  : '('
			\ , 'input' : '(){<C-o>:call append(".", ["","}".getline(".")[col(".")-1:]])<CR><C-o>:call setline(".", getline(".")[:col(".")-2])<CR><Left><Left>'
			\ , 'filetype' : ['cpp']
			\ })

call smartinput#define_rule({
			\   'at': '\(public\|private\|protected\)[^:]*\%#$',
			\   'char': '<CR>',
			\   'input': "<C-o>:call setline('.', substitute(getline('.'), '$', ':', ''))<CR><C-o>$<CR>",
			\   'filetype': ['cpp'],
			\   })

" NOTE: 誤入力防止
call smartinput#define_rule(
			\ { 'at'    : 'if.*\[.*\]\%#\s*\%(then\)\@!$'
			\ , 'char'  : ':'
			\ , 'input' : '; then'
			\ , 'filetype' : ['sh','zsh']
			\ })
call smartinput#define_rule(
			\ { 'at'    : 'if.*\[.*\]\%#.*then'
			\ , 'char'  : ':'
			\ , 'input' : ';'
			\ , 'filetype' : ['sh','zsh']
			\ })
call smartinput#define_rule(
			\ { 'at'    : 'if.*\[.*\]\%#\%(;\s*then\)\@!'
			\ , 'char'  : '<CR>'
			\ , 'input' : '; then<CR>'
			\ , 'filetype' : ['sh','zsh']
			\ })

call s:map_to_trigger('i', 'f')
call smartinput#define_rule(
			\ { 'at'    : 'endi\%#'
			\ , 'char'  : 'f'
			\ , 'input': "<C-o>:call setline('.', 'fi')<CR><C-o>$"
			\ , 'filetype' : ['sh','zsh']
			\ })
call smartinput#define_rule(
			\ { 'at'    : 'elsei\%#'
			\ , 'char'  : 'f'
			\ , 'input': "<C-o>:call setline('.', 'elif')<CR><C-o>$"
			\ , 'filetype' : ['sh','zsh']
			\ })

call smartinput#define_rule({
			\   'at': '^plug\%#$',
			\   'char': '<Space>',
			\   'input': "<C-o>:call setline('.', \"Plug ''\")<CR><C-o>$<Left>",
			\   'filetype': ['vim'],
			\   })
