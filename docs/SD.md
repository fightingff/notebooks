# UCB-Linux System Administration Decal

> 记录一些知识点，包括课程讲义、实验等

## Lectures

### License

- Copyleft(GPL)

    > All versions of the software remain free

    通过GPL协议，要求源程序必须公开，任何人都可以使用、修改、复制、分发源代码，但是必须保持开源，并且任何修改后的代码也必须遵守GPL协议。

    !!! tip

        A quote from Richard Stallman, the founder of the Free Software Foundation, emphasizes his goal to maintain the freedom of GNU software: "I want to make sure that all versions of GNU remain free."

        Steve Ballmer, former CEO of Microsoft, referred to the GPL as "a cancer that attaches itself in an intellectual property sense to everything it touches." 

        由此可见，GPL的完全开源会对衍生的商业软件产生不可忽视的“威胁”

- Permissive（MIT,BSD,Apache,WTFPL）

    > You can do whatever you want with the software, as long as you include the original copyright and license notice in any copy of the software/source.

    这类协议允许用户自由使用、修改、复制、分发源代码，但是不需要保持开源，可以闭源，只要在源代码中包含原始版权和许可通知即可。

## Labs

### Lab 1

- `.tgz`(`tar.gz`)文件

    - 压缩：`file --(tar)--> file.tar --(gzip)--> file.tar.gz`
    
    - 解压 

        ```bash
        tar -xvzf filename.tgz
        ```

        - `-x`：解压
        
        - `-v`：显示详细信息
        
        - `-z`：使用`gzip`解压
        
        - `-f`：指定文件

- `xargs`

    常和管道符`|`一起使用，将前一个命令的输出作为后一个命令的参数，注意`xargs`默认以空格分隔参数，将换行符转换为空格，并且要写在后一个命令的前面

    ```bash
    # command1 | xargs command2
    cat * | xargs echo # 将所有文件内容以一行输出
    ```

- `tr`

    替换字符

    ![1721382712677](image/SD/1721382712677.png)
