" OS clupboard share
" [vimのクリップボードとレジスタのコピーアンドペースト - たけし備忘録](http://takeshid.hatenadiary.jp/entry/2015/09/08/001517)
" [zshとVimでOS判定 - shkh's blog](http://shkh.hatenablog.com/entry/2012/06/17/222936)

if has('windows')
	set clipboard=unnamed,unnamedplus
elseif has('mac') " NOTE: mac also has 'unix'
	" for cui vim
	" 	set clipboard=unnamed,autoselect
	" for gvim and cui vim
	set clipboard=unnamed,unnamedplus
elseif has('unix')
	" ubuntu
	set clipboard=unnamedplus
endif
