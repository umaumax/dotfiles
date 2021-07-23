if &rtp !~ 'vim-altercmd'
  finish
endif

call altercmd#load()

" NOTE: vim-altercmdはcmap <CR>にマッピングがないことが前提
" vim-smartinputではdefaultで設定されてしまうので注意
" NOTE: cnoremapとするとvim-altercmdで設定したcnoreabbrevが機能しない
augroup ovrewrite_cmap_cr
  autocmd!
  " [autocomplete \- Command line completion to enter into a folder in Vim \- Stack Overflow]( https://stackoverflow.com/questions/11991665/command-line-completion-to-enter-into-a-folder-in-vim )
  autocmd User VimEnterDrawPost cmap <silent> <expr> <CR> pumvisible() ? "\<Space>\<BS>" : "\<CR>"
augroup END

AlterCommand m Message
AlterCommand p[lug]i PlugInstall
AlterCommand p[luginstall] PlugInstall
AlterCommand p[lug]u PlugUpdate
AlterCommand p[lug]ud PlugUpdate
AlterCommand p[lugupdate] PlugUpdate
AlterCommand p[lug]ug PlugUpgrade
AlterCommand p[lugupgrade] PlugUpgrade

" for prettyprint.vim
AlterCommand pp PP
" for fzf plugins
AlterCommand mru FZFMru
AlterCommand fzf FZF
AlterCommand ag Ag
AlterCommand tig Tig
AlterCommand gblame Gblame
AlterCommand blame Gblame
" umaumax/vim-open-googletranslate
AlterCommand g[oogletrans] :OpenGoogleTranslate

" for my commands
AlterCommand del[ete] Delete
AlterCommand f[ile]n FileName
AlterCommand f[ilename] FileName
AlterCommand gu GitURL
AlterCommand gum GitURLMaster
AlterCommand fpg FilePathGit
AlterCommand fp FilePath
AlterCommand f[ile]p FilePath
AlterCommand f[ilepath] FilePath
AlterCommand ca CopyAll
AlterCommand c[opy]a CopyAll
AlterCommand c[opyall] CopyAll
AlterCommand t[emplate] T
AlterCommand r[eplace] R
AlterCommand cgl CtrlPGitLog
AlterCommand cr CtrlPRegister
AlterCommand cyr CtrlPYankRegister
AlterCommand tab[info] TabInfo
AlterCommand cmd CmdlineWindow
AlterCommand wc[md] Wcmd
AlterCommand ws[earch] Wsearch
AlterCommand tac Tac

AlterCommand dup  Duplicate
AlterCommand dups Duplicates
AlterCommand dupv Duplicatev

" NOTE: for misstype
AlterCommand qw wq
