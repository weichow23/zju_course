### 1.7

> List four significant differences between a file-processing system and a DBMS

1. 数据库管理系统协调对数据的物理和逻辑访问，而文件处理系统仅协调物理访问。
2. DBMS 可以让数据方便多个程序共享，而文件处理系统中一个程序编写的数据可能无法被另一个程序读取。
3. 数据库管理系统旨在允许对数据的灵活访问，而文件处理系统旨在允许对数据的预定访问。
4. 数据库管理系统可以用事务等方法控制多个用户同时访问相同数据。文件处理系统一般不允许多个程序同时访问一个数据文件。
5. DBMS可以有效应对数据不一致、数据孤立、存取数据困难、完整性、原子性、并发性访问等文件处理系统无法解决的问题。

### 1.8

>Explain the concept of physical data independence and its importance in database systems.

物理数据独立性是将存储介质中存储的物理数据与程序员编写的逻辑结构分离开来的特性，这样程序员就不必担心处理物理数据，而只需要处理逻辑层，从而减轻数据库设计和编程的负担

### 1.9

> List five responsibilities of a database-management system. For each responsibility, explain the problems that would arise if the responsibility were not discharged.

a. interaction with the file manager.

DBMS不能工作，因为它不能搜索存储在磁盘中的任何东西

b. integrity keeping.

多种文件格式，不同文件中的信息重复

c. security protection.

数据或者隐私泄露

d. backup and recovery.

数据遗失

e. concurrency-access anomaly protection.
可能被恶意篡改，或可能导致违反一致性约束，导致数据错误

### 1.15

> Describe at least three tables that might be used to store information in a social networking system such as Facebook.

1. 用户表，包含用户微信号，用户名，用户电话号码，用户头像，用户邮箱等
2. 微信钱包，包含用户的余额，交易流水等
3. 好友表，包含好友的用户微信名、备注、好友的基本信息等