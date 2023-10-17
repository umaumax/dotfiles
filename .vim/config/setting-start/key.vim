" paste with space
nnoremap gp a <ESC>p

nnoremap cc vc
nnoremap co i<CR><ESC>

" NOTE: nnoremap上で利用する場合に，`|`をescapeする必要がある
nnoremap <silent> <CR> :call setline('.', substitute(getline('.'), '\(\s\\|　\\|\r\)\+$', '', ''))<CR><CR>

nnoremap <Leader>p %

" disable <C-@>
inoremap <C-@> <C-[>
" NOTE: disable dangerous exit commands
nnoremap ZZ <nop>
nnoremap ZQ <nop>

nnoremap <leader>r :redraw!<CR>
command! -nargs=0 Redraw :redraw!

" keep undo information
inoremap <Left> <C-g>U<Left>

" cursor movement in insert mode
inoremap <C-h> <Left>
inoremap <C-k> <C-r>=<SID>Up()<CR>
inoremap <C-j> <C-r>=<SID>Down()<CR>
inoremap <C-l> <Right>

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
command! UnFoldenable set nofoldenable
command! FoldenableNo set nofoldenable
command! Foldenable   set foldenable

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
  " NOTE: function's capital has to start uppercase
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

" FYI: [neocomplcache\#smart\_close\_popup\(\)とsmartinputの機能を両立させる \- Qiita]( https://qiita.com/todashuta/items/958ef3b4c32b4f992e0e )
" you can get smartinput sid by smartinput#sid()
let s:vim_smartinput__trigger_or_fallback={x,y -> "\<C-G>u\<CR>" }
augroup get_function_group
  autocmd!
  autocmd User VimEnterDrawPost let s:vim_smartinput__trigger_or_fallback=GetFunc('vim-smartinput/autoload/smartinput.vim','_trigger_or_fallback', s:vim_smartinput__trigger_or_fallback)
augroup END

" NOTE: Enterで補完決定(without additional <CR> after selection)
" i  <CR>        & <SNR>71__trigger_or_fallback("\<CR>", "\<CR>")
" inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"
" [vim\-smartinput/smartinput\.vim at master · kana/vim\-smartinput]( https://github.com/kana/vim-smartinput/blob/master/autoload/smartinput.vim#L318 )
function! s:cr()
  if pumvisible()
    return "\<C-Y>"
  endif
  " NOTE: <C-g>uは undo を分割する
  return "\<C-g>u".s:vim_smartinput__trigger_or_fallback("\<CR>","\<CR>")
endfunction
function! s:space()
  " NOTE: i  <Space>     & <SNR>129__trigger_or_fallback("\<Space>", "\<Space>")
  return "\<C-g>u\<C-\>\<C-o>:let _ = vim_auto_fix#auto_fix() && vim_blink#blink('[^ ]* *\\%#')\<CR>\<C-g>u".s:vim_smartinput__trigger_or_fallback("\<Space>","\<Space>")
endfunction
function! s:c_x()
  " NOTE: i  <Space>     & <SNR>129__trigger_or_fallback("\<Space>", "\<Space>")
  return "\<C-g>u\<C-\>\<C-o>:let _ = vim_auto_fix#auto_fix() && vim_blink#blink('[^ ]* *\\%#')\<CR>\<C-g>u".s:vim_smartinput__trigger_or_fallback("\<C-x>\<C-x>","\<C-x>\<C-x>")
endfunction
" NOTE:
" bufferを付加すると優先度が高くなるため，以降にpluginで設定されてもそれは無効化されるが，最初に開いたbufferでしか有効にならないので注意
" そのため，augroupを利用
augroup insert_cr_mapping
  autocmd!
  autocmd BufNewFile,BufNew,BufRead,WinNew,TabNew,WinEnter,TabEnter * inoremap <silent> <buffer> <script> <expr> <CR> <SID>cr()
  if &rtp =~ 'vim-smartinput' && &rtp =~ 'vim-auto-fix' && &rtp =~ 'vim-blink'
    autocmd BufNewFile,BufNew,BufRead,WinNew,TabNew,WinEnter,TabEnter * inoremap <silent> <buffer> <script> <expr> <Space> <SID>space()
    inoremap <silent> <buffer> <script> <expr> <C-s> <SID>c_x()
    inoremap <silent> <buffer> <script> <expr> <C-x><C-x> <SID>c_x()
  endif
augroup END

cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

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
if &rtp =~ 'vim-blink'
  nnoremap <silent> n nzz:call vim_blink#blink('\c\%#'.@/,'VimBlinkSearch')<CR>
  nnoremap <silent> N Nzz:call vim_blink#blink('\c\%#'.@/,'VimBlinkSearch')<CR>
  nnoremap <silent> * *zz:call vim_blink#blink('\c\%#'.@/,'VimBlinkSearch')<CR>
  nnoremap <silent> # #zz:call vim_blink#blink('\c\%#'.@/,'VimBlinkSearch')<CR>
else
  nnoremap <silent> n nzz2
  nnoremap <silent> N Nzz2
  nnoremap <silent> * *zz2
  nnoremap <silent> # #zz2
endif
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
vnoremap <silent> n :call <sid>select_search('n')<CR>
vnoremap <silent> N :call <sid>select_search('N')<CR>
" vnoremap * *zz
" vnoremap # #zz
vnoremap <silent> * "zy:let @/ = @z<CR>n
vnoremap <silent> # "zy:let @/ = @z<CR>N

" gv: select pre visual selected range
" gV: select pre pasted or yanked range
noremap <silent> gV `[v`]
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
nnoremap <silent> zm :call <SID>scroll_to_center(strlen(getline("."))/2)<CR>
nnoremap <silent> zM :call <SID>scroll_to_center(col('.'))<CR>
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
nnoremap <silent> zh :call <SID>zH()<CR>
nnoremap <silent> zl :call <SID>zL()<CR>
nnoremap <silent> zH :call <SID>zh(1)<CR>
nnoremap <silent> zL :call <SID>zl(1)<CR>

" visual mode
if &rtp !~ 'vim-textobj-user'
  vnoremap <silent> j iw
  vnoremap <silent> k ge
endif

vnoremap <C-h> <Left>
vnoremap <C-j> <Down>
vnoremap <C-k> <Up>
vnoremap <C-l> <Right>

nnoremap <C-h> <Left>
nnoremap <C-j> <Down>
nnoremap <C-k> <Up>
nnoremap <C-l> <Right>

function! s:undo()
  let view = winsaveview()
  normal! u
  " NOTE: restore cursor jump automatically
  if col('.')==1 && line('.')==1
    silent call winrestview(view)
  endif
endfunction
nnoremap <silent> u :call <SID>undo()<CR>
inoremap <silent> <C-u> <C-o>:call <SID>undo()<CR>

function! s:redo()
  let view = winsaveview()
  execute "normal! \<C-r>"
  " NOTE: restore cursor jump automatically
  if col('.')==1 && line('.')==1
    silent call winrestview(view)
  endif
endfunction
nnoremap <silent> <C-r> :call <SID>redo()<CR>
inoremap <silent> <C-r> <C-o>:call <SID>redo()<CR>

inoremap <C-x>e <ESC>
inoremap <C-x><C-e> <ESC>

" bg
inoremap <C-z> <ESC><C-z>

" toggle relativenumber
nnoremap <silent> <Space>l :<C-u>setlocal relativenumber!<CR>
" toggle AnsiView
" nnoremap <Space>a :AnsiEsc<CR>

" define shortcut key of going to mark position
for key in split("^(){}[]<>.'\"", '\zs')
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
vnoremap <silent> <C-p> <Esc>:call <SID>vertical_paste()<CR>

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
vnoremap <silent> p "_x:call <SID>visual_mode_paste()<CR>

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
        if type(result) == type('')
          let target = substitute(target, pattern, result, '')
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
vnoremap <silent> <C-x> "zd:call <SID>switch()<CR>

function! s:V()
  let m=visualmode()
  if m ==# 'V'
    normal! gvy
  else
    normal! gvV
  endif
endfunction
vnoremap v y
vnoremap <silent> V :<C-u>call <SID>V()<CR>

" NOTE: ubuntu16.04 gx binding doesn't work well with unclear reason
function! OpenURL(...)
  let url=get(a:, 1, matchstr(getline("."), '\(http\(s\)\?://[^ ]\+\)', 0))
  echom '[open url]: '.url
  if has('mac')
    let output = system("open -n '".url."'")
  elseif !has('win')
    let output = call system("xdg-open &>/dev/null '".url."'")
  else
    echom 'not supported on windows!'
  endif
  if v:shell_error != 0
    echom '[failed to open url]: ' . output
  endif
endfunction
" to overwrite : n  gx @<Plug>Markdown_OpenUrlUnderCursor
" augroup gx_group
" autocmd!
" " NOTE: BufReadPost is for unnamed tab and load file
" autocmd User VimEnterDrawPost nnoremap <buffer> gx :call OpenURL()<CR>
" autocmd BufReadPost * nnoremap <buffer> gx :call OpenURL()<CR>
" augroup END
nnoremap <silent> gx :call OpenURL()<CR>

" <Nul> means <C-Space>
" [vim のkeymapでCtrl-Spaceが設定できなかったので調べてみた。 - dgdgの日記]( http://d.hatena.ne.jp/dgdg/20080109/1199891258 )
imap <Nul> <C-x><C-o>

inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
vnoremap <C-a> ^
vnoremap <C-e> $<Left>
vnoremap $ $<Left>

" NOTE: prevent forcus lsp popup
augroup bufenter_group
  autocmd!
  autocmd WinEnter,TabEnter * if @% == '__LanguageClient__' | exe winnr().'wincmd c' | endif
augroup END

" FYI: [dogfiles/vimrc at master · rhysd/dogfiles]( https://github.com/rhysd/dogfiles/blob/master/vimrc#L254 )
" quickfix -> main windowの順に閉じる
function! s:close(force)
  let l:flag=''
  let l:w=''
  if exists("*float_preview#close")
    if g:float_preview#win != 0
      " NOTE: opening
      call float_preview#close()
      return
    endif
  endif
  if !(&bt == 'quickfix' || &bt == 'nofile')
    " NOTE: auto close LC popup window
    let save_winnr = winnr()
    windo if l:flag=='' && (@% == '__LanguageClient__') | let l:flag=&bt | let l:w=winnr() | endif
    exe save_winnr. 'wincmd w'
    if l:flag!=''
      exe l:w.'wincmd c'
    endif
    let l:flag=''
    let save_winnr = winnr()
    " scrollview: dstein64/nvim-scrollview
    " deol: Shougo/deol.nvim
    windo if l:flag=='' && (&bt=='quickfix' || (&bt=='nofile' && &ft != 'scrollview') || (&bt == 'terminal' && &ft == 'deol'))  | let l:flag=&bt | let l:w=winnr() | endif
    exe save_winnr. 'wincmd w'
  endif
  if l:flag!=''
    if l:flag=='quickfix'
      ccl
    elseif l:flag=='nofile' || l:flag == 'terminal'
      exe l:w.'wincmd c'
    else
      echom 'unknown flag: "'.l:flag.'"'
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

" for auto quit vimconsole
" function! s:get_window_n()
" let save_winnr = winnr()
" windo let wn+=1
" exe save_winnr. 'wincmd w'
" return wn
" endfunction
" function! s:last_window_event()
" if &ft == 'vimconsole'
" q
" endif
" endfunction
" augroup auto_window_quit
" autocmd!
" " NOTE: below silent! is for 'Not allowed to edit another buffer now'
" autocmd WinEnter,BufWinEnter,BufEnter * silent! if s:get_window_n() == 1 | call s:last_window_event() | endif
" augroup END

" save and quit
" write all
" nnoremap wa :wa<CR>
" nnoremap wq :wq<CR>
" nnoremap ww :w<CR>
nnoremap qw :<C-u>wq<CR>
" FYI: [vim\-jp » Hack \#35: ex コマンドを実行するキーマッピングを定義する]( https://vim-jp.org/vim-users-jp/2009/07/02/Hack-35.html )
nnoremap <Leader>w :<C-u>w<CR>
nnoremap <Leader>q :<C-u>q<CR>
" NOTE: for prevent 'Press ENTER or type command to continue'
nnoremap <silent> qq :call <SID>close(0)<CR><Esc>
nnoremap <silent> q! :call <SID>close(1)<CR><Esc>
" sudo save
" NOTE: below command is only for 'vim' not 'nvim'
if !has('nvim')
  function! s:vim_force_save()
    :w !sudo tee > /dev/null %
    :e!
  endfunction
  command! ForceSave :call s:vim_force_save()
  nnoremap <Leader>! :w !sudo tee > /dev/null %<CR> :e!<CR>
  " cnoremap <Leader>!  w !sudo tee > /dev/null %<CR> :e!<CR>
else
  if &rtp !~ 'suda.vim'
    command! ForceSave :w suda://%
    nnoremap <Leader>! :w suda://%<CR>
    " cnoremap <Leader>!  w suda://%<CR>
  else
    command! ForceSave :echom 'You need "lambdalisue/suda.vim" to save this file!'
    nnoremap <Leader>! :echom 'You need "lambdalisue/suda.vim" to save this file!'<CR>
    " cnoremap <Leader>!  echom 'You need "lambdalisue/suda.vim" to save this file!'<CR>
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
  autocmd CmdwinLeave * autocmd! cmdline_compl CmdwinEnter
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

  let cmd = getcmdline()
  let cmdpos = getcmdpos()
  let lbuffer=cmd[:cmdpos-1-1].clipboard
  let rbuffer=cmd[cmdpos-1:]
  let buffer=lbuffer.rbuffer

  " NOTE: The first position is 1.
  call setcmdpos(1+strlen(lbuffer))
  return buffer
endfunction
" [cmdline \- Vim日本語ドキュメント]( http://vim-jp.org/vimdoc-ja/cmdline.html#c_CTRL-_e )
cnoremap <C-v> <C-\>e<SID>paste_at_cmdline()<CR>

function! s:yank_cmdline()
  let @+ = getcmdline()
  return "\<C-c>"
endfunction
cnoremap <expr> <C-y> <SID>yank_cmdline()

" function! s:has_prefix(str, prefix)
"   return a:str[:strlen(a:prefix)-1] == a:prefix
" endfunction
" " NOTE: 検索時の先頭の'/'はgetcmdline()には含まれないため，':'のときに次の関数を呼び出してもは適切な挙動にはならない
" function! s:to_search()
"   "   let cmd = getcmdline()
"   let cmd = g:cmd_tmp
"   if s:has_prefix(cmd, '%smagic/')
"     let cmd = '\v'.cmd[8:]
"   elseif s:has_prefix(cmd, '%s/')
"     let cmd = ''.cmd[3:]
"   endif
"   call setcmdpos(strlen(cmd)+1)
"   return cmd
" endfunction
" " NOTE: 以前の検索対象のみがハイライトされる
" function! s:to_replace()
"   let cmd = g:cmd_tmp
"   if s:has_prefix(cmd, '\v')
"     let cmd = '%smagic/'.cmd[2:]
"   elseif !s:has_prefix(cmd, '%s/') && !s:has_prefix(cmd, '%smagic/')
"     let cmd = '%s/'.cmd[0:]
"   endif
"   call setcmdpos(strlen(cmd)+1)
"   return cmd
" endfunction
" function! s:cmd_copy()
"   let g:cmd_tmp = getcmdline()
"   let @/='' " to avoid no hit error
"   return ""
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
cnoremap <C-p> <C-\>eToggleWordBounds(getcmdtype(), getcmdline())<CR>
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
" toggle / and :s///g
cnoremap <expr> <C-o> ToggleSubstituteSearch(getcmdtype(), getcmdline())
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

cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" FYI: [cheapcmd\.vim/cheapcmd\.vim at master · LeafCage/cheapcmd\.vim]( https://github.com/LeafCage/cheapcmd.vim/blob/master/autoload/cheapcmd.vim#L22 )
function! s:default_expand()
  cnoremap <Plug>(tmp_command_mode:tab)  <Tab>
  cnoremap <expr><Plug>(tmp_command_mode:rest-wcm) <SID>default_expand_rest_wcm()
  let s:save_wcm = &wcm
  set wcm=<Tab>
  call feedkeys("\<Plug>(tmp_command_mode:tab)\<Plug>(tmp_command_mode:rest-wcm)", 'm')
  return ''
endfunction
function! s:default_expand_rest_wcm()
  cunmap <Plug>(tmp_command_mode:tab)
  cunmap <Plug>(tmp_command_mode:rest-wcm)
  let &wcm = s:save_wcm
  unlet s:save_wcm

  " NOTE: no expand by default tab key
  if getcmdline()[-1:] == "\t"
    cnoremap <silent><expr> <Plug>(launch_command_line_completion:tab) Launch_command_line_completion()
    call feedkeys("\<BS>\<Plug>(launch_command_line_completion:tab)", 'm')
  endif
  return ''
endfunction
cmap <silent><expr> <Tab> <SID>default_expand()

function! Backword_delete_word()
  let cmd = getcmdline()
  let cmdpos = getcmdpos()
  let lbuffer=cmd[:cmdpos-1-1]
  let rbuffer=cmd[cmdpos-1:]
  let lbuffer=substitute(lbuffer, '\([^/#\-+ (),.:"'."'".']*\( \)*\|.\)$', '', '')
  " NOTE: The first position is 1.
  call setcmdpos(1+len(lbuffer))
  let buffer=lbuffer.rbuffer
  return buffer
endfunction
function! s:un_tab()
  if pumvisible()
    return "\<C-p>"
  endif
  return "\<C-\>eBackword_delete_word()\<CR>"
endfunction
cnoremap <expr> <S-Tab> <SID>un_tab()

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

" NOTE: for avoid below error
" E127: Cannot redefine function Source: It is in use
if !exists("*Source")
  function! Source(...)
    let file = get(a:, 1, expand('~/.vimrc'))
    echo 'source ' . file
    execute 'source '.fnameescape(l:file)
  endfunction
  command! -nargs=? Src    call Source(<f-args>)
  command! -nargs=? Load   call Source(<f-args>)
  command! -nargs=? Reload call Source(<f-args>)
endif

function! AbsFilePathToGitRelFilePathWithRepoName(abs_filepath)
  let escaped_filepath=shellescape(a:abs_filepath)
  let cmd=printf('basename $(git -C $(dirname %s) rev-parse --show-toplevel)', escaped_filepath)
  let repo_name= substitute(system(cmd), '\n$', '', '')
  if repo_name==''
    return ''
  endif

  let cmd=printf('git -C $(dirname %s) ls-files --full-name %s', escaped_filepath, escaped_filepath)
  let relpath= substitute(system(cmd), '\n$', '', '')
  if relpath==''
    let cmd=printf('realpath --canonicalize-missing --no-symlinks --relative-to $(git -C $(dirname %s) rev-parse --show-toplevel) %s', escaped_filepath, escaped_filepath)
    let relpath= substitute(system(cmd), '\n$', '', '')
    return repo_name.'/'.relpath
  endif
  return repo_name.'/'.relpath
endfunction

command! FileName     :let @+ = expand('%:t')               | echo '[COPY!]: ' . @+
command! FilePath     :let @+ = expand('%:p')               | echo '[COPY!]: ' . @+
command! FilePathNR   :let @+ = expand('%:p').':'.line('.') | echo '[COPY!]: ' . @+
command! FilePathGit  :let @+ = AbsFilePathToGitRelFilePathWithRepoName(expand('%:p')) | echo '[COPY!]: ' . @+
command! DirPath      :let @+ = expand('%:p:h')             | echo '[COPY!]: ' . @+
command! DirName      :let @+ = expand('%:p:h:t')           | echo '[COPY!]: ' . @+
command! CopyFileName   :FileName
command! CopyFilePath   :FilePath
command! CopyFilePathNR :FilePathNR
command! CopyFilePathGit :FilePathGit
command! CopyDirPath    :DirPath
command! CopyDirName    :DirName
" copy current buffer lines
command! -nargs=0 CopyAll :%y
" delete all lines at buffer without copy
" don't add <silent>
command! -nargs=0 Delete normal! ggVG"_x

" 左回り
vnoremap <silent> <C-g> o<Right>"zd<Left>"zPgvo<Left>o
" 右回り
vnoremap <silent> <C-r> <Left>"zd<Right>"zPgv<Right>

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
"       \{'keys':["\<Space>"],                   'prefix':" ",    'suffix':" "},
for mapping in surround_key_mappings
  let prefix=mapping['prefix']
  let suffix=mapping['suffix']
  for key in mapping['keys']

    "     execute "vnoremap s".key." c<C-o>:let @z=\"".prefix."\".@+.\"".suffix."\"\<CR>\<C-r>\<C-o>z\<Esc>"
    execute "vnoremap s".key." \"yc<C-o>:let @z=\"".prefix."\".substitute(@y, '\\n*$', '', '').\"".suffix."\"<CR><C-r><C-o>z<Esc>"
    " NOTE: 記号の場合にはprefix:sはなし
    let top_char=key[0]
    if (top_char =~ '\W' || top_char == '_') && top_char != '$'
      execute "vnoremap ".key." \"yc<C-o>:let @z=\"".prefix."\".substitute(@y, '\\n*$', '', '').\"".suffix."\"<CR><C-r><C-o>z<Esc>"
    endif
  endfor
endfor
vnoremap s<Space> c<C-o>:let @z=' '.@+.' '<CR><C-r><C-o>z<Esc>
vnoremap  <Space> c<C-o>:let @z=' '.@+.' '<CR><C-r><C-o>z<Esc>
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
" nnoremap q <Nop>
" NOTE: for alternate for q
nnoremap Q q

" disable F13
map <S-F1> <Nop>
map! <S-F1> <Nop>

let b:macro_key=''
function! StartMacro(char)
  let b:macro_key=a:char
  echom '(q'.a:char.'(start) ->) q(end) -> @'.a:char.'(do) -> @@(repeat)'
  execute("normal! q".a:char)
endfunction
for char in split('abcdefghijklmnopqrstuvwxyz','\zs')
  if char=='q' || char=='w'
    continue
  endif
  execute("nnoremap <silent> q".char." :call StartMacro('".char."')\<CR>")
endfor
function! EndMacro()
  let b:macro_key = get(b:, 'macro_key', '')
  if empty(b:macro_key)
    return
  endif
  " NOTE: human readable macro
  execute('let tmp=@'.b:macro_key)
  let key_set={ "BS":"<BS>","ESC":"<ESC>","Left":"⏪","Up":"⏫","Right":"⏩","Down":"⏬","CR":"<CR>","Space":" "}
  for special_key in keys(key_set)
    let visual_key=key_set[special_key]
    execute('let tmp = substitute(tmp,"\<'.special_key.'>", "'.visual_key.'","g")')
  endfor
  execute('echom "@'.b:macro_key.' is [".tmp."]"')
  let b:macro_key=''
endfunction
nnoremap <silent> q q<Esc>:call EndMacro()<CR>

command! CmdlineWindow       call feedkeys("q:", "n")
command! SearchCmdlineWindow call feedkeys("q/", "n")
" FYI: open cmdline window
cnoremap <silent> <C-g> <C-f>

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

" auto comment off
" augroup auto_comment_off
" autocmd!
" <CR>
"   autocmd BufEnter * setlocal formatoptions-=r
" o, O
" autocmd BufEnter * setlocal formatoptions-=o
" augroup END
" NOTE: M: join multi-byte words without space
" NOTE: 2: ???
set formatoptions+=M2

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

" FYI: [\(12\) thincaさんはTwitterを使っています: 「Vim で貼り付けは p ですが、\]p を使うと、貼り付ける内容のインデントを貼り付け先のインデントに合わせて調整した上で貼り付けてくれます。貼り付けた後にインデントの再調整をしなくて済むので便利です。 \#vimtips\_ac」 / Twitter]( https://twitter.com/thinca/status/1200791599510245376 )
" nnoremap p ]p
" nnoremap P ]P
" nnoremap ]p p
" nnoremap ]P P

" move to last of pasted text
" nnoremap <silent> p p`]

nnoremap ; :
vnoremap ; :

" NOTE: ignore yank blank string
nnoremap <silent> dd "zdd:if split(@z,"\n")!=[] \| let @+=@z \| endif<CR>
vnoremap <silent> d  "zdd:if split(@z,"\n")!=[] \| let @+=@z \| endif<CR>

" how to use
" 1. yank something
" 2. store yank text by m1
" 3. do something
" 4. load yank text by y1
" 5. paste yanked text
for i in range(0,9)
  execute "nnoremap y".i." :let @+=@".i."\<CR>:echo '[copyed to clipboard]:'.split(@+, \"\\n\")[0]\<CR>"
  execute "nnoremap m".i." :let @".i."=@+\<CR>:echo '[copyed to @".i."]:'.split(@+, \"\\n\")[0]\<CR>"
endfor
