" paste with space
nnoremap gp a <ESC>p

nnoremap cc vc
nnoremap co i<CR><ESC>

" NOTE: nnoremap上で利用する場合に，`|`をescapeする必要がある
nnoremap <silent> <CR> :call setline('.', substitute(getline('.'), '\(\s\\|　\\|\r\)\+$', '', ''))<CR><CR>

nnoremap <Leader>p %

" disable <C-@>
inoremap <C-@> <C-[>

" NOTE: esc by jj
" inoremap <expr> j  getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'

nnoremap <leader>r :redraw!<CR>
command! -nargs=0 Redraw :redraw!

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>

" undo情報を保つ
inoremap <Left> <C-g>U<Left>

" cursor movement in insert mode
inoremap <C-h> <Left>
inoremap <C-k> <C-r>=<SID>Up()<CR>
inoremap <C-j> <C-r>=<SID>Down()<CR>
inoremap <C-l> <Right>

" NOTE: デフォルト割当のwindow移動を書き換え
" Delete and Backspace key
" inoremap <C-d> <Esc>lxi
inoremap <C-d> <Delete>
inoremap <C-f> <BS>
nnoremap <C-d> "_x
nnoremap <C-f> "_X
vnoremap <C-d> <Left>
vnoremap <C-f> <Right>
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
inoremap <silent> <Up> <C-r>=<SID>Up()<CR>
inoremap <silent> <Down> <C-r>=<SID>Down()<CR>

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

command! -nargs=0 -range TrimSpace      <line1>,<line2>:s/^\s*\(.\{-}\)\s*$/\1/ | nohlsearch
command! -nargs=0 -range TrimLeftSpace  <line1>,<line2>:s/^\s*\(.\{-}\)$/\1/    | nohlsearch
command! -nargs=0 -range TrimRightSpace <line1>,<line2>:s/^\(.\{-}\)\s*$/\1/    | nohlsearch

" for function args movement
" in insert mode <C-o> + below key
nnoremap , f,
" nnoremap < F(
" nnoremap > f)
nnoremap < 0
nnoremap > $
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
		let [line_end,   column_end]   = getpos("'>")[1:2]
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
" nnoremap gb `.zz
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

" undo: カーソル位置調整
function! s:U()
	let view = winsaveview()
	normal! u
	" NOTE: カーソルが先頭まで飛ぶ場合のほとんどはauto formatによるもの
	if col('.')==1 && line('.')==1
		silent call winrestview(view)
	endif
endfunction
nnoremap u :call <SID>U()<CR>
inoremap <C-u> <C-o>:call <SID>U()<CR>
" redo: カーソル位置調整
function! s:C_R()
	let view = winsaveview()
	execute "normal! \<C-r>"
	" NOTE: カーソルが先頭まで飛ぶ場合のほとんどはauto formatによるもの
	if col('.')==1 && line('.')==1
		silent call winrestview(view)
	endif
endfunction
nnoremap <C-r> :call <SID>C_R()<CR>
inoremap <C-r> <C-o>:call <SID>C_R()<CR>

inoremap <C-x>e <ESC>
inoremap <C-x><C-e> <ESC>

" bg
inoremap <C-z> <ESC><C-z>

" toggle relativenumber
nnoremap <Space>l :<C-u>setlocal relativenumber!<CR>
" toggle AnsiView
" nnoremap <Space>a :AnsiEsc<CR>

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
nnoremap dx "_dd
nnoremap dc ddi
vnoremap s "_s

function! s:vertical_paste()
	" NOTE: 1行でないと適切な動作とならない
	let @v=substitute(@+, "\n", "", 'g')
	let cmd="I\<C-r>v\<ESC>\<ESC>"
	if visualmode() == 'v' " 'v' or 'V'
		let cmd = "\<C-v>".cmd
	endif
	execute 'normal! gv'.cmd
endfunction
" NOTE: paste yanked string vertically
" NOTE: visual block かつ registerがone lineならば下記の単純なmappingでOK
" vnoremap <C-p> I<C-r>"<ESC><ESC>
vnoremap <C-p> <Esc>:call <SID>vertical_paste()<CR>

function! s:visual_mode_paste(...)
	let content = get(a:, 1, @+)
	let vm = visualmode()
	if vm ==# 'v'
	elseif vm ==# 'V'
		" NOTE: move to top of line
		normal! 00
		let last_char=content[len(content)-1]
		if last_char!="\n"
			let content.="\n"
		endif
	else
	endif
	" visual modeで切り取りを行った直後でカーソルが行の末尾場合の調整
	let is_line_end = getpos("'<")[2]==col('$')
	call <SID>paste_at_cursor(!is_line_end, content)
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
					if &rtp =~ 'vim-prettyprint'
						PP result
					else
						echo result
					endif
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
" don't add <silent>
command! -nargs=0 Delete normal! ggVG"_x

" NOTE: 理由は不明だが，Ubuntuでgxが機能しないため
function! OpenURL(...)
	let url=get(a:, 1, matchstr(getline("."), '\(http\(s\)\?://[^ ]\+\)', 0))
	echom 'open url:'.url
	if has('mac')
		call system("open '".url."'")
	elseif !has('win')
		call system("xdg-open &>/dev/null '".url."'")
	else
		echom 'not supported at windows!'
	endif
endfunction
" to overwrite : n  gx @<Plug>Markdown_OpenUrlUnderCursor
" augroup gx_group
" autocmd!
" " NOTE: BufReadPost is for unnamed tab and load file
" autocmd User VimEnterDrawPost nnoremap <buffer> gx :call OpenURL()<CR>
" autocmd BufReadPost * nnoremap <buffer> gx :call OpenURL()<CR>
" augroup END
nnoremap gx :call OpenURL()<CR>

function! s:yank_pwd()
	let @+ = '.' " default value
	let @+ = expand('%:p:h')
endfunction
" nnoremap wd :call <SID>yank_pwd()<CR>
command! WorkingDirectory call <SID>yank_pwd()
" ##############

" vim tab control
" nnoremap ? :tabnew<CR>
" nnoremap > :tabn<CR>
" nnoremap < :tabp<CR>

" vim window control
" :sp 水平分割
" :vs 垂直分割
" :e <tab>

" copy current buffer lines
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
	" NOTE: below silent! is for 'Not allowed to edit another buffer now'
	autocmd WinEnter,BufWinEnter,BufEnter * silent! if s:get_window_n() == 1 | call s:last_window_event() | endif
augroup END
" save and quit
" write all
nnoremap wa :wa<CR>
nnoremap wq :wq<CR>
nnoremap ww :w<CR>
nnoremap <silent> qq :call <SID>close(0)<CR>
nnoremap <silent> q! :call <SID>close(1)<CR>
" sudo save
" NOTE: below command is only for 'vim' not 'nvim'
if !has('nvim')
	nnoremap w! :w !sudo tee > /dev/null %<CR> :e!<CR>
	cnoremap w!  w !sudo tee > /dev/null %<CR> :e!<CR>
else
	if &rtp !~ 'suda.vim'
		nnoremap w! :w suda://%<CR>
		cnoremap w!  w suda://%<CR>
	else
		nnoremap w! :echom 'You need "lambdalisue/suda.vim" to save this file!'<CR>
		cnoremap w!  echom 'You need "lambdalisue/suda.vim" to save this file!'<CR>
	endif
endif

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

" paste
function! s:paste_at_cursor_with_str(Pflag, prefix, suffix)
	call s:set_cleaned_clipboard_at_reg('z', a:prefix.@+.a:suffix)
endfunction
function! s:paste_at_cursor(Pflag, ...)
	call s:set_cleaned_clipboard_at_reg('p', get(a:, 1, @+))
	if a:Pflag
		normal! "pP
	else
		normal! "pp
	endif
endfunction
function! s:set_cleaned_clipboard_at_reg(reg_char, ...)
	let content = get(a:, 1, @+)
	" 最後の連続改行を削除することで，カーソル位置からの貼り付けとなる
	" そうでない場合には次の行への貼り付けになってしまう
	let vm = visualmode()
	" NOTE:
	" 行選択状態では，次の行への貼付けを気にしない(むしろ，そのままのほうが良い)
	if vm !=# 'V'
		" NOTE: e.g. c-vでの貼り付けは改行を含んでいていも，カーソル位置に貼り付けたいため
		let content=substitute(content, '\n*$', '', '')
	endif
	call setreg(a:reg_char, content)
endfunction
inoremap <silent><C-v> <C-o>:call <SID>set_cleaned_clipboard_at_reg('p')<CR><C-r>p
nnoremap <silent><C-v> :call <SID>paste_at_cursor(1)<CR><Right>

function! s:paste_at_cmdline()
	let clipboard=@+
	let clipboard=substitute(clipboard, '\n', ' ', '')
	" [gvim \- How to remove this symbol "^@" with vim? \- Super User]( https://superuser.com/questions/75130/how-to-remove-this-symbol-with-vim )
	let clipboard=substitute(clipboard, '\%x00', '', '')
	let cmd = getcmdline() . clipboard
	call setcmdpos(strlen(cmd)+1)
	return cmd
endfunction
" NOTE: 下記のURLはvimのgxコマンドではなく，直接URLを貼り付けて開くこと(urlencodeされてしまうため)
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
nnoremap /  :set hlsearch<CR>:set incsearch<CR>/\V
nnoremap ?  :set hlsearch<CR>:set incsearch<CR>?\V
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

" nnoremap src :source ~/.vimrc<CR>
" :Src
" :Src .
function! s:source(...)
	let l:file = get(a:, 1, expand('~/.vimrc'))
	echo 'source ' . l:file
	call system('source ' . l:file)
endfunction
command! -nargs=? Src call s:source(<f-args>)

command! FileName     :let @+ = expand('%:t')               | echo '[COPY!]: ' . @+
command! FilePath     :let @+ = expand('%:p')               | echo '[COPY!]: ' . @+
command! FilePathNR   :let @+ = expand('%:p').':'.line('.') | echo '[COPY!]: ' . @+
command! DirPath      :let @+ = expand('%:p:h')             | echo '[COPY!]: ' . @+
command! DirName      :let @+ = expand('%:p:h:t')           | echo '[COPY!]: ' . @+
command! CopyFileName   :FileName
command! CopyFilePath   :FilePath
command! CopyFilePathNR :FilePathNR
command! CopyDirPath    :DirPath
command! CopyDirName    :DirName

" 文字数をカウントした方がよさそう
" visual paste関数と組み合わせる?
function! s:move_block(direction)
	let n = { s -> strlen(substitute(s, ".", "x", "g"))}(@z)
	" visual modeで切り取りを行った直後でカーソルが行の末尾場合の調整
	let is_line_end = getpos("'<")[2]==col('$')
	let paste_command = is_line_end ? 'p' : 'P'
	if a:direction < 0
		if col('.')==1
			let paste_command='p'
			execute "normal! \<Left>\"z".paste_command.(n-1)."\<Left>v".(n-1)."\<Right>"
		else
			execute "normal! \<Left>\"z".paste_command.(n-1)."\<Left>v".(n-1)."\<Right>"
		endif
	elseif a:direction > 0
		if col('.')==col('$')-1
			if !is_line_end
				let paste_command='p'
				execute "normal! \"z".paste_command.(n-1)."\<Left>v".(n-1)."\<Right>"
			else
				let paste_command='P'
				execute "normal! \<Right>\"z".paste_command.(n-1)."\<Left>v".(n-1)."\<Right>"
			endif
		else
			execute "normal! \<Right>\"z".paste_command.(n-1)."\<Left>v".(n-1)."\<Right>"
		endif
	endif
endfunction
" vnoremap <S-Left> "zd:call <SID>move_block(-1)<CR>
" vnoremap <S-Right> "zd:call <SID>move_block(1)<CR>
" <Left>"zPgv<Left>o<left>o
" NOTE: 't9md/vim-textmanip'
xmap <S-Down>  <Plug>(textmanip-move-down)
xmap <S-Up>    <Plug>(textmanip-move-up)
xmap <S-Left>  <Plug>(textmanip-move-left)
xmap <S-Right> <Plug>(textmanip-move-right)

" 左回り
vnoremap <silent> <C-g> o<Right>"zd<Left>"zPgvo<Left>o
" 右回り
vnoremap <silent> <C-r> <Left>"zd<Right>"zPgv<Right>

" 現在のカーソル位置から行末までをコピー
nnoremap Y y$

" s means surround
let surround_key_mappings=[
			\{'keys':["`","bq"],                     'prefix':"`",     'suffix':"`"},
			\{'keys':["'","sq"],                     'prefix':"'",     'suffix':"'"},
			\{'keys':["\"","dq"],                    'prefix':'\"',    'suffix':'\"'},
			\{'keys':["<","lt"],                     'prefix':"<",     'suffix':">"},
			\{'keys':["(","pa","pt","kakko"],        'prefix':"(",     'suffix':")"},
			\{'keys':["[","br","ary","list"],        'prefix':"[",     'suffix':"]"},
			\{'keys':["{","sb","dict","map","func"], 'prefix':"{",     'suffix':"}"},
			\{'keys':["c","tbq"],                    'prefix':'```\n', 'suffix':'\n```'},
			\{'keys':["$","var"],                    'prefix':'${',    'suffix':'}'},
			\{'keys':["do","run","exec"],            'prefix':'$(',    'suffix':')'},
			\{'keys':["_","us","ub","ud","fold"],    'prefix':"__",    'suffix':"__"},
			\]
" 			\{'keys':["\<Space>"],                   'prefix':" ",    'suffix':" "},
for mapping in surround_key_mappings
	let prefix=mapping['prefix']
	let suffix=mapping['suffix']
	for key in mapping['keys']

		" 		execute "vnoremap s".key." c<C-o>:let @z=\"".prefix."\".@+.\"".suffix."\"\<CR>\<C-r>\<C-o>z\<Esc>"
		execute "vnoremap s".key." \"yc<C-o>:let @z=\"".prefix."\".substitute(@y, '\\n*$', '', '').\"".suffix."\"<CR><C-r><C-o>z<Esc>"
		" NOTE: 記号の場合にはprefix:sはなし
		let top_char=key[0]
		if (top_char =~ '\W' || top_char == '_') && top_char != '$'
			execute "vnoremap ".key." \"yc<C-o>:let @z=\"".prefix."\".substitute(@y, '\\n*$', '', '').\"".suffix."\"<CR><C-r><C-o>z<Esc>"
		endif
	endfor
endfor
vnoremap s<Space> c<C-o>:let @z=' '.@+.' '<CR><C-r><C-o>z<Esc>
vnoremap <Space>  c<C-o>:let @z=' '.@+.' '<CR><C-r><C-o>z<Esc>
" NOTE: visual modeの状態がoで反転していないことを仮定
vnoremap sx <ESC>"_xgvo<ESC>"_xgvo<Left><Left>

" [visual \- Vim日本語ドキュメント]( https://vim-jp.org/vimdoc-ja/visual.html )
vnoremap ikakko ib
vnoremap akakko ab
vnoremap iary   i]
vnoremap aary   a[
vnoremap ielem  i]
vnoremap aelem  a[
vnoremap ielem  i]
vnoremap aelem  a[
vnoremap idq    i"
vnoremap adq    a"
vnoremap isq    i'
vnoremap asq    a'
vnoremap ibq    i`
vnoremap abq    a`

" to avoid entering ex mode
nnoremap Q <Nop>
" to avoid entering command line window mode
nnoremap q: <Nop>
" to avoid entering recoding mode
" [What is vim recording and how can it be disabled? \- Stack Overflow]( https://stackoverflow.com/questions/1527784/what-is-vim-recording-and-how-can-it-be-disabled )
nnoremap q <Nop>
nnoremap Q q

command! Wcmd                call feedkeys("q:", "n")
command! CmdlineWindow       call feedkeys("q:", "n")
command! Wsearch             call feedkeys("q/", "n")
command! SearchCmdlineWindow call feedkeys("q/", "n")

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

" NOTE: no arg  : just exec :NERDTreeCWD
" NOTE: with arg: exec :NERDTreeCWD at specific wd
function! NERDTreeCD(...)
	let new_wd = get(a:, 1, '')
	let cwd = getcwd()
	if &rtp =~ 'nerdtree'
		if exists(':NERDTreeCWD')
			if haslocaldir()
				execute 'lcd '.new_wd
			else
				execute 'cd '.new_wd
			endif
			:NERDTreeCWD
		endif
	endif
	if haslocaldir()
		execute 'lcd '.cwd
	else
		execute 'cd '.cwd
	endif
endfunction
function! CD()
	cd %:h
	" NOTE: cd with nerdtree
	call NERDTreeCD()
endfunction
function! LCD()
	lcd %:h
	" NOTE: cd with nerdtree
	call NERDTreeCD()
endfunction
command! -nargs=0 CD :call CD()
command! -nargs=0 LCD :call LCD()

if &rtp =~ 'nerdtree'
	function! NERDTreeToggleWrapper()
		if exists(':NERDTreeCWD')
			:NERDTreeToggle
		else
			" NOTE: 初回はそのファイルパスを基準に開く
			let dirpath=expand('%:p:h')
			:NERDTreeToggle
			call NERDTreeCD(dirpath)
		endif
	endfunction
	command! -nargs=0 NCD :call NERDTreeCD(expand('%:p:h'))
	nnoremap <silent><C-e> :call NERDTreeToggleWrapper()<CR>
endif

" up dir
command! U lcd %:h:h
command! CDGitRoot  execute "cd  ".system("git rev-parse --show-toplevel")
command! LCDGitRoot execute "lcd ".system("git rev-parse --show-toplevel")

" auto comment off
augroup auto_comment_off
	autocmd!
	" <CR>
	" 	autocmd BufEnter * setlocal formatoptions-=r
	" o, O
	autocmd BufEnter * setlocal formatoptions-=o
augroup END

" for external command
" NOTE: execute is used to avoid last space of a line
execute 'nnoremap ! :! '

" NOTE: rotate 行頭 → 非空白行頭 → 行
" ^[0000]$[0000]0
function! s:rotate_in_line()
	let c_now = col('.')
	normal! ^
	let c_hat = col('.')
	if c_now == 1 && c_hat != 1
		normal! ^
	elseif c_now == c_hat
		normal! $
	else
		normal! 0
	endif
endfunction
nnoremap <silent>0 :<C-u>call <SID>rotate_in_line()<CR>

" [インデントレベルが同じ行を探して移動する \- Qiita]( https://qiita.com/crispy/items/ff3522a327d0a7d7706b )
func! s:IndentSensitive(backward)
	let lineNum = line('.')
	let line = getline(lineNum)
	let col = col('.')
	call cursor(lineNum, 1)
	let indentLevel = s:getIndentLevel(line)
	let nextLine = getline(lineNum + (a:backward ? -1 : 1))
	let nextIndentLevel = s:getIndentLevel(nextLine)

	let pattern = printf('^[ \t]\{%d}[^ \t]', indentLevel)
	if indentLevel != nextIndentLevel
		let hitLineNum = search(pattern, 'n' . (a:backward ? 'b' : ''))
	else
		let lastLineNum = line('$')
		let hitLineNum = lineNum
		while 1 <= lineNum && lineNum <= lastLineNum
			let lineNum += a:backward ? -1 : 1
			if lineNum < 1
				break
			endif
			if s:getIndentLevel(getline(lineNum)) != indentLevel
				break
			end
			let hitLineNum = lineNum
		endwhile
	endif

	call cursor(hitLineNum, col)
endfunc
func! s:getIndentLevel(str)
	return len(matchstr(a:str, '^[ \t]*'))
endfunc
func! IndentSensitivePrev()
	call s:IndentSensitive(1)
endfunc
func! IndentSensitiveNext()
	call s:IndentSensitive(0)
endfunc
nnoremap <silent> t<Up> :call IndentSensitivePrev()<CR>
nnoremap <silent> t<Down> :call IndentSensitiveNext()<CR>
