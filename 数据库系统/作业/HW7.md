### 7.1

 $R_1 \cap R_2 = A$.
Since $A$ is a candidate key, $R_1 \cap R_2 \rightarrow R_1$.

so this decomposition is a lossless decomposition

### 7.13

<img src="p06.png" style="zoom:67%;" />

$(F_1 \cup F_2)^+$ is easily seen not to contain $B \rightarrow D$ 

### 7.21

B->D. 是非平凡的,而且B不是superkey, 所以B在两边都有

$\{{(A,B,C,E), (B,D)}\}$是BCNF的

### 7.22

$R = \{(A,B,C) , (C,D,E) , (B,D), (E,A) \} $

### 7.30

> a. Compute $B^+$.

$B^+ = \{A, B, C, D, E\}$

> b. Prove (using Armstrong's axioms) that $AG$ is a superkey. 

$A \rightarrow BCD$  （已知条件） 

$A \rightarrow BC$ （分解律）

$BC \rightarrow DE$ （已知条件）

因此，$A \rightarrow BCDE$ 

两侧再同乘$AG$, 最后可以得到 $AG \rightarrow ABCDEG$.

这说明了$AG$ 是$super$ $key$



用简洁准确的语言(适当改变语序）将下文翻译为中文并且在符号和公式两端加上$以适应markdown排版

> c. Compute a canonical cover for this set of functional dependencies $F$; giveeach step of your derivation with an explanation.

$A \rightarrow BCD$  中的$D$是多余的，所以去掉它

$BC \rightarrow DE$ 中的$D$也是多余的，所以去掉它

最后可以得到 $F$ 的一个标准覆盖：

$$
A \rightarrow BC \\
BC \rightarrow E \\
B \rightarrow D \\
D \rightarrow A \\
$$

> d. Give a 3NF decomposition of the given schema based on a canonical cover. 

由c中得到的标准覆盖，可以得到一个$3NF$

$$
\{ \{A,B,C\}, \{B,C,E\}, \{B,D\}, \{D,A\}, \{A,G\}\}
$$

> e. Give a BCNF decomposition of the given schema using the original set $F$ of functional dependencies. 

$$
\{ \{A,B,C\}, \{B,D\}, \{A, E\}, \{A,G\}\}
$$
