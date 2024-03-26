# 计算机组成

[超详细前辈笔记](https://xuan-insr.github.io/computer_organization/)

因此我只记录了一下自己遇到的重难点，以及自己的一些其他思考

## Chapter 1

### Eight Great Ideas in Computer Architecture

- Design for Moore's Law
    
    > Moore's Law: The number of transistors on a chip will double about every 18 - 24 months. 

    - 为了追求更高的性能，我们可以通过增加晶体管的数量来提高计算机的性能。但是，随着晶体管数量的增加，计算机的功耗和散热问题也会变得越来越严重，遇到功耗墙等问题。

- Use Abstraction to Simplify Design

    - 计算机的多层次抽象结构：数字逻辑、指令集架构、操作系统、编程语言、应用程序等。

- Make the Common Case Fast

    - 通过优化运行最多的操作来提高计算机的性能。

- Performance via Parallelism

    - 并行加速

- Performance via Pipelining

    - 流水线加速

- Performance via Prediction

    - 通过预测操作提高性能，如分支预测，缓存预读等
  
- Hierarchy of Memories

    - 计算机的存储器层次结构，如下：
        
        ![Memory Hierarchy](./images/memory_hierarchy.png) 

- Dependability via Redundancy

    - 利用冗余提高系统可靠性，即多保险，如备份等

### Performance

主要要知道专有名词的定义，计算方法相对还是简单的

- Performance = 1 / Execution Time

- Execution Time = Clock Cycles * Clock Cycle Time

- CPI (Cycles Per Instruction) = Clock Cycles / Instructions

- MIPS (Million Instructions Per Second) = Frequency / CPI / $10^6$

## Chapter 3

### 数的表示

- 在各种课程内已经出现过好多次了，没什么特别好说的
  
### 运算

- 关于 overflow （同号相加出异号）的处理 （最后一位 Cin xor Cout = 1）

    - ALU detection
      
        - Exception
    
    - Overflow log
    
        - Store instruction address in a special register EPC
        
    - Jump to exception handler
    
        - Correct & Return
        
        - Return with error code
        
        - Abort program

- **Addition**

    - Carry Ripple Adder (数逻讲过，略)
    
    - Carry Lookahead Adder (CLA)
    
        - Generate: Gi = Ai & Bi
        
        - Propagate: Pi = Ai | Bi
        
        - Carry: Ci = Gi | (Pi & Ci-1) 

            将递推式不断展开，可以得到每一个Ci的表达式，这样就可以并行进行每一位的计算，大大提高了速度

            不过随着位数的不断增加，硬件复杂度也会不断增加，因此实际上将会每4位或者8位作为一个单元，然后再进行并行计算

            ![CLA](./images/CLA.png)

            如上图，根据输入，通过每个小单元里的CLA 可以算出每个小 pi, gi

            然后进一步，可以得出每个大的 Pi, Gi, 然后通过大的 CLA 可以得出每个大的 Ci

            这个Ci再传入每个小的 CLA， 就可以算出最终的结果了

    - Carry Select Adder (CSA)
    
        - 利用 预测 & 冗余的方法
        
        - 相当于对上述CLA的一个改进，预先将 Cin = 0 / 1 的可能值都算出来，然后根据输入的 Cin 选择其中一个  
    
    - slt (set less than)
    
        - a < b --> a - b < 0 

- **Multiplier** && **Division**

佬的笔记很详细了

核心就是充分利用结果寄存器，将 乘数 / 被除数 放到寄存器的右半冗余部分进行运算，并且变乘除法为加减法

*Booth 算法，减少“1” 的个数，提高效率，每一串”1“只需要运算两次*

- **Float**

各种课讲过很多次了，略

特殊标记：

![Float](./images/float.png)