function! s:setlines(pos, lines)
	if len(a:lines)==0
		execute ':'.a:pos.'d'
		return
	endif
	call setline(a:pos, a:lines[0])
	call append(a:pos, a:lines[1:])	
endfunction
