augroup set_filetype
	autocmd!
	autocmd BufRead,BufNewFile *.{gp,gnu,plt,gnuplot} set filetype=gnuplot
	autocmd BufRead,BufNewFile *.js set ft=javascript syntax=jquery
	autocmd BufRead,BufNewFile *.{sh,bashrc,bashenv,bash_profile,envrc} set ft=sh
	autocmd BufRead,BufNewFile *.{zsh,zshrc,zshenv,zprofile} set ft=zsh
	autocmd BufRead,BufNewFile *interfaces set ft=interfaces
	autocmd BufRead,BufNewFile *gitignore set ft=gitignore
	autocmd BufRead,BufNewFile Vagrantfile set ft=ruby
augroup END
