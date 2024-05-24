# OOP

## 整理

### 声明 & 定义

声明不分配内存，定义分配内存

如 extern, struct, class 内都是声明

### varibles scope & lifetime

||scope|lifetime|storage|
|---|---|---|---|
|local|{}|{}|stack|
|global|global|program|global|
|static local|{}|program (init when called)|global|
|member(private)|class|object|object|
|static member|class|program|global|
|malloc|passed in-out|malloc-free|heap|

### Tricks

- 编程复杂度 与 现实要求 冲突时，一般选择服从现实要求比较“顺”

- 没有成员变量的类 的 size 为1，用来区分，但是在其子类中不会有这个区分，即为0

- 函数传入 & 传出

    ![1715311286030](image/OOP/1715311286030.png)

## Buzzwords

- Encapsulation: 封装

- Inheritance: 继承

- Polymorphism: 多态

- Overriding: 覆盖

- Interface: 接口

- Cohesion: 內聚, 一个类内的功能高度相关

- Coupling: 耦合， 不同类之间的关联程度

- Collection classes: 容器

- Template: 模板

- Responsibility-driven design: 责任驱动设计

- Generic: 泛型

- Field: 字段

- Parameter: 函数参数

## STL

> **Standard Template Library**

- *工程中慎用\<bits/stdc++.h\>头文件，降低编译压力*

- Containers

    - vector
        
        - 内部实现：
            
            - 动态内存分配，当容量不足时，会将容量扩大为原来的两倍，然后将原来的元素复制到新的内存空间中，释放原来的内存空间。
            
            - 插入均摊时间复杂度为 O(1)
            
            - 删除元素时，会将后面的元素向前移动，时间复杂度为 O(n) 
      
        - vector\<int\>p(capacity,(k)) (capacity 个 k) 
        
        - vector [] “可以”越界访问，（因为实际上的容量可能大于它显示的capacity），.at() 会抛出异常

            *（乱穿马路违法，但是一般没人会来管你。没撞死算幸运，撞死活该。）*  
    
    - deque (double ended queue) 
    
        - 内部实现： 
    
            - 使用缓存区块存取元素，使用 map 建立缓存区块的索引，当缓存区块不足时，会重新分配内存空间。
            
            - 两端插入和删除均摊时间复杂度为 O(1)，但实现上比 vector 复杂
            
            - 缓存区内部实现与 vector 类似 

    - list  (doubly linked list)
    
        - `list.begin() != list.end()` (不推荐使用 < ，可能会出错)
        
        - `copy(L, R, vector<>it)` 链表展平为 vector 
    
    - forward_list
  
    - *string  
  
    - set
    
    - map    

- Algorithms

- Iterators

    - 输入迭代器：只能读取数据，不能修改数据
    
    - 输出迭代器 
    
    - 前向迭代器
    
    - 双向迭代器
    
    - 随机访问迭代器   

## Container

> 容器，collection of objects that can store an arbitrary number of other objects.

- 通常用 size 来表示其中 object 的数量 

## Class

> 类，一种用户自定义的数据类型，用于封装数据和方法
>
> *关于内部数据存储，具有地址对齐性，即一个短变量只会在一行内读出，不会跨行读取*

### 构造

- 全局变量构造在main函数之外，main函数之前构造，main函数之后析构，按书写顺序构造，反序析构

- 类内构造

    1. 调用父类构造函数
    
    2. 按顺序调用成员构造函数（检查调用的构造函数的初始化列表内是否有相应代理构造，若没有则调用默认构造）
    
    3. 调用自身构造函数   

- 初始化变量时 `= x, (x)` 都会调用构造函数，没有区别

- *但是全局变量处在多文件时，构造顺序是不确定的*                                            

- 进入函数时，所有本地变量所占据空间已经分配完毕，并且**实参量会调用拷贝构造函数（const Tp &x）来传值**

- 构造列表只能初始化 non-static 的成员，包括可以初始化const常量 

- **Delegating Constructor**

    - 一个构造函数可以调用另一个构造函数，减少代码重复

    - `A(int x, int y): A(x) {}`

### 析构
  
- 编译器控制，当变量结束生命周期时自动调用

- 同等条件下，析构函数的调用顺序与构造函数的调用顺序相反（栈一样，避免依赖关系影响） 

### 权限

- private

    - 仅在**类**内部可见
    
    - **边界是类, 不是对象（类内可以访问其他同类对象的私有成员），并且由编译器控制（可以绕过，如利用指针为所欲为）**  

- public

    - 都可以访问，与 structure 类似 

- protected

    - 与private的区别是子类可见（*留给子类的遗产*） 

- default

    - class 默认是 private 的，struct 默认是 public 的 

- friend

    - 权限授权，可以访问该类的私有成员 和 保护成员
    
    - 友元不是成员函数
    
    - 友元的友元不一定是友元，即友元关系不可继承

### overload 重载

- 函数名相同，参数不同

- 不能使用 auto-cast, 会造成二义性

## static

- deprecated：（过时）

    > 限制外部访问

    - static free function
    
    - static global variables
    
- static local variables

    - 持久存储，多次调用保存上次的值    
    
    - 本质上是 **访问受限的全局变量**，在函数被第一次调用时构造，在程序结束时析构(如果被构造了) 

- static member variables

    - 所有对象共享，不属于对象，属于类
    
    - 不能在类内初始化，需要在类外初始化
    
        **static variable 需要全局定义申请内存空间（包括private / public）** 

        ` Tp ClassName::StaticVariable = x;`

    - 可以通过类名访问，也可以通过对象访问
    
    - static member function 只能访问 static member variables  

## Reference

`Tp &x = v`

**本质上相当于给变量起了一个别名，方便变量的引用，不会分配内存空间（否则对于一个对象的拷贝可能开销过大）**

**实质上就是使用指针实现的**

- 在定义时初始化为一个左值，且不能改变指向 (左值引用`&`)

- 在定义时初始化为一个右值，且可以改变指向，相当于记下了一个临时变量 (右值引用`&&`)
  
> No pointers to references `(Tp&) *p`
>
> References to pointers OK `(Tp*) &p`

- *Left value & Right value*

    - Left value: `.` `[]` `->` `*`
    
    - Right value: others  

## Const

> **不可赋值（可以在创建时初始化一次）**

- const & pointer

    观察`*`位置
    
    - const 在 `*` 前，说明指向的内容不可修改
    
    - const 在 `*` 后，说明该指针不可修改 

- 声明 const function

    - `const` 修饰函数，表示该函数不会修改成员变量  (const *this)
    
    - 因此，const object 只能调用 const function, 使编译器能够检查错误

    - *建议能加 const 的函数都加上，比如const对象默认只能调用const/static函数*

- 关于定义数组 [const size]：

    - 本地变量可以直接使用，因为在函数内可以自由分配栈空间

        ```cpp
        void f(int n) {
            int a[n];//OK
        }
        ```

    - 对象成员的数组定义不能用size，哪怕已经直接初始化，因为编译器不能确定（const 常量可能在初始化列表中被重新初始化）
    
        ```cpp
        class A {
            const int n = 10;
            int a[10];  //Error
            A():n(6){}  // Legal and powerful
            // Thus "change" the n to 6 when the object is constructed
        };
        ```
    
    - enum & static 可以用来定义数组大小

        ```cpp
        class A {
            static const int m = 10;
            enum {n = 10};
            int a[n];  //OK
            int b[m];  //OK
        };
        ```

## new & delete

> new 动态申请空间，返回指针
>
> delete ([]) p 释放空间，[] 取决于单一对象还是数组
>
> 本质上是运算符

- new的实质 

    - 申请的空间没有默认初始值（直接给内存中的垃圾值），可以用 `{}` 初始化
  
    - 对于对象，需要有默认构造函数才能满足默认构造 

    - 前面有一个标记头，记录了口令和大小，用于 delete 时检查; 之后是实际申请的空间

- delete的实质

    - 检查对象的析构函数，**并调用析构（在释放内存前）**
    
    - 往前走一个单位，检查口令和空间大小，不对会抛出异常

    - 不加 [] 只会释放第一个对象的空间，而不会释放记录的空间大小，同时系统也会失去这部分内存的信息（最后不再调用剩余的析构）

## default argument（默认参数）

- 默认参数“从右往左连续写”
    
- 默认参数值是静态的（编译器处理），**在声明中写默认值，不能在定义中写** 

    - 因此本质上是定义了一个带参函数，小心重载时的重复错误

    - *头文件内定义的默认值可能会被篡改*

## inline（内联）

> 本质上相当于将函数代码直接拷贝到当前代码块中（**直接添加到当前文件的.obj中，而不是后续通过link连接**），避免函数调用的开销
>
> **inline 函数（包括body）相当于声明，不是定义，因此要整个放在头文件中，让编译器处理。编译器不会分配函数空间，而是直接将对应指令“抄下来”，在需要的地方直接填上去。**

- 会增长代码，本质上是用“空间换时间”

- inline 函数复杂时可能会被编译器放弃 inline
  
    一般是比较短小且频繁调用的函数

    ~~递归不适合~~

- class 成员函数加上 body 直接默认 inline，无需特殊标记

    *当长度过长时，可以在头文件内用 inline 声明， 然后直接将定义写在下方（都在头文件内，都加inline）*

## namespace

> Expresses a logical grouping of classes, functions, variables, etc.
>
> *{}末尾没有 分号 作为结束*

- using 简化

    - `using namespace Name;`
    
        `using Name::Func;`
    
        `using Name::Class;`

    - using 可能会导致同名成员冲突，但是只有调用冲突成员时才会报错，using并不会马上报错。为了解决冲突问题，可以通过显式指明命名空间。

- alias 重命名

    - `namespace NewName = OldName;`

- openness

    - 同一个命名空间可以分布在多个文件中

## Composition

### Embedded Objects

> A class **has** other classes

- Storage：按照书写顺序在内存中存储 

- Constructor & Deconstructor：同样是顺序构造，逆序析构
  
- Fully v/s **By Reference**

    - logical relationship
    
    - size of is not known
    
    - resource is to be allocated / connected at run-time
    
    - *Only C++ can use fully* 

### Inheritance

> 继承性，面向对象的重要思想

- Advantage

    - Avoid code duplication
    
    - Code reuse
    
    - Easier maintenance: 修改模块对其他模块影响小
    
    - Extendibility： 易于添加新功能

- 可继承的成员

    > 本质上内存里父类对象会放在子类对象的前面（*可以将子类指针赋给父类指针*）

    - **public / protected** member data
    
    - **public / protected** member functions
    
    - *static* 仍然为class-wide，依赖它的属性 

- Constructor & Deconstructor
  
    - 构造先父类后子类
    
    - 析构同样反向 

- **Name Hiding**

    - 一旦出现overload，则所有同名的函数都得覆写，否则父类的会被隐藏

    - 可以使用 `using base::f;` 把它找出来

- **Inheritance Access Protection**

    - public / protected / private: 定义继承的父类成员的访问权限

    - private: default(并不是OOP语意)

### Polymorphism

> 多态性，静态声明 & 动态类型

- Subtyping
  
    子类对象可以赋给父类对象, 所有父类具有的派生类都有

    ![1714098664603](image/OOP/1714098664603.png) 
    
- Up-casting

    向上造型，子类对象赋给父类对象（指针 / 引用），不会丢失子类的信息

    但是只能调用父类的成员，不能调用子类的成员

    **virtual**

    - 定义一个接口，让编译器知道该函数将会被子类覆写，从而可以在Up-casting时用父类指针/引用调用子类函数
  
    - 本质上是动态变量的绑定（dynamic binding），即在运行时根据dynamic type才确定调用的函数，而非编译时的静态绑定。因此速度会相对慢一点，除非编译器发现是静态绑定，会自动转为静态绑定。
  
    - 编译器执行静态检查，因此父类内的接口不可省略（只要父类定义为虚函数，子类中该函数就自动成为虚函数）
  
    - 内存存储：

        **头部**有一个vptr指针，且为构造时存入

        - **vptr**：虚函数表指针，指向虚函数表，存储虚函数的地址
        
        - **vtable**：虚函数表，存储虚函数的地址
        
        - **vfunc**：虚函数，存储函数的地址  

    - 纯虚函数：

        - `virtual Type F() = 0`

        - 整个类成为抽象类，不能定义对象
    
- 多继承

    - virtual inheritance 处理菱形继承关系，不将父类放到子类中，而利用指针索引

### Copy & Move

- **copy constructor**

    > `T::T (const T&)`
    >
    > 复制一份

    - 函数调用的赋值
    
        - 用函数本地变量返回赋值只会调用拷贝构造一次

        - 直接返回构造不需要调用拷贝构造（将相应内存直接放在函数体上方）

        ![1715310755018](image/OOP/1715310755018.png)

    - member-wise copy: 拷贝指针小心，否则可能会影响源对象

- **move constructor**

    > `T::T (const T&&)`
    >
    > 传递指针，销毁原对象

    - 使用 `std::move()` 转为右值

### Overloading Operator

- Can

    ![1715911657490](image/OOP/1715911657490.png)

- Can't

    ![1715911919152](image/OOP/1715911919152.png)

- Don't
  
    `&&` `||` `,`

#### ProtoTypes

- Tips

    ![1715913261767](image/OOP/1715913261767.png)

- Member operator

    *注意，调用时左边应该为对象（左结合）*

    - binary

        - `T operator+(const T &x)`

    - unary

        - `T operator-()`

- Global operator

    *为了访问私有变量，可以使用 public / friend*

    - binary

        - `T operator+(const T &x, const T &y)`

    - unary

        - `T operator-(const T &x)`

- Some

    ![1715913842344](image/OOP/1715913842344.png)

    ![1715914279609](image/OOP/1715914279609.png)

    (Relational, just need define `==` & `<`)

    ![1715914907475](image/OOP/1715914907475.png)

    ![1715915485582](image/OOP/1715915485582.png)

    ![1715915499073](image/OOP/1715915499073.png)

    ![1715915619644](image/OOP/1715915619644.png)

    ![1715915874386](image/OOP/1715915874386.png)

    ![1715916428225](image/OOP/1715916428225.png)

#### Argument passing

- read-only argument: `const T &x`

- const member function(not change `this`): `const T`

- const result(can't be L-value): `const T`

- always use reference

#### Type conversion

> `explicit` to avoid `implicit conversion`

![1715916652058](image/OOP/1715916652058.png)

![1715916854154](image/OOP/1715916854154.png)

### Template

> generic programming（泛型编程）

- Function Template

    本质上也是声明，由编译器发现相关调用后创建，因此需要在头文件中定义

    ```c++
    template <class / typename T>
    T func(T x, T y) {
        return x + y;
    }
    //强制类型调用
    func<T>();
    ```
    !!! danger

        模板函数必须保证调用的参数类型完全一致，自动类型转换无效！
    
    ??? 函数调用顺序

        1. 精确类型
        
        2. 精确模板
        
        3. overloading  

- Class Template

    ```c++
    template <class T>
    class A {
        T x;
        T f(T x);
    };
    template <class T>
    T A<T>::f(T x) {
        return x;
    }

    // 调用
    A<type> a;
    ```

- 拓展用法

    - 多个模板参数

        ```c++
        template <class T, class U ...>
        ```
    
    - 嵌套模板

        ```c++
        template <Class<T> >    //现代编译器无所谓那个空格了
        
        template <int (*)(Class<T> ) > //函数指针
        ```
    
    - 默认参数

        ```c++
        template <class T, int para = default>  // 内部相当于一个字面量
        ```
    
    - 继承模板

        ```c++
        template <class T>
        class B : public A<T> {
            ...
        }
        ```
    
    - friend

        ```c++
        template <class T>
        class A {
            friend T;
        }
        ```

    - static member

        相当于每种类型都有一个独立的 static member
        
        ```c++
        template <class T>
        class A {
            static int x;
        }
        template <class T>
        int A<T>::x = 0;
        ```