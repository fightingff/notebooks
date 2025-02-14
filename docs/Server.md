# Server

> 记录一些常见的服务器操作

## SSH

### 登陆

生成本机的密钥对，将公钥添加到服务器的`~/.ssh/authorized_keys`文件中，之后就可以直接使用私钥登陆了。

!!! note "关于创建新用户"

    ```bash
    sudo adduser user
    # sudo usermod -aG sudo user
    ```

```bash
ssh user@host -p port -i ~/.ssh/id_rsa # 终端登陆

ssh user@host -p port -N -L local_port:remote_host:remote_port # 端口转发
```

## SFTP

sftp是ssh的一个子协议，用于文件传输。

```bash
sftp user@host -P port -i ~/.ssh/id_rsa # 登陆

# 上传文件
put local_file remote_file

# 下载文件
get remote_file local_file
```