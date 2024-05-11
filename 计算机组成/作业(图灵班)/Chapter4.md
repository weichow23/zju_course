# Chapter 4

### 4.1

| instruction | ALUsrc | MemtoReg | MemRead | MemWrite | Branch | Jump | ALUOp1 | ALUOp2 | ALUop |
| ----------- | ------ | -------- | ------- | -------- | ------ | ---- | ------ | ------ | ----- |
| and         | 0      | 0        | 1       | 0        | 0      | 0    | 1      | 0      | and   |

registers, ALUsrc mux, ALU, MemtoReg mux

all bloacks produce some output. The output of Data Memory and Imm Gen are not used

<img src="C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240507112044582.png" alt="image-20240507112044582" style="zoom:50%;" />

### 4.4

1. loads and `jal` instructions are broken
2. I-type, Loads and stores instructions are broken

### 4.6

| instruction | ALUsrc | MemtoReg | MemRead | MemWrite | Branch | Jump | ALUOp1 | ALUOp2 | ALUop |
| ----------- | ------ | -------- | ------- | -------- | ------ | ---- | ------ | ------ | ----- |
| addi        | 0      | 00       | 1       | 0        | 0      | 0    | 1      | 1      | add   |
| andi        | 1      | 00       | 1       | 0        | 0      | 0    | 1      | 1      | and   |

### 4.7

##### 4.7.1 

R-type : 30 + 250 + 150 + 25 + 200 + 25 + 20 = 700ps

##### 4.7.2 

ld : 30 + 250 + 150 + 25 + 200 + 250 + 25 + 20 = 950 ps

##### 4.7.3 

sd : 30 + 250 + 150 + 200 + 25 + 250 = 905 ps

##### 4.7.4 

beq : 30 + 250 + 150 + 25 + 200 + 5 + 25 + 20 = 705 ps

##### 4.7.5 

I-type : 30 + 250 + 150 + 25 + 200 + 25 + 20 = 700ps

##### 4.7.6 

CPU clock is the longest latency: 950 ps

### 4.9

##### 4.9.1

假设使用4.7中给定的参数，在没有修改ALU之前，clock cycle time = 950 ps

修改之后，clock cycle time = (950 + 300) ps = 1250 ps

##### 4.9.2

修改ALU之前，time = 950*IC ps

修改之后，time = 1250 * 0.95 *IC ps
$$
\text{speed up}=\frac{IC \times 950}{IC \times 0.95 \times1250}=0.8
$$


### 4.11

1. Introducing a New Functional Block: The **instruction** necessitates address computation, prompting the creation of a dedicated functional block tailored for calculating memory addresses based on the values stored in registers rs1 and rs2.
2. Adjustments to Existing Functional Blocks: The functional blocks already in place for instruction fetching, decoding, and execution must undergo modifications to identify and process the new instruction format. This adjustment entails updating control signals and instruction decoding logic.
3. Data Paths: Encouragingly, the "lwi.d" instruction can leverage the existing data paths within the **processor**. It executes a memory load operation into a register, akin to other load instructions in RISC-V. Hence, no additional data paths are necessary for this instruction.
4. Introduction of New Control Signals: The control unit is tasked with generating fresh signals to accommodate the "lwi.d" instruction. These signals play a role in activating the address calculation block, managing **memory access**, and indicating to the register the storage of the loaded value.

### 4.16

##### 4.16.1 

Pipelined: 350;
non-pipelined: 1250

##### 4.16.2 

Pipelined: 350*5=1750;

non-pipelined: 1250

##### 4.16.3 

Split the ID stage. This reduces the clock cycle time to 300ps.

##### 4.16.4 

35%.

##### 4.16.5

 65%

### 4.18

x13=33

x14=26

### 4.20

addi x11, x12, 5
NOP
NOP
add x13, x11, x12
addi x14, x11, 15
NOP
add x15, x13, x12

### 4.25

… indicates a stall. ! indicates a stage that does not do useful work.

<img src="C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240507113534802.png" alt="image-20240507113534802" style="zoom:47%;" />

During a specific clock cycle, a pipeline stage is deemed unproductive if it's either stalled or if the instruction passing through it isn't performing any meaningful tasks. As depicted in the diagram above, there are no cycles where each pipeline stage is fully engaged in productive tasks.
