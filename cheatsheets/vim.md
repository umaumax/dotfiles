# vim

# normal mode
## move
A,I,G
`S`:行を消してinsert mode
`gm`: goto middle of screen of current line(basically you can use `gs` as `$`)

## line join
`J`: join with space
`gJ`: join with no space
`gJ...J`: join with no space by sub-mode plugin

## fold
`zi`: toggle foldenable
`zR`: all open

## multi commands
`ggVG`: entire select

`w`:word
`p`:paragraph
`ciw`,`diw`,`viw`: cut, delete, visual for word on cursor
`ci"`,`di"`, `vi"`: cut, delete, visual inner of `"`

## tab
### my bind
`st`: new tab

`sn`: next tab
`sp`: previous tab

### default bind

## window
### my bind
* `s`+`h,j,k,l`: move current window
* `s`+`H,J,K,L`: move current window itself
* `ss`: split window (up)
* `sv`: split window (left)

### default bind

## NERDTree
`<C-e>`: toggle `my`
<!-- `s`: open at new left window -->
<!-- `o`,`<CR>`: open at current window -->
`?`: toggle help

```
" :help NERDTree-t
" CD: set root
" u:up a dir
" r,R: refresh
let g:NERDTreeMapOpenSplit='h' " 'i'
let g:NERDTreeMapOpenVSplit='v' " 's'
```

## ctrlpv.vim
`<C-p>`: file search at default
`<C-p>`: grep search at quickfix window

## QuickFix
```
" for vimgrep quickfix
nmap <Space>n :cnext<CR>
nmap <Space>N :cprev<CR>
```

## sonictemplate-vim
`<C-y>t`,`<C-y><C-t>`,`<C-y>T`: sonicp temaplte

## jump
`gx`: open url
`gf`: goto file on cursor
`gF`: goto file on cursor with line number
`gi`: goto next buffer `my`
`go`: goto prev buffer `my`

## easymotion
```
map g<Space> <Plug>(easymotion-overwin-f2)
map gj       <Plug>(easymotion-j)
map gk       <Plug>(easymotion-k)
map gl       <Plug>(easymotion-lineforward)
map gh       <Plug>(easymotion-linebackward)
map gw       <Plug>(easymotion-overwin-w)
```

## completion
`<C-x><C-p>`: 'mattn/sonictemplate-vim'
`<C-x><C-x>`: name to sign `my`

----

# visual mode
`o`: toggle cursor
`gv`: relelected the last block (@normal mode)

## my bind
`in`: number
`ih`: word + hyphen
`id`: word + dot
`ic`: word + comma
`if`: file path

```
" expand range one char both side
vnoremap <Space> <Right>o<Left>o
```

## 'sgur/vim-textobj-parameter' bind
`i,`: func args
`a,`: func args with space

----

# normal and visual mode
## move by 'rhysd/clever-f.vim'
`f,F,t,T`

----

# insert mode

----

# how to insert multi line
* c,s: change text
* I: insert at start of range
* A: insert at end of range
## default
* `<C-v>`->move->`I,A,c,s`->put text->`Esc`
## 'terryma/vim-multiple-cursors'
* <C-N> on word
* repeat <C-N> or <C-X>:skip, <C-p>:prev

----

# commands
## basic
```
:help
:function
:message
:scriptnames
:colorscheme
```
## confirmation
```
:echo &ft
:echo &bt
:echo &rtp
:echo &enc
```

## tips
```
:%d # delete all in this file
```
