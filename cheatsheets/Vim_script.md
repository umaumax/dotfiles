# Vim script

## cursor
```
" ".", "'<", "'>"
let wordUnderCursor = expand("<cword>")
let currentLine = getline(".")
let currentCol = col(".")
" let currentRow = row(".") " not exist this function!

call setline('.', line)
" call setpos(',', [<same buf>, row, col, <same off>])
call cursor(row, col)

let [buf, row, col, off] = getpos(".")
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

let array=[1,2,3]
let array+=[4,5,6]
```

## regexp
```
let url = matchstr(test, '\ca href=\([''"]\)\zs.\{-}\ze\1')
if empty(url)
   throw "no url recognized into ``".test."''"
endif
```

## file
```
let outputfile = "$HOME/test.txt"
let lines = [ "line 1", "line 2", "line 3", "line 4" ]
call writefile(lines, outputfile)
```
