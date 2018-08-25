" [vim \- How to yank lines into the same register then paste into a new buffer? \- Super User]( https://superuser.com/questions/1107864/how-to-yank-lines-into-the-same-register-then-paste-into-a-new-buffer )
function! PipeCommandResultToNewTab(cmd)
	" NOTE: this ESC is to acoid 'Press ENTER or type command to continue'
	execute "normal! \<ESC>"
	redir @z
	execute 'silent '.a:cmd
	redir END
	tabnew | exe "normal! \"zp" | setlocal buftype=nofile | setlocal ft=vim
endfunction

command! Messages    call PipeCommandResultToNewTab("messages")
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
command! Scriptnames call PipeCommandResultToNewTab("scriptnames")
command! Runtimepath call PipeCommandResultToNewTab('echo substitute(&runtimepath,",","\n","g")')
command! Function    call PipeCommandResultToNewTab("function")
command! Registers   call PipeCommandResultToNewTab("registers")
command! History     call PipeCommandResultToNewTab("history")
command! Command     call PipeCommandResultToNewTab("command")
command! Syntax      call PipeCommandResultToNewTab("syntax")
command! Set         call PipeCommandResultToNewTab("set")
command! SetAll      call PipeCommandResultToNewTab("set all")
command! TabInfo     call PipeCommandResultToNewTab("echo 'expandtab:'.&expandtab | echo 'tabstop:'.&tabstop | echo 'shiftwidth:'.&shiftwidth | echo 'softtabstop:'.&softtabstop | echo 'autoindent:'.&autoindent | echo 'smartindent:'.&smartindent")

command! ColorName16     :so $VIMRUNTIME/syntax/colortest.vim
command! ColorSyntaxName :so $VIMRUNTIME/syntax/hitest.vim

" user defined command
command! SyntaxInfo call PipeCommandResultToNewTab("SyntaxInfoEcho")
