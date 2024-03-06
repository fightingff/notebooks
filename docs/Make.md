# Makefile & CMake

----
> 人始终还是**惰性动物**，虽然寒假里已经强迫自己学了一些基本的`Makefile`，但是当真的面对一个project进行应用的时候，还是举步维艰。因此就借着OOP Lab1的push, 重新整理一下对于`Makefile`的理解。
>
> 至于`CMake`，等将最近专业课的太多作业处理一下再整理。
>
----

## Compile & Link (C++)

首先整理一下代码源文件到可执行文件的过程：

- **Preprocessing**：预处理，将`#include`的头文件所指引的源文件插入到对应文件中，进行宏定义的替换，并删除注释，生成临时文件`*.i`。

- **Compilation**：编译，将预处理后的文件转换为汇编代码`*.s`。
    
    - `g++ -S *.cpp` 

- **Assembly**：汇编，将汇编代码转换为目标文件`*.o`。

    - `g++ -c *.s` 
    
    - `g++ -c *.cpp` 

- **Linking**：链接，将目标文件链接为可执行文件。

    - `g++ -o *(.exe) *.o` 

- *PS: -o 选项只是指定输出文件名，并没有其他特殊的意义，因此前面几条命令也可以使用-o选项指定输出文件名。* 

----

## Multiple Files (C++)

- *.h

    - 只是作为该功能模块的接口，**一般**不包含具体的实现，通过`#include`指引到对应的源文件中。
    
    - 很多时候感觉由于翻译问题，”定义“、”声明“、”实现“之类的感觉完全分不清，但是一般可以简单理解为**在头文件中不能开辟内存空间**即可。
    
    - **主要内容：**
        
        - 头文件保护 `#ifndef` `#define` `#endif`
        
        - 结构体、类的声明（**重载运算符似乎需要直接实现，其他内部函数只需要声明**）
        
        - 函数的声明
        
        - 宏定义
        
        - 全局量的声明 `extern` （不可赋值，否则就需要占用内存空间了）      

- *.cpp（功能模块源文件）
    
    - 对头文件声明的部分进行具体实现
    
    - **主要内容：**
        
        - 头文件引用
            
            - 上述同名头文件
            
            - **其他需要的头文件**，这样可以由该模块直接生成对应的OBJ目标文件，方便整个工程后续的链接。
        
        - 结构体、类的实现，不能重复出现声明部分，需要用`name::`指定 
        
        - 函数的实现
        
        - 全局量的定义（赋值）

- Main.cpp 
    
    - 主函数，调用其他模块的函数，实现整个程序的功能。
    
    - 正常情况下，只需要引用对应的头文件，然后调用对应的函数即可。  

----

## Makefile

> **Make loves c compilation. And every time it expresses its love, things get confusing.**

- [Tutorial](https://makefiletutorial.com/) （通过大量举例，非常通俗易懂且形象

- [Docs](https://www.gnu.org/software/make/manual/make.html) （官方文档，详细全面，但是有点枯燥）

- Makefile 我的理解，本质上就是一个**自动化编译的脚本**，通过指定一系列的规则和命令，来实现对于源文件的编译、链接等操作。下面我就简单整理了一下自己认为比较重要比较常用的一些点。

----

### Varible

- 常用全部大写，用`(:)=`赋值

    - `:=` 会立即展开，而`=`则是在使用时才展开 (因此可以用于递归定义)

- `+=` 追加赋值

- 用用`$()`引用

- 关于值的传入（从WK老师的补充资料里学到的）

    - `make`命令后面可以直接跟上变量的赋值`NAME=VALUE`，这样可以在`Makefile`中使用这个变量`$(NAME)`

    - `make`命令后面直接跟上变量的赋值`NAME=VALUE`，还可以当作C语言代码的宏定义，这样编译结果会不同
    
        C 语言可以通过`-D`，用宏定义选项传入对应的变量值 
        
        例如下面代码，可以使用`g++ -D ARGS=\"Hello World\" main.c -o main`来编译得到`main`可执行文件(反斜杠是为了转义双引号一起传入避免当成宏定义的赋值)，输出`Hello World`

        ```cpp title="main.c" linenums="1"
        #include<bits/stdc++.h>
        using namespace std;
        int main(){
            cout << ARGS << endl;
            return 0;
        }
        ```

### Sign

- 特殊变量

    - `$@` 目标文件
    
    - `$^` 所有的依赖文件
    
    - `$<` 第一个依赖文件
    
    - *`$?` 所有比目标文件新的依赖文件*
    
    - *`$*` 无后缀的目标文件名*

- 通配符

    - `*` 匹配任意长度的字符串
    
    - `?` 匹配单个字符
    
    - `%` 匹配任意有长度的字符串,**并且往往应用在Pattern Rule**

### Rule

- **Basic Rule**

    ```py title="Makefile"
    target: prerequisites
        command
    ```
        
    - **Target**：
        
        - 目标, 本质上是一个标号，用于指定一个规则的名字
    
        - 特殊的，'all'为默认目标，'clean'为清理目标

    - **Prerequisites**：依赖文件，依赖文件变化才会执行相应命令

    - **Command**：命令 

- Pattern Rule

    ```py title="Makefile"
    %.o: %.c
        $(CC) $(CFLAG) -c $< -o $@
    ```
    
    - **%.o**：通配符，表示所有的.o文件
    
    - **%.c**：通配符，表示所有的.c文件
    
    - 这里相当于将目录中所有的.c文件编译为对应的.o文件，而不需要一个个指定
    
    - **虽然看起来相当高效，但是由于这样没有规则标号，难以控制，因此在实际应用中并不常用**

- **Static Pattern Rule**

    ```py title="Makefile"
    targets: target-pattern: prereq-patterns
        command
    ```
    
    - **targets**: 这里往往是一个列表，表示一系列的目标文件
    
    - **target-pattern**: 一般使用`%`通配符来获取文件信息
    
    - **prereq-patterns**: 同上，一般使用`%`通配符来获取文件信息 
    
    - **command**: 感觉非常像Verilog中的generate语句，通过一系列的规则来生成相似的功能模块（详见下方例子）

- **Pattern Filter**

    - `$(filter pattern, text)`: 从text中筛选出符合pattern的部分 
    
    - 可以配合上方的Pattern Rule使用，替换targets来实现更加灵活的功能
    
    ```py title="Makefile"
    # Ex 1: .o files depend on .c files. Though we don't actually make the .o file.
    $(filter %.o,$(obj_files)): %.o: %.c
	echo "target: $@ prereq: $<"

    # Ex 2: .result files depend on .raw files. Though we don't actually make the .result file.
    $(filter %.result,$(obj_files)): %.result: %.raw
	echo "target: $@ prereq: $<" 
    ```

### Function

- `$(wildcard pattern)`
    
    - 通配符，获取当前目录下所有符合pattern的文件名

- `$(patsubst pattern, replacement, text)`

    - 替换，将text中符合pattern的部分替换为replacement

- `$(addprefix prefix, names)`

    - 添加前缀，将names中的每个元素都添加上prefix

- `$(addsuffix suffix, names)`

    - 添加后缀，将names中的每个元素都添加上suffix 

- `$(shell command)`

    - 执行命令，将命令的输出作为函数的返回值

### 其他高阶用法

- ~~还没学~~

### Example(以OOP Lab1为例)

- 项目简介：
    
    - 实现一个简单的文本管理系统，要求生成`pdadd`、`pdlist`、`pdremove`、`pdshow` 4个可执行文件
    
    - 编程时创建了一个file类，用于与文本文件进行交互，因此四个可执行文件都需要引用该类的头文件 

- 【最简单粗暴版】

  ```py title="Makefile"
    CC = g++
    CFLAG = -std=c++11
    SRC = .
    OD = ..
    FILE_ASSIST = $(SRC)/file.cpp

    # 直接两两文件一绑，然后直接编译
    $(OD)/pdadd: $(SRC)/pdadd.cpp $(FILE_ASSIST)
        $(CC) $(CFLAG) $^ -o $(OD)/pdadd

    $(OD)/pdlist: $(SRC)/pdlist.cpp $(FILE_ASSIST)
        $(CC) $(CFLAG) $^ -o $(OD)/pdlist

    $(OD)/pdshow: $(SRC)/pdshow.cpp $(FILE_ASSIST)
        $(CC) $(CFLAG) $^ -o $(OD)/pdshow

    $(OD)/pdremove: $(SRC)/pdremove.cpp $(FILE_ASSIST)
        $(CC) $(CFLAG) $^ -o $(OD)/pdremove

    clean:
        rm -f $(OD)/pdadd $(OD)/pdlist $(OD)/pdremove $(OD)/pdshow
        rm -f $(SRC)/*.o 
  ```

- 【正常编译程序版】

  ```py title="Makefile"
    CC = g++
    CFLAG = -std=c++11
    SRC = .
    OD = ..
    OBJ = $(SRC)/file.o			#	object files of file assist
    ADDOBJ = $(SRC)/pdadd.o		#	object file for pdadd
    LISTOBJ = $(SRC)/pdlist.o		#	object file for pdlist
    REMOVEOBJ = $(SRC)/pdremove.o	#	object file for pdremove
    SHOWOBJ = $(SRC)/pdshow.o		#	object file for pdshow

    all: $(OD)/pdadd $(OD)/pdlist $(OD)/pdremove $(OD)/pdshow

    # 通过.o文件链接得到可执行文件，避免了重复编译
    $(OD)/pdadd: $(ADDOBJ) $(OBJ)
        $(CC) $(CFLAG) -o $(OD)/pdadd $(ADDOBJ) $(OBJ)

    $(OD)/pdlist: $(LISTOBJ) $(OBJ)
        $(CC) $(CFLAG) -o $(OD)/pdlist $(LISTOBJ) $(OBJ)

    $(OD)/pdremove: $(REMOVEOBJ) $(OBJ)
        $(CC) $(CFLAG) -o $(OD)/pdremove $(REMOVEOBJ) $(OBJ)

    $(OD)/pdshow: $(SHOWOBJ) $(OBJ)
        $(CC) $(CFLAG) -o $(OD)/pdshow $(SHOWOBJ) $(OBJ)	

    # 通过从.cpp文件编译得到.o文件
    .cpp.o:
        $(CC) $(CFLAG) -c $< -o $@

    clean:
        rm -f $(OBJ) $(ADDOBJ) $(LISTOBJ) $(REMOVEOBJ) $(SHOWOBJ) $(OD)/pdadd $(OD)/pdlist $(OD)/pdremove $(OD)/pdshow
  ```

- 【高效版】
  
  ```py title="Makefile"
    CC = g++
    CFLAG = -std=c++11
    SRC = .
    OD = ..
    OBJ = $(SRC)/file.o			#	object files of file assist
    TARGETS = pdadd pdlist pdremove pdshow
    OBJS = $(addsuffix .o, $(TARGETS)) file.o

    all: $(OBJS) $(TARGETS) 

    # 通过static pattern rule，大大简化了生成*.o 和 *(.exe)的过程
    $(TARGETS): %: $(SRC)/%.o $(OBJ)
        $(CC) $(CFLAG) -o $(OD)/$@ $^

    $(OBJS): %.o: $(SRC)/%.cpp
        $(CC) $(CFLAG) -c $< -o $(SRC)/$@

    clean:
        cd $(SRC) && rm -f $(OBJS)
        cd $(OD) && rm -f $(TARGETS)
  ```
  