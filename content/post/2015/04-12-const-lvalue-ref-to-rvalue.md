---
title: "从const左值到右值"
date: "2015-04-12"
tags:
    - code
---

首先定义左值和右值。左值和右值在C里面是有定义的，虽然和最近的C++中的定义不太一样。左值就是那些可以被引用的值，比如int a = 1; int *p = &a;，a就是左值。而int &b = a中的b就是左值引用了，引用的是一个左值。右值就是那些不是左值的东西，比如前面的1啦，或者 int foo () { return 1; } 中的 foo()了，这些都是右值。对于这些右值，有个特点，就是不能使用求地址的符号&来操作它们。比如

```cpp
int foo () {
  return 1;
}

// 下面的是错误的，编译器会抛出异常
// error: lvalue required as unary '&' operand
int *p = &(foo());

// 你只能这样来
int temp = foo();
int *p = &temp;
```

上面代码的异常“lvalue required as unary ‘&’ operand”的意思是，&操作符需要一个“左值”来进行取地址的操作，但是foo函数返回一个常量，而那个常量是个右值。

### 左值引用

看下面的C++代码，因为引用只出现在C++里面。

```cpp
int foo () {
  return 1;
}

// 错误
int &p = foo();

// ok
// const int &p = foo();
```

引用，在逻辑上就是对一个内存内容的映射，你对这个引用进行更改，那么那个地址的内容也会被更改。比如 int i = 3; int &ref = i; ref = 5; printf("%d\n", i);会输出5。所以，类似这样的赋值是不合逻辑的： int &ref = 3; 。试想这样的，赋值，意味着我们可以随意修改这个常量3吗？显然不合逻辑，因此这是不被允许的。但是如果使用const的话就可以了。因为使用const的左值引用，就是创造了一个临时的变量。就如上面代码中的那段const int &p = foo()，可能在C++的实现中是int __tempKw = foo(); int &p = __tempKw; 。而这样的行为又造成了另一个特性，那就是临时变量生命期的增加。上面的代码中，不能说是临时变量，1只是个常量。比如下面的代码

```cpp
int foo () {
  int i = 3;
  return i;
} // i的生命期在这里就结束了。

// const int &p = foo();
```

i是个临时变量，它的生命期是在函数foo里面，但是在通过const的左值引用赋值后，i的生命期得到了延续，延续到了变量p的生命期的结束。变量p是对变量i的引用绑定。变量p有它的生命期，如果它的生命期结束了，那么i的生命期可以说是真正的结束了。这里有个说明[extend lifetimes](http://en.cppreference.com/w/cpp/language/reference_initialization).

类似const &va = i这样的声明的，都算是对临时变量的生命期的延续，但是这个左值引用是不能对原值进行修改的。而右值引用却可以。比如来自cppreference的例子：

```cpp
std::string s1 = "Test";
// std::string&& r1 = s1; // error: can't bind to lvalue

const std::string& r2 = s1 + s1; // OK, lvalue ref to const extends lifetime
// r2 += "Test"; // error: can't modify through reference to const

std::string&& r3 = s1 + s1; // OK, rvalue ref extends lifetime
r3 += "Test"; // this object can be modified
std::cout << r3 << '\n';
```
