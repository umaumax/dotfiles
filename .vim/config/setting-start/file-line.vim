" FYI: [file\-line/file\_line\.vim at master · bogado/file\-line · GitHub]( https://github.com/bogado/file-line/blob/master/plugin/file_line.vim )
" e.g.
" vim ~/.vimrc:10
" :e ~/.vimrc:10

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_file_line') || (v:version < 701)
  finish
endif
let g:loaded_file_line = 1

" below regexp will separate filename and line/column number
" possible inputs to get to line 10 (and column 99) in code.cc are:
" * code.cc(10)
" * code.cc(10:99)
" * code.cc:10
" * code.cc:10:99
"
" closing braces/colons are ignored, so also acceptable are:
" * code.cc(10
" * code.cc:10:
let s:regexpressions = [ '\(.\{-1,}\)[(:]\(\d\+\)\%(:\(\d\+\):\?\)\?' ]

" e HEAD:README.md
" e HEAD:%
" e %:HEAD~
" for my cmd
" DiffSplit HEAD:%
let s:git_prefix_regexpressions = {'regexp': '^\(\([0-9a-f]\{5,40}\|@\|HEAD\)[~^]*\):\(.\+\)$',     'file': 3, 'commit': 1}
let s:git_suffix_regexpressions = {'regexp': '^\(.\{-1,}\):\(\([0-9a-f]\{5,40}\|@\|HEAD\)[~^]*\)$', 'file': 1, 'commit': 2}
let s:git_regexpressions = [ s:git_prefix_regexpressions, s:git_suffix_regexpressions ]

function! s:reopenAndGotoLine(file_name, line_num, col_num)
  if !filereadable(a:file_name)
    return
  endif

  let l:bufn = bufnr("%")

  exec "keepalt edit " . fnameescape(a:file_name)
  exec a:line_num
  exec "normal! " . a:col_num . '|'
  if foldlevel(a:line_num) > 0
    exec "normal! zv"
  endif
  exec "normal! zz"

  exec "bwipeout " l:bufn
  exec "filetype detect"
endfunction

function! s:create_tmp_git_show_file(sha,filename)
  let basename=fnameescape(fnamemodify(a:filename,':t'))
  let absdirpath=fnameescape(fnamemodify(a:filename,':p:h'))
  let tmpfilepath=tempname()."_".fnameescape(a:sha)."_".basename
  let cmd=join(["git", "-C", shellescape(absdirpath), "show", shellescape(a:sha).":./".shellescape(basename)], ' ')

  let output = system(cmd)
  if v:shell_error != 0
    let output=cmd."\n".output
  endif
  call writefile(split(output,"\n"),fnameescape(tmpfilepath))
  return tmpfilepath
endfunction

function! s:gotoline()
  let file = bufname("%")

  " :e command calls BufRead even though the file is a new one.
  " As a workaround Jonas Pfenniger<jonas@pfenniger.name> added an
  " AutoCmd BufRead, this will test if this file actually exists before
  " searching for a file and line to goto.
  if (filereadable(file) || file == '')
    return file
  endif

  let l:names = []
  for regexp in s:regexpressions
    let l:names =  matchlist(file, regexp)

    if ! empty(l:names)
      let file_name = l:names[1]
      let line_num  = l:names[2] == ''? '0' : l:names[2]
      let  col_num  = l:names[3] == ''? '0' : l:names[3]
      call s:reopenAndGotoLine(file_name, line_num, col_num)
      return file_name
    endif
  endfor

  for reg_obj in s:git_regexpressions
    let regexp=reg_obj['regexp']
    let commit_index=reg_obj['commit']
    let file_index=reg_obj['file']
    let l:names = matchlist(file, regexp)

    if ! empty(l:names)
      let sha = l:names[commit_index]
      let file_name = l:names[file_index]
      let line_num='0'
      let col_num='0'
      let tmpfilepath=s:create_tmp_git_show_file(sha,file_name)
      call s:reopenAndGotoLine(tmpfilepath, line_num, col_num)
      return tmpfilepath
    endif
  endfor
  return file
endfunction

" Handle entry in the argument list.
" This is called via `:argdo` when entering Vim.
function! s:handle_arg()
  " NOTE: for prevent 'E37: No write since last change (add ! to override)'
  "       caused by ls | vim - a.log b.log c.log
  " NOTE: below codes cause go to line number error at first tab
  " if &modified
  " tabnew
  " endif

  let argname = expand('%')
  let fname = s:gotoline()
  if fname != argname
    let argidx = argidx()
    exec (argidx+1).'argdelete'
    exec (argidx)'argadd' fnameescape(fname)
  endif
endfunction

function! GotolineStartup()
  autocmd BufNewFile * ++nested call s:gotoline()
  autocmd BufRead * ++nested call s:gotoline()

  tabdo e!
  tabfirst

  if argc() > 0
    let argidx=argidx()
    silent call s:handle_arg()
    exec (argidx+1).'argument'
    " Manually call Syntax autocommands, ignored by `:argdo`.
    doautocmd Syntax
    doautocmd FileType
  endif
endfunction

" if !isdirectory(expand("%:p"))
" autocmd User VimEnter ++nested call GotolineStartup()
" endif
