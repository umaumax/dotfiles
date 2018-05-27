" cursor movement in insert mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Delete and Backspace key
" inoremap <C-d> <Esc>lxi
inoremap <C-d> <Delete>
inoremap <C-f> <BS>

" for seamless line movement
nnoremap h <Left>
nnoremap l <Right>
" zz: set cursor center
" nnoremap k kzz
" nnoremap j jzz
nnoremap <Up>   gk
nnoremap <Down> gj

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
imap <Up> <ESC>:call <SID>Up()<CR>i
imap <Down> <ESC>:call <SID>Down()<CR>i
" Enterで補完決定(no additional <CR>)
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"

cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" for function movement
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

" 現在の行の中央へ移動
" [vimで行の中央へ移動する - Qiita]( http://qiita.com/masayukiotsuka/items/683ffba1e84942afbb97?utm_campaign=popular_items&utm_medium=referral&utm_source=popular_items )
" go to center
nnoremap gc :call cursor(0,strlen(getline("."))/2)<CR>

" visual mode
" word copy
vnoremap j iwv
" word cut
vnoremap k iwc<ESC>

" undo
inoremap <C-z> <Esc>ui
" reduo
inoremap <C-r> <Esc><C-r>i

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

" yy copy command in visual mode
vnoremap yy :!pbcopy;pbpaste<CR>
" no yank by x or s
nnoremap x "_x
nnoremap s "_s

function! s:yank_pwd()
	let @+ = '.' " default value
	let @+ = expand('%:p:h')
endfunction
nnoremap wd :call <SID>yank_pwd()<CR>
" cd to editting file dir
command! -nargs=0 CD cd %:h
" ##############

" space -> tab replace
nnoremap 1t :%s/^\(\t*\) /\1\t/g<CR>
nnoremap 2t :%s/^\(\t*\)  /\1\t/g<CR>
nnoremap 3t :%s/^\(\t*\)   /\1\t/g<CR>
nnoremap 4t :%s/^\(\t*\)    /\1\t/g<CR>
" tab -> space replace
nnoremap 0T :%s/^\( *\)\t/\1/g<CR>
nnoremap 1T :%s/^\( *\)\t/\1 /g<CR>
nnoremap 2T :%s/^\( *\)\t/\1  /g<CR>
nnoremap 3T :%s/^\( *\)\t/\1   /g<CR>
nnoremap 4T :%s/^\( *\)\t/\1    /g<CR>

" vim tab control
nnoremap ? :tabnew<CR>
nnoremap > :tabn<CR>
nnoremap < :tabp<CR>

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
" function! s:copy_all()
" 	" 改行コードが変化する可能性
" 	" 	let l:source = join(getline(1, '$'), "\n")
" 	let l:view = winsaveview()
" 	" 	normal! ggVGV
" 	" 	execute "normal! ggVGV"
" 	silent call winrestview(l:view)
" 	echo 'This current file has copied!'
" endfunction
" command! -nargs=0 C call s:copy_all()
" command! -nargs=0 Copy call s:copy_all()

" <Nul> means <C-Space>
" [vim のkeymapでCtrl-Spaceが設定できなかったので調べてみた。 - dgdgの日記]( http://d.hatena.ne.jp/dgdg/20080109/1199891258 )
imap <Nul> <C-x><C-o>

" [\[Vim\] インサートモードで行頭や行末へ移動する方法 ~ 0から始めるvim ~]( https://qiita.com/ymiyamae/items/cea5103c65184f55d62e )
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$

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
function! s:paste_at_cursor()
	let l:tmp=@+
	" 最後の連続改行を削除することで，カーソル位置からの貼り付けとなる
	let @+=substitute(@+, '\n*$', '', '')
	normal! p
	let @+=l:tmp
endfunction
inoremap <C-v> <ESC>:call <SID>paste_at_cursor()<CR>i

" dynamic highlight search
" very magic
" [Vimでパターン検索するなら知っておいたほうがいいこと \- derisの日記]( http://deris.hatenablog.jp/entry/2013/05/15/024932 )
nnoremap / :set hlsearch<CR>:set incsearch<CR>/\v
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" [俺的にはずせない【Vim】こだわりのmap（説明付き） \- Qiita]( https://qiita.com/itmammoth/items/312246b4b7688875d023 )
" カーソル下の単語をハイライトしてから置換する
nnoremap grep "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap sed "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///gc<Left><Left>
vnoremap sed v:let @/ = '\<' . @+ . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///gc<Left><Left>
" > Shift + Enterで下に、Shift + Ctrl + Enterで上に空行を挿入します。
" inoremap <S-CR> <End><CR>
" inoremap <C-S-CR> <Up><End><CR>

nnoremap src :source ~/.vimrc<CR>
" :Src
" :Src .
function! s:source(...)
	let l:file = get(a:, 1, expand('~/.vimrc'))
	echo 'source ' . l:file
	call system('source ' . l:file)
endfunction
command! -nargs=? Src call s:source(<f-args>)

" [TabとCtrl\-iどちらを入力されたか区別する\(Linux限定\) \- Qiita]( https://qiita.com/norio13/items/9c05412796a7dea5cd91 )
" <Tab> == <C-i>
" insert new line at pre line
nnoremap <C-o> mzO<ESC>`z
" insert new line at next line
" nnoremap <C-i> mzo<ESC>`z

" tab
nnoremap <Tab> >>
imap <Tab> >>
nnoremap <S-Tab> <<

" quote
" s means surround
vnoremap s' c''<Left><ESC>p
vnoremap s" c""<Left><ESC>p
vnoremap s< c<><Left><ESC>p
vnoremap s( c()<Left><ESC>p
vnoremap s[ c[]<Left><ESC>p
vnoremap s{ c{}<Left><ESC>p
vnoremap s` c``````<Left><Left><Left><ESC>p
vnoremap s_ c____<Left><Left><ESC>p

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

" for no space line join
call submode#enter_with('join_line', 'n', '', 'gJ', 'gJ')
call submode#map('join_line', 'n', '', 'J', 'gJ')
