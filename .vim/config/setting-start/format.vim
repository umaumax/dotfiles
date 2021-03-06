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

" NOTE: git logのauthorが自分と一致する場合はプライベートなファイルであると仮定
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

  "   let l:author = system("git config user.name")
  " TODO: create function
  " cache data
  let l:tempfilename = 'git.config.user.name'
  "   let l:tempfilepath = fnamemodify(tempname(), ":p") . l:tempfilename
  let l:tempfiledir = expand('~/.vim/cache')
  if !isdirectory(l:tempfiledir)
    call mkdir(l:tempfiledir, "p")
  endif
  let l:tempfilepath = l:tempfiledir . '/' . l:tempfilename

  if filereadable(l:tempfilepath)
    let l:author = join(readfile(l:tempfilepath),'')
  else
    let l:author = system("git config user.name")
    if v:shell_error == 0
      call writefile(split(l:author, '\n'), l:tempfilepath)
    else
      let l:author = ''
    endif
  endif

  " NOTE: use only 10 oldeset commits for lookup speed
  " TODO: oldestからn件を効率よくlookupする方法は?
  " --revsere -n 10とすると直近10件をrevsereしてしまう
  let l:authors = system("cd " . shellescape(l:dir_path) . " && git rev-parse --is-inside-work-tree > /dev/null 2>&1 && (git log --format='%an' -10 > /dev/null 2>&1 | sort | uniq | tr -d '\n')")
  let l:is_private = l:authors == "" || l:authors == l:author || l:authors == 'umaumax'
  let g:is_private_work_cache[l:dir_path] = l:is_private
  return l:is_private
endfunction

" NOTE: [vim で markdown を書いているときに prettier で整形する \(プラグイン使わずに\) \- Qiita]( https://qiita.com/pankona/items/a493bf97f46e3d52d0de )
" formatargを設定する手法を利用してみると範囲指定のformatがやりやすいのでは?

" NOTE: default format command
function! s:format_file()
  " FYI: [Vim:カーソル位置を移動せずにファイル全体を整形する \- ぼっち勉強会]( http://kannokanno.hatenablog.com/entry/2014/03/16/160109 )
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
command! NoAutoFormatForce let g:auto_format_force_flag=0
command! AutoFormatForce let g:auto_format_force_flag=1
command! ResetAutoFormatForce unlet g:auto_format_force_flag
command! DisableAutoFormat let b:auto_format_flag=0
command! AutoFormat let b:auto_format_flag=1

" 下記のautocmdの統合は案外難しい
" FYI
" [vim\-codefmt/yapf\.vim at 5ede026bb3582cb3ca18fd4875bec76b98ce9a12 · google/vim\-codefmt]( https://github.com/google/vim-codefmt/blob/5ede026bb3582cb3ca18fd4875bec76b98ce9a12/autoload/codefmt/yapf.vim#L22 )

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
if Doctor('autopep8', 'python format')
  augroup python_group
    autocmd!
    " NOTE: if you want to ignore text length per line
    " :PythonFormat --ignore=E501
    " NOTE: for force format
    " :PythonFormat --aggressive --aggressive
    autocmd FileType python ++once autocmd BufWinEnter *.py command! -bar Format :PythonFormat --aggressive
    autocmd FileType python ++once autocmd BufWritePre *.py if IsAutoFormat() | :PythonFormat --aggressive | endif
  augroup END
endif

" 'maksimr/vim-jsbeautify'
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

augroup awk_group
  autocmd!
  autocmd FileType awk ++once autocmd BufWinEnter *.awk command! -bar Format call <SID>format_file()
  autocmd FileType awk ++once autocmd BufWritePre *.awk if IsAutoFormat() |  call <SID>format_file() | endif
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

if Doctor('shfmt', 'shell format')
  augroup shell_group
    autocmd!
    " NOTE: _* is for zsh completion file
    autocmd FileType sh,zsh ++once autocmd BufWinEnter *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile},_* command! -bar Format ShFormat
    autocmd FileType sh,zsh ++once autocmd BufWinEnter * if &ft == 'sh' || &ft == 'zsh' | command! -bar Format ShFormat | endif
    autocmd FileType sh,zsh ++once autocmd BufWritePre *.{sh,bashrc,bashenv,bash_profile,zsh,zshrc,zshenv,zprofile},_* if IsAutoFormat() |  :ShFormat | endif
    autocmd FileType sh,zsh ++once autocmd BufWritePre * if (&ft == 'sh' || &ft == 'zsh' ) && IsAutoFormat() | :ShFormat | endif
  augroup END
endif

if Doctor('cmake-format', 'cmake format')
  augroup cmake_format_group
    autocmd!
    autocmd FileType cmake ++once autocmd BufWritePre CMakeLists.txt,*.{cmake}      if       IsAutoFormat() | :Format | endif
    autocmd FileType cmake ++once autocmd! cmake_format_group FileType
  augroup END
endif

if Doctor('nasmfmt', 'nasm format')
  augroup nasm_format_group
    autocmd!
    autocmd FileType nasm ++once autocmd BufWinEnter * if &ft == 'nasm' | command! -bar Format NasmFormat | endif
    autocmd FileType nasm ++once autocmd BufWritePre * if &ft == 'nasm' && IsAutoFormat() | :NasmFormat | endif
    autocmd FileType nasm ++once autocmd! nasm_format_group FileType
  augroup END
endif

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

if Doctor('gofmt', 'go format')
  augroup go_format_group
    autocmd!
    autocmd FileType go ++once autocmd BufWinEnter *.go command! -bar Format GoFmt
    autocmd FileType go ++once autocmd BufWritePre *.go if IsAutoFormat() | :GoFmtWrapper | endif
  augroup END
  " NOTE: original GoFmt has no '-bar' option
  command! -bar GoFmtWrapper :GoFmt
endif

" NOTE: コメントが消える不具合がある
" augroup yaml_format_group
" autocmd!
" autocmd FileType yaml autocmd BufWinEnter *.{yaml,yml} command! -bar Format YAMLFormat
" autocmd FileType yaml autocmd BufWritePre *.{yaml,yml} if IsAutoFormat() | :YAMLFormatWrapper | endif
" autocmd FileType yaml autocmd! yaml_format_group FileType
" augroup END
" " NOTE: original YAMLFormat has no '-bar' option
" command! -bar YAMLFormatWrapper :YAMLFormat

if Doctor('align', 'yaml format')
  augroup yaml_format_group
    autocmd!
    autocmd FileType yaml ++once autocmd BufWinEnter *.{yaml,yml} command! -bar Format YamlFormat
    autocmd FileType yaml ++once autocmd BufWritePre *.{yaml,yml} if IsAutoFormat() | :YamlFormat | endif
  augroup END
  " command! YAMLFormat :
  " NOTE: original YAMLFormat has no '-bar' option
  " command! -bar YAMLFormatWrapper :YAMLFormat
endif

if Doctor('prettier', 'toml format')
  augroup toml_format_group
    autocmd!
    autocmd FileType toml ++once autocmd BufWinEnter *.{toml,yml} command! -bar Format TomlFormat
    autocmd FileType toml ++once autocmd BufWritePre *.{toml,yml} if IsAutoFormat() | :TomlFormat | endif
  augroup END
endif

if Doctor('rustfmt', 'rust format')
  augroup rust_format_group
    autocmd!
    autocmd FileType rust ++once autocmd BufWinEnter *.{rs} command! -bar Format RustFormat
    autocmd FileType rust ++once autocmd BufWritePre *.{rs} if IsAutoFormat() | :RustFormat | endif
  augroup END
endif

if Doctor('goenkins-format', 'jenkins pipeline format')
  let g:vim_format_list={
        \ 'jenkins':{'autocmd':['*.groovy'],'cmds':[{'requirements':['goenkins-format'], 'shell':'cat {input_file} | goenkins-format'}]},
        \ }
  augroup jenkins_pipeline_format_group
    autocmd!
    autocmd FileType groovy ++once autocmd BufWinEnter *.{groovy} command! -bar Format JenkinsFormat
    autocmd FileType groovy ++once autocmd BufWritePre *.{groovy} if IsAutoFormat() | :JenkinsFormat | endif
  augroup END
endif

" " error表示のwindowの制御方法が不明
" " Plug 'tell-k/vim-autopep8'
" function! Preserve(command)
" " Save the last search.
" let search = @/
" " Save the current cursor position.
" let cursor_position = getpos('.')
" " Save the current window position.
" normal! H
" let window_position = getpos('.')
" call setpos('.', cursor_position)
" " Execute the command.
" execute a:command
" " Restore the last search.
" let @/ = search
" " Restore the previous window position.
" call setpos('.', window_position)
" normal! zt
" " Restore the previous cursor position.
" call setpos('.', cursor_position)
" endfunction

" function! Autopep8()
" [vimでpythonのコーディングスタイルを自動でチェック&自動修正する \- blog\.ton\-up\.net]( https://blog.ton-up.net/2013/11/26/vim-python-style-check-and-fix/ )
" call Preserve(':silent %!autopep8 --ignore=E501 -')
" endfunction

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
