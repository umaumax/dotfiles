" set <Leader>
let mapleader = "\<Space>"

" paste with space
nnoremap gp a <ESC>p

nnoremap cc vc
nnoremap co i<CR><ESC>

nnoremap <Leader>p %

" disable <C-@>
inoremap <C-@> <C-[>

inoremap <expr> j  getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'

nnoremap <leader>r :redraw!<CR>

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>

" undo情報を保つ
inoremap <Left> <C-g>U<Left>

" " cursor movement in insert mode
inoremap <C-h> <Left>
inoremap <expr> <C-j> <SID>Down()
inoremap <expr> <C-k> <SID>Up()
inoremap <C-l> <Right>

" NOTE: デフォルト割当のwindow移動を書き換え
" Delete and Backspace key
" inoremap <C-d> <Esc>lxi
inoremap <C-d> <Delete>
inoremap <C-f> <BS>
nnoremap <C-d> <Delete>
nnoremap <C-f> <BS>
vnoremap <C-d> <Delete>
vnoremap <C-f> <BS>
cnoremap <C-d> <Delete>
cnoremap <C-f> <BS>

" for seamless line movement
nnoremap h <Left>
nnoremap l <Right>
vnoremap h <Left>
vnoremap l <Right>
" zz: set cursor center
nnoremap <up>   gk
nnoremap <down> gj

nnoremap <C-Up>   gg
nnoremap <C-Down> G

command! NoFoldenable set nofoldenable
command! Foldenable set foldenable

" pumvisible(): completion list?
function! s:Up()
	if pumvisible() == 0
		return "\<Up>"
	endif
	normal! gk
	" NOTE: 次の動作がないと，変換候補のメニューが消えない
	return "\<Left>\<Right>"
endfunction
function! s:Down()
	if pumvisible() == 0
		return "\<Down>"
	endif
	normal! gj
	" NOTE: 次の動作がないと，変換候補のメニューが消えない
	return "\<Left>\<Right>"
endfunction
" NOTE: neocomplete cache, omni補完(<expr>を利用するべき?)では適切に動作しない<C-o>が意図した動作にならない<C-r>を利用する必要がある
" inoremap <Up> <C-o>:call <SID>Up()<CR>
" inoremap <Down> <C-o>:call <SID>Down()<CR>
inoremap <Up> <C-r>=<SID>Up()<CR>
inoremap <Down> <C-r>=<SID>Down()<CR>

" [Big Sky :: vimでスクリプト内関数を書き換える]( https://mattn.kaoriya.net/software/vim/20090826003359.htm )
" fnameは完全一致後に正規表現で比較
function! GetScriptID(fname)
	let snlist = ''
	redir => snlist
	silent! scriptnames
	redir END
	let smap = {}
	let mx = '^\s*\(\d\+\):\s*\(.*\)$'
	for line in split(snlist, "\n")
		let smap[tolower(substitute(line, mx, '\2', ''))] = substitute(line, mx, '\1', '')
	endfor
	if has_key(smap, tolower(a:fname))
		return smap[tolower(a:fname)]
	endif
	for key in keys(smap)
		let val = smap[key]
		if key =~ a:fname
			return val
		endif
	endfor
	return ''
endfunction

function! GetFunc(fname, funcname, ...)
	" NOTE: function's captial has to start uppercase
	let Default_func = get(a:, 1, {x->x})
	let sid = GetScriptID(a:fname)
	" NOTE: 関数の存在確認(global関数ならばexists())
	" [vim \- VimL: Checking if function exists \- Stack Overflow]( https://stackoverflow.com/questions/13710364/viml-checking-if-function-exists )
	silent! let F = function("<SNR>".sid."_".a:funcname)
	if F == 0
		return Default_func
	endif
	return F
endfunction

let s:vim_smartinput__trigger_or_fallback={x,y -> "\<C-G>u\<CR>" }
augroup get_function_group
	autocmd!
	autocmd User VimEnterDrawPost let s:vim_smartinput__trigger_or_fallback=GetFunc('vim-smartinput/autoload/smartinput.vim','_trigger_or_fallback', s:vim_smartinput__trigger_or_fallback)
augroup END

" Enterで補完決定(no additional <CR>)
" i  <CR>        & <SNR>71__trigger_or_fallback("\<CR>", "\<CR>")
" inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"
" [vim\-smartinput/smartinput\.vim at master · kana/vim\-smartinput]( https://github.com/kana/vim-smartinput/blob/master/autoload/smartinput.vim#L318 )
function! s:CR()
	if pumvisible()
		return "\<C-Y>"
	endif
	" NOTE: <C-g>uは undo を分割する
	return "\<C-g>u".s:vim_smartinput__trigger_or_fallback("\<CR>","\<CR>")
endfunction
inoremap <buffer> <script> <expr> <CR> <SID>CR()

cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" NOTE: dangerous exit commands
nnoremap ZZ <nop>
nnoremap ZQ <nop>

" NOTE: dやc始まりだと，カーソル下の字が消去されない
" mainly for cpp
" `.`: period
" `->`: arrow
" nnoremap dp vf.da.
" nnoremap dP vF.da.
" nnoremap da vf-da->
" nnoremap dA vF-da->

command! -nargs=0 -range TrimSpace <line1>,<line2>:s/^\s*\(.\{-}\)\s*$/\1/ | nohlsearch
command! -nargs=0 -range TrimLeftSpace <line1>,<line2>:s/^\s*\(.\{-}\)$/\1/ | nohlsearch
command! -nargs=0 -range TrimRightSpace <line1>,<line2>:s/^\(.\{-}\)\s*$/\1/ | nohlsearch

" for function args movement
" in insert mode <C-o> + below key
nnoremap , f,
nnoremap < F(
nnoremap > f)
nnoremap ( f(
nnoremap ) F)

" for search
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
" visual mode中のnは検索ワードを選択する
function! s:select_search(key)
	if v:hlsearch == 0
		if a:key ==# 'n'
			normal! nzz
		endif
		if a:key ==# 'N'
			normal! Nzz
		endif
	else
		let [line_start, column_start] = getpos("'<")[1:2]
		let [line_end, column_end] = getpos("'>")[1:2]
		call cursor(line_start, column_start)
		if line_start != line_end || column_start != column_end
			if a:key ==# 'n'
				call cursor(line_end, column_end)
				call search(@/, '')
			endif
			if a:key ==# 'N'
				call search(@/,'b')
			endif
		endif
		normal! v
		call search(@/, 'e')
	endif
endfunction
vnoremap n :call <sid>select_search('n')<CR>
vnoremap N :call <sid>select_search('N')<CR>
" vnoremap * *zz
" vnoremap # #zz
vnoremap * "zy:let @/ = @z<CR>n
vnoremap # "zy:let @/ = @z<CR>N

" 貼り付けたテキストを選択する
" gv: select pre visual selected range
noremap gV `[v`]
command! -nargs=0 LastPaste normal! `[v`]
" move to last edited
map gb `.zz
command! -nargs=0 LastEdit normal! `.zz

" 現在の行の中央へ移動
" [vimで行の中央へ移動する - Qiita]( http://qiita.com/masayukiotsuka/items/683ffba1e84942afbb97?utm_campaign=popular_items&utm_medium=referral&utm_source=popular_items )
" middle
" scorll-horizontal
" zs,ze
function! s:scroll_to_center(center)
	normal! 00
	let zl_cnt=a:center-s:get_window_width()/2
	if zl_cnt>0
		call s:zl(zl_cnt)
	endif
	call cursor('.', a:center)
endfunction
nnoremap zm :call <SID>scroll_to_center(strlen(getline("."))/2)<CR>
nnoremap zM :call <SID>scroll_to_center(col('.'))<CR>
function! s:get_window_width()
	let tmp=&virtualedit
	set virtualedit=all
	let pos=getpos('.')
	norm! g$
	let width=virtcol('.')
	call setpos('.', pos)
	execute('set virtualedit='.tmp)
	return width
endfunction
function! s:zh(number)
	execute('normal! '.a:number.'zh')
endfunction
function! s:zl(number)
	execute('normal! '.a:number.'zl')
endfunction
function! s:zH()
	let half_window_width=s:get_window_width()/2
	call s:zh(half_window_width)
endfunction
function! s:zL()
	let half_window_width=s:get_window_width()/2
	call s:zl(half_window_width)
endfunction
" zH, zLでは中心に移動できない
nnoremap zh :call <SID>zH()<CR>
nnoremap zl :call <SID>zL()<CR>
nnoremap zH :call <SID>zh(1)<CR>
nnoremap zL :call <SID>zl(1)<CR>

" visual mode
" vnoremap j <Down>
" vnoremap k <Up>

vnoremap <C-h> <Left>
vnoremap <C-j> <Down>
vnoremap <C-k> <Up>
vnoremap <C-l> <Right>

nnoremap <C-h> <Left>
nnoremap <C-j> <Down>
nnoremap <C-k> <Up>
nnoremap <C-l> <Right>

" undo
inoremap <C-u> <C-o>u
" redo
inoremap <C-r> <C-o><C-r>

inoremap <C-x>e <ESC>
inoremap <C-x><C-e> <ESC>

" bg
inoremap <C-z> <ESC><C-z>

" toggle relativenumber
nnoremap <Space>l :<C-u>setlocal relativenumber!<CR>
" toggle AnsiView
nnoremap <Space>a :AnsiEsc<CR>

" nnoremap { <PageUp>
" nnoremap } <PageDown>
" nnoremap [ <PageUp>
" nnoremap ] <PageDown>

" ##############
" #### mark ####

let mkeys = [
			\'"',
			\'^',
			\'(',
			\')',
			\'{',
			\'}',
			\'[',
			\']',
			\'<',
			\'>',
			\'.',
			\"'",
			\]
for key in mkeys
	execute 'nnoremap g'.key." '".key
	execute 'nnoremap m'.key." '".key
	execute 'nnoremap M'.key." '".key
endfor

" Mark & Start
" nnoremap ms this means mark as 's' register
" Mark & Yank
nnoremap my y's
" Mark & Cut
nnoremap mc d's

" goto middle line of window
nnoremap MM M
" goto any marks[a~zA~Z]
nnoremap M '
" #### mark ####
" ##############

" no yank by x or s
nnoremap x "_x
nnoremap s "_s
vnoremap x "_x
" vnoremap d "_d
vnoremap s "_s
function! s:visual_mode_paste(...)
	let content = get(a:, 1, @+)
	let vm = visualmode()
	if vm ==# 'v'
	elseif vm ==# 'V'
		normal! 00
	else
	endif
	call <SID>paste_at_cursor(col('.')!=col('$')-1, content)
	if vm ==# 'v'
	elseif vm ==# 'V'
		execute "normal! a\<CR>"
	endif
endfunction
vnoremap p "_x:call <SID>visual_mode_paste()<CR>

" visual modeで囲んだ箇所全体を対象として，'AndrewRadev/switch.vim'のswitchと同様な処理を行う
function! s:switch()
	let target = @z

	for def in g:switch_custom_definitions
		" ['foo', 'bar', 'baz']
		if type(def) == type([])
			let patterns = def
			let index = -1
			for pattern in patterns
				let index+=1
				if target ==# pattern
					let next_pattern = patterns[(index+1)%len(patterns)]
					let target = next_pattern
					break
				endif
			endfor
		elseif type(def) == type({})
			for pattern in keys(def)
				let match = matchstr(target, pattern)
				if match !=# target
					continue
				endif
				let result = def[pattern]
				" {'#include <\([a-zA-Z0-9/\-_.]\+\)>' : '#include "\1"', '#include "\([a-zA-Z0-9/\-_.]\+\)"' : '#include <\1>'},
				if type(result) == type('')
					let target = substitute(target, pattern, result, '')
					" {
					"   "^[^']*'[^']*$" : {"'":'"'},
					"   "^[^\"]*\"[^\"]*$" : {'"':"'"},
					" }
				elseif type(result) == type({})
					for pattern2 in keys(result)
						if target =~# pattern2
							let result2 = result[pattern2]
							let target = substitute(target, pattern2, result2, '')
							break
						endif
					endfor
				else
					echom 'unknown type:'
					PP result
				endif
				break
			endfor
		endif
	endfor
	call <SID>visual_mode_paste(target)
	" select yanked range
	normal! `[v`]
endfunction
vnoremap <C-x> "zd:call <SID>switch()<CR>

function! s:V()
	let m=visualmode()
	if m ==# 'V'
		normal! gvy
	else
		normal! gvV
	endif
endfunction
vnoremap v y
vnoremap V :<C-u>call <SID>V()<CR>

" delete all lines at buffer without copy
command! -nargs=0 Delete normal ggVGx

" NOTE: 理由は不明だが，Ubuntuでgxが機能しないため
function! OpenURL()
	let line = getline(".")
	let url = matchstr(line, '\(http\(s\)\?://[^ ]\+\)', 0)
	echom 'open url:'.url
	if has('mac')
		call system("open ".url)
	elseif !has('win')
		call system("xdg-open &>/dev/null ".url)
	else
		echo 'not supported at windows!'
	endif
endfunction
" to rewrite : n  gx @<Plug>Markdown_OpenUrlUnderCursor
augroup gx_group
	autocmd!
	" BufReadPost is for unnamed tab and load file
	autocmd User VimEnterDrawPost nnoremap <buffer> gx :call OpenURL()<CR>
	autocmd BufReadPost * nnoremap <buffer> gx :call OpenURL()<CR>
augroup END

function! s:yank_pwd()
	let @+ = '.' " default value
	let @+ = expand('%:p:h')
endfunction
" nnoremap wd :call <SID>yank_pwd()<CR>
command! WorkingDirectory call <SID>yank_pwd()
" cd to editting file dir
command! -nargs=0 CD cd %:h
" ##############

" vim tab control
" nnoremap ? :tabnew<CR>
" nnoremap > :tabn<CR>
" nnoremap < :tabp<CR>

" vim window control
" :sp	水平分割
" :vs	垂直分割
" :e <tab>

" ウィンドウ切り替え
nnoremap <C-w> <C-w><C-w>
" 現在のウィンドウのサイズ調整
nnoremap <C-w>, <C-w><
nnoremap <C-w>. <C-w>>
nnoremap <C-w>; <C-w>+
"nnoremap <C-w>- <C-w>-

" entire select
" function! s:copy_all()
" 	" NOTE: 改行コードが変化する可能性
" 	let l:source = join(getline(1, '$'), "\n")
" 	let @+=l:source
" endfunction
" command! -nargs=0 CopyAll call s:copy_all()
command! -nargs=0 CopyAll :%y

" <Nul> means <C-Space>
" [vim のkeymapでCtrl-Spaceが設定できなかったので調べてみた。 - dgdgの日記]( http://d.hatena.ne.jp/dgdg/20080109/1199891258 )
imap <Nul> <C-x><C-o>

" [\[Vim\] インサートモードで行頭や行末へ移動する方法 ~ 0から始めるvim ~]( https://qiita.com/ymiyamae/items/cea5103c65184f55d62e )
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
vnoremap <C-a> ^
vnoremap <C-e> $<Left>
vnoremap $ $<Left>

" FYI: [dogfiles/vimrc at master · rhysd/dogfiles]( https://github.com/rhysd/dogfiles/blob/master/vimrc#L254 )
" quickfix -> main windowの順に閉じる
function! s:close(force)
	let l:flag=''
	let l:w=''
	if !(&bt == 'quickfix' || &bt == 'nofile')
		let save_winnr = winnr()
		windo if l:flag=='' && (&bt=='quickfix' || &bt=='nofile') | let l:flag=&bt | let l:w=winnr() | endif
	exe save_winnr. 'wincmd w'
endif
if l:flag!=''
	if l:flag=='quickfix'
		ccl
	elseif l:flag=='nofile'
		exe l:w.'wincmd c'
	endif
else
	if a:force
		q!
	else
		try
			q
		catch
			echohl ErrorMsg
			echomsg v:exception
			echohl None
		endtry
	endif
endif
endfunction

function! s:get_window_n()
	let wn=0
	let save_winnr = winnr()
	windo let wn+=1
	exe save_winnr. 'wincmd w'
	return wn
endfunction
function! s:last_window_event()
	if &ft == 'vimconsole'
		q
	endif
endfunction
augroup auto_window_quit
	autocmd!
	autocmd WinEnter,BufWinEnter,BufEnter * if s:get_window_n() == 1 | call s:last_window_event() | endif
augroup END
" save and quit
" write all
nnoremap wa :wa<CR>
nnoremap wq :wq<CR>
nnoremap ww :w<CR>
nnoremap qq :call <SID>close(0)<CR>
nnoremap q! :call <SID>close(1)<CR>
" sudo save
nnoremap w! :w !sudo tee > /dev/null %<CR> :e!<CR>
cnoremap w! w !sudo tee > /dev/null %<CR> :e!<CR>
function! s:cmdwin_setting()
	nnoremap <buffer> qq :q<CR>
endfunction
augroup cmdline_window
	autocmd!
	autocmd CmdwinEnter * call s:cmdwin_setting()
augroup END

" at cmdline window
" default completion c-n, c-p
augroup cmdline_compl
	autocmd!
	autocmd CmdwinEnter * autocmd InsertCharPre <buffer> call feedkeys("\<C-n>\<C-p>", 'n')
augroup END

" psate
function! s:paste_at_cursor_with_str(Pflag, prefix, suffix)
	let l:tmp=@+
	" 最後の連続改行を削除することで，カーソル位置からの貼り付けとなる
	let @+=substitute(a:prefix.@+.a:suffix, '\n*$', '', '')
	" 	if a:Pflag
	" 		normal! P
	" 	else
	" 		normal! p
	" 	endif
	let @z=@+
	let @+=l:tmp
endfunction
" psate
function! s:paste_at_cursor(Pflag, ...)
	let content = get(a:, 1, @+)
	" 最後の連続改行を削除することで，カーソル位置からの貼り付けとなる
	let content=substitute(content, '\n*$', '', '')
	let @p = content
	if a:Pflag
		normal! "pP
	else
		normal! "pp
	endif
endfunction
inoremap <C-v> <ESC>:call <SID>paste_at_cursor(0)<CR>i
nnoremap <C-v> :call <SID>paste_at_cursor(1)<CR>

function! s:paste_at_cmdline()
	let clipboard=@+
	let clipboard=substitute(clipboard, '\n', ' ', '')
	" [gvim \- How to remove this symbol "^@" with vim? \- Super User]( https://superuser.com/questions/75130/how-to-remove-this-symbol-with-vim )
	let clipboard=substitute(clipboard, '\%x00', '', '')
	let cmd = getcmdline() . clipboard
	call setcmdpos(strlen(cmd)+1)
	return cmd
endfunction
" NOTE: gxコマンドではなく，直接URLを貼り付けて開くこと
" [cmdline \- Vim日本語ドキュメント]( http://vim-jp.org/vimdoc-ja/cmdline.html#c_CTRL-\_e )
cnoremap <C-v> <C-\>e<SID>paste_at_cmdline()<CR>

" function! s:has_prefix(str, prefix)
" 	return a:str[:strlen(a:prefix)-1] == a:prefix
" endfunction
" " NOTE: 検索時の先頭の'/'はgetcmdline()には含まれないため，':'のときに次の関数を呼び出してもは適切な挙動にはならない
" function! s:to_search()
" 	" 	let cmd = getcmdline()
" 	let cmd = g:cmd_tmp
" 	if s:has_prefix(cmd, '%smagic/')
" 		let cmd = '\v'.cmd[8:]
" 	elseif s:has_prefix(cmd, '%s/')
" 		let cmd = ''.cmd[3:]
" 	endif
" 	call setcmdpos(strlen(cmd)+1)
" 	return cmd
" endfunction
" " NOTE: 以前の検索対象のみがハイライトされる
" function! s:to_replace()
" 	let cmd = g:cmd_tmp
" 	if s:has_prefix(cmd, '\v')
" 		let cmd = '%smagic/'.cmd[2:]
" 	elseif !s:has_prefix(cmd, '%s/') && !s:has_prefix(cmd, '%smagic/')
" 		let cmd = '%s/'.cmd[0:]
" 	endif
" 	call setcmdpos(strlen(cmd)+1)
" 	return cmd
" endfunction
" function! s:cmd_copy()
" 	let g:cmd_tmp = getcmdline()
" 	let @/='' " to avoid no hit error
" 	return ""
" endfunction
" cnoremap <C-o>f     <C-\>e<SID>cmd_copy()<CR><C-c>/<C-\>e<SID>to_search()<CR>
" cnoremap <C-o><C-f> <C-\>e<SID>cmd_copy()<CR><C-c>/<C-\>e<SID>to_search()<CR>
" cnoremap <C-o>r     <C-\>e<SID>cmd_copy()<CR><C-c>:<C-\>e<SID>to_replace()<CR>
" cnoremap <C-o><C-r> <C-\>e<SID>cmd_copy()<CR><C-c>:<C-\>e<SID>to_replace()<CR>

function! s:swap_search_replace_pattern()
	let cmd = getcmdline()
	let cmdtype = getcmdtype()
	if cmdtype == '/' || cmdtype == '?'
		if cmd =~# '^\W*\\v'
			return substitute(cmd, '\\v', '\\V', '')
		elseif cmd =~# '^\W*\\V'
			return substitute(cmd, '\\V', '', '')
		else
			return '\v'.cmd
		endif
	endif
	if cmdtype == ':'
		if cmd =~ '^\W*%smagic'
			return substitute(cmd, '%smagic', '%sno', '')
		elseif cmd =~ '^\W*%sno'
			return substitute(cmd, '%sno', '%s', '')
		elseif cmd =~ '^\W*%s'
			return substitute(cmd, '%s', '%smagic', '')
		endif
	endif
	return cmd
endfunction
cnoremap <C-x> <C-\>e<SID>swap_search_replace_pattern()<CR>

cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" [\.vim/\.vimrc at master · cohama/\.vim]( https://github.com/cohama/.vim/blob/master/.vimrc#L947 )
" / で検索するときに単語境界をトグルする
cnoremap <C-f> <C-\>eToggleWordBounds(getcmdtype(), getcmdline())<CR>
function! ToggleWordBounds(type, line)
	if a:type == '/' || a:type == '?'
		if a:line =~# '^\\<.*\\>$'
			return substitute(a:line, '^\\<\(.*\)\\>$', '\1', '')
		else
			return '\<' . a:line . '\>'
		endif
	else
		return a:line
	endif
endfunction
" / と :s///g をトグルする
cnoremap <expr> <C-e> ToggleSubstituteSearch(getcmdtype(), getcmdline())
function! ToggleSubstituteSearch(type, line)
	if a:type == '/' || a:type == '?'
		let range = GetOnetime('s:range', '%')
		return "\<End>\<C-U>\<BS>" . substitute(a:line, '^\(.*\)', ':' . range . 's/\1', '')
	elseif a:type == ':'
		let g:line = a:line
		let [s:range, expr] = matchlist(a:line, '^\(.*\)s\%[ubstitute]\/\(.*\)$')[1:2]
		if s:range == "'<,'>"
			call setpos('.', getpos("'<"))
		endif
		return "\<End>\<C-U>\<BS>" . '/' . expr
	endif
endfunction
function! GetOnetime(varname, defaultValue)
	if exists(a:varname)
		let varValue = eval(a:varname)
		execute 'unlet ' . a:varname
		return varValue
	else
		return a:defaultValue
	endif
endfunction

" dynamic highlight search
" very magic
" [Vimでパターン検索するなら知っておいたほうがいいこと \- derisの日記]( http://deris.hatenablog.jp/entry/2013/05/15/024932 )
nnoremap se :set hlsearch<CR>:set incsearch<CR>/\V
nnoremap / :set hlsearch<CR>:set incsearch<CR>/\V
nnoremap ? :set hlsearch<CR>:set incsearch<CR>?\V
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" [Simplifying regular expressions using magic and no\-magic \| Vim Tips Wiki \| FANDOM powered by Wikia]( http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic )
" cnoremap %m %smagic/
cnoremap %s %sno/
" replace by raw string
" cnoremap %n %sno/
" cnoremap \>s/ \>smagic/
" nnoremap g/ :g/\v
" cnoremap g/ g/\v

" /{pattern}の入力中は「/」をタイプすると自動で「\/」が、
" ?{pattern}の入力中は「?」をタイプすると自動で「\?」が 入力されるようになる
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" [俺的にはずせない【Vim】こだわりのmap（説明付き） \- Qiita]( https://qiita.com/itmammoth/items/312246b4b7688875d023 )
" カーソル下の単語をハイライトしてから置換する
" `"z`でzレジスタに登録してからsearch
nnoremap grep "zyiw:let @/='\<'.@z.'\>'<CR>:set hlsearch<CR>
vnoremap grep "zy:let @/=@z<CR>:set hlsearch<CR>
nnoremap sed :set hlsearch<CR>:%s%<C-r>/%%gc<Left><Left><Left>
vnoremap sed "zy:let @/ = @z<CR>:set hlsearch<CR>:%s%<C-r>/%%gc<Left><Left><Left>

" <C-p>, <C-q>: 前方一致ではなく愚直に履歴を辿る。
" カーソルキーの上下は前方一致
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" cnoremap <C-p> <S-Tab>
" cnoremap <C-n> <Tab>

nnoremap src :source ~/.vimrc<CR>
" :Src
" :Src .
function! s:source(...)
	let l:file = get(a:, 1, expand('~/.vimrc'))
	echo 'source ' . l:file
	call system('source ' . l:file)
endfunction
command! -nargs=? Src call s:source(<f-args>)

command! FileName :let @+ = expand('%:t')     | echo 'copyed:' . expand('%:t')
command! FilePath :let @+ = expand('%:p')     | echo 'cooyed:' . expand('%:p')
command! DirPath  :let @+ = expand('%:p:h')   | echo 'cooyed:' . expand('%:p:h')
command! DirName  :let @+ = expand('%:p:h:t') | echo 'cooyed:' . expand('%:p:h:t')
command! CopyFileName :let @+ = expand('%:t')     | echo 'copyed:' . expand('%:t')
command! CopyFilePath :let @+ = expand('%:p')     | echo 'cooyed:' . expand('%:p')
command! CopyDirPath  :let @+ = expand('%:p:h')   | echo 'cooyed:' . expand('%:p:h')
command! CopyDirName  :let @+ = expand('%:p:h:t') | echo 'cooyed:' . expand('%:p:h:t')

" [TabとCtrl\-iどちらを入力されたか区別する\(Linux限定\) \- Qiita]( https://qiita.com/norio13/items/9c05412796a7dea5cd91 )
" <Tab> == <C-i>
" insert new line at pre line
" nnoremap <C-o> mzO<ESC>`z
" insert new line at next line
" nnoremap <C-i> mzo<ESC>`z

" tab
nnoremap <Tab> >>
nnoremap <S-Tab> <<
" vnoremap <Tab> >>
" vnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" 文字数をカウントした方がよさそう
" 行をまたぐとずれるpasteした範囲とgvは異なる
" visual paste関数と組み合わせる?
function! s:move_block(direction)
	let n = { s -> strlen(substitute(s, ".", "x", "g"))}(@z)
	if a:direction < 0
		execute "normal! \<Left>\"zP".(n-1)."\<Left>v".(n-1)."\<Right>"
	elseif a:direction > 0
		execute "normal! \<Right>\"zP".(n-1)."\<Left>v".(n-1)."\<Right>"
	endif
endfunction
vnoremap <S-Left> "zd:call <SID>move_block(-1)<CR>
vnoremap <S-Right> "zd:call <SID>move_block(1)<CR>
" <Left>"zPgv<Left>o<left>o

" 左回り
vnoremap <silent> <C-g> o<Right>"zd<Left>"zPgvo<Left>o
" 右回り
vnoremap <silent> <C-r> <Left>"zd<Right>"zPgv<Right>

nnoremap Y y$

" s means surround
let surround_key_mappings=[
			\{'keys':["`","bq"],                     'prefix':"`",    'suffix':"`"},
			\{'keys':["'","sq"],                     'prefix':"'",    'suffix':"'"},
			\{'keys':["\"","dq"],                    'prefix':'\"',   'suffix':'\"'},
			\{'keys':["<","lt"],                     'prefix':"<",    'suffix':">"},
			\{'keys':["(","pa","pt","kakko"],        'prefix':"(",    'suffix':")"},
			\{'keys':["[","br","ary","list"],        'prefix':"[",    'suffix':"]"},
			\{'keys':["{","sb","dict","map","func"], 'prefix':"{",    'suffix':"}"},
			\{'keys':["code","tbq"],                 'prefix':'```\n','suffix':"```"},
			\{'keys':["_","us","ub","ud","fold"],    'prefix':"__",   'suffix':"__"},
			\]
" 			\{'keys':["\<Space>"],                   'prefix':" ",    'suffix':" "},
for mapping in surround_key_mappings
	let prefix=mapping['prefix']
	let suffix=mapping['suffix']
	for key in mapping['keys']
		" 		execute "vnoremap s".key." c<C-o>:let @z=\"".prefix."\".@+.\"".suffix."\"\<CR>\<C-r>\<C-o>z\<Esc>"
		execute "vnoremap s".key." \"yc<C-o>:let @z=\"".prefix."\".@y.\"".suffix."\"<CR><C-r><C-o>z<Esc>"
		if key[0] =~ '\W'
			execute "vnoremap ".key." \"yc<C-o>:let @z=\"".prefix."\".@y.\"".suffix."\"<CR><C-r><C-o>z<Esc>"
		endif
	endfor
endfor
vnoremap s<Space> c<C-o>:let @z=' '.@+.' '<CR><C-r><C-o>z<Esc>
vnoremap <Space> c<C-o>:let @z=' '.@+.' '<CR><C-r><C-o>z<Esc>

" [visual \- Vim日本語ドキュメント]( https://vim-jp.org/vimdoc-ja/visual.html )
vnoremap ikakko ib
vnoremap akakko ab
vnoremap iary i]
vnoremap aary a[
vnoremap ielem i]
vnoremap aelem a[
vnoremap ielem i]
vnoremap aelem a[
vnoremap idq i"
vnoremap adq a"
vnoremap isq i'
vnoremap asq a'
vnoremap ibq i`
vnoremap abq a`

" to avoid entering ex mode
nnoremap Q <Nop>
" to avoid entering command line window mode
nnoremap q: <Nop>
" to avoid entering recoding mode
" [What is vim recording and how can it be disabled? \- Stack Overflow]( https://stackoverflow.com/questions/1527784/what-is-vim-recording-and-how-can-it-be-disabled )
nnoremap q <Nop>
nnoremap Q q
command! CmdlineWindow call feedkeys("q:", "n")

" [\.vim/\.vimrc at master · cohama/\.vim]( https://github.com/cohama/.vim/blob/master/.vimrc#L1362 )
" 矩形選択でなくても複数行入力をしたい
xnoremap <expr> I MultipleInsersion('I')
xnoremap <expr> A MultipleInsersion('A')
function! MultipleInsersion(next_key)
	if mode() ==# 'v'
		return "\<C-v>" . a:next_key
	elseif mode() ==# 'V'
		return "\<C-v>0o$" . a:next_key
	else
		return a:next_key
	endif
endfunction

" cdcurrent
command! CdCurrent cd %:p:h
command! LcdCurrent lcd %:p:h

" auto comment off
augroup auto_comment_off
	autocmd!
	" <CR>
	" 	autocmd BufEnter * setlocal formatoptions-=r
	" o, O
	autocmd BufEnter * setlocal formatoptions-=o
augroup END

" for external command
nnoremap ! :! 
