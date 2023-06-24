## Virtual

```cpp
#include <iostream>
#include <vector>

class Shape {
  public:
    // Shape() {}
    virtual void move() { std::cout << "Shape::move()\n"; }
    virtual void render() { std::cout << "Shape::render\n"; }
};

class Ellipse : public Shape {
  public:
    // Ellipse() {}
    virtual void move() { std::cout << "Ell::move()\n"; }
    virtual void render() { std::cout << "Ell::render()\n"; }
};

class Circle : public Ellipse {
  public:
    // Circle() {}
    virtual void move() { std::cout << "Cir::move()\n"; }
    virtual void render() { std::cout << "Cir::render()\n"; }
};

void render(Shape *p) {
    p->render();  // calls correct render function
}  // for given Shape!

void move_and_redraw_all(const std::vector<Shape *> &shapes) {
    for (auto p : shapes) {
        p->move();
        p->render();
    }
}

int main() {
    Ellipse ell;
    Circle circ;
    // ell.render();
    // circ.render();
    // render(&ell);
    // render(&circ);
    std::vector<Shape *> all_shapes{&ell, &circ};  // c++11
    move_and_redraw_all(all_shapes);
}

/*
Output:
Ell::move()
Ell::render()
Cir::move()
Cir::render()
*/
```

### 抽象父类

==抽象父类不能有对象(`Shape s;`会报错)，然后`virtual ReturnType Function()= 0;`的函数必须由子类实现(自己无法实现，也因此不能有对象)==

pure virtual 纯虚函数，含纯虚函数的类称为抽象类，不能有对象 (比如动物类难以描述自己的成员，所以可以作为抽象类)

```cpp
class Shape {
  public:
    // Shape() {}
    virtual void move() = 0;	// Key word
    virtual void render();
};
```



### memory

智能指针

```cpp
#include <memory>

int main(){
    std::unique_ptr<Circle> pc(new Circle);		// 不用手动释放
    std::unique_ptr<Ellipse> pe(new Ellipse);
}
```

### override

c++11之后子类的virtual可以改成override

```cpp
class Circle : public Ellipse {
  public:
    // Circle() {}
    virtual void move() { std::cout << "Cir::move()\n"; }
    virtual void render() { std::cout << "Cir::render()\n"; }
};
// 改成下面
class Circle : public Ellipse {
  public:
    // Circle() {}
    void move() override { std::cout << "Cir::move()\n"; }
    void render() override { std::cout << "Cir::render()\n"; }
};
```



## 多态的底层实现

http://c.biancheng.net/view/267.html

```cpp
#include <iostream>

using namespace std;

class Base {
  public:
    Base() : data(10) {}
    void foo() { cout << "Base::foo(): data = " << data << endl; }
    virtual void bar() {
        cout << "Base::bar()\n";
    }  // 没加这个函数Base b的size是4(int的大小)，加上之后变成16了

  private:
    int data;
};

int main(int argc, char const *argv[]) {
    Base b, b2;
    b.foo();
    cout << "size of b is: " << sizeof(b) << endl;
    int *p     = (int *)&b;
    void **pp  = (void **)p;
    void *vptr = *pp;
    cout << *(p++) << endl;        // 178024504
    cout << *(int *)&b2 << endl;   // 178024504 // 说明一个类共用一个vtable
    cout << vptr << endl;          // 0x10077d038: 说明了是指向代码段的
    cout << (void *)main << endl;  // 0x10077bf50
    cout << *(p++) << endl;        // 1
    cout << *(p++) << endl;        // 10	==>data
    cout << *(p++) << endl;        // 0
    return 0;
}
// (int(*)[4])((int *) &b): {8248, 1, 10, 0}
// 小端规则：8248+1*2^32，0是对齐的占位
```

实际上`pwhatever`是指向vtable(虚函数指针表)的 **PPT6.13**



```cpp
#include <iostream>

using namespace std;

class Base {
  public:
    Base() : data(10) {}
    void foo() { cout << "Base::foo(): data = " << data << endl; }
    virtual void bar0() { cout << "Base::bar0()\n"; }
    virtual void bar1() { cout << "Base::bar1()\n"; }

  private:
    int data;
};

class Derived : public Base {
  public:
    Derived() : datad(100) {}
    virtual void bar0() { cout << "Derived::bar0()\n"; }
    // 如果用virtual，这边的参数和基类不一样，但是不会报错，用override就会报错
    virtual void bar1(int a) {
        cout << "Derived::bar1(): datad+a\n" << datad + a << endl;
    }

  private:
    int datad;
};

int main(int argc, char const *argv[]) {
    Base b;
    b.foo();

    void **vfuncsd = (void **)vptrd;
    void **f0      = (void *)vfuncsd[0];
    cout << f0 << ": f0\n";
    void *f1 = (void *)vfuncsd[1];
    cout << f1 << ": f1\n";

    void **vfuncsd = (void **)vptrd;
    void **f0d     = (void *)vfuncsd[0];
    cout << f0d << ": f0d\n";
    void *f1d = (void *)vfuncsd[1];
    cout << f1d << ": f1d\n";

    cout << "f0 == f0d:" << (f0 == f0d) << endl;
    cout << "f1 == f1d:" << (f1 == f1d) << endl;

    return 0;
}
```





### 截断

```cpp
#include <iostream>

using namespace std;

class Base {
  public:
    Base() : data(10) {}
    void foo() { cout << "Base::foo(): data = " << data << endl; }
    virtual void bar0() { cout << "Base::bar0()\n"; }
    virtual void bar1(int a) { cout << "Base::bar1()\n"; }

  private:
    int data;
};

class Derived : public Base {
  public:
    Derived() : datad(100) {}
    virtual void bar0() { cout << "Derived::bar0()\n"; }
    // 如果用virtual，这边的参数和基类不一样，但是不会报错，用override就会报错
    virtual void bar1(int a) { cout << "Derived::bar1(): datad+a\n" << datad + a << endl; }

  private:
    int datad;
};

int main(int argc, char const *argv[]) {
    Base b;
    Derived d;
    Base *p = &d;
    p->bar0();  // Derived::bar0()
    b = d;      // 观察发现这句话没有任何作用
    b.bar0();   // Base::bar0()
    p = &b;
    p->bar0();  // Base::bar0()
    return 0;
}
```



## 其他

### Virtual D'tor

基类的析构函数一定要是Virtual的

### Override

```cpp
class Base {
  public:
    virtual void func();
}
class Derived : public Base {
  public:
    void func() override;
    //overrides Base::func()
}
```

### Relaxation

返回值类型不一定要相同，如果是类的**<u>指针或引用</u>**，也可以是继承关系的，例如

```cpp
class Expr {
  public:
    virtual Expr *newExpr();
    virtual Expr &clone();
    virtual Expr self();
};

class BinaryExpr : public Expr {
  public:
    virtual BinaryExpr *newExpr();  // ok
    virtual BinaryExpr &clone();    // ok
    virtual BinaryExpr self();      // Error!
};

// error: virtual function 'self' has a different return type ('BinaryExpr')
//      than the function it overrides (which has return type 'Expr')
```

### Overload

```cpp
class Base {
public:
    virtual void func();
    virtual void func(int);
};
```

## Protocol / Interface classes

```cpp
class CDevice {
public:
    virtual ~CDevice() {}
    virtual int read(...) = 0;
    virtual int write(...) = 0;
    virtual int open(...) = 0;
    virtual int close(...) = 0;
    virtual int ioctl(...) = 0;
};
```

