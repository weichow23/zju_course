除了使用`usermod`命令来修改用户名之外，你还可以使用以下方法来更改用户名：

1. 创建一个新用户，然后将旧用户的文件和设置移动到新用户中。这个方法需要管理员权限。

首先，创建一个新用户，例如`newusername`：

```
sudo adduser newusername
```

然后，使用以下命令将旧用户`oldusername`的文件和设置移动到新用户中：

```
sudo rsync -a /home/oldusername/ /home/newusername/
```

这将递归复制旧用户的所有文件和目录，包括隐藏文件和权限设置。注意，`/home/newusername/`目录必须是空的。

接着，将新用户添加到和旧用户相同的组中：

```
sudo usermod -a -G yangshuai zhouwei
```

最后，将新用户名设置为系统默认用户名：

- `sudo chown -R zhouwei:zhouwei /home/zhouwei/`：将新用户"zhouwei"作为所有文件和目录的所有者。
- `sudo userdel -r yangshuai`：删除旧用户"yangshuai"及其主目录。





```
sudo usermod -d /home/zhouwei -m -l zhouwei yangshuai
```

1. 直接编辑系统文件，手动更改用户名。这个方法需要管理员权限。

首先，使用以下命令编辑`/etc/passwd`文件：

```
bashCopy code
sudo nano /etc/passwd
```

找到包含旧用户名的行，例如：

```
rubyCopy code
oldusername:x:1000:1000:Old User:/home/oldusername:/bin/bash
```

将该行中的旧用户名`oldusername`替换为新用户名`newusername`，然后保存并退出文件。接着，编辑`/etc/group`文件，将与旧用户名相关的组名称也进行相应的修改：

```
bashCopy code
sudo nano /etc/group
```

找到包含旧用户名的行，例如：

```
makefileCopy code
oldusername:x:1000:
```

将该行中的旧用户名`oldusername`替换为新用户名`newusername`，保存并退出文件。

最后，将旧用户名的主目录和所有相关文件和设置移动到新用户名下：

```
bashCopy code
sudo mv /home/oldusername /home/newusername
```

这将把旧用户名的主目录和所有相关文件和设置移动到新用户名下，并将所有权限设置保留不变。完成这些步骤后，你就成功地将旧用户名更改为新用户名了。
