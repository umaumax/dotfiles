function! s:fzf_vim_commands_snippet() range
  let lines = []

  let g:vim_cmd_snippet_filepath='~/dotfiles/local/snippets/vim_cmd_snippet.txt'
  let l:snippet_filepath=expand(g:vim_cmd_snippet_filepath)
  if filereadable(l:snippet_filepath)
    let lines = readfile(l:snippet_filepath)
  else
    echoerr 'not found '.l:snippet_filepath
  endif

  let objects=[]
  let index=-1
  for line in filter(lines, {i,x-> stridx(x, '#')!=0})
    let key=''
    let value=''
    if stridx(line, 'name:')==0
      let key='name'
      let value=strpart(line, len(key.':'))
      let index+=1
      let objects += [{'name':'','command':'','description':''}]
    elseif stridx(line, 'command:')==0
      let key='command'
      let value=strpart(line, len(key.':'))
    else
      let key='description'
      let value=line
      if stridx(line, 'description:')==0
        let value=strpart(line, len(key.':'))
      endif
      let value .= '\n'
    endif
    if index>=0
      let objects[index][key] .= value
    endif
  endfor
  " NOTE: s.nbs is delim
  let list = map(objects, {i,x->x['name'].s:nbs.x['command'].s:nbs.x['description']})
  let l:header='vim commands snippet'
  return fzf#run({
        \ 'source': [l:header] + list,
        \ 'sink*':   s:function('s:command_snippet_sink'),
        \ 'options': '--ansi --expect '.get(g:, 'fzf_commands_expect', 'ctrl-x').
        \            ' --tiebreak=index --header-lines 1 -x --prompt "Snippets> " -d "'.s:nbs.'" -n 1,2 --with-nth 1,2 --preview '."'echo {3} | { type >/dev/null 2>&1 bat && bat -l md --color always --style=plain --pager=never || cat; }'"})
endfunction

command! -range FZFCommandsSnippet :<line1>,<line2> call s:fzf_vim_commands_snippet()
command! -range CommandsSnippet :<line1>,<line2> call s:fzf_vim_commands_snippet()
command! -range CS :<line1>,<line2> call s:fzf_vim_commands_snippet()

function! s:command_snippet_sink(lines)
  if len(a:lines) < 2
    return
  endif
  " NOTE: s.nbs is delim
  " name:command:description
  let cmd = split(a:lines[1], s:nbs)[1]
  " NOTE: trim head spaces
  let cmd = substitute(cmd, '^ \+', '', '')
  let pos = stridx(cmd, '\%#')
  let cmd = substitute(cmd, '\\%#', '', '')
  let move_cmd_feedkey=''
  if pos != -1
    let move_cmd_feedkey=repeat("\<Left>", len(cmd)-pos)
  endif
  if empty(a:lines[0])
    call feedkeys(':'.cmd.(cmd[0] == '!' ? '' : '').move_cmd_feedkey, 'n')
    " if pos != -1
    " NOTE: only for <C-\>e mode
    " call setcmdpos(len(':')+pos)
    " endif
  else
    execute cmd
  endif
endfunction

" ----

" NOTE: to overwrite default Commands command of fzf.vim
" because default Commands has no '--nth' option
" beauces default Commands ignore exopts of 'options' key see souce code of `s:fzf()`
function! s:fzf_vim_commands()
  redir => cout
  silent command
  redir END
  let nth_opt='--nth 2'
  let list = split(cout, "\n")
  return fzf#run({
        \ 'source':  extend(extend(list[0:0], map(list[1:], 's:format_cmd(v:val)')), s:excmds()),
        \ 'sink*':   s:function('s:command_sink'),
        \ 'options': '--ansi --expect '.get(g:, 'fzf_commands_expect', 'ctrl-x').
        \            ' --tiebreak=index --header-lines 1 -x --prompt "Commands> " -n2,3,2..3 -d'.s:nbs.' '.nth_opt})
endfunction
command! FZFCommands call s:fzf_vim_commands()
command! Commands call s:fzf_vim_commands()

" FYI
""""""""""""""""""""""""""""""""""""""""""""""""
" https://github.com/junegunn/fzf.vim
" autoload/fzf/vim.vim
""""""""""""""""""""""""""""""""""""""""""""""""

let s:nbs = nr2char(0x2007)

function! s:format_cmd(line)
  return substitute(a:line, '\C \([A-Z]\S*\) ',
        \ '\=s:nbs.s:yellow(submatch(1), "Function").s:nbs', '')
endfunction

function! s:strip(str)
  return substitute(a:str, '^\s*\|\s*$', '', 'g')
endfunction

if v:version >= 704
  function! s:function(name)
    return function(a:name)
  endfunction
else
  function! s:function(name)
    " By Ingo Karkat
    return function(substitute(a:name, '^s:', matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunction$'), ''))
  endfunction
endif

function! s:get_color(attr, ...)
  let gui = has('termguicolors') && &termguicolors
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction

let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36}

function! s:csi(color, fg)
  let prefix = a:fg ? '38;' : '48;'
  if a:color[0] == '#'
    return prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
  endif
  return prefix.'5;'.a:color
endfunction

function! s:ansi(str, group, default, ...)
  let fg = s:get_color('fg', a:group)
  let bg = s:get_color('bg', a:group)
  let color = (empty(fg) ? s:ansi[a:default] : s:csi(fg, 1)) .
        \ (empty(bg) ? '' : ';'.s:csi(bg, 0))
  return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction

for s:color_name in keys(s:ansi)
  execute "function! s:".s:color_name."(str, ...)\n"
        \ "  return s:ansi(a:str, get(a:, 1, ''), '".s:color_name."')\n"
        \ "endfunction"
endfor

function! s:command_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = matchstr(a:lines[1], s:nbs.'\zs\S*\ze'.s:nbs)
  if empty(a:lines[0])
    call feedkeys(':'.cmd.(a:lines[1][0] == '!' ? '' : ' '), 'n')
  else
    execute cmd
  endif
endfunction

let s:fmt_excmd = '   '.s:blue('%-38s', 'Statement').'%s'

function! s:format_excmd(ex)
  let match = matchlist(a:ex, '^|:\(\S\+\)|\s*\S*\(.*\)')
  return printf(s:fmt_excmd, s:nbs.match[1].s:nbs, s:strip(match[2]))
endfunction

function! s:excmds()
  let help = globpath($VIMRUNTIME, 'doc/index.txt')
  if empty(help)
    return []
  endif

  let commands = []
  let command = ''
  for line in readfile(help)
    if line =~ '^|:[^|]'
      if !empty(command)
        call add(commands, s:format_excmd(command))
      endif
      let command = line
    elseif line =~ '^\s\+\S' && !empty(command)
      let command .= substitute(line, '^\s*', ' ', '')
    elseif !empty(commands) && line =~ '^\s*$'
      break
    endif
  endfor
  if !empty(command)
    call add(commands, s:format_excmd(command))
  endif
  return commands
endfunction

