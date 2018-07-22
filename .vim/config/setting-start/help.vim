" [vim \- How to yank lines into the same register then paste into a new buffer? \- Super User]( https://superuser.com/questions/1107864/how-to-yank-lines-into-the-same-register-then-paste-into-a-new-buffer )
function! PipeCommandResultToNewTab(cmd)
	redir @z
	execute 'silent '.a:cmd
	redir END
	tabnew | exe "normal! \"zp" | setlocal buftype=nofile
endfunction

command! Map call PipeCommandResultToNewTab("map")
command! Messages call PipeCommandResultToNewTab("messages")
command! Imap call PipeCommandResultToNewTab("imap")
command! Cmap call PipeCommandResultToNewTab("cmap")
command! Smap call PipeCommandResultToNewTab("smap")
command! Nmap call PipeCommandResultToNewTab("nmap")
command! Vmap call PipeCommandResultToNewTab("vmap")
command! Xmap call PipeCommandResultToNewTab("xmap")
command! Omap call PipeCommandResultToNewTab("omap")
command! Scriptnames call PipeCommandResultToNewTab("scriptnames")
command! Runtimepath call PipeCommandResultToNewTab('echo substitute(&runtimepath,",","\n","g")')
command! Function call PipeCommandResultToNewTab("function")
command! Registers call PipeCommandResultToNewTab("registers")
command! History call PipeCommandResultToNewTab("history")
command! Command call PipeCommandResultToNewTab("command")
