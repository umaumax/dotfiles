# zsh

## array
```
# assign 
local keyword=(${@:<number>})
# expansion
${keyword[@]}
```

### 引数を加工(bash, zsh)
```
local args=()
for arg in ${@}; do
	arg=${arg#https://}
	args+=$arg
done
```

## 変数の正規表現
```
${parameter%パターン}	$parameterの末尾からパターンにマッチする文字列を取り除いた値を返す（最短一致）
${parameter%%パターン}	$parameterの末尾からパターンにマッチする文字列を取り除いた値を返す（最長一致）
${parameter#パターン}	$parameterの先頭からパターンにマッチする文字列を取り除いた値を返す（最短一致）
${parameter##パターン}	$parameterの先頭からパターンにマッチする文字列を取り除いた値を返す（最長一致）

trim_prefix
${#https://}
```
