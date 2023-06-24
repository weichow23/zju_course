Generic

泛化

## Function template

For example: `sort`

```cpp
template <class/typename T>
void swap(T &x, T &y) {
    T tmp = x;
    x = y;
    y = tmp;
}
```

模板的实例化：编译器将模板用重载的方式实现

如果有个函数模板但是没有调用，编译器不会实例化 (如果是具体的函数即使没有调用也会被编译) ==是否意味着模板和内联一样不能跨文件使用？确实==



### 强制

用`<>`强制指定模板类型

```cpp
template <typename T>
void print(T a, T b) {
    std::cout << a << " " << b << std::endl;
}

int main() {
    print<int>(2, 3.2);    // 2 3  // 发生截断
    print<float>(2, 3.2);  // 2 3.2
}
```



### 共存

**普通函数和模板函数共存**

```cpp
template <typename T>
void print(T &a, T &b) {
    cout << a << " " <<< b;
}
void print(float &a, float &b) {
    cout << "print(float): " << a << " " <<< b;
}

print(2f, 3.1f)
```

检查顺序

1. 普通函数
2. 模板函数
3. 隐式转换(implict conversion)

## Class template

例如Vector

```cpp
template <typename T>
class Vector {
  public:
    Vector(int);
    T& operator[];

  private:
    T *m_array;
    int m_size;
};

template <typename T>
Vector<T>::Vector(int size) : m_size(size) {
    m_array = new T[m_size];
}

template <typename T>
T& Vector<T>::operator[](int index){
    if(index < m_size && index >= 0) {
        return m_array[index];
    } else{
        // Error
    }
}

Vector<int> vi;
```



### 带参模板

```cpp
template <typename T, int N = 100>
class Array{
  public:
    int size() const { return N; }
    T & operator[](int i) { return m_arr[i]; }
  private:
    T m_arr[N];
};

Array<int, 3> a;
cout << a.size();
Array<int, 3> b = a;	// OK，会调用默认的拷贝构造
Array<int, 4> c = a;	// TypeError

```

### Recurring

```cpp
template <class T>
class Base {
    // ...
};
class Derived : public Base<Derived> {
    // ...
};
```

例

```cpp
template <class T>
struct Base {
    void interface() {
        // 将基类指针转化为派生类指针，然后用这个指针调用派生类的implementation
        static_cast<T *>(this)->implementation();
        // (T *)this->implementation();
        // this->implementation();
    }
};

struct Derived1 : Base<Derived1> {
    void implementation() { cout << "D1:im()" << endl; }
};

struct Derived2 : Base<Derived2> {
    void implementation() { cout << "D2:im()" << endl; }
};

template <typename T>
void foo(Base<T> &b) {
    b.interface();
}

int main() {
    Derived1 d1;
    foo(d1);
    Derived2 d2;
    foo(d2);
    return 0;
}
```

