

# Composition & Inheritance

Ways of inclusion

* Fully：如人的器官
* Reference
    * 如人的笔记本电脑(是独立不依赖与自己存在)，也可以和其他“人”共享
    * 如employee类中的supervisor，也是个employee，所以只能reference

Example

```cpp
class Person { ... };
class Currency { ... };
class SavingsAccount {
  public:
    SavingsAccount( const char* name, const char* address, int cents);
    ~SavingsAccount();
    void print();
  private:
    Person m_saver;
    Currency m_balance;
};

void SavingsAccount::print() {
    m_saver.print();
    m_balance.print();
}
```



---

Protected：派生类可以访问



Base class Employee

```cpp
inline const std::string& Employee::get_name() const {
      return m_name;
}
inline void Employee::print(std::ostream& out) const {
      out << m_name << endl;
      out << m_ssn << endl;
}
inline void Employee::print(std::ostream& out, const std::string& msg) const {
      out << msg << endl;
      print(out);	// 利用重载函数实现多个代码
}
```

Derived class Manager

```cpp
class Manager : public Employee {
public:
    Manager(const std::string& name,
            const std::string& ssn,
            const std::string& title);
    const std::string title_name() const;
    const std::string& get_title() const;
    void print(std::ostream& out) const;
private:
    std::string m_title;
};

// 初始化列表调用基类的初始化函数进行初始化
Manager::Manager( const string& name, const string& ssn, const string& title = "" )  // 这个默认参数可以写在def也可以写在decl，但是只能写一个地方
                : Employee(name, s sn), m_title( title ) {}

inline void Manager::print( std::ostream& out ) const {
    Employee::print( out ); //call the base class print，需要特别说是Employee里的
    out << m_title << endl;
}
inline const std::string& Manager::get_title() const {
    return m_title;
}
inline const std::string Manager::title_name() const {
    return string( m_title + ": " + m_name );
    // access base m_name
}
```

User

```cpp
int main () {
    Employee bob( "Bob Jones", "555-44-0000" );
    Manager bill( "Bill Smith", "666-55-1234", "ImportantPerson" );
    string name = bill.get_name(); // okay Manager inherits Employee
    //string title = bob.get_title(); // Error -- bob is an Employee!
    cout << bill.title_name() << '\n' << endl;
    bill.print(cout);
    bob.print(cout);
    bob.print(cout, "Employee:");
    //bill.print(cout, "Employee:"); // Error hidden!
}
```



## 初始化列表

```cpp
#include <iostream>

using namespace std;

class Base {
public:
    Base() {
        cout << "Base::Base()\n";
    }
};

class Child : public Base {
public:
    Child(): Base() {
        cout << "Child::Child()\n";
    }
};

int main(int argc, char const *argv[])
{
    Child c;
    return 0;
}
// Output:
// Base::Base()
// Child::Child()
```

## Name Hiding

• If you redefine a member function in the derived class, <u>all other overloaded</u> functions in the base class are inaccessible.

• We'll see how the keyword virtual affects function overloading next time.



## 友元



## 继承

class vs. struct

- class defaults to private
- struct defaults to public

| Inheritance Type ( B is ) | *public*       | *protected*    | *private* |
| ------------------------- | -------------- | -------------- | --------- |
| **:public** A             | public in B    | protected in B | private   |
| **:protected** A          | protected in B | protected in B | private   |
| **:private** A            | private in B   | private in B   | private   |

## 权限

```cpp
class A{
  public:
    A : data(10) {};
    void foo(A *other) {cout << other->data}	// 这是可以的，因为private是相对类而言不是对对象而言
  private:
    int data;
}
```

