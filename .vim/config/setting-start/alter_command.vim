if &rtp !~ 'vim-altercmd'
	finish
endif
call altercmd#load()
" NOTE: cmap <CR>にマッピングがないことが前提
" vim-smartinputとの共存に注意
augroup cunmap_cr
	autocmd!
	autocmd VimEnter * cunmap <CR>
augroup END

AlterCommand m Message
AlterCommand p[lug]i PlugInstall
AlterCommand p[luginstall] PlugInstall
AlterCommand p[lug]u PlugUpdate
AlterCommand p[lug]ud PlugUpdate
AlterCommand p[lugupdate] PlugUpdate
AlterCommand p[lug]ug PlugUpgrade
AlterCommand p[lugupgrade] PlugUpgrade

" prettyprint.vim
AlterCommand pp PP

" for my commands
AlterCommand del[ete] Delete
AlterCommand f[ile]n FileName
AlterCommand f[ilename] FileName
AlterCommand f[ile]p FilePath
AlterCommand f[ilepath] FilePath
AlterCommand c[opy]a CopyAll
AlterCommand c[opyall] CopyAll
AlterCommand t[emplate] T
AlterCommand r[eplace] R
AlterCommand cgl CtrlPGitLog
AlterCommand cr CtrlPRegister
AlterCommand cyr CtrlPYankRegister
