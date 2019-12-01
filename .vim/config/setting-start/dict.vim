let s:dict_delim='__CR__'
" NOTE: __CURSOR__が行末になるときに，1文字左側から入力が始まってしまう
let s:cursor='__CURSOR__'

function! s:dict_replacer()
  let item = v:completed_item
  let menu = item['menu']
  let abbr = item['abbr']
  let neosnippet_flag = menu =~ '^\[ns\] '
  if neosnippet_flag
    return
  endif

  " NOTE: 本来は v:completed_item['word'] の範囲のみを対象に置換するべき
  let line=getline('.')
  if !(stridx(line, s:dict_delim) >=0 || stridx(line, s:cursor) >=0)
    return
  endif
  " 逆向きに検索
  "     '__CURSOR__'の場所を検索
  let lines=split(substitute(line, s:dict_delim, char2nr('\n'), 'g'),char2nr('\n'))
  call append(line('.'), lines)
  execute 'normal! "_dd'
  if stridx(line, s:cursor) >=0 && search('__CURSOR__', 'b') != 0
    execute 'normal! '.len('__CURSOR__').'"_x'
  endif
endfunction

" NOTE: 関数などの補完後も役立つ情報を保持する
function! s:vimconsole_logger()
  " NOTE: for debug
  " PP v:completed_item
  let item = v:completed_item
  let menu = item['menu']
  let abbr = item['abbr']
  let neosnippet_flag = menu =~ '^\[ns\] '
  " NOTE: deoplete環境ではsnippet機能は通常の補完機能となってしまい，一工夫必要
  " [deoplete環境でneosnippetを使えるようにする \- グレインの備忘録]( http://grainrigi.hatenablog.com/entry/2017/08/28/230029 )
  if neosnippet_flag
    " NOTE: snippet自動展開
    " executeを利用すると，一旦normalモードに移行し，その後insertモードに戻るため，行末にカーソルがある場合に位置がずれる
    "     execute "normal a\<Plug>(neosnippet_expand)"
    " NOTE: last \<C-o>:\<Esc> enables to show completion menu list even if after expanding neosnippet (only insert mode... this does't work well in select mode)
    "     call feedkeys("\<Plug>(neosnippet_expand)\<C-o>:\<Esc>", '')
    " NOTE: たまたま，visual  modeの開始地点とカーソル位置が一致しないかぎり，insert modeでもselect  modeで動作する
    " call feedkeys("\<Plug>(neosnippet_expand)\<C-o>:\<C-u>if getpos(\"'<\")==getpos('.') | call feedkeys(\"gv\\<C-g>\", 'n') | endif\<CR>", '')
    " NOTE:
    " 下記のコマンドは補完を確定する際に改行をしないことが前提(現在は<CR>で選択する際に，余計な改行を除去している)
    call feedkeys("\<Plug>(neosnippet_expand)\<C-o>:\<C-u>if getpos(\"'<\")==getpos('.') | call feedkeys(\"gv\\<C-g>\", 'n') | endif\<CR>", '')
    return
  endif
  let vim_flag    = menu == '[vim] '
  let clang_flag  = menu == '[clang] ' || menu == '[PCH] '
  let python_flag = menu == '[jedi] '
  let lsp_flag    = menu =~ '\[LC\] '
  let go_flag     = menu == '[go] '
  if lsp_flag
    call LCCompleteSnippet()
    return
  endif
  if !(vim_flag || clang_flag || python_flag || lsp_flag || go_flag)
    return
  endif
  let func_flag = abbr =~ '.*(.*)'
  let no_arg_func_flag = abbr =~ '.*()'
  let template_flag = abbr =~ '^[^()<>]*<.*>'
  let log_flag = func_flag || template_flag
  " NOTE: is function?
  if func_flag && template_flag
    if clang_flag
      execute "normal! i<>()\<ESC>\<Left>\<Left>"
    endif
  elseif func_flag
    if vim_flag && !no_arg_func_flag
      execute "normal! i)"
    endif
    if clang_flag || python_flag || lsp_flag || go_flag
      execute "normal! i()"
      if no_arg_func_flag
        call feedkeys("\<Right>", 'n')
      endif
    endif
  elseif template_flag
    if clang_flag
      execute "normal! i<>"
    endif
  endif

  if log_flag
    call vimconsole#log('%s:%s', menu, abbr)
    if vimconsole#is_open()
      " NOTE: this is not needed because of let g:vimconsole#auto_redraw=1
      " call vimconsole#redraw()
    else
      call vimconsole#winopen()
    endif
  endif
endfunction

function! s:CompleteDone()
  if v:completed_item == {}
    " NOTE: no completion
    return
  endif
  call s:dict_replacer()
  call s:vimconsole_logger()
endfunction

function! s:SetDictionary(filetype)
  let filetype=a:filetype
  " NOTE: use common dict
  if filetype == 'zsh'
    let filetype='sh'
  endif
  " TODO: use global variable to set path
  let dict_path=$HOME.'/dotfiles/dict'
  let dict_file_path=dict_path.'/'.filetype.'.dict'
  if filereadable(dict_file_path)
    execute 'setlocal dictionary+='.dict_file_path
  endif
endfunction

function! s:AutocmdSetDictionary()
  call s:SetDictionary(&ft)
  call s:SetDictionary('common')
endfunction

" FYI: main info [Snippets should be passed to snippet managers instead of completion plugins · Issue \#379 · autozimu/LanguageClient\-neovim]( https://github.com/autozimu/LanguageClient-neovim/issues/379 )
" FYI: sub info [thomasfaingnaert/vim\-lsp\-ultisnips: Language Server Protocol snippets in vim using vim\-lsp and UltiSnips]( https://github.com/thomasfaingnaert/vim-lsp-ultisnips )
let g:ulti_expand_res = 0 "default value, just set once
function! LCCompleteSnippet()
  if empty(v:completed_item)
    return
  endif

  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res > 0
    return
  endif

  let l:complete = type(v:completed_item) == v:t_dict ? v:completed_item.word : v:completed_item
  let l:comp_len = len(l:complete)

  let l:cur_col = mode() == 'i' ? col('.') - 2 : col('.') - 1
  let l:cur_line = getline('.')

  let l:start = l:comp_len <= l:cur_col ? l:cur_line[:l:cur_col - l:comp_len] : ''
  let l:end = l:cur_col < len(l:cur_line) ? l:cur_line[l:cur_col + 1 :] : ''

  call setline('.', l:start . l:end)
  call cursor('.', l:cur_col - l:comp_len + 2)

  call UltiSnips#Anon(l:complete)
endfunction

augroup dict_comp
  autocmd!
  autocmd FileType * call s:AutocmdSetDictionary()
  autocmd CompleteDone * call s:CompleteDone()
augroup END

" for dict file editting
function! s:DictJoin() range
  let lines = join(getline(a:firstline, a:lastline), s:dict_delim)
  execute 'normal! '.(a:lastline-a:firstline+1).'"_dd'
  call append(a:firstline-1, lines)
endfunction

function! s:DictSplit()
  let lines=split(getline('.'), s:dict_delim)
  call append(line('.'), lines)
  normal! "_dd
endfunction

command! -nargs=0 -range DictJoin  <line1>,<line2>call s:DictJoin()
command! -nargs=0        DictSplit                call s:DictSplit()
