> 数据库第五周作业

# 4.7

![image-20230321084129262](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20230321084129262.png)

```sql
CREATE TABLE employee ( 
    ID INTEGER,
    person_name VARCHAR(50),
    street VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY (ID)
);

CREATE TABLE company ( 
    company_name VARCHAR(50),
    city VARCHAR(50),
    PRIMARY KEY(company_name)
);

CREATE TABLE works (
    ID INTEGER,
    company_name VARCHAR(50),
    salary numeric(10,2),
    PRIMARY KEY(ID),
    FOREIGN KEY (ID) REFERENCES employee(ID),
    FOREIGN KEY (company_name) REFERENCES company(company_name)
);

CREATE TABLE manages ( 
    ID INTEGER,
    manager_id INTEGER, 
    PRIMARY KEY (ID), 
    FOREIGN KEY (ID) REFERENCES employee (ID), 
    FOREIGN KEY (manager_id) REFERENCES employee (ID)
)
```

# 4.9

```sql
# 题干中建立得table
create table manager (
    employee_ID char(20), 
    manager_ID char(20),
primary key employee ID, 
foreign key (manager_ID) references manager(employee_ID) on delete cascade )
```

`cascade`指当删除主表中被引用列的数据时，级联删除子表中相应的数据行。本题中，最初的删除将触发删除所有与经理直接相关的员工元组。这些删除又会导致二级员工元组的删除，依此类推，直到所有直接和间接员工元组都被删除

# 4.12

> 假设一个用户想要授予另一个用户对一个关系的**选择**访问权限。用户为什么应该在授权语句中包含（或不包含）**由当前角色授予**这个子句？

两种情况在语句执行时都给予了相同的授权，但长期效果不同。如果授权是基于角色role的，那么即使执行授权的用户离开并且该用户的账户被终止，授权仍然有效。通常通过角色授权更加清晰和利于长期维护，建议包含（最终基于对用户当前角色、常规用户帐户特权和数据库系统安全要求，如如果数据库系统的安全要求要求所有权限都必须由用户的常规用户帐户显式授予（即不使用角色或其他授予权限机制），则不应使用“由当前角色授予”的子句）。
