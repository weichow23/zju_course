# Chapter 2

### 2.2

$f = g+h+i$

### 2.3

```assembly
sub x8, x28, x29 
slli x8, x8, 2 
add x8, x8, x10 
ld x9, 0(x8) 
sd x9, 32(x11) 
```

### 2.4

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

### 2.5

小端模式：低位在低地址

| Address | 0    | 1    | 2    | 3    |
| ------- | ---- | ---- | ---- | ---- |
| Data    | 12   | ef   | ca   | ab   |

大端模式

| Address | 0    | 1    | 2    | 3    |
| ------- | ---- | ---- | ---- | ---- |
| Data    | ab   | cd   | ef   | 12   |

### 2.11

64位寄存器的有符号数范围为$[-2^{63},2^{63}-1]$

#### 1

溢出时：$128 + x6 > 2^{63} − 1$ , 即 $x6 > 2^{63} − 129.$
或者 $128 + x6 < - 2^{63}$, 即 $x6 < − 2^{63} − 128$  不可能

综上$-2^{63}-129<x6<2^{63}-1$

### 2

溢出时：$128 – x6 > 2^{63} − 1$, 即 $x6 < 2^{63} + 129$
or $128 – x6 < − 2^{63}$ , 即 $x6 > 2^{63} + 128$  不可能

综上 $-2^{63}<x6<2^{63}-1$

#### 3

溢出时：$x6 − 128 > 2^{63} − 1$ , that is $x6 > 2^{63} + 127$   不可能
或者 $x6 − 128 < − 263$ ,即 $x6 < − 2^{63} + 128$

综上$-2^{63}<x6<− 2^{63} + 128$

### 2.12

| 0000 000 | 0 0001 | 0000 1 | 000  | 0000 1 | 011 0011 |
| -------- | ------ | ------ | ---- | ------ | -------- |
| func7    | x1     | x1     |      | x1     | op       |

因此可以得到：

```assembly
add x1, x1, x1
```

### 2.13

| 0000 001 | 0 0101 | 1111 0 | 011  | 0000 0 | 010 0011 |
| -------- | ------ | ------ | ---- | ------ | -------- |
| func7    | rs2    | rs1    | fun3 | 低五位 | op       |

即

```assembly
0x25F3023 (0000001 00101 11110 011 00000 0100011)
```

### 2.23

#### 1

`UJ`指令格式最合适

`UJ`指令带循环 "参数的最大位数,从而使指令的效用最大化

#### 2

```assembly
loop: addi x29, x29, -1 #Subtract 1 from x29
blt x0, x29, loop #Continue if x29 not negative
addi x29, x29, 1 #Add back 1 that shouldn’t have been subtracted.
```

### 2.24

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

### 2.25

```assembly
		li x7, x0 # x7初始化为0
Loop1:  bge x7, x5, Exit1:
		li x29,x0
Loop2:	bge x29, x6, Exit2:
		slli x8, x29, 2
		add x8, x8, x10
		add x9, x7, x29
		sw x9, 0(x8)
		add x29, x29, 1
		jal x0 Loop2
Exit2:  addi x7, x7, 1
		jal x0 Loop1
Exit1:
```

### 2.26

总指令=外层数（内层数6+4）=$a*(b*6+4)=10*10=100$

### 2.31

```assembly
f:
	addi x2,x2,-16
	sd x1,0(×2)
	add x5,x12,x13
	sd x5,8(x2)
	jal x1, g
	ld x11,8(×2)
	jal x1,g
	ld x1,0(×2)
	addi x2,x2,16
	jalr x0, x1
```

### 2.35

1. 0x11
2. 0x88

### 2.36

```assembly
lui x10
addi x10, x10
slli ×10, x10, 32
lui ×5
addi ×5, x5
add x10, x10, x5
```

### 2.40

#### 1

 $0.7\times 2 + 0.1 \times 6 + 0.2 \times 3 = 2.6$

#### 2

要提升25%的性能，需要$ 0.7*x + 0.1*6 + 0.2*3 < = 1.95$ , 解得$x \le 1.07$

#### 3

$0.7\times x + 0.1\times 6 + 0.2\times 3 < = 1.3$.  解得$x \le 0.14$