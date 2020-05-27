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

## readline-search-history.sh
* [GDB History and FZF · Issue \#1516 · junegunn/fzf]( https://github.com/junegunn/fzf/issues/1516 )

## git_find_big.sh
* [Maintaining a Git Repository \- Atlassian Documentation]( https://confluence.atlassian.com/bitbucket/maintaining-a-git-repository-321848291.html )
  * [git_find_big.sh]( https://confluence.atlassian.com/bitbucket/files/321848291/321979854/2/1587501654761/git_find_big.sh )

## gdb-backtrace.sh
* [root/gdb\-backtrace\.sh at master · root\-project/root]( https://github.com/root-project/root/blob/master/etc/gdb-backtrace.sh )
