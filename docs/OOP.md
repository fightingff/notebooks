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

- *工程中慎用<bits/stdc++.h>头文件，降低编译压力*

- Containers

    - vector
        
        - 内部实现：
            
            - 动态内存分配，当容量不足时，会将容量扩大为原来的两倍，然后将原来的元素复制到新的内存空间中，释放原来的内存空间。
            
            - 插入均摊时间复杂度为 O(1)
            
            - 删除元素时，会将后面的元素向前移动，时间复杂度为 O(n) 
      
        - vector<int>p(capacity,(k)) (capacity 个 k) 
        
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

### 构造

- 全局变量构造在main函数之外，main函数之前构造，main函数之后析构，按书写顺序构造，反序析构

- *但是全局变量处在多文件时，构造顺序是不确定的*                                            

- *进入函数时，所有本地变量所占据空间已经分配完毕*  

- **Delegating Constructor**

    - 一个构造函数可以调用另一个构造函数，减少代码重复

    - `A(int x, int y): A(x) {}`

### 析构
  
- 编译器控制，当变量结束生命周期时自动调用

- 同等条件下，析构函数的调用顺序与构造函数的调用顺序相反（栈一样，避免依赖关系影响） 

### 权限

- private

    - 仅在**类**内部可见
    
    - **边界是类, 不是对象，并且由编译器控制（可以绕过）**  

- public

    - 都可以访问，与 structure 类似 

- protected

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
    
    - 可以通过类名访问，也可以通过对象访问
    
    - static member function 只能访问 static member variables  

## Reference

`Tp &x = v`

**本质上相当于给变量起了一个别名，方便变量的引用，不会分配内存空间（否则对于一个对象的拷贝可能开销过大）**

**实质上就是使用指针实现的**

- 在定义时初始化为一个左值，且不能改变指向 (左值引用`&`)

- 在定义时初始化为一个右值，且可以改变指向，相当于记下了一个临时变量 (右值引用`&&`)
  
> No pointers to references `&*p`
>
> References to pointers OK `*&p`

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

    - *建议能加 const 的函数都加上*

- 关于定义数组 [const size]：

    - 本地变量可以直接使用，因为在函数内可以自由分配栈空间

        ```cpp
        void f(int n) {
            int a[n];//OK
        }
        ```

    - 对象成员的数组定义不能用size，哪怕已经直接初始化，因为编译器不能确定
    
        ```cpp
        class A {
            const int n = 10;
            int a[10];  //Error
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

- new的实质 

    - 申请的空间没有默认初始值（直接给内存中的垃圾值），可以用 `{}` 初始化
  
    - 对于对象，需要有默认构造函数才能满足默认构造 

    - 前面有一个标记头，记录了口令和大小，用于 delete 时检查; 之后是实际申请的空间

- delete的实质

    - 检查对象的析构函数，**并调用析构（在释放内存前）**
    
    - 往前走一个单位，检查口令和空间大小，不对会抛出异常

    - 不加 [] 只会释放第一个对象的空间，数组会释放记录的空间大小

## default argument（默认参数）

- 默认参数“从右往左连续写”
    
- 默认参数值是静态的（编译器处理），**在声明中写默认值，不能在定义中写** 

    - *头文件内定义的默认值可能会被篡改*

### inline（内联）

> 相当于将函数代码拷贝到当前代码块中，避免函数调用的开销
>
> **inline 函数（包括body）相当于声明，不是定义，因此要整个放在头文件中**

- 会增长代码，本质上是用“空间换时间”

- inline 函数复杂时可能会被编译器放弃 inline
  
    一般是比较短小且频繁调用的函数

    ~~递归不适合~~

- class 成员函数加上 body 直接默认 inline，无需特殊标记

    *当长度过长时，可以在头文件内用 inline 声明， 然后直接将定义写在下方（都在头文件内）*

