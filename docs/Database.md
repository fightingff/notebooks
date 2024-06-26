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

    `foreign key A references r2(B1)`

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

    - or 有1为真

    - 比较 / 算术等结果为unknown

    - not unknown = unknown

    - where 中认为 unknown 为 false

    - 筛选distinct时，null = null

    - NULL值不参与对列的代数函数，但是全NULL的tuple会被count(*)计数（直接数行数）。没有非NULL元素时代数操作返回NULL，count( )返回0。

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

**注意，where语句中不能使用聚合函数，只有select后或having语句中可以使用**

#### group by

配合各类代数操作

group by先于select进行，创建一个仅包含代数**操作列**与**group by列**的临时表，select操作在这个临时表中进行。这带来两个特性：

- select...group by...可以在多个列名和列数不完全相同的表中进行，只要共有用于代数操作和group by的列就可以了。例如下面的表r1、r2……只要共有A1、A2（用于group by）和A3（用于sum）即可，其余列无所谓。

    ```mysql
    select A1, sum(A3)
    from r1, r2, r3...
    where P group by A1, A2
    ```

- 同时select代数操作和其他的列时，其他列必须同时放在group by里面，因为不能选择临时表中没有的列，否则得不到理想中想要的结果（不一定报错）。下面是两个错误的例子，ID不能被选择：

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

----

## 第四章 SQL进阶

### Join

Join语句的基本功能是将两张表中的tuple按一定规则进行匹配，将他们相同的列拼起来，不同的列全部保留，合成一个大tuple。

它的控制符可以分为两类：

- Join Conditions（控制哪一些列或条件用于匹配两张表中的tuple）

    - **natural**：tuple所有同名列的值相等（默认），但是有**表结构未知错误合并**的风险

        - natural 会合并同名列，且using也是相当于默认为natural（natural left join，natural在前)

        - 如果没有同名列，会默认输出笛卡尔积

    - **using (A1, A2...)**：tuple同名列中指定的部分列的值相等

    - **on `<predicate>` **：按照特定的规则匹配，不限于同名列

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

- **Foreign Key** : 外键约束，（*原则上，可以不是*）自定的若干个attribute组成的tuple一定是table_name的主键之一，**但是似乎指向的键一定要unique或primary**

    `foreign key (attribute_name) references table_name(attribute)`

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
    on <relation name or view name> from <user list>;//收回
    ```

- 权限可以来自多个上级用户，相互可以重叠，例如有两者都为第三方授予了读取权限，此时即使有一方撤回了权限，第三方仍然可以正常读取。

- 权限可以级联下放，例如A为B授予了某些权限，B可以继续向其他人授予不高于他自己的权限。当A撤回对B的权限时，B下放给他人的权限也会同时被收回。

- 权限的基本单位是relation，需要授予某个数据库内所有relation的权限时可以使用 DB_name.*

- 多次授权，一次只能收一个

- public收回，所有非特殊指明的人的权限都被收回

- *视图上的权限效果类似*，但是视图的权限不能获得对基表的权限

- **role**

    - 有多个同类用户需要做统一的权限调整时，列出 `<user list>` 的使用方式显然不便，此时就需要role。

    - role是权限组成的集合，可以像面向一个用户一样赋予role各种权限，然后像赋予单个权限一样将role赋予用户。修改某个role对应的权限集合时，所有被赋予这个role身份的用户权限都会同时被修改。

        ```mysql
        create role role_name;
        grant <priviledge list> on <relation name> to role_name;
        grant role_name to <user list>;
        ```

----

## 第五章 高级SQL

### SQL Injection

SQL用户端常常需要将用户的输入拼接为完整的sql语句。借助用户端输入框直接输入未预期的sql指令，又由于字符串拼接的缘故这条语句能够被后台执行，这称为sql注入。

避免sql注入的办法是，不要将用户的输入直接作为数据库语句，而是套用一定的模板。

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

trigger是在满足某些条件后自动执行的sql，可以视为对数据库操作的监视或者说副作用。但是现代sql数据库流行的风格是不写trigger。

----

## 第六章 数据库设计范式一

本章主要介绍**Entity-Relationship Model**设计方式。不同于直接建表的做法，实际开发中我们更喜欢先用entity和relationship两类概念构建逻辑关系，再建表。

- Entity的每一行应该是一个实体，例如学生信息表，教师信息表。

- Relation的每一行是多个实体间的某种关联，例如导师-学生关系表。

### Design phases

- Initial phase: 

    - 了解用户需求，确定数据库的目标

- Second phase: 

    - 选择一个数据模型，设计数据库的概念结构

- Final phase: 

    - 将概念结构转化为物理数据库模式，即建表

### Design Alternatives

- Redundancy

    - 数据冗余，即同一数据在多个地方重复出现。冗余数据的存在还会导致数据不一致，增加了数据的修改难度。

- Incompleteness

    - 系统不完整，导致某些功能无法实现。

### E-R Diagram

- Entity

    - 由多个属性 Attribute 构成，属性的取值范围是 Domain

    - *用实体集的外延 extension 表示实际的实体集合*

- Attribute

    - **复合**：用缩进表达层级关系

    - **多值**：（**同一个属性可能有多个取值**）用大括号表示

    - **派生**：（**可由其他属性推导出来**）在后方加上括号抽象为函数

- **Entity-Relation**

    > 菱形表示，其中的文字是Relationship的名字，实体间的这种关联称为 **参与联系集R（participation）**

    - **度 （Degree）**

        > 参与联系集的实体集的个数

        一般二元关系（binary）为主，有时有三元关系，再多元不常见

    - **额外属性(Discriptive Attribute)**

        用**方框 + 虚线**表示

        ![1712973598719](image/Database/1712973598719.png)

    - **Role**

        > Role是连线或者箭头的标签。

        关系对应的Entities应该是唯一的，当关系与某个实体有多重逻辑联系 (Recursive) 时就需要为表达逻辑联系的线或箭头加上标签作为区分。

        ![1712973929199](image/Database/1712973929199.png)

    - **Mapping Cardinality Constraints（映射基数约束）**

        > **箭头表示“一”，直线表示“多”**
        >
        > *多关系时只允许至多一个箭头避免歧义*

        - One-to-One：双向单直线箭头

        - One-to-Many：单向单直线箭头

        - Many-to-One：单向单直线箭头

        - Many-to-Many：单直线

        - **Participation Constraints**

            - total participation

                > 每个实体至少参与一个关系

                用**双直线+双直线框菱形**表示

            - partial participation

                单直线

            - **More accurate notation**

                在单直线上使用数字标注 min...max

                ![1712975619974](image/Database/1712975619974.png)

    - **Primary Key**

        ![1712976256980](image/Database/1712976256980.png)

    - **Weak Entity Set**

        > 没有独立主键的Entity Set称为Weak，它一般是为了增加复用性

        - 要求存在至少一个非Weak的**Identifying Entity Set**，通过一个**完全参与的、一对多的**关系，指认Weak Entity Set中的元素，这个关系就称为**Identifying Relationship**。

        - 弱实体集的属性中与Identifying Relationship相关的属性称为**Discriminator (partial key, 需要找一个强实体集的键一同构成主键)**

            例如下图中section的主键为 (course_id, sec_id, semester, year) 。

        ![1712801478105](image/Database/1712801478105.png)

        （*画E-R图时，虚实体用双线矩形，Discriminator用虚下划线，因为这是完全参与关系，用双线菱形标记关系，同时弱实体集一侧必须完全参与，所以用双线连接）*

    - *重复属性可以通过relation消除冗余*

        ![1712801814521](image/Database/1712801814521.png)

#### 特殊的E-R图

- 可以继承（Top-Down 特化 / Bottom-Up概化）

    ![1712803636247](image/Database/1712803636247.png)

    - Overlapping: 可重叠，即一个实体可以同时属于多个类别

        （既是student，也是employee）

    - Disjoint：不相交，即一个实体只能属于一个类别

        （只能是instructor或者secretary一种身份）

    **减少了冗余信息，但是增加了查询的复杂度（需要多表的笛卡尔积）**

- 可以聚合（Aggregation）

    - 将一个部分组合成一个整体，减少关系

*两者一般都是为了减少冗余，但这都只是特殊逻辑关系的简化表达，并不常见，完全可以用常规的图代替*

### Reduction to Relational Schemas

> 根据E-R图建立数据库表结构，下面为推荐的实现方式，但是途径并不唯一。

- Entity

    - 每个实体至少一张表

    - 复合属性扁平化(选择级别最底层的)

    - 多值属性单独建表，外键连回去

- Relationship

    - 带额外属性的Relationship单独建表

    - Many to Many必须单独建表

    - One to Many在Many侧加上One的主键，外键连回去

    - One to One任选一侧作为上面情况中的Many，同上

----

## 第七章 数据库设计范式二

如果说前一章节描述了如何建立一个表，那么本章将着重于如何根据函数依赖判断一张表的好坏，以及如何拆分一张表

### Function Dependency

前面说到派生属性可以理解为函数，重点在于一对一的映射关系。相同的A一定有相同的B，记为$A\rightarrow B$，A可以是B的一个主码，B可以视为A的派生属性，或者说B是A的函数依赖。

$$tuple \ t_1, t_2 \in r, t_1[A] = t_2[A] \Rightarrow t_1[B] = t_2[B]$$ 

函数依赖可以根据集合关系分为下面3类：

- **完全函数依赖：** A的任何一个真子集，或者说去掉任何一个列之后，对B不构成函数依赖，则称其为完全函数依赖，**反之为部分函数依赖**。

- **传递函数依赖：** 显然函数依赖具有传递性。通过传递间接得到的依赖称为传递依赖，例如closure中$A\rightarrow B$。

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
F^+(A\rightarrow B,\ B\rightarrow C,\ A\rightarrow C, AB \rightarrow C ...)
$$

找函数闭包一般是**Armstrong's Axioms**三条轮着套：(Sound(有效) & Complete(完备))

书上算法：先用自反律和增补律添加新的依赖关系，再用传递律连接

![1713407471264](image/Database/1713407471264.png)

![1713410629655](image/Database/1713410629655.png)

#### Closure of Attribute

给定一个由属性组成的集合$A$，它由函数集$F$中的依赖关系能够关联的属性组成的集合称为Closure of A under F，记为$A^+$

算法：每次枚举所有依赖关系，若满足左侧条件则将右侧属性加入闭包，直到闭包不再增大

属性的闭包的作用有：

- 验证一组属性是否是superkey（它的闭包是否包含所有属性）

- 验证一组属性是否是candidate key（它的真子集的闭包是否包含所有属性）

- 验证函数依赖是否成立（依赖属性是否在被依赖属性的闭包中）

- 找函数的闭包（遍历属性的子集，挨个找闭包，闭包中多出来的属性就对原属性构成依赖）

#### Canonical Cover

- **Redundancy**

    - 在一个函数依赖集中，如果某一个依赖关系可以由其他依赖推得，那么他就是冗余的。

    - 在单个依赖关系中，如果去掉一个属性（左右两侧至少要留下一个），仍然可以由其关系集中的其他依赖推得原式，那么就称这一个属性是冗余的。冗余的属性也可以用**extraneous**形容，直译为多余的。

    **需要注意这里逻辑蕴含 “$\implies$” 的方向始终为弱$\implies$强，左侧减少加强，右侧减少削弱**

    **对应的检查就是删除掉假设的无关属性后，能否推出原来的函数依赖**

    ![1714010926789](image/Database/1714010926789.png)

    ![1714011493811](image/Database/1714011493811.png)

- **正则覆盖**
    
    > 记为$F_c$，指给定一组函数依赖F，去除所有冗余的函数依赖与属性后剩余的部分，相当于函数依赖F的化简集合
    >
    > - 不含冗余函数依赖
    >
    > - 与原函数依赖集F等价，即$F^+ \Leftrightarrow F_c^+$
    >
    > - 函数依赖的左侧属性不重复

    求最小函数依赖集的步骤（**正则覆盖可能不唯一**）：

    ![1714202283682](image/Database/1714202283682.png)

#### Lossless(-join) Decomposition

假设表R被拆分为若干个表R1、R2……Rn，当且仅当R1 nature join R2…… nature join Rn等于R时，称这个这个拆分操作是无损的。

- 当分解为两个表时，证明无损拆分常用的一个**充分非必要条件**是：

    **两张拆开的表取交集，交集是至少一张表的superkey，或者说可以通过F+中的函数依赖推得取交集之前的表**

    $$R1\cap R2 \rightarrow R1\ or\ R2$$

- 当分解为超过两个表时，使用判定表法：https://blog.csdn.net/weixin_42492218/article/details/106218720

#### Dependancy Presevation

在数据库更新时，我们希望依赖关系不会被破坏，即依赖保持

假设表R被拆分为若干个表R1、R2……Rn，函数依赖集F中左右两侧的属性都在R1、R2……中的子集为F1、F2……，称为F在R1、R2……上的投影(书中称为restriction)。

当$F^+=F_1^+\cup F_2^+\cup...$时称这个拆分满足依赖保持(**注意这仅仅是个充分条件**)

同样的，由于函数闭包的计算代价过高，可以使用如下**属性闭包**来代替。相当于每次计算某条依赖限定在 $F_i$ 上的属性闭包，再合并起来，检查是否将这条依赖保持 

![1714203819519](image/Database/1714203819519.png)

*第三范式是满足依赖保持的最高范式, BC范式不能保证依赖保持*

### 第三范式

#### 三大范式

- 第一范式

要求每一个attribue的domain都是atomic的，不能继续分割（如CS-101即可继续分割成课程种类和标号，给更新带来麻烦），同时每一个relation都应该有primary key。

这是所有关系型数据库最基础的范式要求。

- *第二范式（不重要）*

在第一范式的基础上，要求非主属性对所有candidate key不能有部分依赖，就像candidate key被浪费了一样。例如下面这个关系：

（学号，课名）是一个candidate key，但是姓名、系名都是对学号的函数依赖，即对候选键的部分依赖，所以上面这个数据库不满足第二范式，但是满足第一范式。

- 第三范式

在第二范式的基础上，要求非主属性对所有候选键不能有传递依赖。例如下面这个关系：

![1713407061546](image/Database/1713407061546.png)

学号->系名->系主任是一个传递依赖关系，所以上面这个数据库不满足第三范式但是满足第二范式。

#### 定义：

![1714204693174](image/Database/1714204693174.png)

#### 3NF 检查

只需要根据定义，利用属性闭包检查 **F** 中的函数依赖关系

#### 分解为3NF

> Lossless decomposition & Dependence preservation

3NF synthesis algorithm

![1714219561539](image/Database/1714219561539.png)

### BCNF(Boyce-Codd Normal Form)

![1713407681831](image/Database/1713407681831.png)

在第三范式的基础上，要求主属性对所有候选键不能有部分依赖，或者通俗地说，对F+中的任意一组依赖关系$X\rightarrow Y$，X一定是candidate key之一。

对下面这个例子：

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

#### 检查BCNF

- 对于一个函数依赖集F的检查：

    检查 **F**（**不需要F+**）内所有非平凡的函数依赖，计算左侧属性的闭包，如果闭包包含所有属性，就说明这个依赖满足BCNF

- 对于分解后的关系的检查：

    此时上一种情况的条件不满足，必须检查 **F+** 中所有的非平凡的函数依赖

- 另一种通用方法：

    对于某个分解后的关系 $R_i$ 的每个子集 $\alpha$，确保 $\alpha ^+$ 要么包含 $R_i$ 的所有属性，要么不包含 $R_i - \alpha$ 的任何属性

    否则，函数依赖 $\alpha \rightarrow (\alpha^+ - \alpha) \cap R_i$ 违反了BCNF

#### 分解为BCNF

> Lossless decomposition but may not dependence preservation

本质上，就是将一个不满足BCNF的关系从表中拆出去，单独建表

**其中 $\alpha \cap \beta = \emptyset$ 的条件很重要，否则 $R_i - \beta$ 会将 $\alpha \cap \beta$ 部分的属性拆出去，破坏了 $\alpha \rightarrow \beta$ 的函数依赖**

![1714218355781](image/Database/1714218355781.png)

### 多值依赖 & 4NF

#### 多值依赖

> $\alpha \rightarrow \rightarrow \beta$ 表明 $\alpha$ 的每个值都对应于 $\beta$ 的一个或多个值，另一种说法是 $\alpha$ 与 $\beta$ 之间的联系是一对多且独立于其他属性的。
>
> （因此函数依赖本质上是一种特殊的多值依赖，多值依赖的处理方法和函数依赖也基本一致）
>
> *若关系r不满足给定的多值依赖，可以通过向r中增加元组来得到一个满足多值依赖的关系*

函数依赖&多值依赖的闭包 D+：

- $\alpha \rightarrow \beta \implies \alpha \rightarrow \rightarrow \beta$

- $\alpha \rightarrow \rightarrow \beta \implies \alpha \rightarrow \rightarrow R - \alpha - \beta$

#### 4NF

- 定义
    4NF 一定是 BCNF，但是反之不一定成立

    ![1714222354620](image/Database/1714222354620.png)

- 检查

    ![1714222416851](image/Database/1714222416851.png)

- 分解

    ![1714222443565](image/Database/1714222443565.png)

### More

#### More NFs

- 5NF(Project-Join Normal Form)

- DKNF(Domain-Key Normal Form) 

#### Temporal data

- Temporal functional dependency: 在任意时间快照上满足的函数依赖

- 实际操作：给数据加上start time和end time，然后用时间戳来查询

#### *How to Find Candidate Key*

- Primary Attribute

    出现在至少一个candidate key中的属性称为主属性。反之为非主属性。

- 第一步-先找主属性

    先找出$F_c$或$F_m$，然后将所有属性分为以下四类：

    - **L类：**仅存在于依赖左侧，一定是主属性

    - **R类：**仅存在于依赖右侧，一定不是主属性

    - **N类：**没有在任何函数依赖中出现过，一定是主属性，且存在于任何一个候选码中

    - **LR类：**同时出现在了依赖两侧，**待定**

- 第二步-找Candidate Key

    这里是根据$F_c\ or\ F_m$分类，可以直接将L类和N类属性合并，检查其是不是candidate key。如果是根据原始关系集F分类，那么还需要逐一对N类属性与L类的所有子集的并集检查是不是candidate key，并不建议这么做。

    - 如果仅靠L类和N类就可以确定candidate key，则不需要考虑LR类。

    - 如果L类与N类的并集不是candidate key，那么这个并集与LR类的所有子集逐一取并集检查是不是candidate key。确定一个candidate key后，真包含它的所有集合都不是candidate key，可以减少一些运算量。

#### Design Guidelines

- Nice E-R design -> Good relational schema -> Less normalization

- Duplicated name & relation if properties have some relation

- Allowing some redundancy for performance(denormalization & materialized view)

----

## 十二章 物理储存介质

![1714016769851](image/Database/1714016769851.png)

### 储存的评价

![1714017092504](image/Database/1714017092504.png)

### 储存的分类

- **储存可以根据易失性分为：**

    - volatile 掉电失去数据，一般容量小速度快

    - non-volatile 掉电不会失去数据，相对容量大速度慢

- **也可以根据层级分类：**

    - primary storage 最快、一般用volatile介质实现

    - secondary storage 较快、非易失

        - 也叫on-line storage，常见的flash memory、magnetic disks都属于此类

    - teriay storage 慢、非易失

        - 也叫off-line storage，magnetic tape、optical storage属于此类

- **也可以根据原理分类：**

    ![1714016897776](image/Database/1714016897776.png)

- **Measures**

    - Disk block: logical unit for storage allocation and retrieval

        - Too small : **more transfer**

        - Too large : **space wasted**

    - Sequential access pattern: seek required only for first block

    - Random access pattern: each access require a seek

    - I/O opeartions per second(IOPS)

### 磁盘性能评价

**磁盘性能从以下维度评价：**

- **Access time** 访问时间

    - 对HDD又可以细分为Seek time寻道时间(4 ~ 10 milliseconds)和Rotation latency旋转延迟(5 ~ 20 milliseconds)

- **Data-transfer rate** 数据传输速率(25 ~ 200 MBps)

- **IOPS** 每秒I/O操作数

- **Mean time of failure** 平均故障时间(MTTF, 3 ~ 5 years)

根据所访问数据的储存位置，可以将访问分为随机访问和顺序访问。顺序访问的上限主要由传输速率决定；随机访问的上限主要由IOPS决定，IOPS又主要由访问时间决定。

**优化磁盘性能的常见方式：**

- Buffering 缓冲区，避免重复读写相同数据

- Read-ahead 预读取

- Disk-arm-scheduling 针对HDD，相比让磁头来回横跳，适当重排IO请求,像电梯一样，使磁头有序移动能减少平均寻道时间

- File Organization 针对HDD，文件整理，使数据分布尽可能有序

- Wear Leveling 针对NVM和SSD，因为擦写寿命相对有限，需要实现负载均衡

- Non-volatile write buffers 延迟后大批量一同写入

- Effective query processing algorithm (high-level optimization)

----

## 十三章 数据储存结构

一方面，你如何储存一个数据库，是每一张表对应一个文件，还是一个数据库对应一个大文件，还是其他的实现方式？在特定实现方式上怎么优化增删查改？

另一方面你的数据结构怎么与储存介质相配合优化，比如最重要的怎么以扇区为单位大小读写？

### 单条记录

#### 定长数据

按行存放（**Row-Oriented Storage**）的定长数据的增查改都容易实现（一般不允许跨block存储），删除一般有三种方式：

- 删除后将后面的数据前移（可以保持某些键的顺序）

- 删除后的空位用链表（free list）串联供下次插入用

- 删除后将最下面的一个数据移到删除后的空位

但是数据还可以按列存放，称为**Columnar Representation或Column-Oriented Storage**：

- 增删查改的实现与上面类似

- 按列存放更有利于向量运算以及数据分析、运算、压缩等操作

- 如果按属性访问多于按tuple访问，这种储存方式会更快

!!! note "materials"

    - 可以支持向量操作（与编译结合）

    ![1718636161938](image/Database/1718636161938.png)

#### 不定长数据

- 用null-bit map解决允许为NULL的数据储存。n个允许为空的属性需要n个bit的空位图，空位图中某一bit为0/1意味着对应的属性不是/是空的。

    需要注意的是memory一般不允许以bit为单位的读写，需要用n不能被8整除时需要补齐到8的整倍数以实现Byte为单位的读写。

- 用定长的数据，如长度或者偏移量，间接表达长度不定的数据，而将具体的数据存在定长的属性值的后面。

最常见的结构如图所示：

- 定长的数据和不定长数据的定长表示放前面

- 空位图放中间

- 不定长数据的本体放后面
  
例如图中(21, 5)表达了一个变长属性的从21号bit开始且长度为5。（65000为一个定长的属性，放在前面）

![1715221718522](image/Database/1715221718522.png)

### 数据页

定长数据非常容易构建数据页。

不定长数据的数据页一般采用两头夹击的结构便于对齐。最常见的实现方式如图，**Slotted page（分槽页）** Header包含本页中records相关信息：

- record数量，方便下一次插入record指针，防止将free space中的数据视为record指针

- free space末尾位置，方便下一次插入record

- 指向各record的指针（一般是偏移量形式）

![1715221964148](image/Database/1715221964148.png)

### 文件组织

需要设计单条数据和数据页如何分布在文件内部。下图是几种常见的结构：

![1715222315167](image/Database/1715222315167.png)

#### Heap

Heap常用的优化方式是Free-space map，剩余空间图中的元素表示对应的block中剩余空间的比例，即$\frac{x}{2^{bit}}$的部分为空闲的

当数据页比较多时，可以将连续K个map的最大值作为键值，建立起二级索引，以加快查找速度

![1716362796517](image/Database/1716362796517.png)

#### Sequential

这里的Sequential不是指储存空间上有序，而是指每一条数据逻辑关系（**即搜索码**）上有序。在数据经常按某种排序先后取用时，可以考虑顺序文件系统。

先后逻辑一般用类似指针的结构实现，但是会导致数据逻辑存储顺序和物理存储顺序不一致，效率低下，因此需要适时Reorganize。

- 插入：先定位到对应插入位置，若当前block内有剩余空间可以直接插入，否则将数据存入“溢出块”中，利用指针结构连接起来。

- 删除：改变指针指向以改变逻辑先后关系。空余位置的处理视单条数据的结构而定，猜测可以用链表结构连接起来。

#### Multitable Clustering

同一个文件页中存储不同的数据表，可以利用链表结构连接起来，以加快单表查询速度。

- 优点：

    加快了多表查询，特别是join操作

- 缺点：

    不同的数据格式，降低了存储效率，并且访问单表时需要读取更多的block

    一旦有一张表需要更新，整个文件页都需要更新，导致了大量的I/O操作

#### Table Partitioning

某一些表可以从物理上分为多个文件以配合实际使用情况，降低表的大小，提高数据库效率。

!!! example
    
    例如选课信息表，虽然从逻辑上所有学年的选课信息都在同一张表上，但是因为往年的数据几乎不需要增删查改，数据操作集中于当前学年，所以可以进行拆分，将历史信息存储到磁盘中，只保留当前学年的数据在内存中，从而加速查询。

#### B+ Tree File Index

B+树不仅可以作为索引的结构，还可以直接作为文件组织的结构。在下一章中会进行详细介绍。

### Data Dictionary（System Catalog） Storage

上面的三类文件组织都是对库中的实例而言的，但是数据库还有一些框架性的全局的信息需要储存，我们称为元数据Metadata。

![1716363840760](image/Database/1716363840760.png)

为了简化系统的设计，可以直接使用前面的文件组织结构，使用数据表的方式储存元数据。

### Buffer Management

数据库系统的一个重要目标就是 **减少内存和磁盘之间的I/O操作**，这就需要一个缓冲区管理器。

#### Pin

钉住正在读写的数据块直到操作完成，防止被替换出去影响数据的一致性。

实现时可以用一个pin count来记录当前被钉住的次数也即承载的操作数，当pin count为0时，可以被替换出去。

#### Lock

- **Exclusive Lock**

    一般用于写操作，防止其他事务读写该数据块，因此同一时间只能有一个事务对该数据块加上Exclusive Lock。

- **Shared Lock**

    一般用于读操作，防止其他事务写该数据块而影响数据读取，因此同一时间可以有多个事务对该数据块加上Shared Lock

#### Buffer Replacement

每次向缓存请求数据时，若该数据已在缓存中，直接返回；若不在缓存中，需要替换一个数据块来存放新数据，即将一个数据块写回磁盘，再将新数据块读入缓存。

操作系统最常用的是LUR策略，（**L.east R.ecently U.sed Stratergy**），即根据“最近访问过的内容更有可能再次被访问”的原则管理缓存内容，将最久未使用的数据块替换出去。

但数据库系统一般基于历史信息和数据情况进行预测，使用更复杂更高效的混合策略

- 其他策略、

![1716365031561](image/Database/1716365031561.png)

#### Force Output

一般用于处理系统崩溃时的数据一致性问题

![1716365193120](image/Database/1716365193120.png)

----

## 十四章 索引

索引是数据库中的一个重要概念，它可以加速数据库的操作，提高数据库的性能。

但是索引会增加数据库的存储空间，并且需要实时维护。

### 顺序/无序索引

指key有一定顺序的索引。与之对应的，典型的非顺序作引例如哈希索引。顺序索引可以根据不同的排序规则进一步分类：

- Primary Index (clustering index):

    索引的顺序与物理储存的顺序对应。（物理储存顺序往往是根据Primary key，当然这里的search key不一定要求是primary key）

- Secondary Index (non-clustering index):

    索引顺序与物理储存顺序不同，根据使用需求设计。

    由定义可以知道，辅助索引一定是下面提到的稠密索引，因为他无法通过物理存储顺序进行检索数据。

!!! note

    可以看出，当需要线性扫描时，Primary Index的效率更高，因为它的顺序与物理存储顺序一致；而辅助索引可能需要在多个数据块间跳跃

### 稠密/稀疏索引

- Dence Index 稠密索引

    > 指每一个search key的值都在索引列表中出现

    - 插入

        - 若插入的key值在索引中不存在，直接插入到合适的位置

        - 若插入的key值在索引中存在，根据索引情况判断：

            - 若索引存储所有记录的指针，直接插入到合适的位置

            - 若索引仅存储相同搜索码值的第一个记录的指针，则把插入的记录插入到该组记录的后面

    - 删除

        - 若删除的索引唯一，直接删除

        - 同样考虑索引存储情况

            - 若索引存储所有记录的指针，直接删除；

            - 若索引仅存储相同搜索码值的第一个记录的指针，直接删除记录，若恰好为第一个记录，则删除后将指针指向下一个记录
    
- Sparse Index 稀疏索引

    > 指只有部分search key的值在索引列表中出现

    - 插入

        - 直接将记录插入到合适的位置，若恰好为当前块的第一条，则更新索引

    - 删除

        - 直接删除记录

        - 若该记录有索引指向：

            - 若该记录的搜索码值唯一，则用下一个搜索码值的指针替代（若下一个搜索码值已经存在索引中，则直接删除当前索引） 

            - 若该记录的搜索码值不唯一，则将索引指向下一个记录

稀疏索引可以多级嵌套，配合顺序索引就是B+树（当然还要附加其他一些约束）

### *多值索引（Composite Search Key）*

一般按照类似字典序的方式进行排序

### B+树索引

和ADS课上的版本略有不同，要非常小心

![1716368536510](image/Database/1716368536510.png)

!!! note

    **注意这里的 n 一致指上面图中的 n**

    根节点：$[2, n]$ 个孩子指针

    内部节点：$[\lceil \frac{n}{2} \rceil, n]$ 个孩子指针

    叶子节点：$[\lceil \frac{n-1}{2} \rceil, n-1]$ 个记录对（搜索码+记录指针），最后一个（即上图的Pn）指向下一个叶子节点，从而将底层记录串联成线性表

    一个页中可以存放的B+树索引个数为：
    $$
    单页中索引个数n=\frac{页大小-指针大小}{索引数据大小+指针大小}+1
    $$

    树的高度

    $$h \leq \lceil \log_{\lceil \frac{n}{2} \rceil} K \rceil$$

??? 计算

    ![1716369970314](image/Database/1716369970314.png)

- Operations

    与ADS课上所学基本一致，略

    一般前面节点分到 $\lceil \frac{n}{2} \rceil$ 个key

- Extensions

    - 对于**Non-Unique**的搜索码，可以附加记录的主键将其组成一个复合搜索码，从而实现Unique索引。

    - **B+树文件结构**，叶节点不是指针而是记录本身即可

        ??? note "B+树文件索引"

            ![1718673782319](image/Database/1718673782319.png)

            ![1718675613503](image/Database/1718675613503.png)

    - **辅助索引的记录重定位**代价较高，因此可以让辅助索引的叶结点直接存储搜索码而不是记录指针，这样可以减少重定位代价（即更新索引的代价），但是在查询时需要额外代价作相应搜索码查找

    - **字符串索引**，进行前缀压缩，从而减少索引的大小

    - **多码访问**

        - 多个单码索引

        - 使用多值索引

        - 覆盖索引，即在索引中直接存储一些数据，这样直接查询索引即可，不需要再去查询数据表

### 相关优化

- 批量插入BULK LOADING：

    - 一个一个插入显然代价过高

    - 插入之前先进行排序，比乱序插入更新索引的代价小，因为相当于从左往右缓缓展开B+树，每个节点只需要写一次；否则，当树比较大内存存不下时，同一个节点就可能多次写，这显然对于效率的影响是致命的。不过，这样的话会每个节点会不满一点。

        ![1718675267089](image/Database/1718675267089.png)

    - 对B+树，批量插入还可以排序后直接建叶节点，然后自叶向根取每一块的最小值Bottom-up建树，减少了插入时的IO操作，并且这样的树的节点基本都是满的。

- 内存索引：

    - 对disk而言，与磁盘页大小相匹配的size的索引更快，因为磁盘IO的最小单位是扇区

    - 而对mem和cache而言，小节点size更快因为随机访问性能高得多并且没有扇区大小限制

- **写优化** - LSM-Tree(Log Structured Merge Tree)：

    - 多级树型索引分别放在不同层次的储存上

        ![1716510339016](image/Database/1716510339016.png)

        - 保证了写入的速度，并充分利用了空间（先往更快的mem写，写满后再一次性向下合并完成写入）

        - 减少了磁盘的写入量（因为磁盘IO的最小单位是扇区，单次大量写入对磁盘的消耗远小于多次少量写入）

        - 但是损失了查询的速度（要在多棵树里找），并且同一数据可能在多棵树中被拷贝

    - 如果每一层级允许同时存在多棵树，称为**Setpped-merge index**。进一步用编程难度、空间复杂度和查询速度换写速度。

    - 其他操作：

        - 删除： 采用打标记的懒惰删除，只有在合并时才真正删除

        - 更新： 采用插入新值+删除旧值的方式

- **写优化** - Buffer Tree

    - 与LSM-Tree有些类似，在每个节点上都有一个buffer，用于缓存写入的数据，当buffer满了之后继续向下写入

        ![1716510766922](image/Database/1716510766922.png)

    - 同样可以实现大规模写入优化，并且查询速度也不会受到太大影响

    - 但是相比LSM-Tree，Buffer Tree的Random I/O还是会相对多一些，因为没有严格保持有序 

### Hash索引

- 静态散列

    - 使用溢出桶来解决桶溢出（桶不足、偏斜）

    - 解决冲突可以用链表、开放寻址法等

    - 可以周期性rehash, 相当于重建整个哈希表，但是代价较高 

- 动态散列

    - Periodic ReHashing，周期性将桶的个数翻倍

    - Linear Hashing， 增大rehash的条件

    - Extendable Hashing，生成的哈希值为多位，但使用的偏移地址的位数是逐渐增加的（即相当于依据当前的数据量翻倍容量）

### Bitmap索引

- 本质上就是用一个简单数组bitmap来映射索引关系，适用于数据量大，取值范围小的情况，此时可以降低索引的空间代价

    比如下图，相同为1,不同为0，长度 = 记录总数

    ![1718676704875](image/Database/1718676704875.png)

- 核心优势在于**位操作**，可以快速进行**位运算**，如AND、OR、NOT等，因此适用于**多值查询**，如多值查询、范围查询等

----

## 十五章 查询操作

对数据库的任何一个查询操作都大致可以分为一下三个步骤：

1. 解析和翻译：检查所输入语句的语法正确性，并将其翻译成机器能够读懂的形式。

2. 优化：从众多可选的执行方法中选择最优的一种方法。

3. 执行：按照前一步决定的方法执行并返回结果。

考虑的参数：

![1716603229316](image/Database/1716603229316.png)

（一般来说seek时间大于transfer时间）

### Selection

#### Equations

- A1 (Linear Scan)

    线性扫描，通过一次寻道找到起始位置，然后扫描所有数据块（同样很容易应用到任何条件的查询）

    所需的时间是$b_r\times t_T+ 1 \times t_s$（$b_r$为数据表所含的数据块个数）

    *当属于键值记录查找（找到就停）时，平均时间为$\frac{b_r}{2} \times t_T+ 1 \times t_s$*

- A2/A3 (Primary Index Scan)

    利用索引优化查询速度，同样考虑单点key查询与多数据查询

    - 单点查询（key），先通过索引树结构定位到数据库，再通过一次定位+读取获得对应数据内容

        时间代价为$(h_i+1)\times (t_T+t_s)$，其中$h_i$是索引的层数

    - 多点查询（non-key），最后可能要到多个数据库读取数据，因此要额外的一次定位+多次读取数据块

        时间代价为$h_i \times (t_T + t_s) + t_s + b \times t_T$，$b$为涉及的数据块

- A4 (Secondary Index scan)

    利用辅助索引进行搜索。

    - 单点查询（key）与聚集索引相同，为$(h_i+1)\times (t_T+t_s)$

    - 多点查询（non-key），无法通过一次定位后顺序扫描，因此需要在索引树上多次定位+读取数据块

        时间代价为$(h_i + b)\times (t_T + t_s)$，$b$为涉及的数据块 

#### Comparison

*直接使用线性扫描肯定没有问题，下面是使用索引辅助的方法*

- A5（Clustered Index Scan）

    ![1718678500725](image/Database/1718678500725.png)

- A6（Non-Clustered Index Scan）

    （非聚集索引，每次都必须重新seek+transfer）

    ![1718678565587](image/Database/1718678565587.png)

#### Conjunction

- A7

    获取满足部分条件（估计代价最小）的数据存入缓冲区，检查其他条件是否满足

- A8

    通过复合索引进行直接查询

- A9

    每次将结果集合做交集

![1716609288358](image/Database/1716609288358.png)

#### Disjunction

- A10

    对结果集合求并集

    容斥原理求补集

![1716609564731](image/Database/1716609564731.png)

#### Bitmap Index Scan

平衡**辅助索引**查询（散点查询快）与直接扫描（多数据时快）的效率，相当于把物理存储的有序性重新组织出来，从而降低IO操作的代价

![1716609869971](image/Database/1716609869971.png)

### External Sort

> 数据的转移需要在buffer中进行，但可能数据过大，无法完整写入buffer,因此需要分段进行多路归并排序

具体步骤：

1. 将数据按照 缓冲区block数目M 分成N段run，每段内可以调用内部排序算法进行排序

2. 将至多M-1段存入缓冲区（此时可以将理解为存了M-1段的指针），剩下一段作为输出指针，执行多路排序算法

    对当前所有的run进行一轮merge, 此时每M-1段合并成了一段

3. 重复过程2直至所有段合并成一段

复杂度分析：

> 考虑到合并时每一段使用一个block所耗费的seek的数量太多，效率下降，可以考虑$b_b$个block作为初始的段长

- 每次合并的段数：$\lfloor \frac{M}{b_b} \rfloor - 1$

- 合并的总轮数（pass）：$\lceil \log_{\lfloor \frac{M}{b_b} \rfloor - 1} (\lceil \frac{b_r}{M} \rceil) \rceil（这里实际上是N = \frac{b_r}{M}）$

- **Transfer**

    - 每轮的transfer（线性，读+写）：$2b_r$

    - 总transfer（忽略最后一次的写，因为可能作为某个输出而不写）：$b_r \times (2\lceil \log_{\lfloor \frac{M}{b_b} \rfloor - 1} (\lceil \frac{b_r}{M} \rceil) \rceil + 1)$

- **Seek**

    - 生成初始的run（线性读+写）：$2 \lceil \frac{b_r}{M} \rceil$

    - 每轮的seek：$2 \lceil \frac{b_r}{b_b} \rceil$

    - 总seek（同样忽略最后一次写）：$2 \lceil \frac{b_r}{M} \rceil + \lceil \frac{b_r}{b_b} \rceil \times 2(\lceil \log_{\lfloor \frac{M}{b_b} \rfloor - 1} (\lceil \frac{b_r}{M} \rceil) \rceil - 1)$  

### Join

#### Nested-Loop Join

![1716619726979](image/Database/1716619726979.png)

Worst Case： buffer只有2个block, 一个用于读取R，一个用于读取S

- transfer: $b_r + n_r \times b_s$

- seek: $b_r + n_r$

!!! note

    这里需要考虑所谓的连续性 本质上是磁盘的物理结构决定的，seek即磁盘的磁头寻道

    比如这里内层循环后磁头的位置已经改变了，因此回到外循环时要重新寻道回去

Best Case： buffer可以全部存下

- transfer：$b_r + b_s$

- seek: $1 + 1 = 2$

#### Block Nested-Loop Join

仍然是循环结构，但是以block为外关系的单位。

![1716622172663](image/Database/1716622172663.png)

Worst Case：buffer小
  
- transfer：$b_r + b_r \times b_s$

- seek: $2 b_r$

Best Case: buffer足够

- transfer: $b_r + b_r$

- seek: $1 + 1$

!!! note

    折中的优化方法：**注意到外循环的$b_r$作为乘积项影响很大，考虑将buffer中M-2个block作为外循环的单位，降低外循环的复杂度**

    这样相当于将外部循环的次数变为了$\lceil \frac{b_r}{M-2} \rceil$

    - transfer: $b_r + \lceil \frac{b_r}{M-2} \rceil \times b_s$
    
    - seek: $2 \lceil \frac{b_r}{M-2} \rceil$  

#### Indexed Nested-Loop Join

考虑使用索引来加速内层循环的查询

Worst Case：buffer小

由于索引查询有前面提到的各种策略，这里用一个常数$c$来代表一次查询操作的代价

则总代价为：$b_r \times (t_T + t_s)+ n_r \times c$

可以看出，这里的代价受外循环的影响较大，**因此应该尽量选择数目较小的表作为外循环**

#### Sort-Merge Join

> **只适用于取等号（自然连接）这种的**

用类似归并算法的双指针方法，对两个有序表进行join

若**不考虑排序**，可以做到线性时间复杂度，显然效率非常高

- transfer: $b_r + b_s$

- seek: $\lceil \frac{b_r}{b_{br}} \rceil + \lceil \frac{b_s}{b_{bs}} \rceil$

!!! Hybrid-Merge Join

    若其中一个表有序，而另一个表具有辅助索引，可以将有序表与辅助索引的叶子节点进行合并，得到一个混合的地址数据表

    然后按地址进行排序，加快读取的速度，完成join

#### Hash Join

> 同样只适用于取等号的情况，本质利用相同属性值的哈希值相同的特点（相同哈希值不一定属性相同），对数据进行分块处理

- 分块：将两个表分别使用hash进行分块，分成 $n_h$ 个partition 

- 其中一个表作为build input，用**另一个hash函数**对每一个 partition 在内存中建立hash索引

- 另一个表作为probe input，直接读取相应partition的数据，根据后面建立的hash索引在 build input 的索引中查找相应的join目标

![1716639743086](image/Database/1716639743086.png)

首先，划分时partition的个数不能超过内存总block数，不然无法正确划分（要为每一个partition留一个output buffer）

划分后每个partition的大小应该控制在buffer的大小内，因为要在内存中为这一块建立一个索引

$$ \lceil \frac{b_s}{M} \rceil \times f \leq n_h \leq M $$

（ $f$（fudge factor）为避让系数用于降低下述散列表溢出的概率）

- **Recursive Partition**

由上可知，如果数据量太大，$M \leq \sqrt{b_s}$，划分时就无法一趟完成，这时就需要使用多层级的递归划分

每次不够就划分成M-1个子块，然后对每个子块再进行递归划分，直到整个子块可以全部放入buffer

- **Overflowing**

    > 散列划分出现**偏斜**，导致部分过满，部分过空

    - 避让因子：$f = 1.2$

    - 溢出分解：将溢出的部分再次进行散列划分，直到全部放入buffer

    - 溢出避免：划分时划分成小块，在不溢出的情况下再合并成大块

    !!! danger

        当属性值大量重复时，上述策略可能都会失效，此时可以考虑前面的其他join方法  

- **代价分析**

    - 不需要递归

        - transfer: 
        
            $2(b_r + b_s)（初始划分读+写） + (b_s + b_r)（索引中探查） + 4 n_h（划分后的多余块，每个partition最多多余1块，一般可以忽略$
            
            $= 3(b_r + b_s) + 4 n_h$

        - seek: 
        
            $2(\lceil \frac{b_r}{b_{br}} \rceil + \lceil \frac{b_s}{b_{bs}} \rceil) （划分\&写回，一次多读几块）+ (n_h + n_h)（索引中探查）$
            
            $= 2(\lceil \frac{b_r}{b_{br}} \rceil + \lceil \frac{b_s}{b_{bs}} \rceil) + 2n_h$

    - 需要递归

        每次递归划分将大小变为原来的 $\frac{1}{M-1}$ 直至到 $M$，因此需要$\lceil \log_{M-1} (b_s) - 1\rceil$次递归

        - transfer: 
        
            $2(b_r + b_s) \times \lceil \log_{M-1} (b_s) - 1\rceil + b_r + b_s$

        - seek: 
        
            $2(\lceil \frac{b_r}{b_{br}} \rceil + \lceil \frac{b_s}{b_{bs}} \rceil) \times \lceil \log_{M-1} (b_s) - 1\rceil$

    - 最优情况，buffer足够大，直接退化为简单的O(1)对应：

        - transfer: $b_r + b_s$

        - seek: $1 + 1$

- *Hybrid Hash Join*

    - 当内存较大又不是超级大时，可以考虑将一部分内存用来存第一个划分$s_0$不用写回，并且在处理$r_0$划分时直接当场解决，又少了一次写回的代价

    - 一般当$M >> \sqrt{b_s}$时，可以考虑使用这种方法

#### Complex Join

循环嵌套一起做，或者每次做一个条件后进行集合运算

![1716642948613](image/Database/1716642948613.png)

### Other Operations

- Duplicate Elimination

    - 排序去重，相邻的相同元素直接跳过

    - Hash去重，直接避免重复插入

- Projection

    每个元组做投影，然后去重

- Aggregation

    - 类似去重的方法，对相关属性进行聚合处理

    - 还可以考虑从部分聚合开始，逐步向上聚合

- Set Operations

    同样利用 排序/哈希等方法处理
  
- Outer Join

    - 先计算出所有的内连接，然后再将外连接的部分补充进去

    - 修改连接算法，如嵌套循环连接处理单侧外连接很方便，归并算法处理外连接都很方便

### Expression

> 考虑计算含有多个运算的表达式

#### Materialization

> 每个子查询结果都作为一个临时表存储，然后再进行下一步操作

![1718681894296](image/Database/1718681894296.png)

可以使用double buffering模型，即两个buffer轮流使用，一个承接数据，一个并行写磁盘，实现buffer写入磁盘时不需要中断当前进程

**时间代价 = 两子查询的时间代价 + 两子查询的结果合并写入时间代价**

#### Pipeline

> 减少临时文件数，将多个关系操作组合成一个流水线，一个操作的输出直接作为下一个操作的输入

**同一阶段的操作并行运行，但是必须要前面的所有操作都完成后才能进行下一步**

- Demand-Driven (Lazy) Pipeline - Pull

    ![1716644558855](image/Database/1716644558855.png)

- Producer-Driven (Eager) Pipeline - Push

    ![1716644586102](image/Database/1716644586102.png)

- 执行算法

    - 阻塞操作

        如sort等，需要等待所有数据到达后再进行操作

    - 一些操作可以并行进行处理输入流，如projection和selection

        ??? "double-pipelined join"

            ![1716645207767](image/Database/1716645207767.png)

??? "Cache Conscious Algorithm"

    ![1716644890270](image/Database/1716644890270.png)

----

## 十六章 查询优化

本章的目的是具体实现如何选择执行语句的最优方案，大致又可以分为两步：

1. 列出与当前语句等价的内部执行方案，这里的执行方案既包括例如交换结合等逻辑层面的内容，也包括具体使用哪一种索引方法等实现层面的内容。

2. 快速估算每一种执行方案的复杂度并选其中最优的一种

### Equivalence Rules

> 查询结果一般为 **Multisets of Tuples**，等价表达式即 在合法的数据库上结果完全相同 *（注意集合是无序的）*

![1716704968040](image/Database/1716704968040.png)

![1716704999491](image/Database/1716704999491.png)

![1716705173860](image/Database/1716705173860.png)

![1716707417558](image/Database/1716707417558.png)

![1716707576340](image/Database/1716707576340.png)

![1716707602951](image/Database/1716707602951.png)

策略：

通过上述规则将查询语句转化为等价的形式，选择最优的执行方案

*实际使用中往往是引用经验式的规则，想要列出所有可能的实现逻辑一般是不可能的*

常用的套路有

- Space sharing & Time programming

- 选择提前做selection & projection，减少不需要的行数和列数

- 连续的join先做结果较少的，减少中间结果需要的空间（有点类似动态规划经典问题 矩阵乘法）

### Statistical Cost Estimation

??? 一些定义

    ![1716709482195](image/Database/1716709482195.png)

#### Histogram

> 记录每个属性取值的频率，需要随着数据库的更新实时更新

- Equi-width：等宽

- Equi-depth：等高

#### Selection Size Estimation

- 如果有相关的Histogram，直接使用其值即可

- 否则，粗略认为数据满足均匀分布：

    - 单点： $\frac{n_r}{V(A,r)}$

    - 区域（以小于为例）：

        $$
        \left \{
            \begin{aligned}
                0 &\qquad v < min(A,r)\\
                n_r \times \frac{v - \min(A,r)}{max(A,r) - min(A,r)} & \qquad min(A,r) \leq v < max(A,r)\\
                n_r & \qquad v \geq max(A,r)
            \end{aligned}
        \right.
        $$

        *若毫无相关信息，一般认为满足项为$\frac{n_r}{2}$*

    - 复合条件

        使用概率分析，对于每个条件，根据前面所述计算其满足的概率$\frac{s_i}{n_r}$

        - Conjunction：$n_r \times \prod \frac{s_i}{n_r}$

        - Disjunction（容斥）：$n_r \times (1 - \prod (1 - \frac{s_i}{n_r}))$

        - Negation：$n_r - n_p$ 

#### Join Size Estimation

- 笛卡尔积：

    - $n_{r\times s} = n_r \times n_s$

    - $l_{r\times s} = l_r + l_s$

- 自然连接根据 $R \cap S$ 的情况估计

    - $R \cap S = \emptyset$，则 $R\Join S = R \times S$

    - $R \cap S \rightarrow R (S)$，即交集为某一表的主键，则说明每一个元组最多有一个与之匹配，因此$n_{r\Join s} \leq n_s(n_r)$

    - $R \cap S$为外键，此时每一个元组恰好有一个与之匹配，因此$n_{r\Join s} = n_r(n_s)$

    - $R \cap S = A$非键值，则同样考虑均匀概率分布,对于表中的每一个元组考虑其可能匹配的个数，即相当于上述的给定单值的selection，有$n_{r\Join s} = \frac{n_r \times n_s}{max(V(A,r),V(A,s))}$

- 对于一般连接$R \Join_{\theta} S$，可以转化为$\sigma_{\theta}(R \times S)$，然后使用上述方法估计

- 对于外连接，可以看成自然连接+额外元组，有$n_{r⟗s} = n_{r\Join s} + n_r + n_s$

#### Other Estimations

![1716726772210](image/Database/1716726772210.png)

#### Estimation of Distinct Value

- Selection

    - 单点取等： 显然就为条件中的不同值个数

    - 区间取值（比大小）： $V(A,r) \times P_{select}$

    - 复杂情况： 直接粗略估计，$min(V(A,r), n_{\sigma_{\theta(r)}})$ 

- Join：

    - 假设$A = A_r \cup A_s$，则$V(A,r\Join s) = min(V(A_r,r) \times V(A_s - A_r, s), V(A_r - A_s, r) \times V(A_s, s), n_{r \Join s})$

        这里设$V(\emptyset,r) = 1$

- Projection

    - $V(\Pi_{A}(r),r) = V(A,r)$

- Aggregation

    - $V(G_F(A),r) = min(V(A,r), V(G,r))$

### Cost Base Optimize

!!! warning

    1. 局部最优解不一定是整体最优解

        - hash-join一般更快，但merge-join得到的结果是有序的

        - 嵌套的语句计算量不一定最小，但是可以配合流水线提高执行效率，最终时间复杂度反而小

    2. 适当的选择计划途径，可以列出所有选项还是使用启发式搜索

#### Join-Order Selection

考虑$n$个连续join，顺序有$\frac{(2(n-1))!}{(n-1)!}$（卡特兰数），可以用类似矩阵连乘的动态规划求解（但是顺序不定）

- 若选择bushy tree, 复杂度为$\sum_{i=1}^{n} \binom{n}{i} \times 2^i = (1+2)^n = O(3^n)$ （考虑大小为i的子集的更新代价为$2^i$）

    $F(S) = min(F(S_k) + F(S - S_k) + Join(S_k, S-S_k))$

- 若为left-deep tree，更新复杂度为$O(i)$，总复杂度降为$O(n 2^n)$
  
    $F(S) = min(F(r) + F(S - r) + Join(r, S-r))$

??? "Left Deep Join Tree定义"

    ![1716728651407](image/Database/1716728651407.png)

- Interesting Sort Order

    如果使用merge-join等操作，前面的排序可能会预先为后面的操作做一些优化

    因此这些也要在 DP 的过程中考虑进去，称为真正的 **interesting sort order**

#### Cost Based Optimization with Equivalence Rules

通过前面提到的表达式推导的形式寻找最优解，需要解决下述问题：

- 节省空间的表达式表示形式

- 检测相同表达式重复推导的技术

- 基于缓存的记忆化动态规划

#### Heuristic Optimize

- 尽早执行 Selection

- 尽早执行 Projection

- 尽早执行 条件严苛的指令 来筛选、降低表的大小

- 启发式+其他策略混合（如cost-based）

- 其他策略：只考虑left deep join order，optimization cost budget及时终止优化，plan caching 复用策略

#### Nested Subqueries Optimize

> **相关变量（correlation variable）：** 外层查询需要传入内层嵌套子查询的变量
>
> **相关执行（correlated evaluation）：** 外层对from的表列表直接作笛卡尔积得到所有元组，然后将嵌套子查询视为一个关于相关变量的函数，对每个元组进行check

![1716732873796](image/Database/1716732873796.png)

显然上面的方法效率很低，一般尝试将 嵌套子查询 转化为 多连接（注意下面例子的重复元组不同，Join会多一点）

![1716732901355](image/Database/1716732901355.png)

- semijoin ⋉

    - 检查一个结果集（外表）的记录是否在另外一个结果集（字表）中存在匹配记录，本质上半连接仅关注”子表是否存在匹配记录”，而并不考虑”子表存在多少条匹配记录”

        ![1716733909198](image/Database/1716733909198.png)

        半连接的返回结果集仅使用外表的数据集，查询语句中IN或EXISTS语句常使用半连接来处理

        ![1716733867727](image/Database/1716733867727.png)

    - 与之对应的还有反半连接anti-semijoin，检查一个结果集（外表）的记录是否在另外一个结果集（字表）中存在匹配记录，当且仅当字表中没有匹配记录时在返回结果集中包含仅使用外表的数据集

借半连接即可将嵌套子查询拆成单级的结构，回到一般的优化问题

### Materialized View

通过一定冗余提高系统效率

#### Materialized View Maintenance

> 维护有 **立即的视图维护（immediate）** 和 **延迟的视图维护（differed）**

- *人工维护*

- *触发器维护*

- **差分维护：**
  
    只需要处理更新的tuple与其他表的数据关系差异（differential）即可，不需要全体重新计算

    下面$i_r$指新插入的元组，$d_r$指删除的元组

    - Join ($v = r \Join s$)

        ![1716735022061](image/Database/1716735022061.png)

    - Selection($v = \sigma_{\theta}(r)$)

        ![1716735054509](image/Database/1716735054509.png)

    - Projection($v = \Pi_{A}(r)$)

        使用一个count计数，考虑是否需要更新

    - Aggregation($v = G_F(A,r)$)

        count、sum、avg等都比较好维护，增加一些辅助量即可

        min、max可能维护代价太大（删除）

    - Set Operation

        根据集合操作的含义维护即可

    - Expression

        从小的子表达式开始向上推导

#### Query Optimization

- 替换查询直接利用物化视图

- 使用物化视图的地方替换成其定义，可能获得更高的效率

#### Materialized View Selection

类似索引选择，目标都是加速系统的整体效率

具体还得妥善分析系统的工作负载（workload）来决定

----

## 十七章 Transaction

Transaction直译为事务，是一次数据库操作 **若干实际执行的操作** 组成的抽象概念

Transaction的提出主要是为了解决两个问题：

- 数据库的并发操作，从而提高数据库的性能和效率，具体表现为 吞吐量（throughput）和响应时间（response time）

- 数据库的错误处理（crash recovery）

### ACID 原则

Transation的实现要求四个特性**ACID**：

- **Automicity原子性**：要么Transaction内的所有操作都成功要么都失败回滚，不允许部分成功部分失败

- **Consistency一致性**：Transaction的发生前后应该保证数据与操作逻辑一致，例如完整性约束、外键约束、逻辑约束等等

- **Isolation隔离性**：Transaction应该对上层隐藏并发实现，无论并发的Transaction在内部以什么顺序执行，都要保证返回的结果正确；并且具体实现过程和并发信息与上层隔离，操作的中间结果对上层也是隐藏的

- **Durability持久性**：数据必须被安全的保存后Transaction才能结束，例如断电等等意外不能对已结束的Transaction的结果数据造成任何影响

??? note "Transaction定义状态"

    - Active：正在执行

    - Failed：出现错误，终止

    - Aborted：发生错误之后，正在尝试善后

        - 可能是restart，例如读写的数据页和其他Transaction冲突

        - 可能是kill，例如这个Transaction本身不满足一些要求，不可能被顺利执行
      
    - Partially Committed：逻辑操作已经执行完毕，但是相关数据可能还在buffer或者正在进行写回

    - Committed：数据完整写回，Transaction正式结束

### 并发控制

**Schedule**：指并发Transaction的各个子操作在DBMS内部的具体执行步骤。

- 串行调度：一个一个串行执行事务，只要各事务满足ACID，非常容易保证数据一致但是性能低下。注意在严格的并发语境下，只要没有破坏数据一致性，两个操作无论先执行哪一个都可以认为是正确的

- 并行调度：实际内部并不是先完整执行一个再另一个，性能上限高但是数据很容易不一致

本书并不考虑多条指令并发的“真·并行调度”，只关注我们以什么策略来生成一条**操作**执行序列，满足下列要求

![1717492396907](image/Database/1717492396907.png)

#### Serializability

每个Transaction可以分为若干次读、运算、写，其中会发生数据不一致（**Conflict**）的只有多个Transaction**并发读写同一个数据**这一种情况（全部只读不会发生冲突，运算由CPU而不是DBMS负责），所以下面我们主要关注有读有写这一种情况

- Conflict Serializability

    如果S可以通过交换相互不冲突的语句转换为S‘，或者说S与S‘所有相互冲突的Instructions以相同的顺序排列，称S和S‘是**冲突等价（conflict equivalent）**的

    如果S冲突等价于一个串行调度序列，称S是**冲突可串行的（conflict serializable）**。

    ??? example

        - conflict serializable

            ![1717490106116](image/Database/1717490106116.png)

        - not conflict serializable

            ![1717490135297](image/Database/1717490135297.png)

- View Serializability

    同样也有 view equivalent, 看着比较复杂，实际上就是考虑每一次的读要符合原来操作顺序的值，并且最后一次写的事务应该保持一致

    ![1717490766941](image/Database/1717490766941.png)

    容易发现，在这个定义下，view serializability就相当于conflict serializability的一个弱化版，可能存在blind write（未读取而写）问题

    !!! warning

        若考虑运算等一些其他操作，会有除这两者之外的serializability

        如下面 schedule<T1,T5>

        ![1717491448315](image/Database/1717491448315.png)

- Precedence Graph

    $T_i \rightarrow T_j$: $\quad T_i$ 与 $T_j$有冲突并且$T_i$先执行

    当且仅当Precidence图中无环（注意这是有向图的环）时，某个schedule是冲突可串的（显然可以用topo sort解决）

    但对于 视图可串行 的检测属于NP-C问题，因此没有有效算法，只能用一些必要条件进行check

#### Recoverable Schedule

![1718881524990](image/Database/1718881524990.png)

如果并发调度下某一个Transaction失败需要回滚会带动其他Transaction一起回滚，称为**级联回滚（cascading rollback）**，如果一个调度序列不会引起任何级联回滚，称它是**非级联序列（cascadeless schedule）**

??? danger "not recoverable"

    ![1717492088548](image/Database/1717492088548.png)

实现非级联序列的具体要求是，并发Transaction们对同一个数据有读有写时，任意**做了写入的Transaction必须先commit，下一个Transaction才能从中读**

### Trade Off

第一节中就提到了，串行调度数据安全性强而性能弱，并行调度反之。

实际使用中这往往不是一个选择题，通过一些tradeoff(accuracy, week consistency...)取折中。下面列出了常见的四种并行化的层次：

![1717492579162](image/Database/1717492579162.png)

??? note "额外控制手段"

    ![1717492807743](image/Database/1717492807743.png)

## 十八章 并发控制

前一章从调度原理上介绍了并发控制，而本章是讲解其具体的实现步骤

!!! warning

    **Schedules not possible under two-phase locking are possible under the tree protocol, and vice versa.**

### Lock-Based Protocols

锁是Transaction对某个数据的权限申请，由并发管理器控制。

- **exclusive (X) mode**: Data item can be both read as well as written. X-lock is requested using  **lock-X** instruction.

- **shared (S) mode**: Data item can only be read. S-lock is requested using  **lock-S** instruction.

根据上述逻辑，对某一块数据，没有X锁时可以分享多把S锁给不同Transaction，但是存在一把X锁后就不能再有任何其他锁。这种做法一定程度上避免了混乱的读写

![1717637119400](image/Database/1717637119400.png)

#### 内部实现

??? note "Atomatic Acquisition of Locks"

    ![1717761635492](image/Database/1717761635492.png)

    ![1717761657812](image/Database/1717761657812.png)

锁策略一般由lock manager 管理，通过数据结构Lock Table实现，用哈希表归类数据，每个数据下挂链表储存当前锁的请求序列（一般还会为每个事务建立锁链表）

- 新请求：将新节点挂到链表的后端

- 解锁：从链表中删除对应节点，并检查该节点后续的请求进行处理

![1718692268670](image/Database/1718692268670.png)

#### 常见问题

- **Dead Lock**：锁协议最大的问题是死锁不能被完全避免,比如下图只能通过回滚其中一个Transaction来解决

    ![1717637451937](image/Database/1717637451937.png)

- **Startvation**：另一种常见的情况是，派出了过多的S锁，导致出现一个X锁请求时，其会被后面的共享锁所阻塞（排他锁只能等待，而共享锁可以随便加），造成时间浪费

#### Two-phase Lock Protocols

为了解决各个Transaction在任意时刻随意加锁解锁带来前一节中提到的问题，出现了二阶段的锁策略：

- 二阶段锁策略2PL是对单个Transaction而言的

- 两阶段锁强调的是加锁（增长阶段，growing phase）和解锁（缩减阶段，shrinking phase）这两项操作，且每项操作各自为一个阶段

    - 不管同一个事务内需要在多少个数据项上加锁，所有的加锁操作都只能在同一个阶段完成，在这个阶段内，不允许对已经加锁的数据项进行解锁操作。

    - 反之，任何一次解锁即视为这个Transaction进入解锁期，此后不允许该Transaction新加任何锁。

??? note "proof"

    We prove by contradiction.

    Suppose that there exists a two-phase lock that is not serializable. Then, there must be a cycle in the precedence graph.

    Let $T_1\rightarrow T_2 \rightarrow \ldots \rightarrow T_n \rightarrow T_1$ be the transactions in the cycle, $\alpha_i$ denote the lock point of $T_i$. Then, we have $\alpha_1 < \alpha_2 < \ldots < \alpha_n < \alpha_1$, which is a contradiction.

    Therefore, every two-phase lock is serializable.

二阶段锁策略保证了冲突可串行性，但是不能保证得到的序列是非级联回滚的，因此有了两种衍生策略来解决这个问题：

- 默认2PL：只要Transaction不需要再申请新锁，并且对某个数据的所有操作都已经完成，那么对这个数据的锁就可以被释放，即使此时Transaction内还有其他操作没有进行

- **Strict Two-phase Locking**：一个Transaction会保留它的X锁直到commit/abort之前

- **Rigorous Two-phase Locking**：一个Transaction会保留它的所有锁直到commit/abort之前

### Tree-Based Protocol ($\in$ Graph-Based Protocol)

!!! note "Graph-Based Protocol"

    ![1717762311231](image/Database/1717762311231.png)

树协议的要求：

- *图结构要是一棵有根树*

- Transaction只能申请X锁，并且同一个事务对一个数据只能申锁一次

- Transaction的第一把锁可以是任何数据项的；接下来，只有该事务持有了数据项的父节点的锁，才可以给数据项加锁

- 数据项可以在任何时候解锁

**特性：**

- **保证冲突可串行化**

- 相比二阶段锁协议解锁时间自由

- **保证无死锁**

- 不保证可恢复性和无联级回滚，但可通过增加限制降低一定并发性来实现

??? note "trade off"

    - 可恢复性&无联级回滚：事务结束前不允许释放排他锁，但是会降低并发性
    
    - 可恢复性：为每个数据设立 **提交依赖**（对为提交数据的读操作），只有当所有依赖的数据都提交后，即都已经正确写入后，才能提交；当某个数据项被回滚时，所有依赖于它的数据也要回滚

缺点：

- 有时会给不需要访问的数据项加锁（要求先给父节点加锁），会增加锁开销

### Handling Deadlock

??? example

    ![1717852620755](image/Database/1717852620755.png)

#### 死锁预防
  
> 通过一些规则避免死锁的发生

- **pre-declaration:**

    在事务执行前一次性申请Transaction需要的所有锁，封锁所有的数据项

    - 事务开始前难以确定需要的锁

    - 许多锁可能会被浪费

- **graph-based protocol:**

    使用图协议给所有的数据项加一个次序，要求事务必须按照这个次序加锁，如前述的树协议

- **Wait-die Scheme**

    两个事务相互死锁，根据赋予的时间戳，若当前事务先于请求冲突的事务，等待；否则，直接自己回滚滚蛋（先入为主）

    - 缺点是回滚后重新计先后，于是后开始的回滚后仍然是后开始的，这有可能导致某个事务一直得不到执行

- **Wound-wait Scheme**

    两个事务相互死锁，根据赋予的时间戳，若当前事务晚于请求冲突的事务，等待；否则，直接回滚自己让位（长江后浪推前浪）

    - 缺点是先开始一般意味着已经执行的操作更多，所以回滚的成本更高

- **Timeout**

    为每个事务设置一个超时时间，超时后直接回滚

    - 简单粗暴，但是时间难以把握，应用场景有限

#### 检测死锁

用类似前序图的等待图（wait-for graph）关联各个事务,箭头从Ti指向Tj意味着Ti正在等待Tj解锁某个数据，自己才能加锁以继续执行操作。

同样通过检测图中是否有环来判断是否有死锁，有环则有死锁，否则没有。

!!! danger "注意区分"

    与前序图不同的是，前序图随Schedule的确定而确定，执行过程中不会变化；而等待图在运行过程中时时可能改动

#### 死锁恢复

要破坏死锁，只能通过回滚某些事务（victim）

??? note "Victim Selection"

    - 目前与未来的运算时间估计
    
    - 事务目前与未来使用的资源量估计
    
    - 事务回滚涉及的事务数目

- Total Rollback

    彻底回滚选定的事务，然后重新开始

- Partial Rollback

    total rollback可能导致过多不必要的回滚，因此有了partial rollback，只回滚必要的部分，即回滚到消除死锁的状态就停止

### Multiple Granularity

Granularity译为粒度,前面锁协议相关内容中，我们将加锁的对象泛指为“数据”，但是实际上“数据“指代的内容量可大可小，组织成一种树形层次结构

如下图所示，从整个数据库到每一个tuple，可以用一个树型结构表示，其中的每一个节点都可以视为“数据”

![1717854468344](image/Database/1717854468344.png)

通过对多粒度的支持，可以更好地选择加锁策略，从而平衡并发性和性能

![1717854704323](image/Database/1717854704323.png)

具体实现时，对于每一个加锁请求，我们只需要对其所在的粒度进行 **显示加锁** 即可，而其子节点将会默认被 **隐式加锁**， 则查询时只要访问从根节点到叶子节点的路径上的所有数据项检查锁即可检查这种”隐式锁“；

然而，当要给某个数据项加锁时，我们还得确认其子节点是否已经被加锁而导致“隐式锁”冲突，显然我们不会傻傻地检查整个子树~~（不然多粒度的设计就没有意义了）~~，这里通过引入意向锁（intention lock）来解决这个问题：当某个节点被加锁时，会对从根节点到该节点的路径上的所有节点加上意向锁，这样就可以通过检查节点的意向锁来判断子节点是否被加锁

引入意向锁后的加锁冲突关系图如下（**S/X表示整棵子树的状态，IS/X表示子树内某个节点的状态**）

![1717855249856](image/Database/1717855249856.png)

??? note

    多粒度增强了并发性，减少了锁开销

    Lock granularity escalation策略: in case there are too many locks at a particular level, switch to higher granularity S or X lock

### Other Operations

#### Insert/Delete

- **Insert**

    插入数据后，需要对新数据项加排他锁，以保证数据的一致性

    必须保证新插入的数据不能被其他事务访问，直到插入事务提交

- **Delete**

    删除数据前，需要对被删除的数据项加排他锁，以保证数据的一致性

    必须小心删除操作与读写操作的冲突

#### Predicate Reads

- Phantom Phenomenon

    本质为一个事务重复读取同一个范围的数据，但是在两次读取之间有另一个事务对数据进行了插入、修改（如将为锁上的数据改为查询的数据）等操作，一般的锁协议无法解决这个问题，从而导致两次读取的数据不一致，成为幻象现象

- *暴力解决方案*

    新建一个新数据项，用于记录查询的范围，对所有可能导致幻象现象的数据项加锁

    显然会导致大量的锁开销，并大大降低并发性

- **Index Locking**

    只有当事务在索引的叶结点上找到相应的数据项时，才能真正访问这些数据

    - 朴素做法：

        对每个事务访问的所有叶结点索引项都加上共享锁

        当要插入、删除、修改数据时，必须更新整个索引，也即需要对所有涉及的叶结点加上排他锁

        此外，需要遵循两阶段锁协议

    - Next-Key Locking

        由于朴素做法中，需要对整个叶结点加锁，导致并发性能大大降低，为了避免上述问题，引入了Next-Key Locking

        谓词查询时，对所有满足条件的 **索引数据项**以及后一个 **索引数据项**加共享锁

        插入、删除、修改数据时，对所有满足条件的 **索引数据项**以及后一个 **索引数据项**加排他锁

        这样当有幽灵数据出现时，必然会引起锁冲突，从而保证了数据的一致性

        ??? example

            ![1717857252124](image/Database/1717857252124.png)

## 十九章 错误恢复（Log-Based Recovery）

### 错误类型

- **Transaction Failures**

    - logical errors: 事务逻辑错误，如插入重复数据等

    - system errors: 系统进入不良状态，如死锁

- **System Crash**

    > fail-stop assumption: 系统在发生错误时会停止运行，易失性数据丢失，非易失性数据不会丢失

    - 硬件故障

    - 软件故障 

- **Disk Failure**

    数据传输过程中由于磁头损坏等故障导致磁盘块内容丢失

### 日志

对每一个事务的每一个update做记录：

- Transaction开始时，记录 `<Ti start>`

- 对每一个写操作，记录 `<Ti, X, V0, V1>`（事务编号Ti，写数据的属性X，原值V0，新值V1）

- 提交时，记录`<Ti commit/abort>`表示事务结束

在更新时机上又有两种选择：

- **immediate-modification**：

    - 允许在commit之前将值写入buff/disk

    - 数据具体何时、什么顺序真正写入disk是不确定的，交给缓冲区管理器决定 

    !!! warning "WAL (Write-Ahead Logging Rule)"

        - 为了保证日志的有效性，日志必须在数据写入之前先写入稳定的存储器，再执行相关数据的写操作

        - Commit后数据可以在buff中停留但是Log必须立刻进入Disk等稳定存储器

- *deferred-modification*：

    - 延迟修改，写操作在commit以前都是在临时变量中做，commit时一次写入buff/disk

（本书中我们只讨论immediate的做法）

### 日志恢复

> 这里只讨论strict two-phase protocol下的恢复

#### Check Point

重复那些已经写入disk的数据操作是没有意义的。如果每次都从最开始的日志开始恢复，会有大量的重复操作和无用开销。

所以每隔一段时间，我们停止schedule并强制将buff中的所有内容写入disk（包括Log），并在Log中留下一条记录`<checkpoint L>`作为标记点，记录L为当前还没有被Commit的事务编号（已经Commit的事务再此之前都保证被写入disk了）。

#### Undo/Redo

一般的恢复过程分为两个阶段：

首先Redo,保证所有数据都被写入（比如commit的数据可能在buff中被损坏了）

然后Undo,将被打断的事务回滚，此时需要留下Compensating Log，记录回滚的操作

??? note "Compensating Log"

    - 为了处理“恢复时出错，需要从恢复中恢复”的套娃情况，作为额外操作的Undo也需要写Log，这种Log就称为补偿日志

    - 一般只需要`<Ti, X, V>`（事务编号Ti，写数据X，恢复值V）三个信息
  
    - 同时恢复的恢复应该具有**幂等性**，保证在套娃恢复时可以得到正确的结果
        
        - A从950恢复到1000：这是幂等的，无论恢复多少次结果都是1000，因此是合适的恢复策略。
        
        - A加50：这不是幂等的，多次恢复可能导致A的值反复相加，这是不好的恢复策略。

- Redo phase（repeating history）：

    ![1718269891247](image/Database/1718269891247.png)

- Undo phase（reversing history）：

    ![1718269932712](image/Database/1718269932712.png)

??? note "Fuzzy Check Point"

    常规Check Point写disk时会强制停止Schedule造成性能浪费，因此有了Fuzzy Checkpoint这一改进策略，相当于每次Checkpoint时将需要写入的数据块记录下来，然后正常执行数据库操作的同时并行写入数据（当数据有冲突时那也没办法只能停了）：

    ![1718270628055](image/Database/1718270628055.png)

    这样子还需要用一个指针记录当前已经写完的部分，以便在恢复时找到正确的起始点

    ![1718270705103](image/Database/1718270705103.png)

#### Buffers

- **Log Buffer**

    上面提到我们总是希望日志被写到Disk中以保证数据可靠，但是这样会对Disk造成很大的压力，所以一般Log也需要Buffer

    一般在 缓冲区已满、事务commit、Check Point时将Buffer中的Log写入Disk

    ![1718270876339](image/Database/1718270876339.png)

- **Data Buffer**

    - 上面提到的恢复算法可以支持下面三种策略：

        - force policy: 每次commit都要求强制写入Disk，保证数据的可靠性

        - no-force policy: commit时只写入buff，可以等到满了或者Check Point时再写入Disk

        - steal policy: uncommitted数据也可以直接写入Disk

    - 写入保护策略（latch）：

        在数据块写入时加排他锁，防止其他事务读写

### 磁盘恢复

前一节主要解决回滚的实现和易失性存储入Mem的恢复。现在非易失性储存入Disk失效时的恢复：

- 定期拷贝磁盘作为备份，称Dump

- 类似于Check Point之于内存，恢复时找到最近的Dump和恢复Log，只做Redo

### 锁的提前释放和逻辑Undo

- 逻辑操作

    前面仅仅讨论了物理Undo（修改），但是有些操作，比如插入、删除，是无法通过简单物理Undo（即记录旧值和新值）来恢复的，这时候就需要逻辑Undo

    并且这些操作在执行时只需要获取一个低级别的瞬时锁，操作完成就可以提前释放，而不用等到事务的释放阶段，以提高并发性

    要Undo这些操作，我们需要为每一个操作定义一个反操作，例如插入索引对删除索引，新建表对Drop表等，Undo某个操作即执行它的反操作

- 逻辑日志

    ![1718277456514](image/Database/1718277456514.png)

- 恢复算法

    对于逻辑Undo，如果该逻辑操作已经完成，那么需要通过其提供的Undo操作来恢复，否则对其中不完整的操作进行物理Undo

    并且Logical Undo一定不是幂等的，所以回滚时如果看到Operation-abort，意味着已经逻辑撤回过，不能再次Undo

    ![1718277661562](image/Database/1718277661562.png)

    ![1718277701028](image/Database/1718277701028.png)

### ARIES

![1718279133705](image/Database/1718279133705.png)

#### Physiological Redo（物理逻辑Redo）

- 其为物理的，因为会标识出具体的受影响的数据页

- 同时它记录的是逻辑操作，可能可以大大降低日志量

!!! exmaple

    删除记录操作，考虑后方数据前移

    若采用物理Redo，需要记录所有移动的数据，开销很大

    若采用逻辑Redo，只需要记录被删除的元组的数据页和删除操作，恢复时再执行删除操作即可

#### ARIES Data Structure

- **Log Sequence Number (LSN)** 

    可以看作是Log的身份证号，ARIES将其存在数据页中，越晚标号越大（一般即为数据页号+页内偏移），标识哪些操作已经被实施

- Page LSN

    Buff和Disk等数据页都保存其数据对应的最新的LSN

- Log Record

    常规的Log记录一般包括LSN、事务ID、当前事务的上一条Log的LSN方便便利、操作信息

    ![1718278805407](image/Database/1718278805407.png)

    还有一种特殊的redo-only log是恢复时的操作，永远不需要undo。为了加快操作，CLR会记录一个UndoNextLSN指向下一个需要Undo的Log，来跳过不需要Undo的Log

    ![1718278948840](image/Database/1718278948840.png)

- Dirty Page Table

    在表中保存当前所有的脏页PageID，并记录PageLSN（更改PageID数据的最新LSN），**RecLSN**（修改该Buff的最早的一条Log的LSN

- CheckPoint Log

    记录当前的CheckPoint，包括**Dirty Page Table**和**Active Transaction Table（未提交的事务以及其LastLSN）**

    *需要注意的是，ARIES并不在CheckPoint时将所有数据写入Disk，而是让缓存在后台自己刷新*

#### ARIES具体步骤

核心是跳过一些不需要的操作，并利用一些指针等加速指令查找

![1718279587109](image/Database/1718279587109.png)

1. Analysis Pass：

    - 从最近的Check Point开始，`RedoLSN=min(RecLSN, CheckPoint)`，`UndoList=L`

    - 向下扫描，更新Dirty Page Table和UndoList

        ![1718279993969](image/Database/1718279993969.png)

    !!! note

        - 维护RedoLSN是优化Redo执行的起点
        
        - 记录每个事务的LastLSN优化Undo执行的起点

2. Redo Pass：

    只重做那些真正需要重做的操作，即还没写入磁盘并处于操作期的buffer

    ![1718280256818](image/Database/1718280256818.png)

3. Undo Pass：

    ![1718280887894](image/Database/1718280887894.png)

    看起来非常复杂的操作，本质上就是为了维护相应的指针，加速查找（用`max(PrevLSN)`作为下一个undo的起点，同时让当前CLR的`PrevLSN`成为当前事务的上一条，即`PrevLSN`）

    ![1718280803888](image/Database/1718280803888.png)

    !!! note "Partial Undo"

        ARIES支持部分Undo，即只Undo到某个特定的LSN（比如仅仅只是为了破坏死锁），这样可以避免不必要的Undo

??? note "其他特征"

    - 恢复独立性（recovery independence）：有些页的恢复可以独立进行
    
    - 保存点（savepoint）：在事务执行过程中，可以设置保存点，以便在回滚时直接回滚到某个保存点
    
    - 细粒度封锁（fine-grained locking）：在恢复时，可以只对需要恢复的数据项加锁，而不是整个事务
    
    - 恢复最优化（recovery optimization）：预先提取数据页、重做推迟等

### 基于主存储的恢复

![1718281501198](image/Database/1718281501198.png)