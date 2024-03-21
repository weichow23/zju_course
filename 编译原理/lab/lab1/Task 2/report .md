<center>
  <font face="黑体" size = 5>
    利用LEX进行字母的大小写转换
  </font>
   <center><font face="黑体" size = 5>
     Task Two
  </font>
  <center><font face="黑体" size = 4>
    姓名： 周炜
  </font>
  <center><font face="黑体" size = 4>
    学号： 32010103790
  </font>
</center> 



[TOC]

大部分内容在Task One中已经有所描述，不再赘述

### 一、实验要求

编写一个LEX输入文件，使之可生成将SPL程序注释之外的所有关键字（保留字）均大写的程序。有关SPL的关键字请见第二章或第八章所述。该LEX生成的程序要能够对SPL源程序进行分析，将不是大写的关键字均转换为大写。 

### 二、效果展示

我把上述过程写为了shell脚本，直接运行如下命令

```shell
bash upper.sh
```

效果为：

![image-20240311140033935](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240311140033935.png)

