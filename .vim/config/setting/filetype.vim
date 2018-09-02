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
	autocmd BufRead,BufNewFile .tigrc setlocal ft=tig syntax=tmux
	autocmd BufRead,BufNewFile .textlintrc setlocal ft=json syntax=json
augroup END
