//  [一週間で身につくC\+\+言語の基本\|第６日目：virtualと仮想関数]( http://cpp-lang.sevendays-study.com/ex-day6.html )
#include <iostream>
#include <string>

using namespace std;

class CBird {
 public:
  // NOTE: 継承して利用される可能性のあるクラスのデストラクタは、必ず仮想デストラクタにしましょう。
  // なぜならば，継承先のデストラクタが呼ばれなくなるため
  // FYI: [C\+\+ でデストラクタを virtual にしなくてはならない条件と理由]( http://www.yunabe.jp/docs/cpp_virtual_destructor.html )
  // つまり，virtual なメソッドを持つクラスのデストラクタは virtual でなくてはならない
  CBird() {}
  virtual ~CBird() {}
  // NOTE: default function
  //   virtual void sing() { cout << "鳥が鳴きます" << endl; }
  // NOTE: 強制的に子クラスで宣言させる
  virtual void sing() = 0;
  void fly() { cout << "鳥が飛びます" << endl; }
};
class CChicken : public CBird {
 public:
  CChicken() {}
  ~CChicken() {}
  void sing() { cout << "コケコッコー" << endl; }
  void fly() { cout << "にわとりは飛べません" << endl; }
};
class CCrow : public CBird {
 public:
  CCrow() {}
  ~CCrow() {}
  void sing() { cout << "カーカー" << endl; }
  void fly() { cout << "カラスが飛びます" << endl; }
};

// NOTE: flyはvirtual指定されていないので，親クラスのCBirdが直接呼ばれる
int main() {
  CBird *b1, *b2;
  b1 = new CCrow();
  b2 = new CChicken();
  b1->sing();
  b1->fly();
  b2->sing();
  b2->fly();
  return 0;
}
