# Intro

**The three parts of STL**
• Containers • Algorithms • Iterators

**All sequential containers**
• vector: variable array
• deque: dual-end queue
• list: double-linked-list
• forward_list: as it，单向链表
• array: as “array”，访问快
• string: char. array

# Container

## vector

### Basic vector operations

**• Constructors**
`vector<Elem> c; vector<Elem> c1(c2);`
**• Simple methods**
V.size( ) // num items
V.empty() //empty?
==, !=, <, >, <=, >= // 大小于的比较方式同字符串，即从前往后依次比较
V.swap(v2) // swap only pointer
**• Element access**
V.at(index)	// 带范围检查(是否越界)
V[index]
V.front( )
V.back( )
**• Iterators**
`I.begin() I.end()`
**• Add/Remove/Find**
V.push_back(e)
V.pop_back( )
V.insert(itor, e)	// O(N)
V.erase(itor)	// O(N)
V.clear( )
V.find(first, last, item)

<u>V.reserve()：预留空间但是size不会增加</u>

`pts.push_back(Point(1, 2))`要先构造再拷贝构造，可以用`pts.emplace_back(1, 2)`替代



## list

双向链表

`front(), back(), push_back(item), push_front(item), pop_front(), remove(item)`

注意：list的迭代器不能写成`itor < ls.end()`而是`itor != ls.end()`



## map

二叉搜索树的平衡树版本 (如AVL，RB

有序的键值对(?) (python里的dict是无序的，用的是散列)，用RB🌲实现

`map<string, string> telephone_book`

```cpp
#include <map>
#include <string>
#include <iostream>
using namespace std;

int main(int argc, char const *argv[]) {
    map<string, float> price;
    price["snapple"] = 0.75;
    price["coke"] = 0.50;
    string item;
    double total = 0;
    while ( cin >> item )
        total += price[item];
    return 0;
}
```

另外，需要在自定义的key类型上重载`<`比较操作

`char *`也是没有自带比较的

```cpp
struct full_name {
    char * first;
    char * last;
    bool operator<(full_name & a) {
        return strcmp(first, a.first) < 0;
    }
};
map<full_name,int> phonebook;
```



有序个🔨？

```cpp
map<int, int> a = {make_pair(1, 2), make_pair(5, 6), make_pair(3, 4)};
for (auto &i : a)
    cout << i.first << i.second << endl;
return 0;
/*
12
34
56
*/
```

有序是相对数据而不是插入顺序而言的，像用unordered_map就变成毫无顺序可言

```c++
unordered_map<int, int> a = {make_pair(1, 2), make_pair(5, 6), make_pair(3, 4)};
for (auto &i : a)
    cout << i.first << i.second << endl;
return 0;
/*
34
56
12
*/
```



### unordered_map

不需要比较函数，但是要哈希函数



## Pitfalls

**map**

```cpp
if (foo["bob"]==1)	// silently created entry "bob"
if (foo.count("bob"))	// check for a key without creating a new entry.
if (foo.contains("bob"))	// Or contains() introduced in C++20
```

**list**

```cpp
if(ls.size() == 0)	// slow
if(ls.empty())		// fast
```

**iterator**

```cpp
list<int> L;
list<int>::iterator li;
li = L.begin();
// WRONG
L.erase(li);	// li就失效了
++li;
// RIGHT
li = L.erase(li);
```



# Algorithm

## copy

```cpp
list<int> L;
vector<int> V;
// 1
V.reserve(L.size());	// 否则会segmentatioin fault
copy (L.begin(), L.end(), V.begin());
// 2
copy (L.begin(), L.end(), back_inserter(V));
```

```cpp
list<int> L = {1, 2, 3, 4};

copy(L.begin(), L.end(), ostream_iterator<int>(cout, ", "));
cout.flush();
```



https://www.fluentcpp.com/getthemap/



