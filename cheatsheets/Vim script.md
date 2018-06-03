# Vim script

```
let wordUnderCursor = expand("<cword>")
let currentLine = getline(".")
let currentCol = col(".")
let currentRow = row(".")

call setline('.', line)
call cursor(row, col)

let pos = getpos(".")
call setpos('.', pos)
```

```
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"
```
