" NOTE: only for normal git commit (when using --amend without git add, this plugin is disabled)
" NOTE: you can't add {'for':'gitcommit'}
Plug 'rhysd/committia.vim'
" NOTE: don't use hook with lazy plug load
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  call s:committia_hooks_edit_open(a:info)
endfunction
let b:startinsert_flag=v:false
function! s:committia_hooks_edit_open(info)
  " Additional settings
  setlocal spell

  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
    let b:startinsert_flag=v:true
  endif

  " Scroll the diff window from insert mode
  map <buffer><S-Down> <Plug>(committia-scroll-diff-down-half)
  map <buffer><S-Up> <Plug>(committia-scroll-diff-up-half)
endfunction

function! s:git_commit_startup()
  if b:startinsert_flag==v:true
    startinsert
  endif
endfunction

augroup git_commit_startup_group
  autocmd!
  autocmd User VimEnterDrawPost call s:git_commit_startup()
  autocmd FileType gitcommit setlocal spell
  " NOTE: automatically remove trailing whitespace at commit message
  autocmd BufWritePre COMMIT_EDITMSG :%s/\s\+$//e
augroup END

" FYI: [チーズバーガー中毒: Vimで入力補完を常にオンにするvimrc]( http://io-fia.blogspot.com/2012/11/vimvimrc.html )
set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_./-",'\zs')
  " NOTE: <buffer> is used for overwrite mapping for callback
  exec "imap <buffer> <expr> " . k . " '" . k . "\<C-X>\<C-O>'"
endfor

let g:commit_words_cache=[]
let g:is_executable_look=executable('look')
" FYI: [vim\-jp » Hack \#14: Insert mode補完 自作編]( https://vim-jp.org/vim-users-jp/2009/05/21/Hack-14.html )
function! CommitMessageHelper(findstart, base)
  if a:findstart
    " Get cursor word.
    let cur_text = strpart(getline('.'), 0, col('.') - 1)
    return match(cur_text, '\f*$')
  endif

  let files = split(expand(a:base . '*'), '\n')
  let files = filter(files, {-> v:val != a:base.'*'})
  let s:TrimPrefix={ str, prefix -> execute(join(['let ret=str','let idx = stridx(str, prefix)','if idx != -1','let ret=str[idx+len(prefix):]','endif'],"\n")) ? "dummy" : ret }
  let files = map(files, {-> s:TrimPrefix(v:val, './')})

  " create words cache
  if len(g:commit_words_cache) == 0
    let lines=[]
    " NOTE: get another buffer words
    for i in range(1, bufnr('$'))
      let buf_lines=getbufline(bufnr(i), 1, '$')
      if len(buf_lines) > 1000
        " maybe bufnr("__committia_diff__") has many lines
        continue
      endif
      let lines+=buf_lines
    endfor
    let min_len=3
    let words=filter(split(substitute(join(lines, "\n"),'[^0-9a-zA-Z_-]',' ','g')), { -> len(v:val) >= min_len })
    " FYI: [How to flatten a nested list in Vim script? \- Stack Overflow]( https://stackoverflow.com/questions/11912688/how-to-flatten-a-nested-list-in-vim-script )
    " NOTE: split xxx-yyy and abc_def for completions of [xxx,yyy,abc,def,xxx-yyy,abc_def]
    function! s:flatten(list)
      let val = []
      for elem in a:list
        if type(elem) == type([])
          call extend(val, s:flatten(elem))
        else
          call add(val, elem)
        endif
        unlet elem
      endfor
      return val
    endfunction
    let words+=s:flatten(map(filter(copy(words),{ -> stridx(v:val,'_')>=0 }), { -> split(v:val, '_') }))+s:flatten(map(filter(copy(words),{ -> stridx(v:val,'-')>=0 }), { -> split(v:val, '-') }))
    call filter(words, { -> len(v:val) >= min_len })
    let words+=['Update','Add','Delete','Remove','Fix','Refs: ','[TMP]','[WIP]', 'Refactor']
    call uniq(sort(words))
    call filter(words, {-> v:val !~ '^[0-9]'})
    let g:commit_words_cache=words
  endif
  let words=g:commit_words_cache

  let word=substitute(a:base,'[^a-zA-Z]','','g')
  let look_words=[]
  if g:is_executable_look && len(word) >= 4
    let look_words=split(system('look '.word,"\n"))
  endif

  let list = []
  call add(list, { 'word' : a:base, 'abbr' : a:base, 'menu' : 'default' })
  let cnt = 0
  " NOTE
  " don't use filter() to reuse words cache
  " call filter(words, {-> v:val =~ '^'.a:base})
  for word in words
    if word =~ '^'.a:base
      call add(list, { 'word' : word, 'abbr' : printf('%3d: %s', cnt, word), 'menu' : 'word' })
      let cnt += 1
    endif
  endfor
  for word in look_words
    call add(list, { 'word' : word, 'abbr' : printf('%3d: %s', cnt, word), 'menu' : 'word' })
    let cnt += 1
  endfor
  for file in files
    call add(list, { 'word' : file, 'abbr' : printf('%3d: %s', cnt, file), 'menu' : 'file' })
    let cnt += 1
  endfor
  return list
endfunction
setlocal omnifunc=CommitMessageHelper

" augroup committia_hooks_group
"   autocmd!
"   autocmd User VimEnterDrawPost if &ft == 'gitcommit' | call s:committia_hooks_edit_open({'vcs':'git'}) | endif
" augroup END
