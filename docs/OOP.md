# OOP

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

