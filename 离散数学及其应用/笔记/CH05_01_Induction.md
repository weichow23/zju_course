<font size=6> Chaptcer 05 Induction and Recursion 归纳与递归</font>

> 第五章（挺重要的）
>
>  5.1数学归纳法（为什么是正确的，需要掌握）
>
>  强数学归纳法
>
> well ordering 
>
> 怎么用递归定义（必须掌握）
>
>  结构化数学归纳法（花点功夫）
>
>  5.5不做要求

------

# Mathematical Induction 数学归纳法

## Framework 基本框架

![](img/CH05/01.PNG)

Express this in the proposition form:（==当然，也可以不从1开始==）

$$P(1)\wedge\forall k(P(k)\to P(k+1))\to\forall nP(n)$$

This is the (first) principle of Mathematical Induction, and it also has the following form
$$P(1)\\\underline{\forall k(P(k)\to P(k+1))}\\\therefore\forall nP(n)$$

## The Validity of Mathematical Induction 数学归纳法的有效性

 **the well-ordering property**（**良序性公理**） ：任意一个**非空**的**非负整数集合**都有最小元素

#### Why Mathematical Induction is Valid

Proof:

Assume that there is at least one positive integer for which *P*(*n*) is false.

*S*: the set of positive integers for which *P*(*n*) is false.

Then *S* is nonempty.

By the well-ordering property, *S* has a least element, which will be denoted by *m*.

Then $$m\ne1$$, *m*-1 is a positive integer. *m-1* is not in *S.* So *P*(*m* -1) is true.

Since the implication $$P(m-1)\to P(m)$$ is also true, *P*(*m*) must be true. 

By contradiction, $$\forall nP(n)$$ 

# Strong Induction 强归纳法

## Framework 基本框架

![](img/CH05/02.PNG)

This is also the second principle of Mathematical Induction

$$(P(n_0)\wedge\forall k\geq n_0(P(n_0)\wedge P(n_0+1)\wedge...\wedge P(k)\to P(k+1)))\to\forall n\geq n_0(P(n))$$

变形形式：

![](img/CH05/03.PNG)

# Connection Between the Three Things 三者关系

The Mathematical Induction, the Strong Induction, and the well-ordering property is actually the same thing!

## 1. From W.P to M.I

See the validity of M.I, where the proof from W.P to M.I is given. We will omit the proof here.

## 2. From W.P to S.I

> Show that strong induction is a valid method of proof by showing that it follows from the well-ordering property

Assume that the well-ordering property holds. Suppose that P(1) is true and that the conditional statement $$[P(1)\wedge P(2)\wedge· · ·\wedge P(n)]\to P(n+1)$$ is true fore very positive integer n. Let S be the set of positive integers n for which P(n) is false.We will show S = ∅. Assume that $$S\neq \emptyset$$. Then by the well-ordering property there is a least integer m in S.We know that m cannot be 1 because P(1) is true. Because n = m is the least integer such that P(n) is false, P(1), P(2), . . . , P (m−1) are true, and m−1 ≥ 1. Because $$[P(1)\wedge P(2)\wedge· · ·\wedge P(m-1)]\to P(m)$$ is true, it follows that P(m) must also be true, which is a contradiction. Hence, S = ∅.

## 3. From M.I to W.P

>  Show that the well-ordering property can be proved when the principle of mathematical induction is taken as an axiom.

Suppose that the well-ordering property were false. Let S be a nonempty set of nonnegative integers that has no least element. Let P(n) be the statement “$$i\notin S\ for\ i=0,1,...,n$$” P(0) is true because if 0 ∈ S then S has a least element, namely, 0. Now suppose that P(n) is true. Thus, $$0\notin S,1\notin S,...,n\notin S$$. Clearly, n+1 cannot be in S, for if it were, it would be its least element. Thus P(n+1) is true. So by the principle of mathematical induction, $$n\notin S$$ for all nonnegative integers n. Thus, S = ∅, a contradiction.

