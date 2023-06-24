```c++
int i = 0; double d = 0.0;
int *pi = &i;
double *pd = &d;

pi = pd;		// Both not ok
void *pv = pd;	// Both ok
pi = pv;		// C ok, C++ not ok
```

# Class

**Objects = Attributes(Data) + Services(Operations)**



构造函数：

一个构造函数也没有时编译器会生成一个空函数作为构造函数，但只要有一个自己写的构造函数之后就不会了，因此如果该构造函数有参数，新定义的类必须带参数进行初始化，否则报错`no matching constructor for initialization of 'A'`



```cpp
#include ""	// 先在当前再在某个其他地方申明了的地方
#include <>	// 直接在指定的地方
```



## Header

Tips for header

1. One class declaration per header file

2. Same prefix with source file.

3. The contents of a header file is surrounded with

    `#ifndef #define... #endif`

## C'tor and D'tor



```cpp
main(){
    A a1;
    goto jump;	// error: jump bypass variable initialize
    A a2;
jump:

}
```

求数组长度`sizeof(ary) / sizeof(*ary)`

### Default constructor

```cpp
struct Y {
    float f;
    int i;
    Y(int a);
};
Y y1[] = { Y(1), Y(2), Y(3) };
Y y2[2] = { Y(1) };	// error: no instance of constructor "Y::Y" matches the argument list
// 因为数组长度为2而只给了一个Y(1)，剩下的都需要用Y()来填充

// 加入Default Constructor 后就可以了
struct Y {
    float f;
    int i;
    Y(int a);
	Y();
    // 也可以加上
    Y() = default;
};

// 如果一个Ctor也没写编译器会生成一个无参数的，但只要有写就不会自动了
```



## Local Variable

```cpp
struct Y {	// Y的地址和
    int i;	// i的地址相同，也就是this指针的地址
    double d;
    void foo(int p) {
        int x;
        x = i * i;
    }
};
int main() {
    Y y1;
    Y y2;
    y1.foo(1);
    y2.foo(2);
    return 0;
}
```

栈结构

|        | 高位 |      |      |      | (this是成员函数的第一个指针，但是被==隐藏==了) |      |
| ------ | ---- | ---- | ---- | ---- | ---------------------------------------------- | ---- |
| 第一次 | y1.i | y1.d | y2.i | y2.d | this = &y1                                     | p=1  |
| 第二次 |      |      |      |      | this = &y2                                     | p=2  |

隐藏this

```cpp
void Point::print();
// 实际上是
void Point::print(Point *this)
```



### Initializer List

```cpp
class Point {
  private:
    const float x, y;

  public:
    Point(float xa, float ya) : y(ya), x(xa) {}
};
```

对于原生类型和直接赋值是一样的

```cpp
// 无继承
struct Y {
    int i;
    Y(int ii) {
        i = ii;
        cout << "Y::Y()" << endl;
    }
};

struct X {
    Y y;
    X() : y(10) {
        cout << "X::X()" << endl;
    }
};

int main(int argc, char const *argv[]) {
    X x;
    return 0;
}
// 输出为
// Y::Y()
// X::X()
// 可见初始化列表是先于函数体执行的
```



```cpp
struct Y {
    int i;
    Y(int ii) {
        i = ii;
        cout << "Y::Y(int)" << endl;
    }
    Y() {
        i = 0;
        cout << "Y::Y()" << endl;
    }
};

struct X {
    Y y;
    X() {
    // X() : y(10) {
        y = Y(10);
        cout << "X::X()" << endl;
    }
};

int main(int argc, char const *argv[]) {
    X x;
    return 0;
}
// 输出为
// Y::Y()	// 说明先用相当于`X() : y()`
// Y::Y(int)
// X::X()

// 若将X改为：
struct X {
    Y y;
    // X() {
    X() : y(10) {
        // y = Y(10);
        cout << "X::X()" << endl;
    }
};
// 则输出为
// Y::Y(int)
// X::X()
```

**Initialization vs. assignment**

`Student::Student(string s) : name(s) {}`

initialization before constructor body

`Student::Student(string s) { name=s; }`

assignment inside constructor body

string must have a default constructor

更费时间



---

重载函数不考虑返回值类型的，因为可能返回值不被使用所以无法区别使用的是哪个函数

同类型的也要消歧义

```cpp
void f(int n) {}
void f(short n) {}
void f(double) {}
void f(float) {}

f(1); // 错
f((short)1);
f(2.3);	// 错
f(2.3f);
```

char*和string也要消歧义吗？会报错`warning: conversion from string literal to 'char *' is deprecated`，但是似乎会默认是char\*？默认是第一个，即使

```cpp
void f(char* s) {}
// void f(const char* s) {}
// void f(string s) {}

int main(int argc, char const *argv[])
{
	f("12");	// 还是报错warning: conversion from string literal to 'char *' is deprecated，看来c++默认字符串都是string类型的
    // const char * 也可以
	return 0;
}
```



**Default Argument**

* 要写在declaration里，definition不能再写了
* 要从右往左写，不能跳跃写





## const类

```cpp
const Currency the_raise (42, 38);
```

如何保证<u>不改变对象的成员函数可以访问对象，会改变对象的不能访问</u>？在member function上做标记const，**声明和实现都要加**

```cpp
int Date::get_day() const {
    day++;			// Error
    set_day(12);	// Error
    return day;		// OK
}
```



```cpp
class AType
{
public:
	void foo() {		// 相当于void foo(AType *this)
		cout << "Nonconst";
	}
	void foo() const {	// 相当于void foo(const AType *this)
		cout << "Const\n";
	}
};

int main(int argc, char const *argv[])
{
	const AType a;
	a.foo();	// "Const"
	return 0;
}
```

Compil-time const

```cpp
// Make the const value static:
    - static const int size = 100;
    - static indicates only one per class (not one per object)
// Or use “anonymous enum” hack:
class HasArray{
    enum { size = 100 };
    int array[size]; // OK! ...
}
```



## Inline Function

实际上是编译器决定的

相比宏，类型安全，例如

```cpp
#define unsafe(i) \
    ((i) >= 0 ? (i) : (-i))
inline int safe (int i){
    return i >= 0 ? i : -i;
}

int f();

void main(){
    ans = unsafe(x++);	// 宏就崩了
    ans = unsafe(f());	// 宏要调用好几次f()
}
```

