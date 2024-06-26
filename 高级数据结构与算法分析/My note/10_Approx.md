[TOC]



# 11 Approximation algorithm 近似算法

近似算法会严格控制界

### $ρ(n)$近似算法

 $\rho(n)$ 近似比 (Approximation Ratio)：

对任意问题规模$n$ ，近似算法得到解的cost $C$ 和最优解的cost  $C^*$的比值不超过 $\rho(n)$

$$
1\le max(\frac{C}{C^∗},\frac{C^∗}{C})≤ρ(n)
$$

### $(1+\varepsilon)$近似算法

近似模式 (approximation scheme)：

近似算法有两个输入：一个是问题的实例 (instance)，另一个是$\varepsilon$ ，使得给定$\varepsilon$ ，近似比是$1+\varepsilon$  

其中$\varepsilon$越小，精度越高

- **多项式时间近似模式 (PTAS, polynomial-time approximation scheme) **

  给定任意有理数ε> 0, 该模式可以在**输入规模n的多项式时间内**完成

  如$O(n^{2/ε}) $

- **完全多项式时间近似模式 (FPTAS, fully polynomial-time approximation scheme) **

  给定任意有理数ε> 0, 返回x的一个（1+ε）近似解在**n和1/ε的多项式时间内**

  如$O((1/ε)^2n^3)$

### 装箱问题 Bin Packing

把一定数量$N$的物品$S_1 , S_2 , …, S_N$放入容量相同的一些箱子中,使得每个箱子中的物品大小之和不超过箱子容量$C$并使所用的箱子数目最少。是NPH问题

![](image\image-20200508003313631.png)

下列三种是离线算法

#### Next Fit

只看最后一个塞不塞的下

最优解$M$， next fit 的==**近似解不超过$2M-1$**==

If Next Fit generates **2M (or 2M+1)** bins, then the optimal solution must generate at least **M+1** bins.s

#### First Fit

把所有的从前往后扫一遍

Let M be the optimal number of bins required to pack a list I of items. Then first fit **never uses more than $17M / 10$ bins**. There exist sequences such that first fit uses 17(M – 1) / 10 bins. ==1.7M==

#### Best Fit

所有的集装箱里面找个最后容积更小的  ==1.7M==

**$T = O( N log N )$  bin ≤ 1.7M  近似比和First Fit一样**  

#### 在线算法 Online Algorithms

上面三种都是在线算法

**No** on-line algorithm can always give an optimal solution.

对于装箱问题：何在线装箱算法使用至少 **5/3** 的最佳箱子数量 ==下界 5/3==

#### 离线

物品装载以前就已得到所有物品信息,之后统一处理所有物品的近似算法称为**离线 (offline)装箱算法**

**first/best fit decreasing**: 排序后先放大的， 不超过**11**M **/ 9** **+** **6/9** **bins**   ==11/9==

Simple **greedy heuristics** can give good results.

### 背包问题 Knapsack Problem

给定$N$种物品，物品$i$的重量为$w_i$，价格为$p_i$，背包所能承受的最大重量为$M$。如何选择使得物品的总价格最高。

#### fractional version

可切割版本可以得到精确解

Pack one item into the knapsack in each stage, and be greedy on **maximum profit density $p_i/w_i$** (性价比最高)

按照性价比选，那最多只有一个切

#### 0-1背包问题 0-1 version

$x_i$ is either 1 or 0 每种物品只能选择0或1个， 不可切分， 是个NPC问题

greedy on maximum profit (最大价值) or profit density (性价比)  $\rho=2$，==2==

pmax是所有物品中的最优，opt是不可切的最优的，frac是可切的解

#### 动态规划解法

套路，规模放进来。然后发现容量没了，所以再放进来容量

$W_{i, p}$ = the minimum weight of a collection from $\{1, …, i \}$ with total profit being  exactly p

**$O(N^2p_{max})$**

![image-20200508131147042](image\image-20200508131147042.png)

$p_{max}$ 很大就同除一个数，就可以降低复杂度了

注意这个的复杂度是**伪多项式的, 具有 FPTAS**

### 选址问题 (中心选择问题, The K-center Problem)

这部分推荐看[xy的](https://note.isshikih.top/cour_note/D2CX_AdvancedDataStructure/Lec11/#%E6%A1%88%E4%BE%8B-the-k-center-problem)  顺带的还有总结也看一下

近似比是==2==



------

### 题目

> [作业里面前3题的解析](https://blog.csdn.net/HGGshiwo/article/details/117435259)
>
> 1. 为中国邮递员问题设计近似比为**2**的算法
>
>    ![image-20200508151615638](image\image-20200508151615638.png)
>
> **Chinese Postman Problem(中国邮路问题, 中国邮递员问题)**
>
> 邮递员每天从邮局出发，走遍该地区所有街道再返回邮局，他应如何安排送信的路线可以使所走的总路程最短。
>
> 给定一个连通图G，每边e有非负权，要求一条回路经过每条边至少一次，且满足总权最小。
