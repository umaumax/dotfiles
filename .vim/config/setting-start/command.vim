function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

function! s:delete_visual_selection()
  let selected = s:get_visual_selection()
  call setpos('.', getpos("'<"))
  let Mlen = { s -> strlen(substitute(s, ".", "x", "g"))}
  let l = Mlen(selected)
  if l > 0
    execute "normal! v".(l-1)."\<Right>\"_x"
  endif
  return selected
endfunction

function! s:p(text)
  let tmp = @a
  let @a = a:text
  execute 'normal! "ap'
  let @a = tmp
endfunction

function! s:ins_tab() range
  let l:last_searched_pattern=@/
  execute ":".a:firstline.",".a:lastline."s/^/\t/"
  let @/=l:last_searched_pattern
endfunction
command! -nargs=0 -range InsTab <line1>,<line2>call s:ins_tab()

" for visual mode
function! CR() range
  let selected = s:delete_visual_selection()
  execute "normal! i\<CR>\<CR>\<Up>\<ESC>"
  call s:p(selected)
endfunction
command! -nargs=0 -range CR <line1>,<line2>call CR()
" NOTE: for c++
" 1行にまとまってしまった関数ボディの改行
function! CRBody() range
  execute "normal! 00f{\<Right>vt}:CR\<CR>"
endfunction
command! -nargs=0 -range CRBody <line1>,<line2>call CRBody()

function! CRSplit()
  let line = getline('.')
  "   let array = matchstr(line, '^[^\[\],]*\[\([^,]*,\)\+[^,]*\][^\[\],]*$')
  "   let func_args = matchstr(line, '^[^(,)]*(\([^,]*,\)\+[^,]*)[^(,)]*$')
  "   if !empty(func_args)
  let delim="????????"
  let line = substitute(line, '\([^(]*(\)', '\1'.delim, '')
  let line = substitute(line, '\(<<\|>>\|&&\|||\)', delim.'\1'.delim, 'g')
  let line = substitute(line, '{', '{'.delim, 'g')
  let line = substitute(line, '}', delim.'}', 'g')
  let line = substitute(line, '\[\(.*\),', '['.delim.'\1,', 'g')
  let line = substitute(line, ',', ','.delim, 'g')
  let line = substitute(line, delim.'\s\+', delim, 'g')
  let lines = split(line,delim)
  for i in range(0, len(lines)-1)
    let lines[i] = substitute(lines[i], '\([^\[]\+\)\]$', '\1'.delim.']', 'g')
    let lines[i] = substitute(lines[i], '\()[^)]\+\)$', delim.'\1', '')
    let lines[i] = substitute(lines[i], '(\([^)]\+\),', '('.delim.'\1,', 'g')
  endfor
  let lines = split(join(lines,delim),delim)
  call s:setlines('.', lines)
endfunction
function! s:setlines(pos, lines)
  if len(a:lines)==0
    execute ':'.a:pos.'d'
    return
  endif
  call setline(a:pos, a:lines[0])
  call append(a:pos, a:lines[1:])
endfunction
command! -nargs=0 Split call CRSplit()
command! -nargs=0 CRSplit call CRSplit()
nnoremap zs :call CRSplit()<CR>
nnoremap gs :call CRSplit()<CR>
inoremap <C-x>s <C-o>:call CRSplit()<CR>
inoremap <C-x><C-s> <C-o>:call CRSplit()<CR>

" for string array
" :Sand " ",
function! Sand(prefix, suffix) range
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    call setline(n, a:prefix.line.a:suffix)
  endfor
endfunction
command! -nargs=+ -range Sand <line1>,<line2>call Sand(<f-args>)
command! -nargs=1 -range AddPrefix <line1>,<line2>call Sand(<q-args>, "")
command! -nargs=1 -range AddSuffix <line1>,<line2>call Sand("", <q-args>)

function! NoDiffStyle() range
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    let line = substitute(line, '^[-+]', '', '')
    call setline(n, line)
  endfor
endfunction
command! -range NoDiffStyle <line1>,<line2>call NoDiffStyle()
function! OnlyPlusDiffStyle() range
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    let line = substitute(line, '\(^+\)\|\(^-.*\)', '', '')
    call setline(n, line)
  endfor
endfunction
command! -range OnlyPlusDiffStyle <line1>,<line2>call OnlyPlusDiffStyle()

" pick up arg
function! s:argsWithDefaultArg(index, default, ...)
  let l:arg = get(a:, a:index, a:default)
  if l:arg == ''
    return a:default
  endif
  return l:arg
endfunction

" NOTE: G: repeat replace with entire range
function! s:substitute(pat, sub, flags) range
  let Gflag=stridx(a:flags,'G')>=0 ? 1 : 0
  " NOTE: distinguish case
  let flags=substitute(a:flags, '\CG', '', 'g')

  let change_flag = 1
  while Gflag == 0 || (Gflag == 1 && change_flag == 1)
    let change_flag = 0
    for l:n in range(a:firstline, a:lastline)
      let l:line=getline(l:n)
      let l:ret=substitute(l:line, a:pat, a:sub, flags)
      if l:line != l:ret
        let change_flag = 1
        call setline(l:n, l:ret)
      endif
    endfor
    if Gflag == 0
      break
    endif
  endwhile
  call cursor(a:lastline+1, 1)
endfunction
command! -nargs=* -range TableConv <line1>,<line2>call s:substitute('^\|'.s:argsWithDefaultArg(1, ' ',<q-args>).'\|$', '|', 'g')

function! s:replace(...) range
  let @/=get(a:,  1, @+)
  if empty(@/)
    let @/=@+
  endif
  let visual_select_key='gv:'
  if a:firstline==a:lastline
    let visual_select_key=':.'
  endif
  " NOTE: for src pattern visibility
  let @z='\V'.escape(@/, '\/')
  call feedkeys(visual_select_key."s/\<C-r>z//g |:noh".repeat("\<Left>",8)."\<Space>\<BS>", 'n')
endfunction

" [Perform a non\-regex search/replace in vim \- Stack Overflow]( https://stackoverflow.com/questions/6254820/perform-a-non-regex-search-replace-in-vim )
command! -nargs=*        S      let @/='\V'.escape(s:argsWithDefaultArg(1, @+, <q-args>), '\/') | call feedkeys("/\<C-r>/\<CR>", 'n')
command! -nargs=*        Search let @/='\V'.escape(s:argsWithDefaultArg(1, @+, <q-args>), '\/') | call feedkeys("/\<C-r>/\<CR>", 'n')
command! -nargs=* -range R      <line1>,<line2>call s:replace(<q-args>)
command! -nargs=* -range Rep    <line1>,<line2>call s:replace(<q-args>)

command! -nargs=* -range Space2Tab let view = winsaveview() | <line1>,<line2>call s:substitute('^\(\t*\)'.repeat(' ', s:argsWithDefaultArg(1, &tabstop, <f-args>)), '\1\t', 'gG') | silent call winrestview(view)
command! -nargs=* -range Tab2Space let view = winsaveview() | <line1>,<line2>call s:substitute('^\( *\)\?\t', '\1'.repeat(' ', s:argsWithDefaultArg(1, &tabstop, <f-args>)), 'gG') | silent call winrestview(view)

" NOTE: 全角文字扱いだが，半角表示となるためにずれる
" command! -nargs=0 -range ReplaceInterpunct <line1>,<line2>call s:substitute('·', '-', 'g')

" NOTE: 匿名化コマンド
execute "command! -range Anonymous :%s:".$HOME.":\${HOME}:gc | :%s:".$USER."@:\${USER}@:gc"

" [editing \- How reverse selected lines order in vim? \- Super User]( https://superuser.com/questions/189947/how-reverse-selected-lines-order-in-vim )
command! -nargs=0 -bar -range=% Tac
      \       let save_mark_t = getpos("'t")
      \<bar>      <line2>kt
      \<bar>      exe "<line1>,<line2>g/^/m't"
      \<bar>  call setpos("'t", save_mark_t)
      \<bar>  nohlsearch

" TODO: enable pass arg which contains space as prefix or suffix
function s:join(...) range
  let delim=get(a:, 1, ' ')
  let lines = join(getline(a:firstline, a:lastline), delim)
  execute 'normal! '.(a:lastline-a:firstline+1).'"_dd'
  call append(a:firstline-1, lines)
endfunction
command! -nargs=? -bar -range=% Join :<line1>,<line2>call <SID>join(<f-args>)

command! -nargs=0 SaveAsTempfile :execute ':w '.tempname()

command! -nargs=0 BoxEdit :execute "normal! \<C-v>"

command! -range=% -nargs=0 RemoveWinCR :<line1>,<line2>/\r//g

function! NeoSnippetWrapLine(name, prefix, suffix)
  let cursor_mark='@'
  let line=a:prefix.substitute(getline('.'), '^\s*\|\s*'.a:name.'$', '', 'g').a:suffix
  " TODO: imapで<Plug>として実行したほうが自由度が高く色々と可能なはず
  " TODO: 複数行のsnippetにも対応したい
  call feedkeys("\<C-o>0\<C-o>\"_".(col('.')-len(a:name))."x\<C-o>".stridx(line, cursor_mark)."\<Right>", 'n')
  let line=substitute(line, cursor_mark, '', '')
  return line
endfunction

" NOTE: for c++ member initialization
function! CppMemberInitialization() range
  let lines=getline(a:firstline, a:lastline)

  let arg_list=[]
  let init_list=[]
  for line in lines
    " NOTE: field_ -> field_(field)
    let list = matchlist(line, '^\s*\(.\{-,}\)\s\+\([0-9a-zA-Z_]\+\)_;')
    if len(list) > 0
      let type_name=list[1]
      let arg_var_name=list[2]
      let field_var_name=list[2].'_'
      let arg_list+=[type_name.' '.arg_var_name]
      let init_list+=[field_var_name.'('.arg_var_name.')']
    else
      " NOTE: field -> field(field_)
      let list = matchlist(line, '^\s*\(.\{-,}\)\s\+\([0-9a-zA-Z_]\+\);')
      if len(list) > 0
        let type_name=list[1]
        let arg_var_name=list[2].'_'
        let field_var_name=list[2]
        let arg_list+=[type_name.' '.arg_var_name]
        let init_list+=[field_var_name.'('.arg_var_name.')']
      endif
    endif
  endfor

  let arg_list_output=""
  let init_list_output=""
  if len(arg_list) > 0
    let arg_list_output= '('.join(arg_list,', ').')'
  endif
  if len(init_list) > 0
    let init_list_output= ': '.join(init_list,', ')
  endif

  call append(line('.')-1, [arg_list_output,init_list_output])
endfunction
command! -nargs=0 -range CppConstructorInitialization <line1>,<line2>call CppMemberInitialization()
command! -nargs=0 -range CppMemberInitialization <line1>,<line2>call CppMemberInitialization()

if Doctor('ctags', 'for getting funcname')
  function! CppFuncName()
    let func_name=system("ctags -x --c-types=f ".expand('%:S')." | sed -E 's/ (\\W+)( *function)/\\1 \\2/' | sort -k 3 | sed -E 's/ +function +([0-9]+).*$/$\\1/' | awk -F'$' -v line=".line('.')." 'line>=int($2){func_name=$1;} END{if(func_name!=\"\") printf \"%s\", func_name;}'")
    return func_name
  endfunction
else
  function! CppFuncName()
    return "YOU NEED TO GET ctags"
  endfunction
endif

" NOTE
" xxx = yyy; -> yyy = xxx;
function! CppSwapVarEqual() range
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    let line = substitute(line, '^\(.*\)=\(.*\);$', '\2=\1;', 'g')
    call setline(n, line)
  endfor
endfunction
command! -nargs=0 -range CppSwapVarEqual <line1>,<line2>call CppSwapVarEqual()

command! -nargs=1 -range E    :exe "e    ".expand('%:p:h').'/'.<q-args>
command! -nargs=1 -range Tabe :exe "tabe ".expand('%:p:h').'/'.<q-args>

" FYI: [aehlke/vim\-rename3: Rename a buffer within Vim and on disk\.]( https://github.com/aehlke/vim-rename3 )
" :Rename[!] {newname}
command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")
" NOTE: bang: '' or '!'
function! Rename(name, bang)
  let l:curfile = expand("%:p")
  if l:curfile==''
    echomsg 'This file has no name!'
    echomsg 'Save :w <filepath>'
    return
  endif
  let l:curfilepath = expand("%:p:h")
  let l:newname = l:curfilepath . "/" . a:name
  let v:errmsg = ""
  let savecmd="saveas"
  silent! exec savecmd . a:bang . " " . fnameescape(l:newname)
  if v:errmsg !~# '^$\|^E329'
    echoerr v:errmsg
  else
    " NOTE: delete orig file
    if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
      silent exec "bwipe! " . fnameescape(l:curfile)
      if delete(l:curfile)
        echoerr "Could not delete " . l:curfile
      endif
    endif
    " NOTE: force reload (to adopt filetype)
    e!
  endif
endfunction

" NOTE: 書き込み処理を行っているとvimのpluginの挙動がおかしくなるので，
" view onlyがおすすめ
function! s:diff_split(...)
  let filename = get(a:, 1, 'HEAD:%')
  let l:currentWindow=winnr()
  execute "vertical rightbelow diffsplit ".filename
  execut l:currentWindow . "wincmd w"
endfunction
command! -nargs=* -complete=file DiffSplit call s:diff_split(<f-args>)
command! DisableDeoplete :call deoplete#disable()
command! EnableDeoplete :call deoplete#enable()

function! s:gitopen()
  let cmd='git url '.expand('%').' '.line('.')." | tr -d '\n'"
  let url=system(cmd)
  call OpenURL(url)
endfunction
command! GitOpen :call s:gitopen()

function! s:get_active_buffers()
  let result = ""
  silent! redir => result
  silent! exe "ls"
  redir END
  let active_buffer_filepath_list = []
  for line in split(result, "\n")
    let m=matchlist(line, '\m[0-9][0-9]* .a.. "\(.*\)"')
    if len(m) >= 2
      let filepath=m[1]
      " NOTE: [No Name] is used by 'mkitt/tabline.vim'
      if filepath == '[No Name]' | continue | endif
      let active_buffer_filepath_list +=[filepath]
    endif
  endfor
  return active_buffer_filepath_list
endfunction
function! s:paste_clipboard_to_active_buffers()
  let active_buffer_filepath_list=s:get_active_buffers()
  if len(active_buffer_filepath_list) > 0
    let @+ = join(active_buffer_filepath_list, "\n")
    echo '[COPY!]:'.@+
  else
    echo '[NO COPY!]'
  endif
endfunction
command! Tabs2Clipboard :call s:paste_clipboard_to_active_buffers()

command! Duplicate  execute("vnew ".expand('%'))
command! Duplicatev execute("vnew ".expand('%'))
command! Duplicates execute("new  ".expand('%'))

command! -range DeleteBlankLine :<line1>,<line2>g/^$/d | :noh
command! -range AddBlankLine :<line1>,<line2>s/$/\r/ | :noh

command! -range DeleteSpace :<line1>,<line2>s/\s\+//g | :noh

if Doctor('code', 'vscode')
  function! s:vscode_open(files)
    for file in a:files
      call system('code '.shellescape(fnamemodify(file, ":p")))
    endfor
  endfunction
  command! VSCodeOpen call s:vscode_open([expand('%')])
  command! VSCodeOpenAll call  s:vscode_open(s:get_active_buffers())
endif

" NOTE: echo value to new tab
command! -nargs=+ -bar -complete=expression Echo :execute "normal! \<ESC>" | redir @z | silent! echo <args> | redir END | tabnew | exe "normal! \"zp" | setlocal buftype=nofile | setlocal ft=log
