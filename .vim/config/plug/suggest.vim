" [vimでちょっとしたワードを調べる時に使うアレ5つ]( https://techracho.bpsinc.jp/yamasita-taisuke/2014_09_18/19082#google )
set completefunc=GoogleComplete
function! GoogleComplete(findstart, base)
	if a:findstart
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && line[start - 1] =~ '\S'
			let start -= 1
		endwhile
		return start
	else
		let ret = system('curl -s -G --data-urlencode "q=' . a:base . '" "http://suggestqueries.google.com/complete/search?&client=firefox&hl=ja&ie=utf8&oe=utf8"')
		let res = split(substitute(ret,'\[\|\]\|"',"","g"),",")
		return res
	endif
endfunction
