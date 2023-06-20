### 12.1

>SSDs can be used as a storage layer between memory and magnetic disks, with some parts of the database (e.g., some relations) stored on SSDs and the rest on magnetic disks. Alternatively, SSDs canbeusedasabufferorcachefor magnetic disks; frequently used blocks would reside on the SSD layer, while infrequently used blocks would reside on magnetic disk. 
>
>a. Which of the two alternatives would you choose if you need to support real-time queries that must be answered within a guaranteed short period of time? Explain why. 
>
>b. Which of the two alternatives would you choose if you had a very large customer relation, where only some disk blocks of the relation are accessed frequently, with other blocks rarely accessed.

a. 在第一种情况下，**SSD作为存储层更好**，因为性能得到了保证。当支持需要保证响应时间的实时查询时，必须选择一个能够提供稳定性能的存储选项。在这种情况下，利用固态硬盘作为内存和磁性磁盘之间的存储层是更好的选择。通过将数据库的某些部分存储在SSD上，可以大大减少数据访问时间。相反，如果经常请求的数据必须从磁片上检索，使用固态硬盘作为缓存可能会导致延迟。因此，使用固态硬盘作为存储层为实时查询提供了一个更可靠的解决方案

b. SSD作为**缓存选项**在这种情况下效果更好。当处理一个大的客户关系时，只有一些磁盘块被频繁访问，要确定哪种存储方案更有利，是比较有挑战性的。由于不可能将整个关系分配给SSD，使用SSD作为存储层是不现实的。在这种情况下，利用固态硬盘作为经常使用的块的缓存，并将其余的数据存储在磁性磁盘上，提供了一个更实用的解决方案。通过利用固态硬盘作为缓存，可以更快地访问频繁访问的块，减少整体响应时间。因此，在这种情况下，使用固态硬盘作为频繁访问数据的缓存是更好的选择

### 13.5

> It is important to be able to quickly find out if a block is present in the buffer, and if so where in the buffer it resides. Given that database buffer sizes are very  large, what (in-memory) data structure would you use for this task? 

在处理大型数据库缓冲区时，有一种快速有效的方法来确定一个区块是否存在于缓冲区中，如果是的话，它在其中的位置是至关重要的。**哈希表**(散列）是大型数据库缓冲区的常见选择。

哈希表使用一个哈希函数将块的键映射到哈希表中的一个特定桶。一旦找到了合适的桶，就可以在其中进行线性搜索，以确定该块是否存在，如果存在，则确定它在缓冲区的位置。使用哈希表可以大大减少在缓冲区内搜索一个块所需的时间，特别是在处理大型数据库时。因此，它是一种理想的数据结构，用于管理数据库缓冲区并确保有效地访问它们所包含的数据

### 13.9

> In the variable-length record representation, a null bitmap is used to indicate if an attribute has the null value. 
>
> a. For variable-length fields, if the value is null, what would be stored in the  offset and length fields?
>
> b. In some applications, tuples have a very large number of attributes, most of  which are null. Can you modify the record representation such that the only overhead for a null attribute is the single bit in the null bitmap? 

a. 在可变长度的记录表示中，空位图用来表示一个属性是否有一个空值。当一个值为空时，应该把**-1**存储在长度字段中，任何值都可以被存储在偏移量字段中，因为该字段为空

b. 是的。为了尽量减少空属性的开销，可以使用修改过的记录表示法。在这种表示法中，空位图被存储在记录的开头。这种方法不需要存储空属性的数据值或偏移/长度，减少了存储空间。然而，从记录中提取属性需要额外的工作。这种方法对有大量字段的应用特别有用，因为大多数字段是空的

### 13.11

> List two advantages and two disadvantages of each of the following strategies for storing a relational database: 
>
> a. Store each relation in one file. 
>
> b. Store multiple relations (perhaps even the entire database) in one file. 

#### 策略(a) - 在一个文件中存储每个关系：

优点：

- 把经常使用的关系放在固态硬盘上，其余的放在磁性磁盘驱动器上，这样更容易优化存储
- 当把关系从硬盘读到内存时，由于区块就近存储在盘片上，从而减少了磁盘臂的移动，所以速度更快

缺点：

- 由于每个关系都存储在它自己的文件中，所以不能进行诸如可多聚类文件组织的优化
- 访问一个关系需要首先通过数据字典/系统目录来定位文件的路径，产生开销

#### 策略（b）--在一个文件中存储多个关系（甚至可能是整个数据库）：

优点：

- 如果需要的话，可以进行优化，比如多级聚类文件组织
- 打开数据库只需要调用一次open()系统调用

缺点：

- 将所有关系存储在一个文件中，使我们无法从从硬盘到主内存的顺序读取中受益
- 不可能通过将经常使用的关系放在固态硬盘上，而将其余的关系放在磁性磁盘驱动器上来优化存储
