" OSのクリップボードを使う
" [vimのクリップボードとレジスタのコピーアンドペースト - たけし備忘録](http://takeshid.hatenadiary.jp/entry/2015/09/08/001517)
" [Vimでyankした内容をクリップボードに入れたい時用のコマンド | kanonjiのブログ](http://kanonji.info/blog/2015/10/23/vim-yank-to-clipboard-by-register-to-another/)
" [UbuntuにインストールしたVimでクリップボード共有する方法 | MBA-HACK](http://mba-hack.blogspot.jp/2013/02/clipboard.html)UbuntuにインストールしたVimでクリップボード共有する方法 | MBA-HACKhttp://mba-hack.blogspot.jp/2013/02/clipboard.html
"[zshとVimでOS判定 - shkh's blog](http://shkh.hatenablog.com/entry/2012/06/17/222936)

let OSTYPE = system('uname')

if OSTYPE == "Darwin\n"
	set clipboard=unnamed,autoselect
elseif OSTYPE == "Linux\n"
	" ubuntu
	set clipboard=unnamedplus
	" ubuntu上でvisual modeで選択したものをyankする
	command VV :let @*=@"  "最後にyank or 削除した内容をクリップボードに入れる
endif
