# 存储区域

```cpp
int i;
static int j;
void f(){
    int k;
    static int l;
    int *p = malloc(sizeof(int));
}
```

全局数据区：全局变量、静态(全局/局部)变量

Stack：局部变量

Heap：动态分配内存(malloc的地址)

打印出来能发现 ijl 相连，地址很小；k与p相连；*p；三类之间差挺多的

`extern`表示Declaration(不分配)，表面其他地方有定义这个全局变量

`static`加在全局变量表示说明当前这个变量只能在当前编译区域中使用；加在函数中不清空

# new与delete

```cpp
new int;
new Stash;
new int[10];

delete p;	// p指向的对象的内存空间(如果p的指针类型不对是不是会错)
delete[] p;	// p是有`new int[10]`这样分出来的空间

Student *pS = new Student();	// ()
```

与malloc区别：

* 用new分配class、struct会==调用构造函数==，用malloc()不会; new 是运算符， malloc是函数。`new` returns a pointer with the appropriate type, while `malloc` only returns a `void *` pointer that needs to be typecasted to the appropriate type

* 用delete删除也会==调用析构函数==

    * 如果r是指向类数组、结构数组的，调用`delete r`理论上只会调用一次析构函数，但是所有对象都会被清理，实际上可能会有更多错误；


内存泄漏：指程序中己**动态分配的堆内存**由于某种原因程序未释放或无法释放

```cpp
int *p;
p = new int[10];
delete[] p;
p = nullptr;	// c++11及之后，NULL类型不安全
delete[] p;		// 这样就不会报错了
```



```cpp
#include <iostream>

typedef struct Student {
	int a;
	// Student() {}
	// ~Student() {}
} Student;

int main(int argc, char const *argv[]) {
	int size;
	if (argc > 1)
		size = atoi(argv[1]);
	Student *pa = new Student[size];
	size_t *p = (size_t*)(pa - 2);	// 这个位置存的是"size"的值
	std::cout << *p;
	return 0;
}
```



**Tips for new and delete**

* Don't use `delete` to free memory that `new` didn't allocate.
* Don't use `delete` to free the same block of memory twice in succession.
* Use `delete []` if you used `new []` to allocate anarray.
* Use `delete` (no brackets) if you used new to allocate a single entity.
* It's safe to apply `delete` to the `null` pointer (nothing happens).