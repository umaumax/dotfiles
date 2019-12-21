# dotfiles cmds

## cpp_dump_gen
* c++の`class`や構造体のソースコードをpipeで流して，dump用のコードを生成する
* `private`なmemberを排除したい場合には`grep -v private`
* `class`や`struct`内の定義や，複雑な定義などには対応していない

```
$ cat <<EOF | cpp_dump_gen
class ABC {
 public:
  int hoge = 3;
  int fuga;
}
EOF

{
auto&& dump_tmp = XXX;
std::cout << "class " << std::endl;
std::cout << "hoge = "<< dump_tmp.hoge << std::endl; // public: int
std::cout << "fuga = "<< dump_tmp.fuga << std::endl; // public: int
}
```

### `awk`ではなく`clang++`を利用する方法の候補
```
#include <string>

class ABC {
 public:
  int hoge;
  int fuga;

 private:
  char c;
  std::string s;
};

void dummy() {
  ABC a;
  a.
}
```

```
clang++ -fsyntax-only -Xclang -code-completion-at=struct.cpp:35:5 -std=c++11 cpp_dump_gen.cpp
```

* `public`と`private`のmember区別がつかない

## colortest.py
* [Testing 256 color shells using background colors and automatic shell width detection]( https://gist.github.com/WoLpH/8b6f697ecc06318004728b8c0127d9b3 )
