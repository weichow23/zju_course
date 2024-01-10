# Q1

> a. Pleas e describe th e two kinds of parallelism in applications.
> b. Please describe the four major ways to exploit the preceding two kinds of application parallelism.
> c. Please describe the principle of dynamic voltage frequency scaling ( DVFS
> d. Please describe the principle of overclocking.

### a. 

**DLP(Data-Level Parallelism)**

many data items being operated on at the same time;

distribute the same data across different processors;

**TLP (Task-Level Parallelism)**

tasks of work created to operate independently and largely in parallel;

run many different tasks at the same time on the same data;

### b. 

**ILP**: Instruction-Level Parallelism

**Vector Architectures**, GPUs, and MM

**TLP:** Thread-Level Parallelism

![image-20231126230026891](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20231126230026891.png)

**RLP**: Request-Level Parallelism

### c.

scale down clock frequency and voltage during periods of low activity

<img src="C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20231126225939803.png" alt="image-20231126225939803" style="zoom:47%;" />

<img src="C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20231126230003422.png" alt="image-20231126230003422" style="zoom:50%;" />

### d.

 the chip runs at a higher clock rate for a short time until temperature rises.

Intel started offering Turbomodein 2008,wherethechipdecides that it is safe to run at a higher clock rate for a short time, possibly on just a few cores, until temperature starts to rise. For example, the 3.3 GHz Core i7 can run in short bursts for 3.6 GHz. Indeed, the highest-performing microprocessors each year since 2008 shown in Figure 1.1 have all offered temporary overclock- ing of about 10% over the nominal clock rate. For single-threaded code, these microprocessors can turn off all cores but one and run it faster. Note that, although the operating system can turn off Turbo mode, there is no notification once it is enabled, so the programmers may be surprised to see their programs vary in performance because of room temperature! 

# Q2

Decrease the CPI of FPSQR to 2: 
$$
CPI=0.23*4+0.02*20+0.75*1.33=2.3175
$$
Decrease the average CPI of all FP operations to 2.5: 
$$
CPI=0.25*2.5+0.75*1.33=1.6225
$$
so, **Decrease the average CPI of all FP operations to 2.5 is better**

# Q3

### a

128 byte  cache with 4 byte each block  $\to$ 32 blocks

 $miss$ $rate=0$. As $64/4=16<32$, after the initial loop, all the instruction will be in the cache.

### b

$miss$ $rate=1$

For a 192-byte loop, with each loop containing 48 instructions, the cache miss rate is 100% because the instructions repeatedly replace each other in the cache. For a 320-byte loop, with each loop containing 80 instructions, the cache miss rate is also 100% due to the replacement pattern.

### c

If the cache replacement policy is changed to Most Recently Used (MRU):

- For a 64-byte loop, $miss$ $rate=0$ as there is no replacement.
- For a 320-byte loop, with 80 instructions, the $miss$ $rate=1$ regardless of the policy.
- For a 192-byte loop, with 48 instructions, the miss rate improves compared to the previous LRU policy, as only one set of instructions is missed in each loop iteration instead of two, so miss rate decrease to $miss$ $rate=0.5$

# Q4

### a

$0.95 * 1 + 0.05 * 105 = 6.2 cycles$

### b

$64KB/256MB=1/2^8$

average access time = $1/2^8 *1 + (1-1/2^8)*105=104.975cycles$

### c

$$
T_{avg}=r*(T_{mem}+L)+(1-r)*(T_{mem}-G)\\=rL+rG-G+T_{mem}
$$

ie,
$$
T_{avg}-T_{mem}=rL+rG-G>0\\r>\frac{G}{L+G}
$$


# Q5

#$block=2*10^{20}*8/(2^6*16)=2^{14}$

#$sets=$#$blcok/$#$ways$=$2^{10}$

$index=log_2{2^{10}}=10$

$offset=log_2{(16*2)}=5$

$tag=64-index-offset=49$

# Q6

for me, the biggest challenge is the English lectures, I often do not know what the teacher is talking about, although I plan to go to the U.S. in the future, I also want to take the TOEFL, but the test and the actual class experience is still very different, I feel particularly difficult to adapt, but I would like to call it a challenge rather than a difficulty, because it is what I have to face.

I feel that architecture is becoming more and more important when it comes to big models nowadays, and understanding some of the underlying arithmetic and scheduling logic is very helpful for our majors no matter what direction we are going to take, especially because Assignment 1 provides such an opportunity. However, I hope that this kind of assignment is for a single person, because it's really hard to coordinate among many people, and eventually it may turn into a one-person job, from interest-driven to a little bit tasteless, which is still quite difficult.

After graduation, I may plan to go to the US or Canada for graduate school, whether I want to do a master's degree or a PhD depends on the results of my application. hhh. I feel like the biggest challenge is that it's too voluminous, there are too many people doing AI right now, and it takes a lot of arithmetic resources (which I don't have much access to) to do some really good work. I had two failed experiences before, the first one is for an off-campus lab to mark data to make a website about 4 months wasted, the grade point also dropped a lot, that time is the first time to enter the lab, and then decisively run away, at that time do not feel the pit (by the teacher drew a big cake), and then run away only to realize that fortunately did not stay long; the other one is his first LEAD a one-work project (before), I did not have any publishing experience. The other part was the first time I led a one-work project (I didn't have any publishing experience before that), and the teacher who brought me along was particularly unhelpful, and I stepped on a lot of potholes in the process, such as not doing a good job of researching the literature, failing to do anything with the problem and methodology locked up, and failing to learn how to communicate effectively (the reason why my brother was unhelpful may be due to the fact that I didn't quite know how to do a PowerPoint at that time, and also I didn't know how to clearly explain my idea and the difficulties I encountered, which led to I think the reason why my brother was not interested is probably because I was not very good at making PowerPoints, and I did not know how to clearly explain my ideas and the difficulties I encountered, which led to the fact that my brother was very tired of listening to me every time. I envy some of my classmates around me, who started out in the better groups in the school, had some good teachers and seniors to bring them up, and already had a good output. However, I think that after I went through this, I am more robust, or maybe it's just the experience. Hopefully I can go to the school I want to go to when I graduate afterward and find the right Miss !
