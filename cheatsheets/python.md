# python

## stdin
```
import sys
line = sys.stdin.readline()
lines = sys.stdin.readlines()
entire = sys.stdin.read()
# 固定行のみ
[raw_input() for _ in range(<number>)]
```

## bool
```
True, False
not flag
```

## string
* __型は自動変換ではないので，strであることを確認すること__
	* e.g. `re.match().group()`とすると`str`
```
"a" + "b"
len(str)
"a" * 3
```

## print
```
print("name: %-10s,score:%-10.2f" %(name,score))
print("name:{0:>10s},score:{1:<10.2f}".format(name,score))
```

## 条件演算子
3項演算子とは順序が異なる
```
print ("Great!" if score > 80 else "so so! ..")
```

## func
```
def say_endo(name="endo",age=23):
    print ("Hi! {0} age({1})".format(name,age))
```

## pass
`if`や`function`で空白のとき

## if
ifの`()`は不要

## for
```
for line in lines:

# for range with index
list = ['python', 'Hello', 'world']
for i, j in enumerate(list):
    print('{0}:{1}'.format(i, j))

# two list for range (短いサイズに合わさる)
list1 = ['python', 'Hello', 'world', 'test']
list2 = ['Python', 'programming', 'beginner']
for i, j in zip(list1, list2):
    print('{0}, {1}'.format(i,j))
```

## null
```
if A is None:
if A is not None:
```

## list, array
```
len(list)
# arr = [[0] * 3] * 5 # ダメ
arr = [[0 for i in range(3)] for j in range(5)]
```

## trim prefix
```
if line.startswith(prefix):
    return line.replace(prefix, '', 1)

value = line.split("Path=", 1)[-1]

rightmost = re.compile('^Path=').sub('', full_path)

if line.startswith("Path="):
    return line[5:]
```
