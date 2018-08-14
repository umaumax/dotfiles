if !(&rtp =~ 'vim-smartinput')
	finish
endif

let s:trigger_map={}
function! s:map_to_trigger(mode, trigger)
	let trigger=a:trigger
	if trigger=='|'
		let trigger='\|'
	endif
	let key=a:mode.':'.trigger
	if has_key(s:trigger_map, key)
		return
	endif
	let s:trigger_map[key]=1
	call smartinput#map_to_trigger(a:mode, trigger, trigger, trigger)
endfunction
function! s:smartinput_define_rule(rule)
	let trigger = a:rule['char']
	call s:map_to_trigger('i', trigger)
	call smartinput#define_rule(a:rule)
endfunction

" <Nul> = <C-Space>
" let s:gtrigger = '<Nul>'
" let s:gtrigger = '<S-Down>'
let s:gtrigger = '<C-x><C-x>'

function! RegisterSmartinputRules(replace_map)
	for key in keys(a:replace_map)
		let srcs=a:replace_map[key]
		let dst=key
		for src in srcs
			let n = len(substitute(src,'^\\<', '', ''))
			let at = src
			let trigger = s:gtrigger
			call s:smartinput_define_rule({'at': at.'\%#', 'char': trigger, 'input': repeat('<BS>', n).dst})
		endfor
	endfor
endfunction

function! s:smartinput_define()
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

	" NOTE: [対応する括弧等を入力する生活に疲れた\(Vim 編\) \- TIM Labs]( http://labs.timedia.co.jp/2012/09/vim-smartinput.html )
	" >  競合時の優先度: 基本的には「 at がやたら長いものはそれだけ複雑な文脈の指定になっている」という前提で at の長いルールの優先度が高くなるように設定されています。
	call s:smartinput_define_rule({
				\'at': '\[\[\%#\]\]', 'char': '<Space>', 'input': '<Space><Space><left>',
				\ 'filetype': ['sh','bash','zsh'],
				\})
	call s:smartinput_define_rule({
				\'at': 'if \[\[\%#\]\]', 'char': '<Space>',
				\ 'input': "<Space><Space><Left><C-o>:call setline('.', substitute(getline('.'), '$', '; then', ''))<CR>",
				\ 'filetype': ['sh','bash','zsh'],
				\})

	" override default rules
	for s:set in ['()','\[\]','{}','``','``````','""',"''"]
		let s:left=s:set[:len(s:set)/2-1]
		let s:right=s:set[len(s:set)/2:]
		call s:smartinput_define_rule({'at': s:left.'\%#'.s:right, 'char': '<BS>', 'input': '<Right><BS>'})
		call s:smartinput_define_rule({'at': s:set.'\%#',          'char': '<BS>', 'input': '<BS>'})
	endfor
	call s:smartinput_define_rule({'at': '```\%#', 'char': '<CR>', 'input': '<CR><ESC>O'})

	" NOTE: 下記の方法では相殺できなかったため，cloneして改変する方法に
	" override default rule
	" call s:smartinput_define_rule({'at': '\%#\_s*)', 'char': ')', 'input': ')'})
	" call s:smartinput_define_rule({'at': '\%#\_s*\]', 'char': ']', 'input': ']'})
	call s:smartinput_define_rule({'at': '\[\%#\]', 'char': ']', 'input': '<Right>'})
	call s:smartinput_define_rule({'at': '(\%#)', 'char': ')', 'input': '<Right>'})
	call s:smartinput_define_rule({'at': '{\%#}', 'char': '}', 'input': '<Right>'})

	" 改行時に行末のスペース除去
	call s:smartinput_define_rule({
				\   'at': '\s\+\%#',
				\   'char': '<CR>',
				\   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
				\   })
	" 			\   'at': 'def.*[^:]\%#',
	" 			\   'at': 'def.*\%#',
	call s:smartinput_define_rule({
				\   'at': '\(class\|for\|if\|def\|while\|else\|elif\).*[^:]\%#$',
				\   'char': '<CR>',
				\   'input': "<C-o>:call setline('.', substitute(getline('.'), '$', ':', ''))<CR><C-o>$<CR>",
				\   'filetype': ['python'],
				\   })

	call s:smartinput_define_rule({
				\   'at': '|\%#$',
				\   'char': '|',
				\   'input': "<BS>or",
				\   'filetype': ['python'],
				\   })

	call s:smartinput_define_rule({
				\   'at': '&\%#$',
				\   'char': '&',
				\   'input': "<BS>and",
				\   'filetype': ['python'],
				\   })

	call s:smartinput_define_rule({
				\   'at': '== None.*\%#$',
				\   'char': '<Space>',
				\   'input': "<C-o>:call setline('.', substitute(getline('.'), '== None', 'is None', 'g'))<CR><Space>",
				\   'filetype': ['python'],
				\   })
	call s:smartinput_define_rule({
				\   'at': '== Non\%#$',
				\   'char': 'e',
				\   'input': "<C-o>:call setline('.', substitute(getline('.'), '== Non', 'is None', 'g'))<CR><C-o>$",
				\   'filetype': ['python'],
				\   })

	" <>_ ===> <_>
	call s:smartinput_define_rule({'at': '<\%#', 'char': '>', 'input': '><Left>'})

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

	call RegisterSmartinputRules(s:replace_map)

	" NOTE:登録済のトリガを大量に登録すると反応しないので注意
	call s:map_to_trigger('i', s:gtrigger)

	" クラス定義や enum 定義の場合は末尾に;を付け忘れないようにする
	call s:smartinput_define_rule({
				\   'at'       : '\(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#[^{]*$',
				\   'char'     : '<CR>',
				\   'input'    : '<Space>{};<Left><Left><CR><Left><CR>',
				\   'filetype' : ['cpp'],
				\   })
	" template に続く <> を補完
	call s:smartinput_define_rule({
				\   'at'       : '\<template\>\s*\%#',
				\   'char'     : '<',
				\   'input'    : '<><Left>',
				\   'filetype' : ['cpp'],
				\   })

	" [dogfiles/vimrc at master · rhysd/dogfiles]( https://github.com/rhysd/dogfiles/blob/master/vimrc#L2086 )
	" \s= を入力したときに空白を挟む
	call s:smartinput_define_rule(
				\ { 'at'    : '\s\%#'
				\ , 'char'  : '='
				\ , 'input' : '= '
				\ })

	" でも連続した == となる場合には空白は挟まない
	call s:smartinput_define_rule(
				\ { 'at'    : '=\s\%#'
				\ , 'char'  : '='
				\ , 'input' : '<BS>= '
				\ })

	" でも連続した =~ となる場合には空白は挟まない
	call s:smartinput_define_rule(
				\ { 'at'    : '=\s\%#'
				\ , 'char'  : '~'
				\ , 'input' : '<BS>~ '
				\ })

	" Vim は ==# と =~# がある
	call s:smartinput_define_rule(
				\ { 'at'    : '=[~=]\s\%#'
				\ , 'char'  : '#'
				\ , 'input' : '<BS># '
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : '[a-zA-Z_)]\%#'
				\ , 'char'  : '-'
				\ , 'input' : '->'
				\ , 'filetype' : ['cpp']
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : '\(#\s*include\s*\|vector\|shared_ptr\|unique_ptr\|weak_ptr\|make_shared\|map\|unordered_map\|array\|list\|forward_list\|dequre\|priority_queue\|set\|multiset\|unordered_set\|unordered_multiset\|multimap\|unordered_multimap\|stack\|queue\|template\)\%#'
				\ , 'char'  : '<'
				\ , 'input' : '<><Left>'
				\ , 'filetype' : ['cpp']
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : '<\%#>'
				\ , 'char'  : '<'
				\ , 'input' : ''
				\ , 'filetype' : ['cpp']
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : '(\%#)'
				\ , 'char'  : '('
				\ , 'input' : ''
				\ , 'filetype' : ['cpp']
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : '\%(^#include <\)\@<!vecto\%#'
				\ , 'char'  : 'r'
				\ , 'input' : 'r<><Left>'
				\ , 'filetype' : ['cpp']
				\ })

	" 確実なマッピング
	call s:smartinput_define_rule(
				\ { 'at'    : '\(std\|clang\|llvm\|internal\|detail\|boost\)\%#'
				\ , 'char'  : ':'
				\ , 'input' : '::'
				\ , 'filetype' : ['cpp']
				\ })
	" NOTE: 文字列内である可能性では排除
	" call s:smartinput_define_rule(
	" 			\ { 'at'    : '^[^"]*\w\%#'
	" 			\ , 'char'  : ':'
	" 			\ , 'input' : '::'
	" 			\ , 'filetype' : ['cpp']
	" 			\ })
	" ::続きの場合
	call s:smartinput_define_rule(
				\ { 'at'    : '::[a-zA-z0-9-_]\+\%#'
				\ , 'char'  : ':'
				\ , 'input' : '::'
				\ , 'filetype' : ['cpp']
				\ })

	" NOTE: 誤入力防止
	call s:smartinput_define_rule(
				\ { 'at'    : '::\%#'
				\ , 'char'  : ':'
				\ , 'input' : ''
				\ , 'filetype' : ['cpp']
				\ })
	call s:smartinput_define_rule(
				\ { 'at'    : '<<\%#'
				\ , 'char'  : '<'
				\ , 'input' : ''
				\ , 'filetype' : ['cpp']
				\ })
	call s:smartinput_define_rule(
				\ { 'at'    : '[\->]>\%#'
				\ , 'char'  : '>'
				\ , 'input' : ''
				\ , 'filetype' : ['cpp']
				\ })
	call s:smartinput_define_rule(
				\ { 'at'    : '!\%#'
				\ , 'char'  : '-'
				\ , 'input' : '='
				\ , 'filetype' : ['cpp']
				\ })
	" . to ->
	call s:smartinput_define_rule(
				\ { 'at'    : '.\%#'
				\ , 'char'  : '-'
				\ , 'input' : '<BS>->'
				\ , 'filetype' : ['cpp']
				\ })
	" -> to .
	call s:smartinput_define_rule(
				\ { 'at'    : '->\%#'
				\ , 'char'  : '.'
				\ , 'input' : '<BS><BS>.'
				\ , 'filetype' : ['cpp']
				\ })


	call s:smartinput_define_rule(
				\ { 'at'    : '\(cout\|cerr\|clog\|stream\|ss\).*\%(<<\)\@<!\%#'
				\ , 'char'  : '<'
				\ , 'input' : '<<'
				\ , 'filetype' : ['cpp']
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : '\%(>>\)\@<!\%#.*\(cin\|stream\|ss\)'
				\ , 'char'  : '>'
				\ , 'input' : '>>'
				\ , 'filetype' : ['cpp']
				\ })

	" NOTE: lambda(変数に代入を想定)
	call s:smartinput_define_rule(
				\ { 'at'    : '\%((\)\@<!\[\]\%#'
				\ , 'char'  : '('
				\ , 'input' : '(){<Left><Left><C-o>:call append(".", ["","};"])<CR>'
				\ , 'filetype' : ['cpp']
				\ })
	" NOTE: lambda(thread([](){}))
	call s:smartinput_define_rule(
				\ { 'at'    : '\%((\)\@<=\[\]\%#'
				\ , 'char'  : '('
				\ , 'input' : '(){<C-o>:call append(".", ["","}".getline(".")[col(".")-1:]])<CR><C-o>:call setline(".", getline(".")[:col(".")-2])<CR><Left><Left>'
				\ , 'filetype' : ['cpp']
				\ })

	call s:smartinput_define_rule({
				\   'at': '\(public\|private\|protected\)[^:]*\%#$',
				\   'char': '<CR>',
				\   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s*$', ':', ''))<CR><C-o>$<CR>",
				\   'filetype': ['cpp'],
				\   })

	" NOTE: 誤入力防止
	call s:smartinput_define_rule(
				\ { 'at'    : 'if.*\[.*\]\%#\s*\%(then\)\@!$'
				\ , 'char'  : ':'
				\ , 'input' : '; then'
				\ , 'filetype' : ['sh','zsh']
				\ })
	call s:smartinput_define_rule(
				\ { 'at'    : 'if.*\[.*\]\%#.*then'
				\ , 'char'  : ':'
				\ , 'input' : ';'
				\ , 'filetype' : ['sh','zsh']
				\ })
	call s:smartinput_define_rule(
				\ { 'at'    : 'if.*\[.*\]\%#\%(;\s*then\)\@!'
				\ , 'char'  : '<CR>'
				\ , 'input' : '; then<CR>'
				\ , 'filetype' : ['sh','zsh']
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : 'endi\%#'
				\ , 'char'  : 'f'
				\ , 'input': "<C-o>:call setline('.', 'fi')<CR><C-o>$"
				\ , 'filetype' : ['sh','zsh']
				\ })
	call s:smartinput_define_rule(
				\ { 'at'    : 'elsei\%#'
				\ , 'char'  : 'f'
				\ , 'input': "<C-o>:call setline('.', 'elif')<CR><C-o>$"
				\ , 'filetype' : ['sh','zsh']
				\ })

	call s:smartinput_define_rule(
				\ { 'at'    : '\(^\|\s\)f\%#'
				\ , 'char'  : 'i'
				\ , 'input': "<BS>endif"
				\ , 'filetype' : ['vim']
				\ })
	call s:smartinput_define_rule({
				\   'at': '^plug\%#$',
				\   'char': '<Space>',
				\   'input': "<C-o>:call setline('.', \"Plug ''\")<CR><C-o>$<Left>",
				\   'filetype': ['vim'],
				\   })

	call s:smartinput_define_rule({
				\   'at': 'don\%#',
				\   'char': 't',
				\   'input': "'t",
				\   })

	call s:smartinput_define_rule({
				\   'at': ' pipe\%#',
				\   'char': '<Space>',
				\   'input': "<BS><BS><BS><BS>|<Space>",
				\   })

	" NOTE: if xxx { -> if (xxx) {
	call s:smartinput_define_rule({
				\   'at': 'if\s*[^() \t].\{-}[^() \t]\s*{\%#',
				\   'char': '<CR>',
				\   'input': "<C-o>:call setline('.', substitute(getline('.'), 'if\\s*\\([^() \\t].\\{-}[^() \\t]\\)\\s*{', 'if (\\1) {', ''))<CR><C-O>$",
				\   'filetype': ['cpp'],
				\   })
endfunction

" NOTE: to speed up starting
augroup smart_input_define_group
	autocmd!
	autocmd User VimEnterDrawPost call <SID>smartinput_define()
augroup END
