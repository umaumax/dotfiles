" [vim \- How to yank lines into the same register then paste into a new buffer? \- Super User]( https://superuser.com/questions/1107864/how-to-yank-lines-into-the-same-register-then-paste-into-a-new-buffer )
function! PipeCommandResultToNewTab(cmd)
  " NOTE: this ESC is to acoid 'Press ENTER or type command to continue'
  execute "normal! \<ESC>"
  redir @z
  execute 'silent '.a:cmd
  redir END
  tabnew | exe "normal! \"zp" | setlocal buftype=nofile | setlocal ft=vim
endfunction

function! OrigBind()
  echo ' crs,cr_ " SnakeCase" -> "snake_case"'
  echo ' crm     "mixed_case" -> " MixedCase"'
  echo ' crc     "camel_case" -> " camelCase"'
  echo ' cru,crU "upper_case" -> "UPPER_CASE"'
  echo ' crk,cr- " dash_case" -> " dash-case"'
  echo ' cr.     "  dot_case" -> "  dot.case"'
  echo ' cr" "   "space_case" -> "space case"'
  echo ' crt     "title_case" -> "Title Case"'
endfunction

command! Map         call PipeCommandResultToNewTab("map")
command! Imap        call PipeCommandResultToNewTab("imap")
command! Cmap        call PipeCommandResultToNewTab("cmap")
command! Smap        call PipeCommandResultToNewTab("smap")
command! Nmap        call PipeCommandResultToNewTab("nmap")
command! Vmap        call PipeCommandResultToNewTab("vmap")
command! Xmap        call PipeCommandResultToNewTab("xmap")
command! Omap        call PipeCommandResultToNewTab("omap")
command! Mapv        call PipeCommandResultToNewTab("verbose map")
command! Imapv       call PipeCommandResultToNewTab("verbose imap")
command! Cmapv       call PipeCommandResultToNewTab("verbose cmap")
command! Smapv       call PipeCommandResultToNewTab("verbose smap")
command! Nmapv       call PipeCommandResultToNewTab("verbose nmap")
command! Vmapv       call PipeCommandResultToNewTab("verbose vmap")
command! Xmapv       call PipeCommandResultToNewTab("verbose xmap")
command! Omapv       call PipeCommandResultToNewTab("verbose omap")
command! Defaultmap  :help index.txt<CR>

command! Autocmd     call PipeCommandResultToNewTab("autocmd")
command! Changes     call PipeCommandResultToNewTab("changes")
command! Command     call PipeCommandResultToNewTab("command")
command! Function    call PipeCommandResultToNewTab("function")
command! SearchHistory     call PipeCommandResultToNewTab("history")
command! Messages    call PipeCommandResultToNewTab("messages")
command! Registers   call PipeCommandResultToNewTab("registers")
command! Runtimepath call PipeCommandResultToNewTab('echo substitute(&runtimepath,",","\n","g")')
command! Scriptnames call PipeCommandResultToNewTab("scriptnames")
command! Set         call PipeCommandResultToNewTab("set")
command! SetAll      call PipeCommandResultToNewTab("set all")
command! Syntax      call PipeCommandResultToNewTab("syntax")
command! TabInfo     call PipeCommandResultToNewTab("echo 'expandtab:'.&expandtab | echo 'tabstop:'.&tabstop | echo 'shiftwidth:'.&shiftwidth | echo 'softtabstop:'.&softtabstop | echo 'autoindent:'.&autoindent | echo 'smartindent:'.&smartindent")

command! HelpRtag    call PipeCommandResultToNewTab("filter /rtags/ nmap")
command! HelpGtag    call PipeCommandResultToNewTab("filter /Gtags/ nmap")

command! HelpGit     call PipeCommandResultToNewTab("filter /diffget/ nmap")

command! HelpOrigBind call PipeCommandResultToNewTab("call OrigBind()")

command! ColorName16     :so $VIMRUNTIME/syntax/colortest.vim
" WARN: take a lot of time
" command! ColorSyntaxName :so $VIMRUNTIME/syntax/hitest.vim
command! ColorSyntaxName verbose highlight
command! ColorSyntaxNameNewTab call PipeCommandResultToNewTab("verbose highlight") | echom ':ColorHighlight'

" user defined command
command! SyntaxInfo call PipeCommandResultToNewTab("SyntaxInfoEcho")
