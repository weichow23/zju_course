# 2.4

$B[g] = A[f] + A[f+1]$

```assembly
s1li x30,x5,3 #x30 = f*8
add x30,x10,x30  # ×30 =&A[f]
slli x31,x6,3l #x31 = g*8
add x31,x11,x31 # x31 = &B[ g]
ld x5,0(×30)  #f=A[f]
addi x12,×30,8  #x12=&B[g]
ld x30,0(x12) #x30=A[f+1]
add x30,x30, x5 # x30 =A[f+1]+A[f]
sd x30,0(×31) #B[g] =A[f]+A[f+1]
```

# 2.8

```assembly
addi x30, x10, 8
addi x31, x10, 0
sd   x31, 0(x30)
ld 	 x30, 0(x30)
add  x5, x30, x31
```

# 2.12

| 0000 000 | 0 0001 | 0000 1 | 000  | 0000 1 | 011 0011 |
| -------- | ------ | ------ | ---- | ------ | -------- |
| func7    | x1     | x1     |      | x1     | op       |

因此可以得到：

```assembly
add x1, x1, x1
```

# 2.14

![image-20240408152908542](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240408152908542.png)

R-type sub

| 0100 000 | 0 0101 | 0011 1 | 000    | 0011 0 | 011 0011 |
| -------- | ------ | ------ | ------ | ------ | -------- |
| func7    | rs2    | rs1    | funct3 | rd     | op       |

sub x6, x7, x5

# 2.17

### 1

```assembly
# or x7, x7, x6
x7 = 0x0000, 000A, AAAA, AAA0
x6 = 0x1234, 5678, 1234, 5678
```

最后结果为

```assembly
x7 = 0x1234, 567A, BABE, FEF8
```

### 2

即16进制左移一位

```assembly
0x 2345, 6781, 2345, 6780
```

### 3

```assembly
0x545
```

# 2.22

### 1

最大正数位$2^{20}-2$, 最小负数$-2^{20}$

20 imm, 最后地址位$1FF00000$

### 2

12 imm,  最后地址位$1FFFF000$

# 2.24

#### 1

初始时 $x5=0$之后$x6$会一直自减到0,才跳出循环, 因此执行了10次

最终  $x5=20$

#### 2

```c++
int acc = 0;
int i = 10;
while (i ! = 0) {
	acc += 2;
	i--;
}
```

#### 3

$4N+1$

#### 4

```c++
int acc = 0;
int i = 10;
while (i >= 0) {
	acc += 2;
	i--;
}
```

# 2.29

```assembly
#   a0 - n (input)
#   a1 - temporary register for storing result
#   a2 - temporary register for storing n-1
#   a3 - temporary register for storing n-2

circle:
  addi sp, sp, -8
  sw ra, 0(sp)
  sw fp, 4(sp)
  addi fp, sp, 8
  # Check if n == 0
  li a1, 0
  beqz a0, fib_return
  # Check if n == 1
  li a2, 1
  beq a0, a2, fib_return
  subi a2, a0, 1
  # fib(n-1)
  mv a0, a2
  jal fib
  mv a2, a1
  # fib(n-2)
  subi a0, a0, 1
  jal fib
  mv a3, a1
  # fib(n) = fib(n-1) + fib(n-2)
  add a1, a2, a3

fib:
  lw ra, 0(fp)
  lw fp, 4(fp)
  addi sp, fp, 8
  jr ra
```

