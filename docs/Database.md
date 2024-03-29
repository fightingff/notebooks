# DataBase

[Fork Yile Liu](https://github.com/yile-liu/ZJU_database_system)

----

## 第一章 引入

### 数据库重要问题

- data persistence: 数据持久化

- convenience in accessing data: 方便的数据访问

- data integrity: 数据完整性

- concurrency control for multiple user: 多用户并发控制

- failure recovery: 失败恢复

- security control: 安全控制

### 系统结构

- Physical Level: 数据在磁盘上的存储方式

- Logical Level: 数据在用户看来的存储方式

- View Level: 用户看到的数据

### 数据库语言

- **DDL** (Data Definition Language)

    - 数据定义语言，定义数据库的结构

        ```sql
            create table student(
                name varchar(20),
                ...
                primary key(name),
                foreign key(name) 
            );
        ```

    - DDL interpreter: 用于解释DDL语句，将其转化为内部数据结构

- **DML** (Data Manipulation Language)

    - 数据操作语言，对数据库中的数据进行操作

    - Procedural DML: 通过过程化语言进行操作

    - Declarative DML(nonprocedural): 通过声明式语言进行操作(例如SQL，更加常见)

    - DML compiler: 用于解释DML语句

- **Query Processor**

    - query -> parse and translate -> relational-algebra -> optimizer -> query plan -> execute plan

- **transaction management**

    - 事务管理，保证数据库的一致性

    - 事务：一系列操作，要么全部执行，要么全部不执行

----

## 第二章 数据库概念

### 概念引入

#### Table

可以类比excel，数据库以表的形式组织数据。表中的一列是某一类数据，一行是某一个事物具有的多类数据的集合。一张表是多个集合组成的大集合。

注意根据集合不能有相同元素的要求，一张表中不能出现数据相同的两行，也不能出现意义相同的两列。数据库课程一般不考虑空集。

#### Relation

表的一行是某一个事物具有的多类属性，反过来说多类属性由某个事物关联起来。从这个意义上，一个Relation一般指代一张Table。

Relation又可以分为两个部分：

- **Relation Schema**

    Relation Schema指一张表的逻辑设计，包括Table的名字，其中有哪些Attribute，每个Attribute各自的Domain等。Relation Schema不关心表中具体的数据，只关心整体设计。

    R = (A_1, A_2, A_3, ... A_n)

    例如：Student(Student_ID, Name, Phone_Number), in which Student_ID supposed to be ......这是一个Relation Schema。

- **Relation Instance**

    Relation Instance是一张表中具体某几个事物（某几行）的集合。出于集合的定义，Relation Instance是可拆分的，一个Instance从中的某几行组成集合是另一个新的Instance。

    r(R) = {(t_1), (t_2), ... (t_n)}

    例如：{(3200102708, Liu Siri, 13588089548), (3200102706, Su Houxian, null)}这是一个Relation Instance。

    **关于元组**：

    - Tuple

        直译为元组，指某个表中的一个事物，或者说一行。

    - Attribute

        直译为属性，指某个表中的某一类数据，或者说一列。

    - Domain

        某个Attribute的取值范围。

    - *Unordered Set*

        表中的行是无序的，即表中的行的顺序不影响表的定义。

- **Atomic**

    我们要求数据库中任意关系r，其Attribute的Domain必须是Atomic的。某个Domain是Atomic的指其中存储的数据已经是最小单元，不能进一步拆分。

    例如：对于Attribue(Phone_Number)，如果允许多个电话号的集合同时存储在该列某行中，那么这个Attribute就不满足Atomic，于是这张表也不满足数据库的设计规范，因为一般认为这个集合可以进一步拆分成一个个电话号。

    但是注意，你既可以认为单个电话号为不能继续拆分的最小单位，这时它Atomic；也可以认为电话号又包括了国家编码、区号、分机号等等，不满足Atomic。

    **因此Atomic是一个相对的概念**，“能不能继续拆分”取决于设计数据库的具体要求与你看待数据的方式。


#### Key

Key是某一个relation中某几个attribute的集合。它的每一个子集也都是不同的Key。

- Superkey

    如果在某relation instance中根据一个key能够单独确定一个tuple，它是Superkey

    因此，superkey 可以很大，如 *整个元组的所有属性就是一个superkey*

- Candidate Key

    如果一个Superkey，去掉任意一个attribute后不再是Superkey，他就是Candidate Key

    就相当于是**“最小”的Superkey**    

- Primary Key（默认not null）

    使用任意Candidate Key都可以方便的查找relation中的某个tuple，但是为了同一操作、规范接口，设计者应该为每个relation在Candidates中选出一个作为Primary Key (a.k.a. Primary Key Constraint)。

    Primary Key是relation的固有属性而不仅是attribute的集合，地位发生了变化。

- Foreign Key Constraint

    A是关系$r_{1}$的一个key，（B是关系$r_{2}$的Primary Key，）如果A中每个tuple都在B中都存在，就称
    
    A is a **foreign key** from $r_{1}$ referencing $r_{2}$
    
    $r_{1}$ is the **referencing relation** of this foreign-key constraint and $r_{2}$ Is the **referenced relation**

    `foreign key A referencing r2(B1)`

#### Schema Diagram

规定某个relation的Primary Key由下划线标出；有向箭头表示Foreign Key Constraint，从referencing relation指向referenced relation。

### 关系代数

#### 基础操作

- And Or Not(∧ ∨ ¬)

- Select

    $\sigma_{selection\  predicate}(relation)$：从relation中选出满足selection predicate的tuple组成一个新的relation。即选行。

- Project

    $\Pi_{A1,A2...}(relation)$：从relation中选出名称为A1、A2……的attribute组成一个新的relation,即选列。

    **注意这是集合操作，因此会自动去重**

- Union（$\cup$）

    - 待合并的两张表应该应该相同的属性元组（即属性完全相同）

- Intersection（$\cap$）

    - 待合并的两张表应该应该相同的属性元组（即属性完全相同）

- Set Difference（-）

    - 待合并的两张表应该应该相同的属性元组（即属性完全相同）

- Cartesian-Product（$\times$）

    - 开销很大，可以想办法先用选择条件降低表大小再做积（不过应该不用强求）

    - 两个表做笛卡尔积，会获得 N * M 行

- **Join** （后面章节重点）

    - $r\bowtie_{predicate}s=\sigma_{predicate}(r\times s)$

    - Inner Join: $r \bowtie s$
    
    - Outer Join
        
        - Left Outer Join: $r\ ⟕\ s$
        
        - Right Outer Join: $r\ ⟖\ s$
        
        - Full Outer Join: $r\ ⟗\ s$


- *Rename*

    - $\rho_{x(A_{1},A_{2}...)}(E)$
        
        将名为E的表重命名为x，并将其每一列重命名为A1、A2……

    - 下标$(A_{1},A_{2}...)$不是必须的，不写这一部分表示只改表名不改列名。


- *Assignment*

    - $d\leftarrow expression$
    
        将表达式的结果存放在临时“变量”d中，以便后续复用。这个操作一般用于简化公式和增强可读性。

    - 注意数据库所有的返回值都是**表**，包括代数操作或者单指操作等。

- *Division*

    - let $r(ID,course.ID)$ and $s(course.ID)$,  then $r\div s$ gives us ID who have taken all courses in the relation $s$.

- 代数操作

    - 常见的代数操作有avg, min, max, sum, count等

----

## 第三章 SQL基础

### SQL数据类型

**char(n)**: 定长为n的字符串

**varchar(n)**: variable-lenth char 最大长度为n的可变长字符串

**int/smallint**: 整数型，允许的数据范围由库和计算机架构决定。smallint占据的空间与可表示的范围都小于int。

**numeric(p, d)**: 十进制表示，总共有p位，其中小数点后有d位。例如对numeric(3, 1)，10.5、01.0是合法的，1.05、105、1都是不合法的。

**real/double precision**: 单精度和双精度浮点，大致对应C语言的float/double。允许的数据范围由库和计算机架构决定。

**float(n)**: 至少有n个数字的浮点数。注意区别SQL的float与常见编程语言的float。

**NULL**

- 代表未知，和 0 不相同

- **特殊运算规则**

    - and 有0为假

    - or    有1为真

    - 比较 / 算术等结果为unknown

    - not unknown = unknown

    - where 中认为 unknown 为 false

    - 筛选distinct时，null = null

    - NULL值不参与对列的代数函数，全NULL的tuple不会被count( )计数。没有非NULL元素时代数操作返回NULL，count( )返回0。

**注意：以上是教科书中的内容，其中char/varchar/int基本全世界通用，但是其他的数据类型在不同DBMS中语法及用法可能各有不同。**

----

### SQL语句

所有SQL语句以及**表名、列名**等标识符都是大小写不敏感的

但是表的**内容**，例如字符串等，大小写敏感。

以下只记录易错点，不涵盖所有语法。

#### Updates to tables

- `drop table r;`

- `alter table r add column_name data_type;`

- `alter table r drop column_name;`

#### select

select可以细分为select all与select distinct，区别是是否为结果去重，select不使用后缀时默认为select all

select选择的内容可以是表达式，例如select salary/1000 from teacher; 返回的是salary/1000的结果。

from子句可以包含多个表，用逗号分隔，例如from r1, r2, r3...，这样select的结果就是这些表的笛卡尔积。

后面一般有where子句，用于筛选表中的内容。

*因此select可以没有from子句，一般用于展示数据或者赋值并展示结果，例如select 12345/5; 单纯打印这个表达式的结果数字*

select结果可以使用order by ATTRIBUTE_NAME (desc/asc)子句排序，desc/asc表示按照降/升序，不写默认为asc。

order by后面可以跟多个attribute，以逗号分隔，靠前的优先。

*select 'k' from --->N行 一列'k', 属性'k'*

#### as

as可以为同一个对象赋两个别名以实现自我对比，但是别名的作用域仅限于单条语句，实际名称并不会被更改.

#### string

SQL 用一对单引号表示字符串，若要在字符串中使用单引号，可以用两个单引号表示一个单引号。

like是模糊搜索的关键字，可以用 % 表示任意多个字符，用 _ 表示任意一个字符

需要字符串查找内容本身包含特殊字符的，可以用逃逸符号+转义字符，如获得'%' ` '\%' escape '\'`

字符串内容匹配默认区分大小写。

#### set

- set operations

    - `union / intersect / except` 又有all和distinct两个版本，区别是结果是否去重

    - **但是他们默认作为集合操作是去重的**，这与select不同。

- set membership

    - `(not) in`

- set comparison

    - `some / all`

    - ( = some) == (in) 

    - ( != some) != (not in)

    - (!= all) == (not in)

    - ( = all) != (in)

- set empty test

    - `(not) exists`

- set unique test

    - `unique` to check if duplicates exist

#### aggregate functions

`avg, count, min, max, sum`

聚集函数，顾名思义，能把同一列不同值聚集到一起处理为一个值

#### group by

配合各类代数操作

group by先于select进行，创建一个仅包含代数操作列与group by列的临时表，select操作在这个临时表中进行。这带来两个特性：

- select...group by...可以在多个列名和列数不完全相同的表中进行，只要共有用于代数操作和group by的列就可以了。例如下面的表r1、r2……只要共有A1、A2（用于group by）和A3（用于sum）即可，其余列无所谓。

    ```mysql
    select A1, sum(A3)
    from r1, r2, r3...
    where P group by A1, A2
    ```

- 同时select代数操作和其他的列时，其他列必须同时放在group by里面，因为不能选择临时表中没有的列。下面是两个错误的例子，ID不能被选择：

    **即group by之后，每个group只能输出一行数据**

    ```mysql
    select dept_name, ID, avg (salary)
    from instructor
    group by dept_name;
    
    select ID, max(salary) from instructor;
    ```

#### where / having

**where在group by之前进行，不满足条件的tuble不会参与group by进入临时表**

**having在group by之后进行，在临时表中筛选（因此同样只有group by之后的数据栏），只返回满足的tuble**

因此引申出exists只能跟where；代数操作做条件只能跟having；同样的语句在where和having之后效果不一定相同。

#### with

```mysql
with 
temp_table_name1(attribute_name1, attibute_name2...) as (),
temp_table_name2(attribute_name1, attibute_name2...) as (),
...
```

建立一个作用域为一条语句的临时的表用于简化逻辑表达式增加可读性。
相当于关系代数中的Assignment。select可以不出现。

#### delete

`delete from table_name where ()`

#### insert

`insert into table_name values(...)`

`insert into table_name(attributes...) values(...)`

*values 也可替换成嵌套子查询*

#### update

- ``update table_name set attribute = () where ()``

- 有时操作会影响后续的判断，导致非常麻烦的拓扑序处理，因此复杂时可以使用case条件判断

    ```sql
    set () = case
        when condition1 then value1
        when condition2 then value2
        ...
        else value2
    end
    ```

## 第四章 SQL进阶

### Join

Join语句的基本功能是将两张表中的tuple按一定规则进行匹配，将他们相同的列拼起来，不同的列全部保留，合成一个大tuple。

它的控制符可以分为两类：

- Join Conditions（控制哪一些列或条件用于匹配两张表中的tuple）

    - **natural**：tuple所有同名列的值相等（默认），但是有**表结构未知错误合并**的风险

        - natural 会合并同名列，且using也是相当于默认为natural

    - **using (A1, A2...)**：tuple同名列中指定的部分列的值相等

    - **on \<predicate>**：按照特定的规则匹配，不限于同名列

- Join Types（控制如何处理没有匹配对象的tuple）

    - Inner Join：没有匹配对象则不返回（默认）

    - Left Outer Join：左侧表的tuple没有匹配对象，则为扩展的列填入NULL，一起返回（左边元素一定存在）

    - Right Outer Join：右侧表的tuple没有匹配对象，则为扩展的列填入NULL，一起返回（右边元素一定存在）

    - Full Outer Join：上面二者的并集

### View

```mysql
create view view_name(attributes...) as () 
```

view一般由于权限问题，遮掩部分数据用于查找以及接口，语法和with相同，作用也基本相同。唯一的区别是view一经定义则一直可用，而with的作用域仅有单条语句。

- view并不是实际存在的表，每次调用view时只是重复调用了筛选的条件。因此update table后，与之关联的view也会改变

- 我们一般不对view进行update，大部分SQL系统对update view有严格的限制。

- 部分SQL也支持materialize view，view此时是一张真实存在的表，这一般是为了用空间换时间，物化视图相关的表发生变化时，它自己也必须同时更新，以维持一般view的特性。

- view dependecy: 可以嵌套定义，甚至自我递归定义？ 

### Index

```mysql
CREATE INDEX index_name ON table_name ( column1, column2.....);//创建
ALTER TABLE table_name DROP INDEX index_name;//删除
```

索引的原理类似于书的目录，要查找某个词不需要从头开始阅读书籍，可以从目录查到页码直接跳转，于是加快了查找的速度。其具体实现方式不需要深究。一个表可以创建多个索引，一个索引可以包含多个列（复合索引）。

但索引并不是尽善尽美，例如update之后，索引需要同步维护；同时索引是一种物理数据结构，有额外的空间与IO开销。不适当的索引设置反而会降低效率。

### Integrity Constraint

完整性约束即对attribute内容的约束，不满足约束条件的tuple不能被插入。

*对数据类型的约束既可以在定义表时规定，也可以后期通过domain关键字增删改*

一般有4类约束方法：

- **not NULL**：非空。

- **Primary Key**：构成主键的tuple不能重复。

- **Check(Predicate)**：自定义检查的条件，在数据表有改变时便会自动检查，例如 `CHECK (semester in ("spring", "autumn") )`。

- **Foreign Key** : 外键约束，（*原则上，可以不是*）自定的若干个attribute组成的tuple一定是table_name的主键之一

    `foreign key (attribute_name1, attribute_name2 ...) references table_name(attribute)`

约束被破坏时的处理方法：

- cascade: 级联，更新与删除等操作违反完整性约束，便会将影响的子数据一并处理掉（一般没有 insert cascade）

    - *还可以set null, set default等*

- assertion: 断言，always satisfy

- trigger：Events & Actions
    - 有效但少用

### 特殊数据类型

- 时间相关

    - date：日期

    - time：SQL自带时间相关的特殊数据类型

    - timestamp：date + time

    - interval：时间间隔

- 大对象

    - large number：对于尤其空间尤其巨大的值，传指针比直接传数据本身高效得多。在此理解即可。

    - large-object types

        - blob: binary 

        - clob: character

- user-defined

    - e.g. `create type dollar as numeric(10, 2);`

- domain

    - 和 type类似，不过可以加上约束条件

### 权限

- 授予/收回权限的基本语法：

    权限：`select, insert, update, delete, references, all privileges`

    ```mysql
    grant <priviledge list or role name> 
    on <relation name or view name> to <user list>;//授予

    revoke <priviledge list or role name> 
    on <relation name or view name> to <user list>;//收回
    ```

- 权限可以来自多个上级用户，相互可以重叠，例如有两者都为第三方授予了读取权限，此时即使有一方撤回了权限，第三方仍然可以正常读取。

- 权限可以级联下放，例如A为B授予了某些权限，B可以继续向其他人授予不高于他自己的权限。当A撤回对B的权限时，B下放给他人的权限也会同时被收回。

- 权限的基本单位是relation，需要授予某个数据库内所有relation的权限时可以使用 DB_name.*

- 多次授权，一次只能收一个

- public收回，所有非特殊指明的人的权限都被收回

- *视图上的权限效果类似*，但是视图的权限不能获得对基表的权限

- **role**

    - 有多个同类用户需要做统一的权限调整时，列出\<user list>的使用方式显然不便，此时就需要role。
    
    - role是权限组成的集合，可以像面向一个用户一样赋予role各种权限，然后像赋予单个权限一样将role赋予用户。修改某个role对应的权限集合时，所有被赋予这个role身份的用户权限都会同时被修改。

        ```mysql
        create role role_name;
        grant <priviledge list> on <relation name> to role_name;
        grant role_name to <user list>;
        ```

## 第五章 高级SQL

### SQL Injection

SQL用户端常常需要将用户的输入拼接为完整的sql语句。借助用户端输入框直接输入未预期的sql指令，又由于字符串拼接的缘故这条语句能够被后台执行，这称为sql注入。

比变sql注入的办法是，不要将用户的输入直接作为数据库语句，而是套用一定的模板。

### Stored Procedure

通过用户界面的前后端构建、传递、执行、回传sql代码带来大量的开销，所以现代sql都支持Stored Procedure。你可以将它理解为一种内建的小型编程语言，支持if-else、for、while等简单编程逻辑，用于构造执行一些sql语句，最终返回结果。sql还支持function，作用与之基本类似。

因为它们是内建的，且大多采用类似C语言的编译执行方式，性能往往远高于在用户端拼接字符串构建并执行sql语句。

Stored Procedure与function中还可以创建cursor，以完成一些复杂的数据库操作。

例如：

```mysql
create procedure
dept_count_proc (in dept_name varchar(20), out d_count integer)
begin
select count(*) into d_count
from instructor
where instructor.dept_name = dept_count_proc.dept_name
end

declare d_count integer;
call dept_count_proc('physics', d_count)
```

### Trigger

trigger是在满足某些条件后自动执行的sql，可以视为对数据库操作的监视或者说副作用。但是现代sql数据库流行的风格是不写trigger，下面列出了trigger的弊端和一些替代品。


## 第六章 数据库设计范式一

本章主要介绍**Entity-Relationship Model**设计方式。不同于直接建表的做法，实际开发中我们更喜欢先用entity和relationship两类概念构建逻辑关系，再建表。

- Entity的每一行应该是一个实体，例如学生信息表，教师信息表。
- Relation的每一行是多个实体间的某种关联，例如导师-学生关系表。

先根据需求画出E-R关系图，再开始建表会比直接写表连外键逻辑更清晰。下面是一个E-R图的例子：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411092249561.png" alt="image-20220411092249561" style="zoom:50%;" />

### 补充定义

#### Attribute Type

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411082934800.png" alt="image-20220411082934800" style="zoom:40%;" />

本节中Attribute的定义有所扩展。可以分为：

- 直接的和复合的
- 单值的和多值的
- 派生的

#### Degree of Relationship

某个关系与多少个Entity有关，就称它的Degree是多少。

Degree大于2的relationship是很少见的。

#### Binary Relationship Type

- One to One
- One to Many
- Many to One
- Many to Many

根据两Entity之间的联系对二元关系进行分类。不同的二元关系会对随后建表的方式有影响。

### E-R Diagram

#### Attribute

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411084206205.png" alt="image-20220411084206205" style="zoom:33%;" />

- 复合的属性用缩进表达层级关系
- 多值的属性用大括号表示
- 派生的属性在后方加上括号抽象为函数

#### Entity-Relation

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411084618951.png" alt="image-20220411084618951" style="zoom:40%;" />

- Entity的画法与原来建表相同
- Relationship用菱形表示，其中的文字是Relationship的名字。
- Relationship需要额外的属性时，用方框+**虚线**表示

#### 连线

- 单向箭头：多对一
- 双向箭头：一对一
- 单直线：多对多
- 双直线：其连接的Entity完全参与

例如下图：

- student可以没有instructor（如果每一个学生都一定有instructor就是完全参与，那么右侧应该用双直线），如果有则只能有一个（左侧是单向箭头）。
- 一个instructor可以有多个student（如果只能有一个那就是一对一关系，应该用双向箭头），也可以没有（如果必须有那就是完全参与，应该用双直线）。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411084919250.png" alt="image-20220411084919250" style="zoom:33%;" />

#### Role

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411085102057.png" alt="image-20220411085102057" style="zoom:40%;" />

Role是连线或者箭头的标签。关系对应的Entities应该是唯一的，当关系与某个实体有多重逻辑联系时就需要为表达逻辑联系的线或箭头加上标签作为区分。

#### Total Participation

如果相关实体中的每一个元素都参与了某个关系至少一次，就称这个关系是Total Parcitipation，否则称为Partial Participation。**完全参与的关系用双线标记菱形**。例如下图表示每个学期都有课，且每门课程都在某些学期中，这是一个完全参与的关系。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411085741235.png" alt="image-20220411085741235" style="zoom:40%;" />

与之对比，本节之前出现的三E-R图张中的关系都是部分参与的。课程可以没有预修要求，导师可以不带任何学生。

#### Weak Entity Set

没有主键的Entity Set称为Weak，它一般是为了增加复用性。但Weak Entity Set的存在需要外界帮助：

- 存在至少一个非Weak的**Identifying Entity Set**，通过一个**完全参与的、一对多的**关系，指认Weak Entity Set中的元素。这个关系称为**Identifying Relationship**。
- 弱实体集的属性中与Identifying Relationship相关的属性称为**Discriminator**。
- Identifyi Entity Set的主键与Weak Entity Set的Discriminator合在一起作为弱实体集的主键。例如下图中section的主键为 (course_id, sec_id, semester, year) 。

画E-R图时，因为这是完全参与关系，用双线菱形标记关系，同时弱实体集一侧必须完全参与，所以用双线连接，Discriminator用虚下划线。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411085741235.png" alt="image-20220411085741235" style="zoom:40%;" />

#### 特殊的E-R图

- 可以继承

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411124717390.png" alt="image-20220411124717390" style="zoom:33%;" />

- 可以聚合

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220411124741633.png" alt="image-20220411124741633" style="zoom:33%;" />

两者一般都是为了减少冗余，但这都只是特殊逻辑关系的简化表达，并不常见，完全可以用常规的图代替。

### Reduction to Relational Schemas

本节中我们探讨如何根据E-R图建立数据库表结构。下面为推荐的实现方式，但是途径并不唯一。

#### Entity

- 每个实体至少一张表
- 复合属性扁平化
- 多值属性单独建表，外键连回去

#### Relationship

- 带额外属性的Relationship单独建表
- Many to Many必须单独建表
- One to Many在Many侧加上One的主键，外键连回去
- One to One任选一侧作Many，同上

## 第七章 数据库设计范式二

如果说前一章节描述了如何建立一个表，那么本章将着重于如何根据函数依赖判断一张表的好坏，以及如何拆分一张表。

1NF～BCNF部分主要参考了：数据库第一二三范式到底在说什么？ - 刘慰的文章 - 知乎 https://zhuanlan.zhihu.com/p/20028672

### Function Dependency

前面说到派生属性可以理解为函数，重点在于一对一的映射关系。相同的A一定有相同的B，记为$A\rightarrow B$，B可以视为A的派生属性，或者说B是A的函数依赖。

- **完全函数依赖：**A的任何一个真子集，或者说去掉任何一个列之后，对B不构成函数依赖，则称其为完全函数依赖，**反之为部分函数依赖**。

- **传递函数依赖：**显然函数依赖具有传递性。通过传递间接得到的依赖称为传递依赖，例如closure中$A\rightarrow B$。

- **Trival平凡函数依赖：**
    $$
    In\ general,\ A\rightarrow B\ is\ trival\ if\ B\subseteq A.\\
    For\  example,\ (ID,\ name)\rightarrow name.
    $$

对函数依赖组成的集合F，若一个relation满足F+中的所有依赖关系，称为：

- R(relation schema) **holds on** F
- r(relation instance) **satisfyies** F

对R holds on F，取R1为R的一个子集，F中左右两侧的属性都在R1中的函数依赖组成的集合称为F在R1上的投影。

#### Closure of Function

给定一个由函数依赖组成的集合$F$，它与它的所有推论组成的集合称为Closure of F，记为$F^+$，例如：
$$
F(A\rightarrow B,\ B\rightarrow C)\\
F^+(A\rightarrow B,\ B\rightarrow C,\ A\rightarrow C)
$$

找函数闭包一般是**Armstrong's Axioms**三条轮着套：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220413230359330.png" alt="image-20220413230359330" style="zoom: 33%;" />

#### Closure of Attribute

给定一个由属性组成的集合$A$，它由函数集$F$中的依赖关系能够关联的属性组成的集合称为Closure of A under F，记为$A^+$，例如：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220413231124852.png" alt="image-20220413231124852" style="zoom:30%;" />

属性的闭包的作用有：

- 验证一组属性是否是superkey（它的闭包是否包含所有属性）
- 验证一组属性是否是candidate key（它的真子集的闭包是否包含所有属性）
- 验证函数依赖是否成立（依赖属性是否在被依赖属性的闭包中）
- 找函数的闭包（遍历属性的子集，挨个找闭包，闭包中多出来的属性就对原属性构成依赖）

#### Redundancy

- 在一个函数依赖集中，如果某一个依赖关系可以由其他依赖推得，那么他就是冗余的。
- 在单个依赖关系中，如果去掉一个属性（左右两侧至少要留下一个），仍然可以由其关系集中的其他依赖推得原式，那么就称这一个属性是冗余的。冗余的属性也可以用**extraneous**形容，直译为多余的。

#### Canonical Cover

正则覆盖，记为$F_c$，指给定一组函数依赖F，去除所有冗余的函数依赖与属性后剩余的部分。将正则覆盖中所有左侧属性相同的依赖合并，剩余的部分称为**最小函数依赖集**，记为$F_m$。

求最小函数依赖集的步骤：

1. **分解：**将右侧有多个属性的依赖每个属性拆开
2. **消除所有冗余的函数依赖：**逐一假设某个依赖是冗余的，利用剩余依赖关系找其左侧属性的闭包，如果闭包内包含右侧属性即说明它可以由其他函数依赖推得，的确是冗余的。
3. **消除所有冗余属性：**因为经过第一步分解，依赖右侧只有一个属性，所以冗余属性一定在左侧。只需要逐一假设左侧某个属性是多余的，找左侧剩余属性的闭包，如果闭包内包含被假设多余的属性那么它的确是多余的。
4. **如果第3步消除了至少一个冗余属性，回到2重新检查冗余依赖，如此循环直到找不出冗余属性。**

### How to Find Candidate Key

#### Primary Attribute

出现在至少一个candidate key中的属性称为主属性。反之为非主属性。

##### 第一步-先找主属性

先找出$F_c$或$F_m$，然后将所有属性分为以下四类：

- **L类：**仅存在于依赖左侧，一定是主属性
- **R类：**仅存在于依赖右侧，一定不是主属性
- **N类：**没有在任何函数依赖中出现过，一定是主属性，且存在于任何一个候选码中
- **LR类：**同时出现在了依赖两侧，**待定**

#### 第二步-找Candidate Key

这里是根据$F_c\ or\ F_m$分类，可以直接将L类和N类属性合并，检查其是不是candidate key。如果是根据原始关系集F分类，那么还需要逐一对N类属性与L类的所有子集的并集检查是不是candidate key，并不建议这么做。

- 如果仅靠L类和N类就可以确定candidate key，则不需要考虑LR类。
- 如果L类与N类的并集不是candidate key，那么这个并集与LR类的所有子集逐一取并集检查是不是candidate key。确定一个candidate key后，真包含它的所有集合都不是candidate key，可以减少一些运算量。

### Decomposition

#### Lossless Decomposition

假设表R被拆分为若干个表R1、R2……Rn，当且仅当R1 nature join R2…… nature join Rn等于R时，称这个这个拆分操作是无损的。

- 当分解为两个表时，证明无损拆分常用的一个充分非必要条件是：两张拆开的表取交集，交集同时是两张表各自的superkey，或者说可以通过F+中的函数依赖推得取交集之前的表。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220418172027159.png" alt="image-20220418172027159" style="zoom:40%;" />

- 当分解为超过两个表时，使用判定表法：https://blog.csdn.net/weixin_42492218/article/details/106218720

#### Dependancy Presevation

假设表R被拆分为若干个表R1、R2……Rn，函数依赖集F中左右两侧的属性都在R1、R2……中的子集为F1、F2……，称为F在R1、R2……上的投影。当$F^+=F_1^+\cup F_2^+\cup...$时称这个拆分满足依赖保持.

一般直接用定义证明。

第三范式是满足依赖保持的最高范式。

### 第一范式

要求每一个attribue的domain都是atomic的，不能继续分割，同时每一个relation都应该有primary key。这是所有关系型数据库最基础的范式要求。

### 第二范式

在第一范式的基础上，要求非主属性对所有candidate key不能有部分依赖。例如下面这个关系：

<img src="https://pic4.zhimg.com/51e2689ac9416a91800e63101bee9db7_b.jpg" alt="img" style="zoom:49%;" />

（学号，课名）是一个candidate key，但是姓名、系名都是对学号的函数依赖，即对候选键的部分依赖，所以上面这个数据库不满足第二范式，但是满足第一范式。

### 第三范式

在第二范式的基础上，要求非主属性对所有候选键不能有传递依赖。例如下面这个关系：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220413205821647.png" alt="image-20220413205821647" style="zoom: 20%;" />

学号->系名->系主任是一个传递依赖关系，所以上面这个数据库不满足第三范式但是满足第二范式。

#### 分解为3NF

1. 找出$F_c\ or\ F_m$
2. 找出所有candidate key
3. $F_c\ or\ F_m$中每个依赖关系一张表
4. 如果所有candidate key都没有被任何一张表完整包含，任选一个candidate key新建一张表多的不用管

上面例子满足第三范式的设计如下：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220413210604899.png" alt="image-20220413210604899" style="zoom:20%;" />

### BCNF

在第三范式的基础上，要求主属性对所有候选键不能有部分依赖，或者通俗地说，对F+中的任意一组依赖关系$X\rightarrow Y$，X一定是candidate key之一。对下面这个例子：

- 关系模式：仓库（仓库名，管理员，物品名，数量）
- 已知函数依赖：
    - 仓库名->管理员
    - 管理员->仓库名 （一个仓库只有一名管理员，一名管理员只能负责一个仓库）
    - （仓库名，物品名）->数量
    - （管理员，物品名）->数量
- candidate key有：
    - （仓库名，物品名）
    - （管理员，物品名）
- 所以主属性有：仓库名，物品名，管理员

这个关系满足3NF，但是注意到存在 **仓库名->管理员** 依赖，这是主属性对候选键的部分依赖，或者说仓库名（X）不是candidate key，所以这个例子不满足BCNF。满足BCNF的分解是：

- 管理（仓库名， 管理员）
- 储存（仓库名，物品名，数量）

#### 分解为BCNF

1. 如果一个集合满足BCNF，返回它本身
2. **对违反范式的依赖关系（注意四个范式是层层递进的，不仅要检查BCNF，还要检查123NF）**，假设为X→Y，计算X+
3. 选择R1=X+作为一个关系模式，并使另一个关系模式R2包含属性X以及R不在X+中的属性
4. 求R1和R2的FD集，分别记为S1和S2，递归地检查R1和R2是否满足BCNF
5. 这些分解得到每一个小集合一张表

## 十二章 物理储存介质

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427111506198.png" alt="image-20220427111506198" style="zoom:45%;" />

### 储存的分类

**储存可以根据易失性分为：**

- volatile 掉电失去数据，一般容量小速度快
- non-volatile 掉电不会失去数据，相对容量大速度慢

**也可以根据层级分类：**

- primary storage 最快、一般用volatile介质实现
- secondary storage 较快、非易失
    - 也叫on-line storage，常见的flash memory、magnetic disks都属于此类
- teriay storage 慢、非易失
    - 也叫off-line storage，magnetic tape、optical storage属于此类

**也可以根据原理分类：**

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427102240054.png" alt="image-20220427102240054" style="zoom:45%;" />

### 磁盘性能评价

**磁盘性能从以下维度评价：**

- Access time 访问时间
    - 对HDD又可以细分为Seek time寻道时间和Rotation latency旋转延迟
- Data-transfer rate 数据传输速率
- IOPS 每秒I/O操作数
- Mean time of failure 平均故障时间

根据所访问数据的储存位置，可以将访问分为随机访问和顺序访问。顺序访问的上限主要由传输速率决定；随机访问的上限主要由IOPS决定，IOPS又主要由访问时间决定。

**优化磁盘性能的常见方式：**

- Buffering 缓冲区，避免重复读写相同数据
- Read-ahead 预读取
- Disk-arm-scheduling 针对HDD，相比让磁头来回横跳，适当重排IO请求使磁头有序移动能减少平均寻道时间
- File Organization 针对HDD，文件整理，使数据分布尽可能有序
- Wear Leveling 针对NVM和SSD，因为擦写寿命相对有限，需要实现负载均衡

## 十三章 数据储存结构

一方面，你如何储存一个数据库，是每一张表对应一个文件，还是一个数据库对应一个大文件，还是其他的实现方式？在特定实现方式上怎么优化增删查改？

另一方面你的数据结构怎么与储存介质相配合优化，比如最重要的怎么以扇区为单位大小读写？

### 单条记录

#### 定长数据

按行存放（**Row-Oriented Storage**）的定长数据的增查改都容易实现，删除一般有两种方式：

- 删除后的空位用链表串联供下次插入用（图中所示）
- 删除后将最下面的一个数据移到删除后的空位

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427103406875.png" alt="image-20220427103406875" style="zoom:50%;" />

但是数据还可以按列存放，称为**Columnar Representation或Column-Oriented Storage**：

- 增删查改的实现与上面类似的
- 按列存放更有利于向量运算
- 如果按属性访问多于按tuple访问，这种储存方式会更快

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427135738878.png" alt="image-20220427135738878" style="zoom:55%;" />

#### 不定长数据

- 用null-bit map解决允许为NULL的数据储存。n个允许为空的属性需要n个bit的空位图，空位图中某一bit为0/1意味着对应的属性不是/是空的。

    需要注意的是memory一般不允许以bit为单位的读写，需要用n不能被8整除时需要补齐到8的整倍数以实现Byte为单位的读写。

- 用定长的数据，如长度或者偏移量，间接表达长度不定的数据，例如图中(21, 5)表达了一个变长属性的从21号bit开始且长度为5。(65000)为一个定长的属性。

最常见的结构如图所示：

- 定长的数据和不定长数据的定长表示放前面
- 空位图放中间
- 不定长数据的本体放后面

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427105742228.png" alt="image-20220427105742228" style="zoom:45%;" />

### 数据页

定长数据非常容易构建数据页。

不定长数据的数据页一般采用两头夹击的结构便于对齐。最常见的实现方式如图，Header包含本页中records相关信息：

- record数量，方便下一次插入record指针，防止将free space中的数据视为record指针
- free space末尾位置，方便下一次插入record
- 指向各record的指针（一般是偏移量形式）

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427110832599.png" alt="image-20220427110832599" style="zoom:40%;" />

### 文件组织

需要设计单条数据和数据页如何分布在文件内部。下图是几种常见的结构：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427113558547.png" alt="image-20220427113558547" style="zoom:45%;" />

#### Heap

Heap常用的优化方式是Free-space map，剩余空间图中的元素表示对应的block中还有多少剩余空间。例如下图中first level表示从第0个块开始，块内剩余空间分别为4、2、1、4、7...个单位。

当文件非常大时，还可以将Free-space map分层形成树形结构，例如下图中将first level每4个一组创建了第二层map。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427114314620.png" alt="image-20220427114314620" style="zoom:60%;" />

#### Sequential

这里的Sequential不是指储存空间上有序，而是指每一条数据逻辑关系上有序。在数据经常按某种排序先后取用时，可以考虑顺序文件系统。先后逻辑一般用类似指针的结构实现。

- 删除：改变指针指向以改变逻辑先后关系。空余位置的处理视单条数据的结构而定。

- 插入：有剩余空间可以直接插入。但是如果当前block满了，既只能插入到新block中又需要维持逻辑先后关系，就会形成下图所示的结构（为便于理解这里以定长数据为例）。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427115707249.png" alt="image-20220427115707249" style="zoom:50%;" />

因为存在上图所示问题，在多次插入和删除之后指针系统会变得很低效，因此顺序文件系统需要适时Reorganize。

#### Multitable Clustering

例如一个班级，我可以同时维护姓名排序、学号排序、成绩排序三张表供不同的场合使用。Multitable Clustering File Organization就是这么做的。同时维护多个不同结构的文件（一个大文件内部分为不同部分同理），视请求决定应该使用哪一个。

这可以提高查找的速度，但也意味着成倍的空间和增删改成本。

#### Table Partitioning

某一些表可以从物理上分为多个文件以配合实际使用情况。例如选课信息表，虽然从逻辑上所有学年的选课信息都在同一张表上，但是因为往年的数据几乎不需要增删查改，数据操作集中于当前学年，所以按照学年物理划分为多个储存文件将有助于提高性能。

#### B+ Tree File Index

B+树不仅可以作为索引的结构，还可以直接作为文件组织的结构。在下一章中会进行介绍。

### Data Dictionary Storage

上面的三类文件组织都是对库中的实例而言的，但是数据库还有一些框架性的全局的信息需要储存，我们称为Metadata。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427135033631.png" alt="image-20220427135033631" style="zoom:35%;" />

其中一种实现方式是用事先约定的固定的几个表，储存用户定义的信息。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220427135142957.png" alt="image-20220427135142957" style="zoom:40%;" />

### Buffer Management

最常用的是LUR策略，（**L.east R.ecently U.sed Stratergy**），即根据“最近访问过的内容更有可能再次被访问”的原则管理缓存内容。需要理解下图所示buffer的变化：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502162140360.png" alt="image-20220502162140360" style="zoom:50%;" />

其余缓存策略了解即可：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502162913758.png" alt="image-20220502162913758" style="zoom:40%;" />

## 十四章 索引

索引的基本结构如下，注意这里的指针是对储存文件而言的，和内存指针略有不同。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502163411215.png" alt="image-20220502163411215" style="zoom:50%;" />

### 顺序/无序索引

指key有一定顺序的索引。与之对应的，典型的非顺序作引例如哈希索引。顺序索引可以根据不同的排序规则进一步分类：

- Primary Index (clustering index): 索引的顺序与物理储存的顺序对应。（物理储存顺序往往是根据Primary key）

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502164254385.png" alt="image-20220502164254385" style="zoom:40%;" />

- Secondary Index (non-clustering index): 索引顺序与物理储存顺序不同，根据使用需求设计，例如下图中是按照工资顺序做索引。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502164458925.png" alt="image-20220502164458925" style="zoom:40%;" />
    
    但是当原表发生了变化，所有与之相关的辅助索引指针（以偏移量形式实现）都需要更新，所以Secondary Index的另一种实现方式是存放对应记录主键的值而不是二级指针，建立与主索引的映射关系。

### 稠密/稀疏索引

Dence Index指每一个tuple都有索引。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502164917087.png" alt="image-20220502164917087" style="zoom:30%;" />

与之对应的有Sparse Index稀疏索引。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502165021449.png" alt="image-20220502165021449" style="zoom:33%;" />

稀疏索引可以多级嵌套，配合顺序索引就是B+树（还要求节点半满不然应该合并）。

### B+树索引

下面是一个B+树索引的例子。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220502165234327.png" alt="image-20220502165234327" style="zoom:33%;" />

B+树不仅可以作为记录的索引，还可以作为文件的结构，叶节点不是指针而是记录本身即可。

一个页中可以存放的B+树索引个数为：
$$
单页中索引个数=\frac{页大小-指针大小}{索引数据大小+指针大小}+1
$$
原理如图：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220529134912186.png" alt="image-20220529134912186" style="zoom:70%;" />

### 相关优化

- 批量插入：

    - 插入之前先进行排序，比乱序插入更新索引的代价小，尤其对于B+树索引而言。
    - 对B+树，批量插入还可以直接建叶节点，然后自叶向根更新而不是从顶而下插入。

- 内存索引：

    - 对disk而言，与磁盘页大小相匹配的size的索引更快，因为磁盘IO的最小单位是扇区
    - 而对mem和cache而言，小节点size更快因为随机访问性能高得多并且没有扇区大小限制

- 写优化-LSM-Tree：

    - 多级树型索引分别放在不同层次的储存上

        - 保证了写入的速度（先往更快的mem写，攒够一定量后再一次性写入disk）

        - 减少了磁盘的写入量（因为磁盘IO的最小单位是扇区，单次大量写入对磁盘的消耗远小于多次少量写入）

        - 但是损失了查询的速度（要在多棵树里找）
        
            <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220503203037850.png" alt="image-20220503203037850" style="zoom:47%;" />
    
    - 如果每一层级允许同时存在多棵树，称为**Setpped-merge index**。进一步用编程难度、空间复杂度和查询速度换写速度。
    
        <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220503203714854.png" alt="image-20220503203714854" style="zoom:40%;" />

## 十五章 查询操作

对数据库的任何一个查询操作都大致可以分为一下三个步骤：

1. 解析和翻译：检查所输入语句的语法正确性，并将其翻译成机器能够读懂的形式。
2. 优化：从众多可选的执行方法中选择最优的一种方法。
3. 执行：按照前一步决定的方法执行并返回结果。

本章的目的是介绍三种最常用的查询语句内部可供选择的实现方法，以及对应的复杂度计算，最后简要介绍语句存在复杂嵌套时的流水线执行方法。

### Seek

Seek时间包含磁盘寻道（ts）和数据读取（tr）两部分开销。根据经验，对HDD，一次寻道所需的时间约等于40单位数据读取所需的时间，而对SSD这个数字大约是10。

本节中seek专注于磁盘开销，不考虑CPU等周边设备。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220507183629832.png" alt="image-20220507183629832" style="zoom:40%;" />

以下是一图流浓缩版。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/IMG_783C25A55D82-1.jpeg" alt="IMG_783C25A55D82-1" style="zoom: 50%;" />

#### 详解

##### A1 (Linear Scan)

即线性搜索，每一次seek所需的最坏时间是$b_r\times t_r+t_s$，其中br是总数据量。

意义是，如果假定所有数据顺序存放，顺序查找只需要一次寻道，但是可能需要完整读取所有数据才能找到所查找的量。

##### A2/A3 (Primary Index Scan)

本节讨论查询的条件包含主键的情况。

- 利用**稠密的**主索引进行搜索，每一次seek所需的最坏时间是$(h_i+1)\times (t_r+t_s)$，其中hi是索引的层数。以B+树索引为例：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220507184750882.png" alt="image-20220507184750882" style="zoom:45%;" />

- 利用**稀疏的**主索引进行搜索，与A2的区别是最后一层对应的数据块中可能有多个数据，下面用b表示。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220507185140262.png" alt="image-20220507185140262" style="zoom:45%;" />

##### A4 (Secondary Index scan)

利用辅助索引进行搜索。

- 当查询的值包含编制辅助索引的值时A4与A2、A3没有区别。

- 当查询的值不包含编制辅助索引的值时（习惯记为A4‘），可以适当改进索引的结构如下图所示，了解即可：

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220507185649613.png" alt="image-20220507185649613" style="zoom:45%;" />

##### A5/A6 (Scan With Comparison)

本节讨论的是含单一比较条件的查询。

- 如果存在根据查询项目编制的索引，情况可以视为A3的变种。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220507185844521.png" alt="image-20220507185844521" style="zoom:45%;" />

- 如果不存在，情况视为A4’的变种，了解即可。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220507190158968.png" alt="image-20220507190158968" style="zoom:45%;" />

##### A7/A8/A9 (Scan With Complex Comparisons)

本节讨论的是比较条件较为复杂时的做法，了解即可。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220507190336139.png" alt="image-20220507190336139" style="zoom:45%;" />

### Sort

归并排序是DBMS中最常用的排序方法，它分组进行、并行性好的特性非常适合数据量很大的场合。本节着重讨论归并排序的开销。

归并排序的空间复杂度为N+1，过程如图。这里使用的是单个缓冲块的结构，多个缓冲块的复杂度分析请自行完成（可以参考Merge Join一节）。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508115049854.png" alt="image-20220508115049854" style="zoom:40%;" />

时间复杂度的分析如下，注意块传输量复杂度和seek开销复杂度含义区别。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508120114184.png" alt="image-20220508120114184" style="zoom:50%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508120131954.png" alt="image-20220508120131954" style="zoom:50%;" />

### Join

#### Nested-Loop Join

以tuple为外关系的单位进行Join

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508121447539.png" alt="image-20220508121447539" style="zoom:33%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508121513548.png" alt="image-20220508121513548" style="zoom:33%;" />

#### Block Nested-Loop Join

仍然是循环结构，但是以block为外关系的单位。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508121640857.png" alt="image-20220508121640857" style="zoom:33%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508121715704.png" alt="image-20220508121715704" style="zoom:33%;" />

如果空间允许多个block。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508121904940.png" alt="image-20220508121904940" style="zoom:33%;" />

#### Indexed Nested-Loop Join

join需要匹配的量如果编制了索引，join的做法可以从遍历变为查找。利用索引进行join的复杂度主要取决于nr的大小。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508122039944.png" alt="image-20220508122039944" style="zoom: 50%;" />

其中c指利用索引seek的开销，视索引的种类而定。
#### Merge Join

用类似归并排序的方法进行join，注意这里讨论的是两张表中按需要匹配的列顺序存放的情况，如果不是则还要先排序。其中bb是各自使用的缓冲块的数量，实际join双方使用的缓冲块数量可以不相等。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508122509781.png" alt="image-20220508122509781" style="zoom:33%;" />

#### Hash Join

哈希join是为join中需要匹配的属性编制哈希表，然后逐哈希表分块进行。比较特别的是，哈希分块的大小和block大小不一定匹配，会有空间的浪费，因此计算分块数量时需要补一个修正因子。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508123339871.png" alt="image-20220508123339871" style="zoom:33%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508123914766.png" alt="image-20220508123914766" style="zoom:33%;" />

如果hash表对应的分块还是过大，可以进一步分块以适应内存，称为Recursive Partition。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508125522909.png" alt="image-20220508125522909" style="zoom:33%;" />

所以复杂度为。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508125738530.png" alt="image-20220508125738530" style="zoom:33%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508125807655.png" alt="image-20220508125807655" style="zoom: 33%;" />

### Pipeline

流水线是每一条查询操作内部的抽象实现方式。

从推动逻辑可以划分为两类。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508131547847.png" alt="image-20220508131547847" style="zoom:33%;" />

每一个环节又可以划分成三个阶段，下面以demand-driven pipeline为例。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220508131646363.png" alt="image-20220508131646363" style="zoom:33%;" />

## 十六章 查询优化

对数据库的任何一个查询操作都大致可以分为一下三个步骤：

1. 解析和翻译：检查所输入语句的语法正确性，并将其翻译成机器能够读懂的形式。
2. 优化：从众多可选的执行方法中选择最优的一种方法。
3. 执行：按照前一步决定的方法执行并返回结果。

本章的目的是具体实现如何选择执行语句的最优方案，大致又可以分为两步：

1. 列出与当前语句等价的内部执行方案

    这里的执行方案既包括例如交换结合等逻辑层面的内容，也包括具体使用哪一种索引方法等实现层面的内容。

2. 快速估算每一种执行方案的复杂度并选其中最优的一种

### Equivalence Rules

常用的逻辑层面的等价关系有：

- **$\sigma$条件的分解和交换**
    $$
    \sigma_{\theta_1 \wedge \theta_2}(E) = \sigma_{\theta_1}(\sigma_{\theta_2}(E)) =  \sigma_{\theta_2}(\sigma_{\theta_1}(E))
    $$

- **$\sigma$选择笛卡尔积等价于条件连接（后者一般更快）**
    $$
    \begin{aligned}
    \sigma_\theta(E_1\times E_2) & =E_1\Join_\theta E_2
    \end{aligned}
    $$

- **$\sigma$的条件可以和条件连接合并，有时也可以分配给连接的对象**
    $$
    \sigma_{\theta_1}(E_1\Join_{\theta_2} E_2) = E_1 \Join_{\theta_1 \wedge \theta_2}E_2\\
    \\
    \sigma_{\theta_1 \wedge \theta_2}(E_1 \Join_\theta E_2)=(\sigma_{\theta_1}(E_1))\Join_\theta(\sigma_{\theta_2}(E_2))\\
    when\ \theta_1,\theta_2\ involve\ attributes\ only\ in\ E_1, E_2\ perspectively.
    $$

- **不分内外关系的连接可交换**
    $$
    E_1 \Join_{(\theta)}E_2 = E_2 \Join_{(\theta)}E_1
    $$

- **自然连接可结合，条件连接有时可结合**
    $$
    (E_1 \Join E_2) \Join E_3 = E_1 \Join (E_2 \Join E_3)\\
    \\
    (E_1 \Join_{\theta_1} E_2)\Join_{\theta_2 \wedge \theta_3} E_3 = 
    	E_1 \Join_{\theta_1 \wedge \theta_3} (E_2 \Join_{\theta_2} E_3)\\
    when\ \theta_2\ involves\ attributes\ only\ in\ E_2\ and\ E_3
    $$

- **$\Pi$条件可分配**
    $$
    \Pi_{L_1 \cup L_2}(E_1 \Join_{(\theta)}E_2)=(\Pi_{L_1}(E_1))\Join_{(\theta)}(\Pi_{L_2}(E_2))\\
    when\ L_1, L_2\ involve\ attributes\ only\ in\ E_1,E_2\ perspectively.
    $$

- **$\Pi$条件可合并**
    $$
    \Pi_{\theta_1}(\Pi_{\theta_2}(\Pi_{\theta_3}...(\Pi_{\theta_n}(E)))) = \Pi_{\theta_{commom}}(E)\\
    \theta_{commom}是\theta_1到\theta_n的交集
    $$

- **还有各种集合的运算律推广**

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516023154719.png" alt="image-20220516023154719" style="zoom:50%;" />

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516023210312.png" alt="image-20220516023210312" style="zoom:50%;" />

常用的套路有

- 选择提前做，减少不需要的列
- 连续的join先做结果较少的，减少中间结果需要的空间

实际使用中往往是引用经验式的规则，想要列出所有可能的实现逻辑一般是不可能的。

### Statistical Cost Estimation

以下是常用的用于估算复杂度的表信息，对数据库中的表这些数据往往是现成并且定期更新的，难点在于中间结果的信息估算。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516203128145.png" alt="image-20220516203128145" style="zoom:50%;" />

#### Selection Size Estimation

- 单个属性选择认为数据均匀分布：
    - 等于条件查询，$\frac{返回Size}{整个表Size}=\frac{1}{查询条件总数}$
    - 范围条件查询，$\frac{返回Size}{整个表Size}=\frac{查询的范围}{总范围即max-min}$
- 多个属性选择时认为属性之间独立分布：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516204056582.png" alt="image-20220516204056582" style="zoom:50%;" />

#### Join Size Estimation

- 两张表没有用于匹配的列时，返回大小是两者大小之积

- 一般情况下估算如下

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516205020324.png" alt="image-20220516205020324" style="zoom:50%;" />

- 两张表存在外键约束时，返回值不大于被约束的表的大小

- 两张表用于匹配的列是其一的Key时，返回值不大于另一张表的大小

#### Other Estimations

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516205048326.png" alt="image-20220516205048326" style="zoom:50%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516205108732.png" alt="image-20220516205108732" style="zoom:50%;" />

#### Estimation of Distinct Value

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516205443571.png" alt="image-20220516205443571" style="zoom:50%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516205453043.png" alt="image-20220516205453043" style="zoom:50%;" />

### Cost Base Optimize

主要思想如下：

1. 局部最优解不一定是整体最优解
    - hash-join一般更快，但merge-join得到的结果是有序的
    - 嵌套的语句计算量不一定最小，但是可以配合流水线提高执行效率，最终时间复杂度反而小
2. 适当的选择计划途径，可以列出所有选项还是使用启发式搜索

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516211342064.png" alt="image-20220516211342064" style="zoom:50%;" />

#### Join-Order Selection

连续Join的顺序选择是最经典的一类优化问题。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516212000152.png" alt="image-20220516212000152" style="zoom:50%;" />

往往采用动态规划方法，**伪代码要会**：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516212314539.png" alt="image-20220516212314539" style="zoom:50%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516212325269.png" alt="image-20220516212325269" style="zoom:50%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516213325915.png" alt="image-20220516213325915" style="zoom:50%;" />

下面是一些已经证明的复杂度结论。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516213946420.png" alt="image-20220516213946420" style="zoom:50%;" />

#### Heuristic Optimize

使用一般性的经验做启发性的优化，本节了解常见的优化习惯即可。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516214112004.png" alt="image-20220516214112004" style="zoom:50%;" />

#### Nested Subqueries Optimize

首先了解**相关变量**和**相关执行**两个词的含义：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516214739959.png" alt="image-20220516214739959" style="zoom:50%;" />

对嵌套查询语句优化，需要学习**半连接**的用法：

- 检查一个结果集（外表）的记录是否在另外一个结果集（字表）中存在匹配记录，半连接仅关注”子表是否存在匹配记录”，而并不考虑”子表存在多少条匹配记录”，半连接的返回结果集仅使用外表的数据集，查询语句中IN或EXISTS语句常使用半连接来处理。
- 与之对应的还有反半连接，检查一个结果集（外表）的记录是否在另外一个结果集（字表）中存在匹配记录，当且仅当字表中没有匹配记录时在返回结果集中包含仅使用外表的数据集。

借半连接即可将嵌套子查询拆成单级的结构，回到一般的优化问题。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516215122427.png" alt="image-20220516215122427" style="zoom:50%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516215306548.png" alt="image-20220516215306548" style="zoom:50%;" />

### Materialized View Maintainance

差分维护：只需要处理更新的tuple与其他表的数据关系即可，不需要全体重新计算。下图中ir、dr指新加入、新删除的tuple，有其他关系代数的view处理逻辑也是相同的，在此仅用最简单的Join做例子。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220516221713816.png" alt="image-20220516221713816" style="zoom:50%;" />

维护含Aggregate Operation的view注意有时需要额外维护过程量，例如view中有平均值时可以额外维护sum和count便于后续有插入和删除时能够差分更新而不需要全表重新统计。

## 十七章 Transaction

Transaction直译为事物，是一次数据库操作若干执行操作组成的抽象概念。Transaction的提出是为了维护数据的完整性。

### ACID

Transation的实现要求四个特性**ACID**：

- **Automicity原子性**：要么Transaction内的所有操作都成功要么都失败回滚，不允许部分成功部分失败。
- **Consistency一致性**：Transaction的发生前后应该保证数据与操作逻辑一致。
- **Isolation隔离性**：Transaction应该对上层隐藏并发实现，无论并发的Transaction在内部以什么顺序执行，都要保证返回的结果正确且具体实现过程和并发信息与上层隔离，操作的中间结果对上层也是隐藏的。
- **Durability持久性**：数据必须被安全的保存后Transaction才能结束，例如断电等等意外不能对已结束的Transaction的结果数据造成任何影响。

为了实现ACID，我们为Transaction定义了多种状态：

- Active：正在执行
- Failed：出现错误，终止
- Aborted：发生错误之后，正在尝试善后
    - 可能是restart，例如读写的数据页和其他Transaction冲突
    - 可能是kill，例如这个Transaction本身不满足一些要求，不可能被顺利执行
    - 两种可能的操作在下图中未画出
- Partially Committed：逻辑操作已经执行完毕，但是相关数据可能还在buffer或者正在进行写回
- Committed：数据完整写回，Transaction正式结束

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519143837010.png" alt="image-20220519143837010" style="zoom:33%;" />

**ACID中最难实现的是并发控制**，这也是本章的重点内容。

### 并发控制

首先引入**Schedule**的概念：指并发Transaction的各个子操作在DBMS内部的具体执行步骤。

现在给出两个并发的操作：Let *T*1 transfer $50 from *A* to *B*, and *T*2 transfer 10% of the balance from *A* to *B*，可能的Schedule有：

- 串行调度：几个一起来我都一个一个执行，非常容易保证数据一致但是性能低下。注意在严格的并发语境下，只要没有破坏数据一致性，两个操作无论先执行哪一个都可以认为是正确的。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519145648671.png" alt="image-20220519145648671" style="zoom: 50%;" />

- 并行调度：实际内部并不是先完整执行一个再另一个，性能上限高但是数据很容易不一致。例如下图中S3是一个好的并行调度但是S4不是，它破坏了一致性。

    - 好的并行调度与串行调度的结果应该相同（S3与S1），意味着上层始终可以按照严格串行来理解和调用数据库即使其内部并不一定是串行调度。这就是**Isolation**。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519145927738.png" alt="image-20220519145927738" style="zoom:50%;" />

### Schedule Serialize

本书并不考虑多条指令并发的“真·并行调度”，只关注我们以什么策略来生成单条执行序列。

每个Transaction可以分为若干次读、运算、写，其中会发生数据不一致（**Conflict**）的只有多个Transaction并发读写同一个数据这一种情况（全部只读不会发生冲突，运算由CPU而不是DBMS负责）。所以下面我们只关注有读有写这一种情况。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519163515566.png" alt="image-20220519163515566" style="zoom:40%;" />

#### Conflict Serializability

- 如果S可以通过交换相互不冲突的语句转换为S‘，或者说S与S‘所有相互冲突的Instructions以相同的顺序排列，称S和S‘是**冲突等价（conflict equivalent）**的。

- 如果S冲突等价于一个串行调度序列，称S是**冲突可串行的（conflict serializable）**。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519160512827.png" alt="image-20220519160512827" style="zoom:40%;" />

- 如果并发调度下某一个Transaction失败需要回滚会带动其他Transaction一起回滚，称为**级联回滚（cascading rollback）**，如果一个调度序列不会引起任何级联回滚，称它是**非级联序列（cascadeless schedule）**。下图中是一个反面例子，这样的序列被认为是不好的。

    - 实现非级联序列的具体要求是，并发Transaction们对同一个数据有读有写时，任意做了写入的Transaction必须commit，下一个Transaction才能从中读。例如下图序列有写但是没有commit，所以不满足cascadelessness。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519162254646.png" alt="image-20220519162254646" style="zoom:40%;" />

- 当以一个并发调度序列中，如果一个txn从另外一个调txn的结果中读取数据，那么它应该在另外txn的commit之后commit。满足这一条件的调度称为**Recoverable可恢复的**。

### Precedence Graph

当且仅当Precidence图中无环（注意这是有向图的环）时，某个schedule是冲突可串的。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519163609017.png" alt="image-20220519163609017" style="zoom:40%;" />

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519163703055.png" alt="image-20220519163703055" style="zoom:50%;" />

下面是一个具体的例子：

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220525100614094.png" alt="image-20220525100614094" style="zoom:50%;" />

### Trade Off

第一节中就提到了，串行调度数据安全性强而性能弱，并行调度反之。实际使用中这往往不是一个选择题，而是取折中的问题。下面列出了常见的四种并行化的层次。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519164900362.png" alt="image-20220519164900362" style="zoom:50%;" />

## 十八章 并发控制

前一章从调度原理上介绍了并发控制，而本章是讲解其具体的实现步骤。

### Lock-Based Protocols

锁是Transaction对某个数据的权限申请，由并发管理器控制。

- **exclusive (X) mode**: Data item can be both read as well as written. X-lock is requested using  **lock-X** instruction.
- **shared (S) mode**: Data item can only be read. S-lock is requested using  **lock-S** instruction.

根据上述逻辑，对某一块数据，没有X锁时可以分享多把S锁给不同Transaction，但是存在一把X锁后就不能再有任何其他锁。这种做法一定程度上避免了混乱的读写。

#### 内部实现

锁策略一般的是Lock Table实现，用哈希表归类数据，每个数据下辖链表储存当前锁的情况。例如下图中17数据派锁给T23，123数据派锁给T1、T8而T2在等待。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220522100650187.png" alt="image-20220522100650187" style="zoom:40%;" />

#### 常见问题

- **Dead Lock**：锁协议最大的问题是死锁不能被完全避免。

    <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220519170328050.png" alt="image-20220519170328050" style="zoom:40%;" />

- **Startvation**：另一种常见的情况是，派出了过多的S锁，导致出现一个X锁请求时，必须等待此前S锁全部收回，造成时间浪费。

#### Two-phase Lock Protocols

为了解决各个Transaction在任意时刻随意加锁解锁带来前一节中提到的问题，出现了二阶段的锁策略：

- 二阶段锁策略2PL是对单个Transaction而言的
- 两阶段锁强调的是加锁（增长阶段，growing phase）和解锁（缩减阶段，shrinking phase）这两项操作，且每项操作各自为一个阶段。
    - 不管同一个事务内需要在多少个数据项上加锁，所有的加锁操作都只能在同一个阶段完成，在这个阶段内，不允许对已经加锁的数据项进行解锁操作。
    - 反之，任何一次解锁即视为这个Transaction进入解锁期，此后不允许该Transaction新加任何锁。

![image-20220522095432698](%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220522095432698.png)

又因为锁是对单个数据而言的，这种策略保证了schedule serializability，例如下图中：

- Transaction1对数据B有读有写，因此在第2条操作时T1会申请X锁。
- Transaction2对数据B也有读有写，但是因为X锁不能共存，所以在T1完成对B的所有操作并主动解锁B之前，T2无法申请到对B的锁，也就无法进行对B的操作。
- 所以下图中T1、T2对B的环形关系在2PL中是不存在的，即2PL保证了Conflict Serializable。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220525100637514.png" alt="image-20220525100637514" style="zoom:50%;" />

二阶段锁策略保证了冲突可串行性，但是不能保证得到的序列是非级联回滚的，因此有了两种衍生策略：

- 默认2PL：只要Transaction不需要再申请新锁，并且对某个数据的所有操作都已经完成，那么对这个数据的锁就可以被释放，即使此时Transaction内还有其他操作没有进行。
- **Strict Two-phase Locking**：一个Transaction会保留它的X锁直到commit/abort之前。

- **Rigorous Two-phase Locking**：一个Transaction会保留它的所有锁直到commit/abort之前。 

#### Tree-Based Protocol

树协议的要求是：

- Transaction只能申请X锁，并且对一个数据只能申锁一次。
- Transaction的第一把锁可以是任何数据项的；接下来，只有该事务持有了数据项的父节点的锁，才可以给数据项加锁。
- 数据项可以在任何时候解锁。

下图是一个数据树的例子。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220529144815495.png" alt="image-20220529144815495" style="zoom:33%;" />

特性：

- **保证冲突可串行化**
- **保证无死锁**（优于2PL）
- 不保证无联级回滚，但可通过增加限制**“排他锁只有到事务结束时才可以释放”**来实现
- 相比二阶段锁协议解锁时间自由

问题：

- 有时会给不需要访问的数据项加锁（要求先给父节点加锁），会增加锁开销

### Multiple Granularity

Granularity译为粒度。锁协议相关内容中，我们将加锁的对象泛指为“数据”，但是实际上“数据“指代的内容量可大可小，下图便是一个例子，从整个数据库到每一个tuple，可以用一个树型结构表示。其中的每一个节点都可以视为“数据”。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220529154413915.png" alt="image-20220529154413915" style="zoom:50%;" />

对“数据”加锁时应该遵循如下原则：

- 对某节点加或解S/X锁时，**自上而下的**
    - 对它的所有孩子节点加或解S/X锁
    - 对它的所有祖先节点加或解IS/IX锁（Intention Share/eXclusive 意向锁 用于标识）
- 加解锁遵循2PL原则。
- 不同锁之间的共存关系如下图
    - IS/IX可以共存。某数据上IS、IX两把锁都存在时，习惯上合并写为SIX
    - <img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220529155708270.png" alt="image-20220529155708270" style="zoom:50%;" />

### Handling Deadlock

死锁是锁协议必须要解决的问题。解决思路一般有：

- 一次性申请Transaction需要的所有锁，全部申请完成后再执行
    - 效率低下，一般不用
- 使用树策略进行加解锁
    - 前一节中已经提到
- **Timeout-Based Scheme**：等待加锁达到一定时长后整个事务回滚，从头来过

- **Wait-die Scheme**：两个事务相互死锁，后开始的回滚给先开始的让路
    - 缺点是回滚后重新计先后，于是后开始的回滚后仍然是后开始的，这有可能导致某个事务一直得不到执行
- **Wound-wait Scheme**：两个事务相互死锁，先开始的回滚给后开始的让路
    - 缺点是先开始一般意味着已经执行的操作更多，所以回滚的成本更高

### 检测死锁

用类似前序图的等待图关联各个事务。箭头从Ti指向Tj意味着Ti正在等待Tj解锁某个数据，自己才能加锁以继续执行操作。注意与前序图不同的是，前序图随Schedule的确定而确定，执行过程中不会变化；而等待图在运行过程中时时可能改动。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220529174421930.png" alt="image-20220529174421930" style="zoom:50%;" />

## 十九章 错误恢复

### 日志

对每一个事务的每一个write做记录：

- Transaction开始时，记录（Ti start）
- 对每一个写操作，记录（事务编号Ti，写数据的位置D，原值V0，新值V1）
- 提交时，记录（T1 commit/abort）

在更新时机上又有两种选择：

- **deferred-modification**：
    - 写操作在commit以前都是在临时变量中做，commit后一次写入buff/disk
- **immediate-modification**：
    - 允许在commit之前将值写入buff/disk
    - **注意写log一定要在写buff/disk之前进行**

本书中我们只讨论immediate的做法。

### 日志恢复

- **Undo**：指Transaction未Commit时的回滚，需要对每一个写操作利用上面的四元组做回滚，它保证了数据库的原子性。
    - **Undo按时间倒序做**
    - Commit之后相关日志即可从Undo List中移除

- **Redo**：指Commit之后的重做。例如Commit即认为数据应该被持久的保存了，但Commit后一段时间里新数据可能还在buff里没有写入Disk，这时如果发生断电就需要利用Redo Log来保障数据持久性。
    - **Redo按时间顺序做**
    - Commit后事务相关记录进入Redo List
    - Redo只有Physical的

- **WAL (Write-Ahead Logging Rule)**：为了保证可恢复，Log必须比Data先写磁盘。
    - Schedule中必须先写Log到Disk再改动数据
    - Commit后数据可以在buff中停留但是Log必须立刻进入Disk

- **Compensate Log**：Undo和Redo也是写操作，为了防止“恢复时出错，需要从恢复中恢复”的套娃情况，Undo/Redo也需要写Log，这种Log称为补偿日志。
    - 一般只需要（事务编号Ti，写数据的位置D，恢复值V）三个信息
    - 同时恢复的恢复应该具有**幂等性**，保证在套娃恢复时可以得到正确的结果
        - A从950恢复到1000。这是幂等的，无论恢复多少次结果都是1000，因此是合适的恢复策略。
        - A加50。这不是幂等的，多次恢复可能导致A的值反复相加。这是不好的恢复策略。

多个Transaction同时回滚时先将未完成的Undo再将已完成的Redo。

#### Check Point

上面说到，一种需要Redo的典型场景是Commit后一段时间里新数据可能还在buff里没有写入Disk，这时如果发生断电就需要利用Redo Log来保障数据持久性。但是这也带来一个问题，数据在buff中的时间是有限的，迟早会进入非易失的存储器中，Redo已经进入Disk的事务是浪费。

所以每隔一段时间，我们停止schedule并强制将buff中的所有内容写入disk，并在Log中留下一条记录。记录的内容是当时还没有Commit的事务编号（已经Commit的事务再此之前都保证被写入disk了）。下图中假设在执行第18行前发生了断电需要回滚：

- 由12行的checkpoint信息确定出T1、T3已经被持久保存，因此Redo只需要从12行开始
- 由14-16行的补偿日志判断T2发生了回滚，因此不需要再次Undo
- 所以Undo List中只有T4

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220601164936523.png" alt="image-20220601164936523" style="zoom:50%;" />

#### Fuzzy Check Point

常规Check Point写disk时会停止Schedule造成性能浪费，因此有了Fuzzy Checkpoint这一改进策略：

1. 停止Schedule
2. 写Checkpoint Log
3. 记录Commit但是还没有写回Disk的数据的信息到表M中
4. 继续Schedule

这样省下了写Disk的时间，Schedule暂停时长会比常规做法短。但是这样做的话最新的Checkpoint Log并不保证数据可恢复，所以需要补充操作：

5. 设计一个指针，指向保证可恢复性的最后一条Checkpoint Log（不一定是最新的一条）
6. 追踪M中数据的写入情况，实时更新指针

从指针指向的Check Point作为恢复的起点即可。

#### Log Buffer

上面提到我们总是希望日志被写到Disk中以保证数据可靠，但是这样会对Disk造成很大的压力，所以Log也需要Buffer。

一般的策略是：

- 一般的Log可以存Buffer，定期转移到Disk中
- **Check Point时将Log Buffer中所有内容写入DIsk，同时Check Point Log直接写Disk**
- 数据写回Disk释放延后，只有对应的Log写进Disk才能写数据

这样仍然保证了Log一定先于Data进入磁盘，所以不影响安全性。

### 磁盘恢复

前一节主要解决回滚的实现和易失性存储入Mem的恢复。现在非易失性储存入Disk失效时的恢复：

- 定期拷贝磁盘作为备份，称Dump
- 类似于Check Point之于内存，恢复时找到最近的Dump和恢复Log，只做Redo

### Logical Undo

例如插入索引，新建表等操作，是不能用此前提到的记录数据块新旧值的方法来做Undo的。要Undo这些操作，我们需要为每一个操作定义一个反操作，例如插入索引对删除索引，新建表对Drop表等，Undo某个操作即执行它的反操作。这就是Logical Undo。**因为反操作是一个相对独立的操作，所以有Logical Undo对提前释放锁有帮助。**

Logical Undo一定不是幂等的，所以回滚时如果看到Operation-abort，意味着已经逻辑撤回过，不能再次Undo。

Logical Undo和Physical Undo又可以相嵌套。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220601194658127.png" alt="image-20220601194658127" style="zoom:50%;" />

### ARIES

**Log Sequence Number (LSN)** 可以看作是Log的身份证号。 

#### Physiological Redo

合并多次Redo。例如两个事务将A从500改到600，又从600改到800，两者都commit后Redo Log可以合一为A从500到800，这对恢复没有影响。这种做法被称为半逻辑Redo，指不像逻辑Undo一样独立，但也不是完全物理的Redo。

#### ARIES Data Structure

- Buff和Disk中的每一个页都保存其数据对应的最新的LSN。
- Dirty Page Table中PageID是当前所有的脏页，PageLSN是更改PageID数据的最新LSN，**RecLSN是写Disk之后改Buff的最早的一条Log的LSN。**

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220601201530562.png" alt="image-20220601201530562" style="zoom:50%;" />

在Log中添加指针加速遍历。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220601202354910.png" alt="image-20220601202354910" style="zoom:50%;" />

#### ARIES具体步骤

1. 一般的Check Point

   - redo已经提交的，从上往下，从check point到commit或abort

   - undo没有提交的，从下往上，从最后一条log到start
2. ARIES：

   - Analysis Pass：
     - 第一步 读出所需的数据
       - 读出数据
       - RedoLSN=min(RecLSN)
       - UndoList=all not-commit txn in check point log
     - 第二步 从Check Point向后扫描
       - 有新的txn start 加入UndoList
       - 有写入 更新Dirty Page Table和该txn对应的LastLSN
       - 有txn end（commit或abort） 把这个txn从UndoList放到RedoList
   - Redo Pass：
     - 从RedoLSN开始顺序扫描直到RedoList内所有txn都commit
       - 如果RedoList内txn某update对应的页不在Dirty Page Table中或者其LSN小于对应页RecLSN，说明已经写入DIsk，不用操作
       - 否则重做写入
   - Undo Pass：
     - 从下往上Undo
     - 记得Undo要写log
     - 如果需要的话补充记录CRS，重点是UndoNextLSN指向该txn下一条需要Undo的Log

思路和常规的恢复相同，但是利用上面介绍的指针和数据结构进行了加速。

<img src="%E6%95%B0%E6%8D%AE%E5%BA%93%E7%AC%94%E8%AE%B0.assets/image-20220601203307534.png" alt="image-20220601203307534" style="zoom:50%;" />
