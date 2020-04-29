if !(&rtp =~ 'vim-smartinput')
  finish
endif

let g:i_trigger_map={}
let s:trigger_map={}
" FYI: [vim\-smartinput/smartinput\.vim at master · umaumax/vim\-smartinput]( https://github.com/umaumax/vim-smartinput/blob/master/autoload/smartinput.vim#L170 )
let s:default_triggers="[({`|".'"'."'"
for i in range(0,strlen(s:default_triggers)-1)
  let char=strpart(s:default_triggers,i,1)
  let s:trigger_map[char]=1
endfor

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

function! s:smartinput_define_rule(rule, ...)
  let modes=get(a:, 1, 'i')
  let trigger = a:rule['char']
  for mode in split(modes, '\zs')
    call s:map_to_trigger(mode, trigger)
  endfor
  call smartinput#define_rule(a:rule)
endfunction

function! s:smartinput_define_rule_of_word(src,dst,...) " filetype
  let rule={
        \   'at': a:src[:len(a:src)-2].'\%#',
        \   'char': a:src[len(a:src)-1:],
        \   'input': repeat("<BS>",len(a:src)-1).a:dst,
        \   }
  let filetype=get(a:, 1, [])
  if len(filetype)>0 | let rule['filetype']=filetype | endif
  call s:smartinput_define_rule(rule)
endfunction

function! RegisterSmartinputRules(replace_map, src_prefix_char, cursor_prefix_char, trigger)
  for key in keys(a:replace_map)
    let srcs=a:replace_map[key]
    let dst=key
    for src in srcs
      let n = len(substitute(src.a:cursor_prefix_char,'^\\<', '', ''))
      let suffix_char=a:cursor_prefix_char
      " NOTE: disable insert deleted word before cursor
      if stridx(dst,'<Left>')>=0
        let suffix_char=''
      endif
      let at = src
      let trigger = a:trigger
      call s:smartinput_define_rule({'at': a:src_prefix_char.at.a:cursor_prefix_char.'\%#', 'char': trigger, 'input': repeat('<BS>', n).dst.suffix_char})
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
        \   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\(\\s\\|\\r\\)\\+$', '', ''))<CR><CR>",
        \   })
  "       \   'at': 'def.*[^:]\%#',
  "       \   'at': 'def.*\%#',
  call s:smartinput_define_rule({
        \   'at': '\(class\|for\|if\|def\|while\|else\|elif\).*[^:]\%#$',
        \   'char': '<CR>',
        \   'input': "<C-o>:call setline('.', substitute(getline('.'), '$', ':', ''))<CR><C-o>$<CR>",
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

  call s:smartinput_define_rule_of_word('||','or' ,['python'])
  call s:smartinput_define_rule_of_word('&&','and' ,['python'])
  call s:smartinput_define_rule_of_word('true','True',['python'])
  call s:smartinput_define_rule_of_word('false','False' ,['python'])

  " <>_ ===> <_>
  call s:smartinput_define_rule({'at': '<\%#', 'char': '>', 'input': '><Left>'})

  " NOTE: 置き換え時に特殊キーに注意
  " '\<': 単語境界でなければならない
  " NOTE: 置き換え後のspaceの有無の指定方法?
  let s:replace_map = {
        \ '||': ['or'],
        \ '&&': ['and'],
        \ '=~': ['req','regeq'],
        \ "{'':''}<Left><Left><Left><Left><Left>": ['dict'],
        \ ', ': ['arg'],
        \ 'ヽ(*゜д゜)ノ': ['kaiba'],
        \
        \ '!': ['ex'],
        \ '"': ['dq'],
        \ '""<Left>': ['ddq', 'str'],
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

  " NOTE: '\<': word border
  call RegisterSmartinputRules(s:replace_map, '\<', ' ', ' ')
  call RegisterSmartinputRules(s:replace_map, '', '', '<C-x><C-x>')

  " NOTE:登録済のトリガを大量に登録すると反応しないので注意
  call s:map_to_trigger('i', ' ')
  call s:map_to_trigger('i', '<C-x><C-x>')

  " クラス定義やenum定義の場合は末尾に;を付け忘れないように
  " class Nanoha _curosr_
  call s:smartinput_define_rule({
        \   'at'       : '^\s*\(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*[^{}]\%#[^{}]*$',
        \   'char'     : '<CR>',
        \   'input'    : '{};<Left><Left><CR><Left><CR>',
        \   'filetype' : ['cpp'],
        \   })
  " class Nanoha {_curosr_}
  call s:smartinput_define_rule({
        \   'at'       : '^\s*\(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*{\%#}$',
        \   'char'     : '<CR>',
        \   'input'    : '<Right>;<Left><Left><CR><Left><CR>',
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

  " you can toggle . <====> -> by .
  call s:smartinput_define_rule(
        \ { 'at'    : '->%#'
        \ , 'char'  : '.'
        \ , 'input' : '<BS><BS>.'
        \ , 'filetype' : ['cpp']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\.\%#'
        \ , 'char'  : '.'
        \ , 'input' : '<BS>->'
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
        \ { 'at'    : '\(std\|clang\|llvm\|internal\|detail\|boost\|ros\|Eigen\|cv\|bridge\)\%#'
        \ , 'char'  : ':'
        \ , 'input' : '::'
        \ , 'filetype' : ['cpp']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\(std\|clang\|llvm\|internal\|detail\|boost\|ros\|Eigen\|cv\|bridge\)\%#'
        \ , 'char'  : ';'
        \ , 'input' : '::'
        \ , 'filetype' : ['cpp']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\%(\(endl\)\)\@<!;\%#'
        \ , 'char'  : ';'
        \ , 'input' : '<BS>::'
        \ , 'filetype' : ['cpp']
        \ })
  " NOTE: 誤入力防止
  call s:smartinput_define_rule(
        \ { 'at'    : ';\%#'
        \ , 'char'  : ';'
        \ , 'input' : ''
        \ , 'filetype' : ['cpp']
        \ })
  " NOTE: 文字列内である可能性では排除
  " call s:smartinput_define_rule(
  "       \ { 'at'    : '^[^"]*\w\%#'
  "       \ , 'char'  : ':'
  "       \ , 'input' : '::'
  "       \ , 'filetype' : ['cpp']
  "       \ })
  " ::続きの場合
  call s:smartinput_define_rule(
        \ { 'at'    : '::[a-zA-z0-9-_]\+\%#'
        \ , 'char'  : ':'
        \ , 'input' : '::'
        \ , 'filetype' : ['cpp']
        \ })

  " NOTE: 誤入力防止
  call s:smartinput_define_rule(
        \ { 'at'    : '\(::\|;\)\%#'
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
  " -> to .
  call s:smartinput_define_rule(
        \ { 'at'    : '->\%#'
        \ , 'char'  : '.'
        \ , 'input' : '<BS><BS>.'
        \ , 'filetype' : ['cpp']
        \ })

  let cpp_shortcut_map={
        \ 'auto std prefix completion':{
        \   'prefix': 'std::',
        \   'suffix': '',
        \   'prefix_pattern': '\%(\(std::\)\|\([a-zA-Z0-9"<]\)\)\@<!',
        \   'completions': [['cout',' << '],['clog',' << '], ['cerr',' << '],['cin',' >> '],['endl',';'],['shared_ptr','<\%#>'],['unique_ptr','<\%#>'],['vector','<\%#>']],
        \ },
        \ 'auto # prefix completion':{
        \   'prefix': '#',
        \   'suffix': '',
        \   'prefix_pattern': '^',
        \   'completions': [['include'],['ifdef',' '], ['endif'],['elif',' '],['pragma',' '],['undef']],
        \ },
        \ }
  for [key, val] in items(cpp_shortcut_map)
    let prefix=val['prefix']
    let prefix_pattern=val['prefix_pattern']
    let completions=val['completions']
    for obj in completions
      let keyword=obj[0]
      let suffix=get(obj, 1, val['suffix'])
      let left_n=0
      let cursor_idx=stridx(suffix,'\%#')
      if cursor_idx != -1
        " NOTE: drop cursor str
        let suffix=suffix[:cursor_idx-1].suffix[cursor_idx+len('\%#'):]
        let left_n=len(suffix)-cursor_idx
      endif
      let n=len(keyword)
      let keyword_without_last_char=keyword[:n-2]
      let last_char=keyword[n-1]
      call s:smartinput_define_rule(
            \ { 'at'    : prefix_pattern.keyword_without_last_char.'\%#'
            \ , 'char'  : last_char
            \ , 'input' : repeat('<BS>',n-1).prefix.keyword.suffix.repeat('<Left>',left_n)
            \ , 'filetype' : ['cpp']
            \ })
    endfor
  endfor

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
        \ { 'at'    : '\[.*\%#.*\]'
        \ , 'char'  : '>'
        \ , 'input' : '-gt'
        \ , 'filetype' : ['sh','zsh']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\[.*>\%#.*\]'
        \ , 'char'  : '='
        \ , 'input' : '<BS>-ge'
        \ , 'filetype' : ['sh','zsh']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\[.*-gt\%#.*\]'
        \ , 'char'  : '='
        \ , 'input' : '<BS><BS><BS>-ge'
        \ , 'filetype' : ['sh','zsh']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\[.*<\%#.*\]'
        \ , 'char'  : '<'
        \ , 'input' : '-lt'
        \ , 'filetype' : ['sh','zsh']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\[.*<\%#.*\]'
        \ , 'char'  : '='
        \ , 'input' : '<BS>-le'
        \ , 'filetype' : ['sh','zsh']
        \ })
  call s:smartinput_define_rule(
        \ { 'at'    : '\[.*-lt\%#.*\]'
        \ , 'char'  : '='
        \ , 'input' : '<BS><BS><BS>-le'
        \ , 'filetype' : ['sh','zsh']
        \ })

  call s:smartinput_define_rule_of_word('endif','fi' ,['sh','zsh'])
  call s:smartinput_define_rule_of_word('elseif','elif' ,['sh','zsh'])

  call s:smartinput_define_rule(
        \ { 'at'    : '^\s*f\%#'
        \ , 'char'  : 'i'
        \ , 'input': "<BS>endif"
        \ , 'filetype' : ['vim']
        \ })
  " NOTE: temporary solution for avoid wrong replace
  call s:smartinput_define_rule(
        \ { 'at'    : '^\s*endif\%#'
        \ , 'char'  : 'n'
        \ , 'input': "<BS><BS><BS><BS><BS>fin"
        \ , 'filetype' : ['vim']
        \ })
  call s:smartinput_define_rule({
        \   'at': '^plug\%#$',
        \   'char': '<Space>',
        \   'input': "<C-o>:call setline('.', \"Plug ''\")<CR><C-o>$<Left>",
        \   'filetype': ['vim'],
        \   })

  " NOTE: for dummy rule
  call s:smartinput_define_rule({
        \   'at': '$\%#^',
        \   'char': '<Space>',
        \   'input': "<Space>",
        \   })

  call s:smartinput_define_rule_of_word('dont',"don't")
  call s:smartinput_define_rule_of_word('cant',"can't")
  call s:smartinput_define_rule_of_word('doesnt',"doesn't")

  let s:multi_word_map = {
        \'/ NOTE: ':     ['/ note',     '/ note:  '],
        \'/ TODO: ':     ['/ todo',     '/ todo:  '],
        \'/ WARN: ':     ['/ warn',     '/ warn:  '],
        \'/ INFO: ':     ['/ info',     '/ info:  '],
        \'/ FYI: ':      ['/ fyi',      '/ fyi:  '],
        \'/ FIX: ':      ['/ fix',      '/ fix:  '],
        \'/ HINT: ':     ['/ hint',     '/ hint:  '],
        \'/ QUESTION: ': ['/ question', '/ question:  '],
        \'# NOTE: ':     ['# note',     '# note:  '],
        \'# TODO: ':     ['# todo',     '# todo:  '],
        \'# WARN: ':     ['# warn',     '# warn:  '],
        \'# INFO: ':     ['# info',     '# info:  '],
        \'# FYI: ':      ['# fyi',      '# fyi:  '],
        \'# FIX: ':      ['# fix',      '# fix:  '],
        \'# HINT: ':     ['# hint',     '# hint:  '],
        \'# QUESTION: ': ['# question', '# question:  '],
        \'# DELETE: ':   ['# delete',   '# delete:  '],
        \'" NOTE: ':     ['" note',     '" note:  '],
        \'" TODO: ':     ['" todo',     '" todo:  '],
        \'" WARN: ':     ['" warn',     '" warn:  '],
        \'" INFO: ':     ['" info',     '" info:  '],
        \'" FYI: ':      ['" fyi',      '" fyi:  '],
        \'" FIX: ':      ['" fix',      '" fix:  '],
        \'" HINT: ':     ['" hint',     '" hint:  '],
        \'" QUESTION: ': ['" question', '" question:  '],
        \'" DELETE: ':   ['" delete',   '" delete:  '],
        \'* NOTE: ':     ['* note',     '* note:  '],
        \'* TODO: ':     ['* todo',     '* todo:  '],
        \'* WARN: ':     ['* warn',     '* warn:  '],
        \'* INFO: ':     ['* info',     '* info:  '],
        \'* FYI: ':      ['* fyi',      '* fyi:  '],
        \'* FIX: ':      ['* fix',      '* fix:  '],
        \'* HINT: ':     ['* hint',     '* hint:  '],
        \'* QUESTION: ': ['* question', '* question:  '],
        \'* DELETE: ':   ['* delete',   '* delete:  '],
        \'# MEMO':       ['#memo'],
        \'# NOTE':       ['#note'],
        \'# TODO':       ['#todo'],
        \'# WARN':       ['#warn'],
        \'# INFO':       ['#info'],
        \'# FYI':        ['#fyi'],
        \'# FIX':        ['#fix'],
        \'# HINT':       ['#hint'],
        \'# QUESTION':   ['#question'],
        \'# DELETE':     ['#delete'],
        \}
  " \'MEMO: ':['memo', 'memo:  '],
  for key in keys(s:multi_word_map)
    for at in s:multi_word_map[key]
      call s:smartinput_define_rule_of_word(at,key)
    endfor
  endfor

  call s:smartinput_define_rule_of_word('WARN: ing',"warning")

  call s:smartinput_define_rule_of_word('some','Some' ,['rust'])
  call s:smartinput_define_rule_of_word('Something','something' ,['rust'])
  call s:smartinput_define_rule_of_word('none','None' ,['rust'])
  call s:smartinput_define_rule_of_word('option','Option' ,['rust'])
  call s:smartinput_define_rule_of_word('iflet','if let' ,['rust'])

  " NOTE: if xxx { -> if (xxx) {
  call s:smartinput_define_rule({
        \   'at': 'if\s*[^() \t].\{-}[^() \t]\s*{\%#',
        \   'char': '<CR>',
        \   'input': "<C-o>:call setline('.', substitute(getline('.'), 'if\\s*\\([^() \\t].\\{-}[^() \\t]\\)\\s*{', 'if (\\1) {', ''))<CR><C-O>$",
        \   'filetype': ['cpp'],
        \   })

  " NOTE: for save and restore key mappings for terryma/vim-multiple-cursors
  let g:i_triggers=[]
  for key in keys(s:trigger_map)
    let g:i_triggers+=[substitute(substitute(key,'^i:','',''),'\(<[a-zA-Z]*>\)','\\\1','g')]
  endfor
endfunction

" NOTE: to speed up starting
augroup smart_input_define_group
  autocmd!
  autocmd User VimEnterDrawPost call <SID>smartinput_define()
augroup END
