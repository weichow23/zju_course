> 数据库第四周作业

# 3.10

a)

```sql
UPDATE employee
SET city = 'Newtown'
WHERE ID = '12345' 
```

b)

```sql
UPDATE works as T
SET T.salary = T.salary * ( 
    CASE
        WHEN (T.salary * 1.1 > 100000) THEN 1.03
        ELSE 1.1 
    END
)
WHERE T.ID IN (SELECT manager_id FROM manages) 
    AND T.company_name = 'First Bank Corporation'
```

#  3.11

<img src="C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20230320223744928.png" alt="image-20230320223744928" style="zoom:50%;" />

a)

```sql
# 这里要求 no duplicate，因此需要使用 distinct
SELECT DISTINCT student.ID, student.name
FROM student INNER JOIN takes  ON student.ID = takes.ID 
             INNER JOIN course ON takes.course_id = course.course_id
WHERE course.dept_name = 'Comp. Sci.';
```

b) 

```sql
SELECT S.ID, S.name 
FROM student AS S
WHERE NOT EXISTS (
    SELECT * 
    FROM takes AS T
    WHERE T.year < 2017 AND T.ID = S.ID 
)
```

c)

```sql
SELECT I.dept_name, MAX(I.salary)
FROM instructor AS I
GROUP BY I.dept_name 
```

d. Find the lowest, across all departments, of the per-department maximum salary computed by the preceding query.

```sql
WITH max_salary_schema(dept_name, max_salary) AS (
    SELECT I.dept_name, MAX(I.salary)
    FROM instructor AS I
    GROUP BY I.dept_name 
) 
SELECT MIN(max_salary) 
FROM max_salary_schema
```

# 3.15

![image-20230321083146394](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20230321083146394.png)

a） 

```sql
#  X – Y = Ø ⇔ X ⊆ Y
WITH brooklyn(branch_name) AS (
    SELECT branch_name 
    FROM branch
    WHERE branch_city = 'Brooklyn'
)
SELECT ID, customer_name 
FROM customer AS c
WHERE NOT EXISTS (
    (SELECT branch_name FROM brooklyn)
    EXCEPT
    (
        SELECT branch_name
        FROM account INNER JOIN depositor 
            ON account.account_number = depositor.account_number
        WHERE depositor.ID = c.ID
    )
)            
```

b）

```sql
select sum(amount)
from loan
```

c)

```sql
SELECT distinct branch_name 
      FROM branch 
      WHERE assets >  SOME
	       (SELECT assets 
            FROM branch 
            WHERE branch_city = ‘Brooklyn’)

```



# 讨论题 事务的例子以及长事务的利弊

### 1

```bash
# 假设有一个选课系统，其中有以下几个数据表：
students - 包含学生的个人信息，如姓名、年龄和学号。
courses - 包含所有可供选择的课程信息，如课程名称、授课教师和学分。
enrollments - 包含学生选课记录，如学生选了哪门课程和成绩。
```

现在假设一个学生想要选一门课程，以下是一个可能的事务：

```sql
BEGIN TRANSACTION;
SELECT * FROM courses WHERE course_id = 123456 FOR UPDATE;
INSERT INTO enrollments (student_id, course_id, grade) VALUES (456, 123, null);
UPDATE courses SET enrollment_count = enrollment_count + 1 WHERE course_id = 123;
COMMIT;
```

第一个语句使用`SELECT...FOR UPDATE`锁定ID为123456的课程，以确保其他学生不能同时选这门课程

第二个语句将学生ID为456的选课记录插入到`enrollments`表中，其中该学生选择了ID为123的课程，成绩为空

第三个语句将ID为123的课程的`enrollment_count`增加1，以反映该课程现在有一个新的学生

最后，如果所有操作都成功，则使用`COMMIT`语句提交事务，否则使用`ROLLBACK`语句回滚事务

### 2

同1中的选课为例，选课的筛选过程（教务系统抽彩票的过程）就是一个长事务，它需要逐个课程去筛选一门课程的选课学生，并且保证事务的一致性和可靠性(不能重复选课，课程有容量限制等等)

### 3

##### 利：

1. 确保事务的一致性和可靠性，尤其是对于需要多步骤操作的复杂事务，长事务能够保证事务中的每一步骤都得到正确处理

2. 对并发访问进行控制，避免多个用户同时对同一个事务进行操作，从而保证数据的完整性和一致性

##### 弊：

1. 长事务可能会造成资源的浪费，因为事务在执行过程中占用了系统资源

2. 长事务可能会降低系统的可用性，因为长时间运行的事务可能会占用系统的资源，导致系统无法响应其他用户的请求

##### 为了克服长事务的弊端，可以采取以下措施：

1. 分布式事务：在选课系统中，可以将选课过程拆分成多个子事务，并使用分布式事务管理器来管理这些子事务。这样可以将长事务分解成多个短事务，并能够更好地控制事务的执行时间和资源占用，从而提高系统的可用性和并发访问能力。

2. 超时机制：在选课过程中，可以为每个选课请求设置一个超时时间，如果在规定时间内没有得到响应，则认为该选课请求失败，从而释放资源。这样可以避免因为某个选课请求长时间未响应而导致其他用户的请求被阻塞。

3. 数据缓存：在选课过程中，可以使用数据缓存技术来减少数据库的访问次数。当一个选课请求被处理成功后，可以将其结果缓存到内存中，当下一个选课请求访问相同的数据时，可以直接从缓存中获取结果，从而减少对数据库的访问次数，提高系统的响应速度。
