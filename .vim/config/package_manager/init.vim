" NOTE: auto download vim-plug
if has('vim_starting')
	" 	if !isdirectory(expand('~/.vim/plugged/vim-plug'))
	" 		echo 'install vim-plug...'
	" 		call system('mkdir -p ~/.vim/plugged/vim-plug')
	" 		call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
	" 	end
	" 	if isdirectory(expand('~/.vim/plugged/vim-plug'))
	" 		set rtp+=~/.vim/plugged/vim-plug
	" 	endif
	if !filereadable(expand('~/.vim/autoload/plug.vim'))
		echo 'install vim-plug...'
		call system('curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	end
endif

" NOTE: auto PlugInstall detecter
" NOTE: 一部修正しないと動かない
" [おい、NeoBundle もいいけど vim\-plug 使えよ \- Qiita]( https://qiita.com/b4b4r07/items/fa9c8cceb321edea5da0 )
function! s:plug_check_installation()
	if empty(g:plugs)
		return
	endif

	let list = []
	for [name, spec] in items(g:plugs)
		if !isdirectory(spec.dir)
			call add(list, spec.uri)
		endif
	endfor

	if len(list) > 0
		let unplugged = map(list, 'substitute(v:val, "^.*github\.com/\\(.*/.*\\)\.git$", "\\1", "g")')

		" Ask whether installing plugs like NeoBundle
		echomsg 'Not installed plugs: ' . string(unplugged)
		if confirm('Install plugs now?', "yes\nNo", 2) == 1
			PlugInstall
			" Close window for vim-plug
			silent! close
			" Restart vim
			silent! !vim
			quit!
		endif
	endif
endfunction
augroup check-plug
	autocmd!
	autocmd VimEnter * if !argc() | call <SID>plug_check_installation() | endif
augroup END

call plug#begin('~/.vim/plugged')
runtime! config/plugin/*.vim
call plug#end()
