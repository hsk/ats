#include <cassert>
#include <memory>

template<class T> class RBTree {

  enum Color { R, B };

  struct Node {
    Color c;
    std::shared_ptr<const Node> l;
    T v;
    std::shared_ptr<const Node> r;

    Node(
      Color c, 
      std::shared_ptr<const Node> const & l, 
      T v, 
      std::shared_ptr<const Node> const & r
    ) : c(c), l(l), v(v), r(r)
    {}
  };

private:

  std::shared_ptr<const Node> r;

  explicit RBTree(
    std::shared_ptr<const Node> const & node
  ) : r(node) {} 

  Color rootColor() const {
    assert (!isEmpty());
    return r->c;
  }

public:

  RBTree() {}

  RBTree(
    Color c, RBTree const & l, T v, RBTree const & r
  ) : r(std::make_shared<const Node>(c, l.r, v, r.r)) {
    assert(l.isEmpty() || l.root() < v);
    assert(r.isEmpty() || v < r.root());
  }

  RBTree(std::initializer_list<T> init) {
    RBTree t;
    for (T v : init) {
      t = t.insert(v);
    }
    r = t.r;
  }

  template<class I> RBTree(I b, I e) {
    RBTree t;
    for_each(b, e, [&t](T const & v){
      t = t.insert(v);
    });
    r = t.r;
  }

  bool isEmpty() const {
    return !r;
  }

  T root() const {
    assert(!isEmpty());
    return r->v;
  }

  RBTree left() const {
    assert(!isEmpty());
    return RBTree(r->l);
  }

  RBTree right() const {
    assert(!isEmpty());
    return RBTree(r->r);
  }

  bool member(T x) const {
    if (isEmpty()) return false;
    T y = root();
    if (x < y) return left().member(x);
    if (y < x) return right().member(x);
    return true;
  }

  RBTree insert(T x) const {
    RBTree t = ins(x);
    return RBTree(B, t.left(), t.root(), t.right());
  }

  // 1. No red node has a red child.
  void assert1() const {
    if (!isEmpty()) {
      auto l = left();
      auto r = right();
      if (rootColor() == R) {
        assert(l.isEmpty() || l.rootColor() == B);
        assert(r.isEmpty() || r.rootColor() == B);
      }
      l.assert1();
      r.assert1();
    }
  }

  // 2. Every path from root to empty node contains the same
  // number of black nodes.
  int countB() const {
    if (isEmpty()) return 0;
    int l = left().countB();
    int r = right().countB();
    assert(l == r);
    return (rootColor() == B)? 1 + l: l;
  }

private:

  RBTree ins(T x) const {
    assert1();
    if (isEmpty()) return RBTree(R, RBTree(), x, RBTree());
    T y = root();
    Color c = rootColor();
    if (rootColor() == B) {
      if (x < y) return balance(left().ins(x), y, right());
      if (y < x) return balance(left(), y, right().ins(x));
      return *this; // no duplicates
    }
    if (x < y) return RBTree(c, left().ins(x), y, right());
    if (y < x) return RBTree(c, left(), y, right().ins(x));
    return *this; // no duplicates
  }

  // Called only when parent is black
  static RBTree balance(RBTree const & l, T x, RBTree const & r) {
      if (l.doubledLeft())
        return RBTree(R
                    , l.left().paint(B)
                    , l.root()
                    , RBTree(B, l.right(), x, r));
      if (l.doubledRight())
        return RBTree(R
                    , RBTree(B, l.left(), l.root(), l.right().left())
                    , l.right().root()
                    , RBTree(B, l.right().right(), x, r));
      if (r.doubledLeft())
        return RBTree(R
                    , RBTree(B, l, x, r.left().left())
                    , r.left().root()
                    , RBTree(B, r.left().right(), r.root(), r.right()));
      if (r.doubledRight())
        return RBTree(R
                    , RBTree(B, l, x, r.left())
                    , r.root()
                    , r.right().paint(B));
      return RBTree(B, l, x, r);
  }

  bool doubledLeft() const {
    return !isEmpty()
        && rootColor() == R
        && !left().isEmpty()
        && left().rootColor() == R;
  }

  bool doubledRight() const {
    return !isEmpty()
        && rootColor() == R
        && !right().isEmpty()
        && right().rootColor() == R;
  }

  RBTree paint(Color c) const {
    assert(!isEmpty());
    return RBTree(c, left(), root(), right());
  }
};

template<class T, class F>
void forEach(RBTree<T> const & t, F f) {
  if (!t.isEmpty()) {
    forEach(t.left(), f);
    f(t.root());
    forEach(t.right(), f);
  }
}

template<class T, class Beg, class End>
RBTree<T> insert(RBTree<T> t, Beg it, End end) {
  if (it == end)
      return t;
  T item = *it;
  auto t1 = insert(t, ++it, end);
  return t1.insert(item);
}

template<class T>
RBTree<T> treeUnion(RBTree<T> const & a, RBTree<T> const & b) {
  // a u b = a + (b \ a)
  RBTree<T> res = a;
  forEach(b, [&res, &a](T const & v){
    if (!a.member(v)) res.insert(v);
  });
  return res;
}

#include <iostream>
#include <string>
#include <algorithm>

template<class T>
void print(RBTree<T> const & t) {
  forEach(t, [](T v) {
    std::cout << v << " ";
  });
  std::cout << std::endl;
}

void testInit() {
  RBTree<int> t{ 50, 40, 30, 10, 20, 30, 100, 0, 45, 55, 25, 15 };
  print(t);
}

int main() {
  testInit();
  std::string init =  "a red black tree walks into a bar "
    "has johnny walker on the rocks "
    "and quickly rebalances itself."
    "A RED BLACK TREE WALKS INTO A BAR "
    "HAS JOHNNY WALKER ON THE ROCKS "
    "AND QUICKLY REBALANCES ITSELF.";
  auto t = insert(RBTree<char>(), init.begin(), init.end());
  print(t);
  t.assert1();
  std::cout << "Black depth: " << t.countB() << std::endl;
  std::cout << "Member z: " << t.member('z') << std::endl;
  std::for_each(init.begin(), init.end(), [t](char c) {
    if (!t.member(c))
      std::cout << "Error: " << c << " not found\n";
  });

  return 0;
}

