augroup set_filetype
	autocmd!
	autocmd BufRead,BufNewFile *.{gp,gnu,plt,gnuplot} setlocal filetype=gnuplot
	autocmd BufRead,BufNewFile *.js setlocal ft=javascript syntax=jquery
	autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
	autocmd BufRead,BufNewFile *.{sh,bashrc,bashenv,bash_profile,envrc} setlocal ft=sh
	autocmd BufRead,BufNewFile *.{zsh,zshrc,zshenv,zprofile} setlocal ft=zsh
	autocmd BufRead,BufNewFile *interfaces setlocal ft=interfaces
	autocmd BufRead,BufNewFile *gitignore setlocal ft=gitignore
	autocmd BufRead,BufNewFile Vagrantfile setlocal ft=ruby
	" NOTE: .tigrc file syntax is similer to .tmux.conf syntax
	autocmd BufRead,BufNewFile .tigrc setlocal ft=tmux
	autocmd BufRead,BufNewFile .textlintrc setlocal ft=json
	autocmd BufRead,BufNewFile *.csv setlocal ft=csv
	" NOTE: for ros
	autocmd BufRead,BufNewFile *.{launch} setlocal ft=xml
	" NOTE: for ~/dotfiles/snippets/snippet.txt
	autocmd BufRead,BufNewFile snippet.txt setlocal syntax=sh
augroup END
