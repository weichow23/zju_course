# Chapter 1

### 1.1

- Embedded computer: 运行一个应用程序或一组相关的应用集成到一个单一的系统
- PC：个人电脑
- Server：远程访问的计算机
- Supercomputer：一般用于科学计算

### 1.2

a. Performance via Pipelining

b. Dependability via Redundancy

c. Performance via Prediction

d. Make the Common Case Fast

e. Hierarchy of Memories

f. Performance via Parallelism

g. Design for Moore's Law

h. Use Abstraction to Simplify Design

### 1.4

a. $1280 \times 1024 \quad pixels=1280 \times 1024 \times 3 = 3,932,160 \quad bytes/frame$

b. $3,932,160 \times 8 / 10^6 = 0.31\quad seconds$

### 1.6

#### a

$Time=\frac{指令数*CPI}{时钟频率}$

$TotalTime(P1)=\frac{10^5+2*10^5*2+5*10^5*3+2*10^5*3}{2.5*10^9}=10.4*10^{-4}s$

$TotalTime(P2)=\frac{10^5*2+2*10^5*2+5*10^5*2+4*10^5}{3*10^9}=6.66*10^{-4}s$

$CPI(P1)=\frac{10.4*10^{-4}*2.5*10^9}{10^6}=2.6$

$CPI(P2)=\frac{6.66*10^{-4}*3*10^9}{10^6}=2.0$

#### b

Total cycles of $P1 = 10^5 + 2 × 10^5 × 2 + 5 × 10^5 × 3 + 2 × 10^5 × 3 = 2.6 \times 10^6$
Total cycles of $P2 = 10^5 × 2 + 2 × 10^5 × 2 + 5 × 10^5 × 2 + 2 × 10^5 × 2 = 2 \times 10^6$

### 1.7

#### a

$Time=\frac{指令数*CPI}{时钟频率}$

Compiler  $CPI(A) = 1.1$
Compiler $CPI(B) = 1.25$

#### b

$$
\frac{f_B}{f_A}=(\frac{CPI_B*Instr_B}{CPI_A*Instr_A})=1.37
$$

#### c

$$
for A:\frac{T_A}{T_{new}}=1.67\\
for B:\frac{T_B}{T_{new}}=2.27
$$

### 1.14

#### a

$$
clock \quad circle =n_{FP}*CPI_{FP}+n_{int}*CPI_{int}+n_{L/S}*CPI_{L/S}+n_{branch}*CPI_{branch}\\
T_{CPU}=\frac{clock \quad circle}{clock \quad rate}=\frac{512*10^6}{2*10^9}=0.256s
$$

$T_{CPU}$要为$0.128s$，$clock\quad circle$要变为$256*10^6$,此时

$CPI_{FP'}=\frac{256-462}{50}<0$, 所以不可能

#### b

$$
CPI_{improved} = ((1*50 + 1*110+4*80+2*16) /2 – (1*50+1*110+2*16))/80 =
64 /80 = 0.8
$$

#### c

$$
((50+110)*0.6 + (4*80+ 2* 16)* 0.7 ) / 512 = 66.875\%
$$
