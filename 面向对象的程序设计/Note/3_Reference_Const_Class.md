**在C++中struct得到了很大的扩充：**

**1.struct可以包括成员函数**

**2.struct可以实现继承**

**3.struct可以实现多态**



**二.strcut和class的区别**

> **1.默认的继承访问权。class默认的是private,strcut默认的是public。**
> **2.默认访问权限：struct作为数据结构的实现体，它默认的数据访问控制是public的，而class作为对象的实现体，它默认的成员变量访问控制是private的。**
> **3.“class”这个关键字还用于定义模板参数，就像“typename”。但关建字“struct”不用于定义模板参数**



> **4.class和struct在使用大括号{ }上的区别**
> **关于使用大括号初始化**
> **1.）class和struct如果定义了构造函数的话，都不能用大括号进行初始化**
> **2.）如果没有定义构造函数，struct可以用大括号初始化。**
> **3.）如果没有定义构造函数，且所有成员变量全是public的话，class可以用大括号初始化**

# 引用

**引用传递**

https://www.runoob.com/cplusplus/cpp-function-call-by-reference.html

```cpp
char c;
char *p = &c;
char& r = c;	// 声明时必须初始化
				// 除非是在函数的参数表
// r相当于是c
```



例程

```cpp
int main(int argc, char const *argv[])
{
	int a = 1;
	int &b = a;
	printf("%d %d\n", a, b);	// 1 1
	a = 2;
	printf("%d %d\n", a, b);	// 2 2
	b = 3;
	printf("%d %d\n", a, b);	// 3 3
	return 0;
}
/*  */

void func(int &);
func(i * 3);	// ERROR: 不能用表达式
/**/

int* f(int *x) {
	(*x)++;
	return x;
}
int &g(int &x) {
	x++;
	return x;
}
int x;
int &h() {
	int q;
    // return q会报错(显然)
	return x;
}

int main() {
	int a = 0;
	f(&a);
	g(a);
	h() = 16;	// ????
    			// 返回的是引用变量所以可以赋值，对x赋值
}
```

Diff

| Reference                                                | Pointer        |
| -------------------------------------------------------- | -------------- |
| Can't be null(must be initialized)                       |                |
| Can't change to a new "address" location(不可以重新赋值) |                |
| 依赖其他存在的变量                                       | 是个独立的对象 |

**Restrictions**

没有引用的引用(因为引用本身不是一个独立的类型)

```cpp
int &*p;		// Illegal
void f(int *&p);	// Reference to a pointer
```

No arrays of reference

# const

```cpp
const int x = 123;
int y = x;
const int z = x;
// 反正初始化完后x就不能当左值了
```

A const in C++ defults to internal linkage

```cpp
extern const int x;		// a.cpp
const int x = 1024;		// b.cpp
// 把他们连起来的过程是external linkage
// 因为编译器一般把常量放符号表里
```

Run-time constants

```cpp
const int size = 12;
int finalGrade[size];	// OK

int x;
cin >> x;
const int size = x;
double classAvg[size];	// ERROR???试了一下似乎没毛病？
```

## 指针与常量

```cpp
char* const q = "abc";	// a const (char*)
*q = 'c';	// OK
q++;		// ERROR

const char *p = "abc";	// a pointer to (const char)
*p = 'c';	// ERROR;
p++;		// OK

/**/

string s ("fred");
const string *p = &s;
string const *p = &s;
string *const p = &s;

/* 不能对const取地址赋给非const指针 */

int i;
const int ci = 3;
int *ip;
ip = &i;
ip = &ci;	// ERROR
const int *cip;
cip = &i;
cip = &ci;

/* 不可更改 */

char *a  = "Hello, world!";	// warning: conversion from string literal to 'char *' is deprecated(不再被支持)
a[0] = 'B';	// Runtime error: 44154 bus error

const char *b = "Hello, world";	// Okay
b[0] = 'B';	// ERROR

char c[] = "Hello, world!";	// Okay
c[0] = 'B';

/* 地址 */
const char *s1 = "Hello";
const char *s2 = "Hello";
std::cout << (void*)s1 << std::endl << (void*)s2;	// 两个地址一样

/* 常量引用调用(参数表) */
struct Student {
    int id;
};

void foo(const Student *ps) {
    cout << ps->id << endl;
    cout << (*ps).id << endl;
}

void bar(const Student &s) {
    cout << s.id << endl;
}

int main() {
    Student s;
    s.id = 2;
    foo(&s);
    bar(s);
}
```

## const和指针

```cpp
int a = 1;
const int b = 2;
const int *p = &b;
*p = 0;	// Wrong
p = &a;	// Ok
*p = 0;	// Still wrong(`a` seen as const int)
```

```cpp
const int *p = &a;	// 常量指针
int const *p = &a;	// 常量指针
int *const p = &a;	// 指针常量
```

