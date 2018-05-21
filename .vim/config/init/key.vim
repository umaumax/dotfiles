inoremap {} {}<Left>
inoremap [] []<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap <> <><Left>

" 挿入モードでのカーソル移動
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
nnoremap <Down> gj
nnoremap <Up>   gk

cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

function! s:yank_pwd()
	let @* = expand('%:h')
endfunction
nnoremap wd :call <SID>yank_pwd()<CR>

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

" #### mark {{{{
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
" #### mark }}}}

" yy copy command in visual mode
vnoremap yy :!pbcopy;pbpaste<CR>

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

" dynamic highlight search
nnoremap / :set hlsearch<CR>/

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
nnoremap <C-a> ggVG

" <Nul> means <C-Space>
" [vim のkeymapでCtrl-Spaceが設定できなかったので調べてみた。 - dgdgの日記]( http://d.hatena.ne.jp/dgdg/20080109/1199891258 )
imap <Nul> <C-x><C-o>

" save and quit
nnoremap wq :wq<CR>
nnoremap ww :w<CR>
nnoremap qq :q<CR>
nnoremap q! :q!<CR>
" sudo save
cnoremap w! w !sudo tee > /dev/null %<CR> :e!<CR>

" psate
inoremap <C-v> <Esc>pi
inoremap <D-v> <Esc>pi

" [俺的にはずせない【Vim】こだわりのmap（説明付き） \- Qiita]( https://qiita.com/itmammoth/items/312246b4b7688875d023 )
" カーソル下の単語をハイライトしてから置換する
nnoremap grep "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>
nnoremap sed "zyiw:let @/ = '\<' . @z . '\>'<CR>:set hlsearch<CR>:%s/<C-r>///g<Left><Left>
" > Shift + Enterで下に、Shift + Ctrl + Enterで上に空行を挿入します。
" inoremap <S-CR> <End><CR>
" inoremap <C-S-CR> <Up><End><CR>

" insert new line at pre line
nnoremap <C-o> mzO<ESC>`z
" insert new line at next line
nnoremap <C-i> mzo<ESC>`z

nnoremap src :source ~/.vimrc<CR>

" auto toggle
" e.g. md    -> '* xxx'
"      c,cpp -> 'xxx:'
function! Substitute(pat, sub, flags) range
	for l:n in range(a:firstline, a:lastline)
		let l:line=getline(l:n)
		let l:ret=substitute(l:line, a:pat, a:sub, a:flags)
		call setline(l:n, l:ret)
	endfor
	call cursor(a:lastline+1, 1)
endfunction
command! -nargs=0 -range SetMarkdownHead <line1>,<line2>call Substitute('^\([^*].*\)$', '* \1', '')
command! -nargs=0 -range SetCBottom      <line1>,<line2>call Substitute('\(^.*[^;]\+\)\s*$', '\1;', '')
augroup file_detection_for_toggle
	autocmd!
	au BufNewFile,BufRead *.md      nnoremap <silent> @ :SetMarkdownHead<CR>
	au BufNewFile,BufRead *.{c,cpp} nnoremap <silent> @ :SetCBottom<CR>
augroup END

" no yank by x or s
nnoremap x "_x
nnoremap s "_s

" English search
function! SearchEnglishWord()
	let l:buf = @+
	" 	let l:ret = system('p | trans -b -sl=en -tl=ja')
	let l:ret = system('p | trans -b')
	call Window('english', 'open', split(l:buf."\n=>".l:ret, "\n"))
endfunction
nnoremap <Space><Space> viwv:call SearchEnglishWord()<CR>
vnoremap <Space><Space> v:call SearchEnglishWord()<CR>

" tab
nnoremap <Tab> >>
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
nnoremap r q

" for external command
nnoremap ! :! 
