# Chapter 1

### 1.2

a. Performance via Pipelining

b. Dependability via Redundancy

c. Performance via Prediction

d. Make the Common Case Fast

e. Hierarchy of Memories

f. Performance via Parallelism

g. Design for Moore's Law

h. Use Abstraction to Simplify Design

### 1.5



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

### 1.13

