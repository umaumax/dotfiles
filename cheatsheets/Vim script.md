# Vim script

## cursor
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

## pumvisible
```
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"
```

## for-range
```
for i range(1,10)
	echo i
endfor
```

## array
append
```
['a', 'b'] + ['c']
add(['a', 'b'], 'c')
```
__listに対して，`+=`は使えないが，通常の演算では使用可能__
