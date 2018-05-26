" [vimでちょっとしたワードを調べる時に使うアレ5つ]( https://techracho.bpsinc.jp/yamasita-taisuke/2014_09_18/19082#google )
" Ctrl-X,Ctrl-U
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
		let ret = system('curl -s -G --data-urlencode "q=' . a:base . '" "http://suggestqueries.google.com/complete/search?&client=firefox&hl=en&ie=utf8&oe=utf8"')
		let res = split(substitute(ret,'\[\|\]\|"',"","g"),",")
		return res
	endif
endfunction

command! -nargs=? Eiwa call Goo("ej",<f-args>)
command! -nargs=? Ruigo call Goo("thsrs",<f-args>)
command! -nargs=? Kokugo call Goo("jn",<f-args>)
command! -nargs=? Waei call Goo("je",<f-args>)
function! Goo(jisyo,...)
	if has('win32') || has('gui_running')
		let l:cmd = "!"
	else
		let l:cmd = "!clear && "
	endif
	if a:0 == 0
		let l:search_word = expand("<cword>")
	else
		let l:search_word = a:1
	endif
	if a:jisyo == "ej"
		let l:search_tag = " | perl -nle 'print if /alllist/i../<\\/dl>/ or /prog_meaning/'"
	elseif a:jisyo == "je"
		let l:search_tag = " | perl -nle 'print if /alllist/i../<\\/dl>/ or /prog_meaning|prog_example/'"
	elseif a:jisyo == "jn"
		let l:search_tag = " | perl -nle 'print if /alllist/i../<\\/dl>/ or /meaning/'"
	elseif a:jisyo == "thsrs"
		let l:search_tag = " | perl -nle 'print if /--wordDefinition/i../--\\/wordDefinition/i'"
	endif
	execute l:cmd . "curl -s -L " .
				\ "http://dictionary.goo.ne.jp/srch/" . a:jisyo . "/" .
				\ "$(echo " . l:search_word . " | nkf -wMQ | tr = \\%)" .
				\ "/m1u/ " .
				\ l:search_tag .
				\ " | perl -ple 's/<.+?>//g'"
				\ " | head -50"
endfunction
