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

function! Cond(cond, ...)
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
let g:lazy_plug_map={}
" NOTE: 主に'for'や'on'の指定がないものを対象とする
function! LazyPlug(repo, ...)
	let opts = get(a:000, 0, {})
	if !has_key(opts,'on')&& !has_key(opts,'for')
		let opts=extend(opts, { 'on': [], 'for': []})
	endif
	let g:lazy_plug_map[split(a:repo,'/')[1]]=0
	call plug#(a:repo, opts)
endfunction
command! -nargs=+ -bar LazyPlug call LazyPlug(<args>)
command! LazyPlugLoad call <SID>lazy_plug_load()
function! s:lazy_plug_load()
	for key in keys(g:lazy_plug_map)
		if (g:lazy_plug_map[key]==0)
			" NOTE: 可変長引数で文字列も指定可能
			call plug#load(key)
			let g:lazy_plug_map[key]=1
		endif
	endfor
endfunction
augroup load_after_vim_enter
	autocmd!
	" 	autocmd User VimEnterDrawPost call plug#load('vim-airline','deoplete.nvim')
	" 				\| autocmd! load_after_vim_enter
	autocmd User VimEnterDrawPost call <SID>lazy_plug_load()
				\| autocmd! load_after_vim_enter
augroup END

augroup check-plug
	autocmd!
	autocmd User VimEnterDrawPost if !argc() | call <SID>plug_check_installation() | endif
augroup END

call plug#begin('~/.vim/plugged')
" for consecutive shortcut input
Plug 'kana/vim-submode'
runtime! config/plugin/*.vim
call plug#end()
