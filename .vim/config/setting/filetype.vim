augroup set_filetype
  autocmd!
  " autocmd BufRead,BufNewFile *.{c,cpp,cxx,h,hpp}                      setlocal ft=cpp
  " autocmd BufRead,BufNewFile *.go                                     setlocal ft=go
  " autocmd BufRead,BufNewFile *.py                                     setlocal ft=python
  " autocmd BufRead,BufNewFile *.{vim,vimrc}                            setlocal ft=vim

  autocmd BufRead,BufNewFile * FiletypeDetect

  autocmd BufRead,BufNewFile *.{gp,gnu,plt,gnuplot}                   setlocal ft=gnuplot
  autocmd BufRead,BufNewFile *.js                                     setlocal ft=javascript
  autocmd BufRead,BufNewFile *.vue                                    setlocal ft=vue.html.javascript.css
  autocmd BufRead,BufNewFile *.{sh,bashrc,bashenv,bash_profile,envrc} setlocal ft=sh
  autocmd BufRead,BufNewFile *.{zsh,zshrc,zshenv,zprofile}            setlocal ft=zsh
  autocmd BufRead,BufNewFile *interfaces                              setlocal ft=interfaces
  autocmd BufRead,BufNewFile *gitignore                               setlocal ft=gitignore
  autocmd BufRead,BufNewFile *gitconfig                               setlocal ft=gitconfig
  autocmd BufRead,BufNewFile COMMIT_EDITMSG                           setlocal ft=gitcommit
  autocmd BufRead,BufNewFile Vagrantfile                              setlocal ft=ruby
  " NOTE: .tigrc file syntax is similer to .tmux.conf syntax
  autocmd BufRead,BufNewFile .tigrc                                   setlocal ft=tmux
  autocmd BufRead,BufNewFile .textlintrc                              setlocal ft=json
  autocmd BufRead,BufNewFile *.csv                                    setlocal ft=csv
  " NOTE: for ros
  autocmd BufRead,BufNewFile *.{launch}                               setlocal ft=xml
  autocmd BufRead,BufNewFile README,*.md                              setlocal ft=markdown
  " NOTE: for nex [blynn/nex: Lexer for Go]( https://github.com/blynn/nex )
  autocmd BufRead,BufNewFile *.nex                                    setlocal ft=log
  " NOTE: for goyacc
  autocmd BufRead,BufNewFile *.y                                      setlocal ft=goyacc
  " NOTE: for vscode snipept
  autocmd BufRead,BufNewFile *.code-snippets                          setlocal ft=json

  " NOTE: for cpp library header files which has no ext (e.g. cstdio)
  autocmd BufRead,BufNewFile * if expand('%:p:e') == '' && expand('%:p:e') =~ 'include' | setlocal ft=cpp | endif
augroup END
