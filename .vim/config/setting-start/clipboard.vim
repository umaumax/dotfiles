" OS clupboard share
" [vimのクリップボードとレジスタのコピーアンドペースト - たけし備忘録](http://takeshid.hatenadiary.jp/entry/2015/09/08/001517)
" [zshとVimでOS判定 - shkh's blog](http://shkh.hatenablog.com/entry/2012/06/17/222936)

let OSTYPE = system('uname')
if OSTYPE == "Darwin\n"
	" for cui vim
	" 	set clipboard=unnamed,autoselect
	" for gvim and cui vim
	set clipboard=unnamed,unnamedplus | vnoremap v y
elseif OSTYPE == "Linux\n"
	" ubuntu
	set clipboard=unnamedplus
	" ubuntu上でvisual modeで選択したものをyankする
	vnoremap v y
endif
