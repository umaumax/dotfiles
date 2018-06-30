" set <Leader>
let mapleader = "\<Space>"

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>

" " cursor movement in insert mode
inoremap <C-h> <Left>
inoremap <C-j> <ESC>:call <SID>Down()<CR>i
inoremap <C-k> <ESC>:call <SID>Up()<CR>i
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
" zz: set cursor center
" nnoremap k kzz
" nnoremap j jzz
nnoremap <Up>   gk
nnoremap <Down> gj

nnoremap <C-Up>   gg
nnoremap <C-Down> G

" pumvisible(): completion list?
function! s:Up()
	if pumvisible() == 0
		normal! gk
	endif
endfunction
function! s:Down()
	if pumvisible() == 0
		normal! gj
	endif
endfunction
imap <Up> <C-o>:call <SID>Up()<CR>
imap <Down> <C-o>:call <SID>Down()<CR>
" Enterで補完決定(no additional <CR>)
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"

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
vnoremap n nzz
vnoremap N Nzz
vnoremap * *zz
vnoremap # #zz

" 貼り付けたテキストを選択する
" gv: select pre visual selected range
noremap gV `[v`]

" NOTE: カーソル位置によってはexapnd or shrink
" expand range one char both side
" vnoremap m <Right>o<Left>o
" vnoremap <Space> <Right>o<Left>o
" vnoremap <Space><Space> <Right>o<Left>o

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
" word copy
vnoremap j iwv
" word cut
vnoremap k iwc<ESC>

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
vnoremap d "_d
vnoremap s "_s
vnoremap p "_x:call <SID>paste_at_cursor(1)<CR>

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
	autocmd VimEnter * nnoremap <buffer> gx :call OpenURL()<CR>
augroup END

function! s:yank_pwd()
	let @+ = '.' " default value
	let @+ = expand('%:p:h')
endfunction
nnoremap wd :call <SID>yank_pwd()<CR>
" cd to editting file dir
command! -nargs=0 CD cd %:h
" ##############

" " space -> tab replace
" nnoremap 1t :%s/^\(\t*\) /\1\t/g<CR>
" nnoremap 2t :%s/^\(\t*\)  /\1\t/g<CR>
" nnoremap 3t :%s/^\(\t*\)   /\1\t/g<CR>
" nnoremap 4t :%s/^\(\t*\)    /\1\t/g<CR>
" " tab -> space replace
" nnoremap 0T :%s/^\( *\)\t/\1/g<CR>
" nnoremap 1T :%s/^\( *\)\t/\1 /g<CR>
" nnoremap 2T :%s/^\( *\)\t/\1  /g<CR>
" nnoremap 3T :%s/^\( *\)\t/\1   /g<CR>
" nnoremap 4T :%s/^\( *\)\t/\1    /g<CR>

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
" TODO
" nnoremap <C-a> ggVG
function! s:copy_all()
	" NOTE: 改行コードが変化する可能性
	let l:source = join(getline(1, '$'), "\n")
	" 	let l:view = winsaveview()
	" 	" 	normal! ggVGV
	" 	" 	execute "normal! ggVGV"
	" 	silent call winrestview(l:view)
	" 	echo 'This current file has copied!'
	let @+=l:source
endfunction
command! -nargs=0 CopyAll call s:copy_all()

" <Nul> means <C-Space>
" [vim のkeymapでCtrl-Spaceが設定できなかったので調べてみた。 - dgdgの日記]( http://d.hatena.ne.jp/dgdg/20080109/1199891258 )
imap <Nul> <C-x><C-o>

" [\[Vim\] インサートモードで行頭や行末へ移動する方法 ~ 0から始めるvim ~]( https://qiita.com/ymiyamae/items/cea5103c65184f55d62e )
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
vnoremap <C-a> ^
vnoremap <C-e> $

" quickfix -> main windowの順に閉じる
function! s:close(force)
	let l:flag=0
	" 	if &ft != 'vim' && &bt != 'quickfix'
	if &bt != 'quickfix'
		let save_winnr = winnr()
		windo if !l:flag && &bt=='quickfix' | let l:flag=1 | endif
	exe save_winnr. 'wincmd w'
endif
if l:flag
	ccl
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
" save and quit
nnoremap wq :wq<CR>
nnoremap ww :w<CR>
" nnoremap qq :q<CR>
nnoremap qq :call <SID>close(0)<CR>
"nnoremap q! :q!<CR>
nnoremap q! :call <SID>close(1)<CR>
" sudo save
nnoremap w! :w !sudo tee > /dev/null %<CR> :e!<CR>
cnoremap w! w !sudo tee > /dev/null %<CR> :e!<CR>

" psate
function! s:paste_at_cursor(Pflag)
	let l:tmp=@+
	" 最後の連続改行を削除することで，カーソル位置からの貼り付けとなる
	let @+=substitute(@+, '\n*$', '', '')
	if a:Pflag
		normal! P
	else
		normal! p
	endif
	let @+=l:tmp
endfunction
inoremap <C-v> <ESC>:call <SID>paste_at_cursor(0)<CR>i
function! s:paste_at_cmdline()
	let clipboard=@+
	let clipboard=substitute(clipboard, '\n', ' ', '')
	" [gvim \- How to remove this symbol "^@" with vim? \- Super User]( https://superuser.com/questions/75130/how-to-remove-this-symbol-with-vim )
	let clipboard=substitute(clipboard, '\%x00', '', '')
	let cmd = getcmdline() . clipboard
	call setcmdpos(strlen(cmd)+1)
	return cmd
endfunction
" [cmdline \- Vim日本語ドキュメント]( http://vim-jp.org/vimdoc-ja/cmdline.html#c_CTRL-\_e )
cnoremap <C-v> <C-\>e<SID>paste_at_cmdline()<CR>

function! s:has_prefix(str, prefix)
	return a:str[:strlen(a:prefix)-1] == a:prefix
endfunction
" NOTE: 検索時の'/'は含まれないため，
" ':'のときには適切な挙動にはならない
function! s:to_search()
	" 	let cmd = getcmdline()
	let cmd = g:cmd_tmp
	if s:has_prefix(cmd, '%smagic/')
		let cmd = '\v'.cmd[8:]
	elseif s:has_prefix(cmd, '%s/')
		let cmd = ''.cmd[3:]
	endif
	call setcmdpos(strlen(cmd)+1)
	return cmd
endfunction
" NOTE: 以前の検索対象のみがハイライトされる
function! s:to_replace()
	let cmd = g:cmd_tmp
	if s:has_prefix(cmd, '\v')
		let cmd = '%smagic/'.cmd[2:]
	elseif !s:has_prefix(cmd, '%s/') && !s:has_prefix(cmd, '%smagic/')
		let cmd = '%s/'.cmd[0:]
	endif
	call setcmdpos(strlen(cmd)+1)
	return cmd
endfunction
function! s:cmd_copy()
	let g:cmd_tmp = getcmdline()
	let @/='' " to avoid no hit error
	return ""
endfunction
cnoremap <C-o>f     <C-\>e<SID>cmd_copy()<CR><ESC>/<C-\>e<SID>to_search()<CR>
cnoremap <C-o><C-f> <C-\>e<SID>cmd_copy()<CR><ESC>/<C-\>e<SID>to_search()<CR>
cnoremap <C-o>r     <C-\>e<SID>cmd_copy()<CR><ESC>:<C-\>e<SID>to_replace()<CR>
cnoremap <C-o><C-r> <C-\>e<SID>cmd_copy()<CR><ESC>:<C-\>e<SID>to_replace()<CR>

cnoremap <C-A> <Home>
cnoremap <C-E> <End>

" dynamic highlight search
" very magic
" [Vimでパターン検索するなら知っておいたほうがいいこと \- derisの日記]( http://deris.hatenablog.jp/entry/2013/05/15/024932 )
nnoremap se :set hlsearch<CR>:set incsearch<CR>/\v
nnoremap / :set hlsearch<CR>:set incsearch<CR>/\v
nnoremap ? :set hlsearch<CR>:set incsearch<CR>?\v
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" [Simplifying regular expressions using magic and no\-magic \| Vim Tips Wiki \| FANDOM powered by Wikia]( http://vim.wikia.com/wiki/Simplifying_regular_expressions_using_magic_and_no-magic )
cnoremap %m %smagic/
cnoremap %m %smagic/
cnoremap %s %smagic/
cnoremap %s %smagic/
" replace by raw string
cnoremap %n %sno/
cnoremap %n %sno/
cnoremap \>s/ \>smagic/
nnoremap g/ :g/\v
cnoremap g/ g/\v
" nnoremap :g// :g//

" [俺的にはずせない【Vim】こだわりのmap（説明付き） \- Qiita]( https://qiita.com/itmammoth/items/312246b4b7688875d023 )
" カーソル下の単語をハイライトしてから置換する
" `"z`でzレジスタに登録してからsearch
nnoremap grep "zyiw:let @/='\<'.@z.'\>'<CR>:set hlsearch<CR>
vnoremap grep "zy:let @/=@z<CR>:set hlsearch<CR>
nnoremap sed :set hlsearch<CR>:%s%<C-r>/%%gc<Left><Left><Left>
vnoremap sed "zy:let @/ = @z<CR>:set hlsearch<CR>:%s%<C-r>/%%gc<Left><Left><Left>

cnoremap <C-n>  <Down>
cnoremap <C-p>  <Up>

nnoremap src :source ~/.vimrc<CR>
" :Src
" :Src .
function! s:source(...)
	let l:file = get(a:, 1, expand('~/.vimrc'))
	echo 'source ' . l:file
	call system('source ' . l:file)
endfunction
command! -nargs=? Src call s:source(<f-args>)

command! FileName :let @+ = expand('%:t') | echo 'copyed:' . expand('%:t')
command! FilePath :let @+ = expand('%:p') | echo 'cooyed' . expand('%:p')

" [TabとCtrl\-iどちらを入力されたか区別する\(Linux限定\) \- Qiita]( https://qiita.com/norio13/items/9c05412796a7dea5cd91 )
" <Tab> == <C-i>
" insert new line at pre line
" nnoremap <C-o> mzO<ESC>`z
" insert new line at next line
" nnoremap <C-i> mzo<ESC>`z

" tab
nnoremap <Tab> >>
nnoremap <S-Tab> <<

vnoremap <Tab> >>
vnoremap <S-Tab> <<

nnoremap Y y$

" quote
" s means surround
vnoremap s<Space> c  <Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap s'     c''<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap ssq    c''<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap s"     c""<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sdq    c""<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap s<     c<><Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap slt    c<><Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap s(     c()<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap spa    c()<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap skakko c()<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap s[     c[]<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sbr    c[]<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sary   c[]<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap slist  c[]<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap s{     c{}<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap ssb    c{}<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sdict  c{}<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap smap   c{}<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sfunc  c{}<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap s`     c``<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sbq    c``<Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap scode  c```<CR><CR>```<ESC><Up>:call <SID>paste_at_cursor(0)<CR>
vnoremap stbq   c```<CR><CR>```<ESC><Up>:call <SID>paste_at_cursor(0)<CR>
vnoremap s_     c____<Left><Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sus    c____<Left><Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sud    c____<Left><Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sub    c____<Left><Left><ESC>:call <SID>paste_at_cursor(0)<CR>
vnoremap sfold  c____<Left><Left><ESC>:call <SID>paste_at_cursor(0)<CR>

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

" for external command
nnoremap ! :! 
