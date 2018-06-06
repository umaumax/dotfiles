# awk

## print
引数なしで`print`すると`$0`が表示されるはずなので，意図しない場合に注意

## 文字列連結(string join)
```
"a" "b" "c"
ret = sprintf("%s%s", "a", "b")
```

## 組み込み変数
`NR`: 行, Number of Record, line
`NF`: Number of Field

## 正規表現(regexp)
`bool match(str, /reg/)`
```
if (match(line, /<.*>/)) {
	before = substr(line, 0, RSTART-1));
	m      = substr(line, RSTART, RLENGTH));
	after  = substr(line, RSTART+RLENGTH, length(line)-RSTART-RLENGTH+1);
}
```

### replace
* g(global)付きで繰り返し置換する
* sub,gsubの返り値は置換結果ではなく，置換数
* target省略で`$0`
```
len sub(regexp, replacement [, target]) # 破壊的変更
len gsub(regexp, replacement [, target]) # multi, 破壊的変更
ret gensub(regexp, replacement, how [, target]) # multi
```

### 途中で処理を止める
* `for`:`continue`,`break`
* `function`:`return`
* `{}`:`next`
* `END{}`:`exit`
