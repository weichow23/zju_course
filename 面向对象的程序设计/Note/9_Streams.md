# Streams

|            | I             | O             | Header      |
| ---------- | ------------- | ------------- | ----------- |
| Generic    | istream       | ostream       | <iostream>  |
| File       | ifstream      | ofstream      | <fstream>   |
| C string   | istrstream    | ostrstream    | <strstream> |
| C++ string | istringstream | ostringstream | <sstream>   |

## Intro

* Original C I/O used printf, scanf
* Streams introduced in C++
    * C I/O libraries still work
* Advantages of streams
    * Better type safety
    * Extensible
    * More object-oriented
* Disadvantages
    * More verbose 格式控制很烦
    * Might be slower
        * Turn off synchronization: `std::ios::sync_with_stdio(false);`
            * 开了可以混用c和cpp方式



**Predefined streams**

• cin
	– standard input
• cout
	– standard output
• cerr
	– unbuffered error (debugging) output
• clog
	– buffered error (debugging) output

[What is the difference between cout, cerr, clog of iostream header in c++? When to use which one? - Stack Overflow](https://stackoverflow.com/questions/16772842/what-is-the-difference-between-cout-cerr-clog-of-iostream-header-in-c-when)

## Input

### extractor

```cpp
istream& operator>>(istream& is, T& obj) {
    // specific code to read obj
    return is;
}
```

### get

* int get()

    * Returns the next character in the stream

    * Returns EOF if no characters left

    * Example: copy input to output

        ```cpp
        int ch;
        while ((ch = cin.get()) != EOF)
            cout.put(ch);
        ```

* istream& get(char& ch)

    * Reads the next character into argument
    * Similar to int get();

### Other

`get(char *buf, int limit, char delim='\n')`

• Read up to limit characters, or to delim
• Appends a null character to buf
• Does not consume the delimiter

`getline(char *buf, int limit, char delim='\n')`

• Read up to limit characters, or to delim
• Appends a null character to buf
• Does consume the delimiter

`ignore(int limit=1, int delim = EOF)`

• Skip over limit characters or to delimiter
• Skip over delimiter if found

`int gcount()`

• Returns number of characters <u>just read</u>

```cpp
char buffer[100];
cin.getline(buffer, sizeof(buffer));
cout << "read" << cin.gcount() << " characters";
```

`void putback(char c)`

• Pushes a single character back into the stream

`char peek()`

• Examines the next character <u>without consuming it</u>

```cpp
switch(cin.peek())
```

## Output

### inserter

```cpp
ostream& operator<<(ostream& os, const T& obj) {
    // specific code to write obj
    return os;
}
```

### Other

`put(char)`

• Prints a single character
• Examples

```cpp
cout.put('a');
cerr.put('!');
```

`flush()`

• Force output of stream contents
• Example

```cpp
cout << "Enter a number";
cout.flush();
```

## Format

### Manipulators

**endl的作用**

* 加个回车
* 执行`os.flush()`



**进制**

```cpp
cin >> hex >> n;
```



**场宽位宽**

c++中的setprecision()与python中的相反，这里正数是整数，负数是小数

```cpp
cout << setprecision(2) << 1230.243 << endl;
cout << setw(20) << "OK!";
```



| Manipulator                                                  | Effect                     | Type |
| ------------------------------------------------------------ | -------------------------- | ---- |
| dec, hex, oct                                                |                            | IO   |
| endl                                                         |                            | O    |
| flush                                                        |                            | O    |
| setw(int)                                                    |                            | IO   |
| setfill(ch)                                                  |                            | IO   |
| [setbase(int)](http://www.cplusplus.com/reference/iomanip/setbase/) | Set number base(8, 10, 16) | O    |
| ws                                                           | Skip whitespaces           | I    |
| setprecision(int)                                            |                            | O    |
| setiosflag(long)                                             | Turn on specified flags    | IO   |
| resetiosflags(long)                                          | Turn off specified flags   | IO   |



### Flag

![](assets/image-20200506154419698.png)

**Setting flags**

* Using manipulators
    * setiosflags(flags);
    * resetiosflags(flags);
* Using stream member functions
    * setf(flags);
    * unsetf(flags);

