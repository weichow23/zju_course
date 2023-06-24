`T::T(const T&)`



问题

由于自带的拷贝构造是拷贝成员的，因此如果成员中有指针，那么两个类会有指向同一地址的指针



```cpp
#include <cstring>
#include <iostream>

using namespace std;

class Person {
  public:
    char *name;

    Person(const char *s) {
        name = new char[::strlen(s) + 1];
        strcpy(name, s);
    }
    ~Person() {
        delete[] name;  // array delete
    }
};

int main() {
    Person p1("CXY");
    Person p2 = p1;
    cout << (void *)p1.name << endl;  // 两个是一样的
    cout << (void *)p2.name << endl;

    return 0;  // 报错：to be freed is not allocated(p1已经吧"CXY"删掉了，p2再删一次必出错)
}
```

因此要定义拷贝构造函数

```cpp
Person::Person( const Person &other ) {
    name = new char[::strlen(other.name) + 1];
    ::strcpy(name, other.name);
}
```

或者

```cpp
Person::Person( const char *s ) { init(s); }
Person::Person( const Person &other ) { init(other.name); }
void Person::init( const char *s ) {
    name = new char[::strlen(s) + 1];
    ::strcpy(name, s);
}
```



注意这个

```cpp
class Person {
public:
    char* name;
    Person( const char *s ) {
        cout << "Person(const char*)" << endl;
        init(s);
    }
    Person( const Person &other ) {
        cout << "Person(const Person &)" << endl;
        init(other.name);
    }
    void init( const char *s ) {
        name = new char[::strlen(s) + 1];
        ::strcpy(name, s);
    }
};

Person foo(Person p) {
    cout << "foo()\n";
    return p;
}
Person bar(const char *s) {
    cout << "bar()\n";
    return Person(s);
}

int main() {
    Person p1 = foo("Hello1");  // 先拷贝构造了一个对象，再把对象返回，相当于foo(Person("Hello1"))
    Person p2 = bar("Hello2");  // 进去之后产生了一个临时对象Person(s)，然后再把临时对象拷贝给p2
    cout << p1.name << endl;
    cout << p2.name << endl;
}
// 要看到效果要在编译的时候加上 -fno-elide-constructors 关掉拷贝构造优化。若优化之后，bar会直接构造p2，相当于Person p2(s)

// 没关优化的输出
Person(const char*)
foo()
Person(const Person &)
bar()
Person(const char*)
Hello1
Hello2
// 关闭优化的输出
Person(const char*)
Person(const Person &)	// Person("Hello1")拷贝构造给foo中的p
foo()
Person(const Person &)	// 本地p拷贝给返回值
Person(const Person &)	// 返回值拷贝给p1
bar()                   // 传给bar()的参数是const char*所以在输出之前没有涉及到Person
Person(const char*)		// 字符串拷贝构造
Person(const Person &)	// 本地p拷贝给返回值
Person(const Person &)	// 返回值拷贝给p2
Hello1
Hello2
```


Static