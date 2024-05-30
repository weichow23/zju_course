### 5 .11

##### 5.11.1 

Each line in the cache will have a total of six blocks (two in each of three ways). There will be a total of 48/6 = 8 lines

##### 5.11.2

| word address | binary address | tag  | hit/miss | content                 |
| ------------ | -------------- | ---- | -------- | ----------------------- |
| 0x03         | 0000 0011      | 0x03 | M        | 3                       |
| 0xb4         | 1011 0100      | 0xb4 | M        | 3,b4                    |
| 0x2b         | 0010 1011      | 0x2b | M        | 3,b4,2b                 |
| 0x02         | 0000 0010      | 0x02 | M        | 3,b4,2b,2               |
| 0xbe         | 1011 1110      | 0xbe | M        | 3,b4,2b,2,be            |
| 0x58         | 0101 1000      | 0x58 | M        | 3,b4,2b,2,be,58         |
| 0xbf         | 1011 1111      | 0xbf | M        | 3,b4,2b,2,be,58,bf      |
| 0x0e         | 0000 1110      | 0x0e | M        | 3,b4,2b,2,be,58,bf,e    |
| 0x1f         | 0001 1111      | 0x1f | M        | 3,b4,2b,2,be,58,bf,e,1f |
| 0xb5         | 1011 0101      | 0xb5 | M        | 2b,2,be,58,bf,e,1f,b5   |
| 0xbf         | 1011 1111      | 0xbf | H        | 2b,2,be,58,e,1f,b5,bf   |
| 0xba         | 1011 1010      | 0xba | M        | 2,be,58,e,1f,b5,bf,ba   |
| 0x2e         | 0010 1110      | 0x2e | M        | be,58,e,1f,b5,bf,ba,20  |
| 0xce         | 1100 1110      | 0xce | M        | 58.e,1f,b5,bf,ba,2e,ce  |

##### 5.11.4

![image-20240529191225337](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240529191225337.png)

##### 5.11.6-5.11.8

| Word Address | Binary Address | Tag  | Offset | Hit/Miss | Contents                           |
| ------------ | -------------- | ---- | ------ | -------- | ---------------------------------- |
| 0x03         | 0000 0011      | 0x01 | 1      | M        | [2,3]                              |
| 0xb4         | 1011 0100      | 0x5a | 0      | M        | [2,3], [b4,b5]                     |
| 0x2b         | 0010 1011      | 0x15 | 0      | M        | [2,3], [b4,b5], [2a,2b]            |
| 0x02         | 0000 0010      | 0x01 | 0      | H        | [b4,b5], [2a,2b], [2,3]            |
| 0xbe         | 1011 1110      | 0x5f | 0      | M        | [b4,b5], [2a,2b], [2,3], [be,bf]   |
| 0x58         | 0101 1000      | 0x2c | 0      | M        | [2a,2b], [2,3], [be,bf], [58,59]   |
| 0x0e         | 0000 1110      | 0x07 | 0      | M        | [2,3], [58,59], [be,bf], [e,f]     |
| 0x1f         | 0001 1111      | 0x0f | 0      | M        | [58,59], [be,bf], [e,f], [1e,1f]   |
| 0xb5         | 1011 0101      | 0x5a | 1      | H        | [be,bf], [e,f], [1e,1f], [b4,b5]   |
| 0xbf         | 1011 1111      | 0x5f | 1      | H        | [e,f], [1e,1f], [b4,b5], [be,bf]   |
| 0xba         | 1011 1010      | 0x5d | 0      | M        | [1e,1f], [b4,b5], [be,bf], [ba,bb] |
| 0x2e         | 0010 1110      | 0x17 | 0      | M        | [b4,b5], [be,bf], [ba,bb], [2e,2f] |
| 0xce         | 1100 1110      | 0x67 | 0      | M        | [be,bf], [ba,bb], [2e,2f], [ce,cf] |

### 5.16

##### 5.16.1

| Address      | Virtual Page | TLB H/M  | Valid             | Tag  | Physical Page |
| ------------ | ------------ | -------- | ----------------- | ---- | ------------- |
| 4669 0x123d  | 1            | TLB miss | 1                 | b    | 12            |
|              |              | PT hit   | 1                 | 7    | 4             |
|              |              | PF       | 1                 | 3    | 6             |
|              |              |          | 1 (last access 0) | 1    | 13            |
| 2227 0x08b3  | 0            | TLB miss | 1                 | 7    | 4             |
|              |              | PT hit   | 1                 | 3    | 6             |
|              |              |          | 1 (last access 1) | 0    | 5             |
|              |              |          | 1                 | 1    | 13            |
| 13916 0x365c | 3            | TLB miss | 1                 | 7    | 4             |
|              |              | PT hit   | 1 (last access 2) | 3    | 6             |
|              |              |          | 1 (last access 0) | 1    | 13            |
| 34587 0x871b | 8            | TLB miss | 1 (last access 3) | 8    | 14            |
|              |              | PT hit   | 1 (last access 2) | 3    | 6             |
|              |              | PF       | 1 (last access 0) | 1    | 13            |
|              |              |          | 1 (last access 1) | 0    | 5             |
| 48870 0xbee6 | b            | TLB miss | 1 (last access 3) | 8    | 14            |
|              |              | PT hit   | 1 (last access 2) | 3    | 6             |
|              |              |          | 1 (last access 4) | b    | 12            |
| 12608 0x3140 | 3            | TLB miss | 1 (last access 1) | 0    | 5             |
|              |              | PT hit   | 1 (last access 5) | 8    | 14            |
|              |              |          | 1 (last access 5) | 3    | 6             |
| 49225 0xc040 | c            | TLB miss | 1 (last access 5) | 3    | 6             |
|              |              | PT hit   | 1 (last access 4) | b    | 12            |
|              |              | PF       |                   |      |               |

##### 5.16.2

| Address      | Virtual Page | TLB H/M  | Valid             | Tag  | Physical Page |
| ------------ | ------------ | -------- | ----------------- | ---- | ------------- |
| 4669 0x123d  | 1            | TLB miss | 1                 | 11   | 12            |
|              |              | PT hit   | 1                 | 7    | 4             |
|              |              |          | 1                 | 3    | 6             |
|              |              |          | 1 (last access 0) | 0    | 5             |
|              |              |          | 1                 | 11   | 12            |
| 2227 0x08b3  | 0            | TLB hit  | 1                 | 7    | 4             |
|              |              |          | 1                 | 3    | 6             |
|              |              |          | 1 (last access 1) | 0    | 5             |
|              |              |          | 1                 | 11   | 12            |
| 13916 0x365c | 0            | TLB hit  | 1                 | 7    | 4             |
|              |              | PT hit   | 1                 | 3    | 6             |
|              |              |          | 1 (last access 2) | 0    | 5             |
|              |              |          | 1 (last access 3) | 2    | 13            |
| 34587 0x871b | 2            | TLB miss | 1                 | 7    | 4             |
|              |              | PT hit   | 1                 | 3    | 6             |
|              |              | PF       | 2                 | 0    | 5             |
|              |              |          | 1 (last access 4) | 2    | 13            |
| 48870 0xbee6 | 2            | TLB hit  | 1                 | 7    | 4             |
|              |              | PT hit   | 1                 | 3    | 6             |
|              |              |          | 1 (last access 2) | 0    | 5             |
|              |              |          | 1 (last access 4) | 2    | 13            |
| 12608 0x3140 | 0            | TLB hit  | 1                 | 7    | 4             |
|              |              | PT hit   | 1                 | 3    | 6             |
|              |              |          | 5                 | 0    | 5             |
|              |              |          | 1 (last access 4) | 2    | 13            |
| 49225 0xc040 | 3            | TLB hit  | 1                 | 7    | 4             |
|              |              | PT hit   | 1                 | 3    | 6             |
|              |              |          | 1 (last access 6) | 5    | 0             |
|              |              |          | 1 (last access 5) | 0    | 5             |

larger page size cause lower TLB miss rate but lower use of physical memory  

##### 5.16.3

| Address      | Virtual Page | Tag  | Index | TLB H/M  | Valid              | Tag  | Physical Page | Index |
| ------------ | ------------ | ---- | ----- | -------- | ------------------ | ---- | ------------- | ----- |
| 4669 0x123d  | 1            | 0    | 1     | TLB miss | 1                  | b    | 12            | 0     |
|              |              |      |       | PT hit   | 1                  | 7    | 4             | 1     |
|              |              |      |       | PF       | 1                  | 3    | 6             | 0     |
|              |              |      |       |          | 1 (last access 0)  | 0    | 13            | 1     |
| 2227 0x08b3  | 0            | 0    | 0     | TLB miss | 1 (last access 1)  | 0    | 5             | 0     |
|              |              |      |       | PT hit   | 1                  | 7    | 4             | 1     |
|              |              |      |       |          | 1                  | 3    | 6             | 0     |
|              |              |      |       |          | 1 (last access 0)  | 0    | 13            | 1     |
| 13916 0x365c | 3            | 1    | 1     | TLB miss | 1 (last access 1)  | 0    | 5             | 0     |
|              |              |      |       | PT hit   | 11 (last access 2) | 1    | 6             | 1     |
|              |              |      |       |          | 1                  | 3    | 6             | 0     |
|              |              |      |       |          | 1 (last access 1)  | 1    | 13            | 1     |
| 34587 0x871b | 8            | 4    | 0     | TLB miss | 1 (last access 1)  | 0    | 5             | 0     |
|              |              |      |       | PT hit   | 1 (last access 2)  | 1    | 6             | 1     |
|              |              |      |       | PF       | 1 (last access 3)  | 4    | 14            | 0     |
|              |              |      |       |          | 1 (last access 0)  | 1    | 13            | 1     |
| 48870 0xbee6 | b            | 5    | 1     | TLB miss | 1 (last access 1)  | 0    | 5             | 0     |
|              |              |      |       | PT hit   | 1 (last access 2)  | 1    | 6             | 1     |
|              |              |      |       |          | 1 (last access 3)  | 4    | 14            | 0     |
|              |              |      |       |          | 1 (last access 4)  | 5    | 12            | 1     |
| 12608 0x3140 | 3            | 1    | 1     | TLB hit  | 1 (last access 1)  | 0    | 5             | 0     |
|              |              |      |       | PT hit   | 1 (last access 5)  | 1    | 6             | 1     |
|              |              |      |       |          | 1 (last access 3)  | 4    | 14            | 0     |
|              |              |      |       |          | 1 (last access 4)  | 5    | 12            | 1     |
| 49225 0xc049 | c            | 6    | 0     | TLB miss | 1 (last access 6)  | 6    | 15            | 0     |
|              |              |      |       | PT miss  | 1 (last access 5)  | 1    | 6             | 1     |
|              |              |      |       | PF       | 1 (last access 3)  | 4    | 14            | 0     |
|              |              |      |       |          | 1 (last access 4)  | 5    | 12            | 1     |

##### 5.16.4

| Address      | Virtual Page | Tag  | Index | TLB H/M  | Valid | Tag  | Physical Page | Index |
| ------------ | ------------ | ---- | ----- | -------- | ----- | ---- | ------------- | ----- |
| 4669 0x123d  | 1            | 0    | 1     | TLB miss | 1     | b    | 12            | 0     |
|              |              |      |       | PT hit   | 1     | 0    | 13            | 1     |
|              |              |      |       | PF       | 1     | 3    | 6             | 2     |
|              |              |      |       |          | 0     | 4    | 9             | 3     |
| 2227 0x08b3  | 0            | 0    | 0     | TLB miss | 1     | 0    | 5             | 0     |
|              |              |      |       | PT hit   | 1     | 0    | 13            | 1     |
|              |              |      |       |          | 1     | 3    | 6             | 2     |
|              |              |      |       |          | 0     | 4    | 9             | 3     |
| 13916 0x365c | 3            | 0    | 3     | TLB miss | 1     | 0    | 5             | 0     |
|              |              |      |       | PT hit   | 1     | 0    | 13            | 1     |
|              |              |      |       |          | 1     | 3    | 6             | 2     |
|              |              |      |       |          | 1     | 0    | 6             | 3     |
| 34587 0x871b | 8            | 2    | 0     | TLB miss | 1     | 2    | 14            | 0     |
|              |              |      |       | PT hit   | 1     | 0    | 13            | 1     |
|              |              |      |       | PF       | 1     | 3    | 6             | 2     |
|              |              |      |       |          | 1     | 0    | 6             | 3     |
| 48870 0xbee6 | b            | 2    | 3     | TLB miss | 1     | 2    | 14            | 0     |
|              |              |      |       | PT hit   | 1     | 0    | 13            | 1     |
|              |              |      |       |          | 1     | 3    | 6             | 2     |
|              |              |      |       |          | 1     | 2    | 12            | 3     |
| 12608 0x3140 | 3            | 0    | 3     | TLB hit  | 1     | 2    | 14            | 0     |
|              |              |      |       | PT hit   | 1     | 0    | 13            | 1     |
|              |              |      |       |          | 1     | 3    | 6             | 2     |
|              |              |      |       |          | 1     | 0    | 6             | 3     |
| 49225 0xc049 | c            | 3    | 0     | TLB miss | 1     | 3    | 15            | 0     |
|              |              |      |       | PT miss  | 1     | 0    | 13            | 1     |
|              |              |      |       | PF       | 1     | 3    | 6             | 2     |
|              |              |      |       |          | 1     | 0    | 6             | 3     |

##### 5.16.5

Without a TLB, almost every memory access would require two accesses to RAM: An access to the page table, followed by an access to the requested data.

### 5 .17

##### 5.17.1

Th tag size is 32–log2(8192) = 32–13 = 19 bits. All page tables would require 5 × (2^19 × 4) bytes = 10 MB.

##### 5.17.2 

In the two-level approach, the 2^19 page table entries are divided into 256 segments that are allocated on demand. Each of the second-level tables contains 2^(19 - 8) = 2048 entries, which means they require 8 KB each (2048 * 4) and cover 16 MB (2^24) of the virtual address space.

Assuming "half the memory" refers to 2^31 bytes, the minimum amount of memory required for the second-level tables would be 5 * (2^31 / 2^24) * 8 KB = 5 MB. The first-level tables would require an additional 5 * 128 * 6 bytes, which equals 3840 bytes. 

The maximum amount of memory required would be if all first-level segments were activated, utilizing all 256 segments in each application. In this case, the second-level tables would require 5 * 256 * 8 KB = 10 MB, and the first-level tables would require 7680 bytes.

##### 5.17.3

The page index consists of 13 bits (address bits 12 down to 0).

A 16 KB direct-mapped cache with two 64-bit words per block would have 16-byte blocks, resulting in 16 KB/16 bytes = 1024 blocks. Therefore, it would have 10 index bits and 4 offset bits, and the index would extend beyond the page index.

To address this issue, the designer could increase the cache's associativity. By increasing the associativity, the number of index bits would be reduced, allowing the cache's index to fit entirely within the page index.

### 5.20

##### 5.20.1

There are no hits.

##### 5.20.2 

Direct mapped

| 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 0    |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| M    | M    | M    | M    | M    | M    | M    | M    | H    | H    | M    | M    | M    | M    | H    | H    | M    |

##### 5.20.3 

Answers will vary.

##### 5.20.4 

MRU (Most Recently Used) is an optimal policy.

##### 5.20.5 

The best block to evict is the one that will cause the fewest misses in the future. Unfortunately, a cache controller cannot predict the future. Our best alternative is to make a good prediction.

##### 5.20.6 

If you knew that an address had limited temporal locality and would conflict with another block in the cache, choosing not to cache it could improve the miss rate. On the other hand,