# Iterator

Generalization of pointer

Glue between algorithms and containers



指针也能当迭代器使用

```cpp
const int Size = 5;
int arr[Siez] = {1, 2, 3, 4, 5};
auto ita = find(arr, arr + Size, 3);	// type(ita) == int*
```



`++`是所有迭代器都有的，`+=`不是，比如list上就没有`+=`



## 注意

实现泛型函数时可能需要两个typename, where I is itor type, T is data type

```cpp
// we do NOT know the data type of Iter,
// so we need another variable v to infer T
template <class I, class T>
void func_impl(I iter, T& v) {
    T tmp;
    tmp = *iter;
    // processing code here
}
```

或者加一层封装

```cpp
// a wrapper to extract the associated
// data type T
template <class I>
void func(I iter) {
    func_impl(iter, *iter);
    // processing code here
}
```

## 类型定义

`using typedef typename`

```cpp
template <class T>
struct myIter {
    typedef T value_type;
    T* ptr;
    myIter(T *p = 0) : ptr(p) {}
    T& operator*() { return *ptr; }
};


template <class I>
typename I::value_type func(I iter) {  // 这里说明一下是typename否则会被当成member因此报错？
    return *iter;
}

// code
myIter<int> iter(new int(8));
cout << func(iter);

// Vector里面的
template <typename Type>  // First elem
typename Vector<Type>::reference Vector<Type>::front() {
    // Code
}
```

`typedef`不能定义原生类型的指针，如`int*`, `double*`，在C++20之前，使用`iterator_traits`(类型萃取器)，

```cpp
template <class I>
struct iterator_traits {
    typedef typename I::value_type value_type;
}

template <class I>
typename iterator_traits<I>::value_type func(I iter) {
    return *iter;
}

// code
myIter<int> iter(new int(8));
cout << func(*iter);
```

func调用iter不能加`*`。。

```c++
#include <cstring>
#include <iomanip>
#include <iostream>
#include <list>
#include <map>
#include <unordered_map>
#include <vector>

using namespace std;

template <class T>
struct myIter {
    typedef T value_type;
    T *ptr;
    myIter(T *p = 0) : ptr(p) {}
    T &operator*() { return *ptr; }
};

template <class I>
struct Iterator_Traits {
    typedef typename I::value_type value_type;
};

template <class I>
typename Iterator_Traits<I>::value_type func(I iter) {
    return *iter;
}

// code
int main(int argc, char const *argv[]) {
    myIter<int> iter(new int(8));
    cout << func(iter);
    return 0;
}
```

可是爷不萃取也没报错啊，因为myIter里面已经定义过value_type了

```c++
using namespace std;

template <class T>
struct myIter {
    typedef T value_type;
    T *ptr;
    myIter(T *p = 0) : ptr(p) {}
    T &operator*() { return *ptr; }
};

template <class I>
typename I::value_type func(I iter) {
    return *iter;
}

// code
int main(int argc, char const *argv[]) {
    myIter<int> iter(new int(8));
    cout << func(iter);
    return 0;
}
```



## Template specialization

模板特化

```cpp
// Primary template:
template<class T1, class T2, int I>
class A { ... };

// Explicit (full) template specialization: 全特化
template<>
class A<int, double, 5> { ... };

// Partial template specialization: 偏特化
template<class T2>
class A<int, T2, 3> { ... };	// 也可是T2*, T2&, const T2等等
```

## Traits

```cpp
template<class I>
class iterator_traits {
  public:
    typedef typename I::value_type value_type;	// 这里的typename应该是修饰I而不是I::value_type
    typedef typename I::pointer_type pointer_type;
    ......
};

template<class I>
class iterator_traits {
public:
    typedef typename I::value_type value_type;
    typedef typename I:pointer_type pointer_type;
    ......
};

template<class T>
class iterator_traits <T*> {
public:
    typedef T value_type;
    typedef T* pointer_type;
    ......
};
```

常见类型

```cpp
typedef typename I::iterator_category iterator_category;
typedef typename I::value_type value_type;
typedef typename I::difference_type differece_type;
typedef typename I::pointer_type pointer_type;
typedef typename I::reference reference;
```

`iterator_category`
 • InputIterator
 • OutputIterator
 • ForwardIterator
 • BidirectionalIterator
 • RandomAccessIterator

```cpp
// Overload many __advance() with different 3rd argv as iterator_category

template <class Iterator, class Distance>
inline void advance(Iterator &i, Distance n) {
    __advance(i, n, iterator_traits<Iterator>::iterator_category());  // iterator_category()是Temporary object
}
```

tag的隐式转换

```cpp
template <class ForwardIterator, class Distance>
inline void __advance(ForwardIterator &i, Distance n, forward_iterator_tag) {
    __advance(i, n, input_iterator_tag());	// Implicit conversion from forward_iterator_tag to input_iterator_tag()
}
```

