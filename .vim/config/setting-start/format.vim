" NOTE:
" 1. :w <filepath>で初めて，あるFileTypeイベント発生する
" 2. Plug 'xxx', {'for', 'xxx'} は読み込まれていない
" 3. autocmd FileType 駆動で初回のみformatイベントを登録し，
" 最後にautocmd FileTypeを解除する
"
" NOTE:
" :e! cause force FileType event

function! IsInGitRepo(file)
  let ret=system('cd $(dirname '.shellescape(a:file).') && git rev-parse --is-inside-work-tree | tr -d "\n"')
  return ret == 'true'
endfunction
function! GetGitRepoRoot(file)
  return system('cd $(dirname '.shellescape(a:file).') && git rev-parse --show-toplevel 2>/dev/null | tr -d "\n"')
endfunction
function! IsInSameGitRepo(file1, file2)
  let root1=GetGitRepoRoot(a:file1)
  let root2=GetGitRepoRoot(a:file2)
  return root1 != "" && root1 == root2
endfunction

" with cache
function! s:git_user_name()
  let l:tempfilename = 'git.config.user.name'
  let l:tempfiledir = expand('~/.vim/cache')
  if !isdirectory(l:tempfiledir)
    call mkdir(l:tempfiledir, "p")
  endif
  let l:tempfilepath = l:tempfiledir . '/' . l:tempfilename

  if filereadable(l:tempfilepath)
    return join(readfile(l:tempfilepath),'')
  endif
  let l:author = system("git config user.name")
  if v:shell_error != 0
    return ''
  endif
  call writefile(split(l:author, '\n'), l:tempfilepath)
  return l:author
endfunction

" NOTE: if my name is equal to git log author name => private repository
let g:is_private_work_cache={}
function! IsPrivateWork(...)
  let l:dir_path = get(a:, 1, expand('%:p:h'))
  if has_key(g:is_private_work_cache, l:dir_path)
    return g:is_private_work_cache[l:dir_path]
  endif

  " NOTE: if current file git repo has '.public_repo' file,
  " this treats as non-private repo
  if filereadable(GetGitRepoRoot(expand('%:p')).'/.public_repo')
    return 0
  endif

  let l:author = s:git_user_name()

  " NOTE: use only 10 oldeset commits for lookup speed
  " TODO: oldestからn件を効率よくlookupする方法は?
  " --revsere -n 10とすると直近10件をrevsereしてしまう
  let l:authors = system("cd " . shellescape(l:dir_path) . " && git rev-parse --is-inside-work-tree > /dev/null 2>&1 && (git log --format='%an' -10 > /dev/null 2>&1 | sort | uniq | tr -d '\n')")
  let l:is_private = l:authors == "" || l:authors == l:author || l:authors == 'umaumax'
  let g:is_private_work_cache[l:dir_path] = l:is_private
  return l:is_private
endfunction

function! s:toupper_first(text)
  if len(a:text) == 0
    return ''
  endif
  return toupper(a:text[0]).a:text[1:]
endfunction

" NOTE: default format command
function! s:format_file()
  let filetype_format_command = s:toupper_first(&filetype).'Format'
  let exists_full_match_retval = 2
  if exists(':'.filetype_format_command) == exists_full_match_retval
    execute filetype_format_command
    return
  endif

  let l:view = winsaveview()
  normal! gg=G
  silent call winrestview(l:view)
endfunction
command! -bar Format call <SID>format_file()
" NOTE: register default format command
augroup auto_format_setting_when_leaving
  autocmd!
  autocmd BufWinLeave * command! -bar Format call <SID>format_file()
augroup END

function! IsAutoFormat()
  if exists('g:auto_format_force_flag')
    return g:auto_format_force_flag == 1
  endif
  return b:auto_format_flag == 1
endfunction
let b:auto_format_flag=1
" NOTE: if command name startswith AutoFormat, there are many similar command to complete
command! NoAutoFormatForce    let   g:auto_format_force_flag=0
command! AutoFormatForce      let   g:auto_format_force_flag=1
command! ResetAutoFormatForce unlet g:auto_format_force_flag
command! DisableAutoFormat    let   b:auto_format_flag=0
command! AutoFormat           let   b:auto_format_flag=1

if Doctor('clang-format', 'clang format')
  " NOTE: for partly ranged clang-format
  function! s:clang_format_range() range
    if a:firstline==1 && a:lastline==line('$')
      call clang_format#replace(1, line('$'))
    else
      execute ":".a:firstline.",".a:lastline."!clang-format -"
    endif
  endfunction
  command! -range=% -bar ClangFormatRange :<line1>,<line2>call s:clang_format_range()
  augroup cpp_group
    autocmd!
    autocmd FileType cpp ++once autocmd BufWinEnter *.{c,h,cc,cxx,cpp,hpp} command! -range=% -bar Format :<line1>,<line2>ClangFormatRange
    autocmd FileType cpp ++once autocmd BufWritePre *.{c,h,cc,cxx,cpp,hpp} :call s:clang_format_setting() | if IsAutoFormat() | call clang_format#replace(1, line('$')) | endif
  augroup END
endif

" required: 'maksimr/vim-jsbeautify'
if Doctor('npm', 'js,html,css format')
  augroup javascript_group
    autocmd!
    autocmd FileType javascript ++once autocmd BufWinEnter *.js command! -bar Format call JsBeautify()
    autocmd FileType javascript ++once autocmd BufWritePre *.js if IsAutoFormat() |  call JsBeautify() | endif
  augroup END
  augroup json_group
    autocmd!
    autocmd FileType json ++once autocmd BufWinEnter *.json command! -bar Format :JsonFormat
    autocmd FileType json ++once autocmd BufWritePre *.json if IsAutoFormat() |  :JsonFormat | endif
  augroup END
  augroup html_vue_group
    autocmd!
    autocmd FileType html,vue ++once autocmd BufWinEnter *.{html,vue} command! -bar Format call HtmlBeautify()
    autocmd FileType html,vue ++once autocmd BufWritePre *.{html,vue} if IsAutoFormat() |  call HtmlBeautify() | endif
  augroup END
  augroup css_group
    autocmd!
    autocmd FileType css ++once autocmd  BufWinEnter *.css command! -bar Format      call CSSBeautify()
    autocmd FileType css ++once autocmd  BufWritePre *.css if       IsAutoFormat() | call CSSBeautify() | endif
  augroup END
endif

" NOTE: if you want to ignore text length per line
" :PythonFormat --ignore=E501
" NOTE: for force format
" :PythonFormat --aggressive --aggressive
let g:vim_format_fmt_on_save = 1
let g:Vim_format_pre_hook = { key, args -> IsAutoFormat() }

let g:vim_format_list={
      \ 'jenkins':{'autocmd':['*.groovy'],'cmds':[{'requirements':['goenkins-format'], 'shell':'cat {input_file} | goenkins-format'}]},
      \ }
function! s:vim_format_setting()
  if &rtp !~ 'vim-format'
    return
  endif
  " NOTE: _* is for zsh completion file
  call add(g:vim_format_list['zsh']['autocmd-filename'], '_*')
endfunction
augroup vim_format_setting_group
  autocmd!
  autocmd VimEnter * call <SID>vim_format_setting()
augroup END

augroup vim_group
  autocmd!
  autocmd FileType vim ++once autocmd BufWritePre *.vim  if IsAutoFormat() | call <SID>format_file() | endif
  autocmd FileType vim ++once autocmd BufWritePre *vimrc if IsAutoFormat() | call <SID>format_file() | endif
augroup END

augroup tex_group
  autocmd!
  autocmd FileType plaintex ++once autocmd BufWritePre *.tex  if IsAutoFormat() | call <SID>format_file() | endif
augroup END

augroup gas_format_group
  autocmd!
  autocmd FileType gas ++once autocmd BufWritePre * if &ft == 'gas' && IsAutoFormat() | :Format | endif
  autocmd FileType gas ++once autocmd! gas_format_group FileType
augroup END

if Doctor('xmllint', 'xml format')
  " NOTE: tmp disable
  " augroup xml_format_group
  " autocmd!
  " autocmd FileType xml autocmd BufWinEnter *.{xml} command! -bar Format         XMLFormat
  " autocmd FileType xml autocmd BufWritePre *.{xml} if       IsAutoFormat() | :XMLFormat | endif
" autocmd FileType xml autocmd! xml_format_group FileType
" augroup END
command! -range=% -bar XMLFormat :<line1>,<line2>!xmllint --format -
endif

let g:highlight_backup_dict = {}
function! s:highlight_backup(name)
  let result = ""
  silent! redir => result
  execute 'silent! highlight '.a:name
  redir END
  " NOTE: terminalサイズによって，redirの出力には間に無駄に改行が入るので注意
  return substitute(result, "\n",'','g')
endfunction
function! s:save_highlight_to_backup_if_not_exist(list)
  for key in a:list
    if !has_key(g:highlight_backup_dict, key)
      let g:highlight_backup_dict[key] = s:highlight_backup(key)
    endif
  endfor
endfunction
function! s:restore_highlight_from_backup()
  for [key, val] in items(g:highlight_backup_dict)
    " WARN: maybe ignore error
    execute 'silent! highlight '.substitute(val, 'xxx','','')
  endfor
endfunction

function! s:work_setting()
  call s:save_highlight_to_backup_if_not_exist(['Normal','LineNr'])

  if IsPrivateWork()
    let b:auto_format_flag = 1
    let g:autochmodx_ignore_scriptish_file_patterns = []
    call s:restore_highlight_from_backup()
  else
    let b:auto_format_flag = 0
    " NOTE: disable auto chmod
    " shell file is exception
    let g:autochmodx_ignore_scriptish_file_patterns =[
          \      '\c.*\.pl$',
          \      '\c.*\.rb$',
          \      '\c.*\.py$',
          \ ]
    " highlight Normal ctermbg=0 guibg=#320000
    " highlight LineNr ctermbg=167 guibg=#650000
  endif
endfunction

function! s:detect_clang_format_style_file() abort
  let dirname = fnameescape(expand('%:p:h'))
  let filepathes = [findfile('.clang-format', dirname.';')]+[findfile('_clang-format', dirname.';')]
  return len(filepathes) > 0 ? filepathes[0] : ''
endfunction
function! s:clang_format_setting()
  let b:auto_format_flag=1
  let clang_format_filepath=s:detect_clang_format_style_file()
  if !IsPrivateWork() && IsInGitRepo(expand('%:p')) && !IsInSameGitRepo(expand('%:p'), clang_format_filepath)
    let b:auto_format_flag=0
  endif
endfunction

augroup private_or_public_work
  autocmd!
  autocmd BufWinEnter,TabEnter * :call <SID>work_setting()
  autocmd BufWinEnter,TabEnter *.go :let b:auto_format_flag=1
  autocmd BufWinEnter,TabEnter *.rs :let b:auto_format_flag=1
  " autocmd BufWinEnter,TabEnter *.{c,cc,cxx,cpp,h,hh,hpp} :call <SID>clang_format_setting()
  " autocmd FileType cpp :call <SID>clang_format_setting()
augroup END
