<center>
  <font face="黑体" size = 5>
    利用LEX计算文本文件的字符数等
  </font>
   <center><font face="黑体" size = 5>
     Task One
  </font>
  <center><font face="黑体" size = 4>
    姓名： 周炜
  </font>
  <center><font face="黑体" size = 4>
    学号： 32010103790
  </font>
</center> 

## 实验要求

### Lab 3

**利用** **YACC** **生成中缀表示的计算器**

生成如下文法表示的表达式对应的计算器

```
 exp->exp + exp | exp – exp
| exp * exp |exp / exp
|exp ^ exp | - exp
|(exp) |NUM
```

对于输入中缀表达式，要给出结果。如3 +（4 * 5）结果应为23。要求能连续处理若干个数学表达式，直到输入结束或文件结束 

### Lab 4

**利用** **YACC** **生成能进行整数和实数运算计算器** 

文法要求同lab3

对于输入的中缀表达式，要给出结果。举例说明：

  3 + (4 * 5) = 23   3+ (4.2 * 2) = 11.4

  3.2+ (1/2) = 3.7    3+(1/2) = 3

要求能连续处理若干个数学表达式，直到  输入结束或文件结束。 

## 具体实现

使用的是Ubuntu 20系统

从实验要求可以看出lab3是lab4的子集，lab4额外要求要求能同时处理浮点数值和整数。因此我做了lab4相当于完成了lab3

但是需要额外注意的是 3.2+ (1/2) = 3.7    3+(1/2) = 3这个样例说明**只有整数和浮点数混合时才计算小数**

使用下列命令就会自动启动计算器

```shell
./calculator.sh
```

我也写了一个自动测试脚本，读入`test.txt`中的测试样例读入，可以用下列命令完成

```shell
./test.sh
```

发现全都正确

![image-20240325105953126](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240325105953126.png)

在标准的Bison/Yacc使用场景中，解析器是边读边解析边计算的，而不是先读完整个输入再决定计算方式。这里采用同时按照浮点数和整数类型计算得到结果然后按照是否有float来选择输出

