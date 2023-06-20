# 5.6

![image-20230327154807710](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20230327154807710.png)

题目只要求处理`insertion`

插入到 `depositor` 如果有新`customer_name`更新, 

插入到 `account`  如果有新`customer_name`更新, 

```sql
-- for depositor
CREATE TRIGGER insert_account
AFTER INSERT ON account
REFERENCING NEW ROW AS ins
FOR EACH STATEMENT
INSERT INTO branch_cust
    SELECT ins.branch_name,customer_name
    	FROM depositor
    	WHERE depositor.account_number = ins.account_number;
-- for account    
CREATE TRIGGER insert_depositor
AFTER INSERT ON depositor
REFERENCING NEW ROW AS ins
FOR EACH ROW
INSERT INTO branch_cust
    SELECT branch_name,ins.customer_name
   		FROM account
    	WHERE ins.account_number = account.account_number;
```

# 5.15

![image-20230327155523914](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20230327155523914.png) 

```sql
CREATE FUNCTION avg_salary(company_name VARCHAR(20))
    RETURNS REAL
    BEGIN
    DECLARE retval REAL;
        SELECT AVG(salary) INTO retval
			FROM works
			WHERE works.company_name = company_name;
    RETURN retval;
    END;
```

```sql
SELECT DISTINCT company_name
	FROM works
	WHERE avg_salary(company_name) > avg_salary('First Bank');
```

# 5.19

```sql
CREATE TRIGGER trig1 
	AFTER delete ON s
    	referencing old row as orow 
   		for each row 
		begin 
			delete from r
			where orow.A = r.B
		end 
```

当从关系_s_中删除任何行时，触发器机制将删除所有引用从关系_s_中删除的行的关系_r_中的行

# 讨论题  举例说明SQL注入（SQL injection）攻击. 如何避免此类攻击？

比如，假设教务网站有一个页面，用于修改学生的成绩信息。这个页面需要用户先登录系统，然后才能够修改成绩。登录系统的代码如下：

```sql
sqlCopy code
SELECT * FROM users WHERE username = '$username' AND password = '$password'
```

攻击者可以在用户名输入框中输入以下内容：

```sql
vbnetCopy code
admin'; --
```

这个字符序列将会在SQL查询语句中生成以下代码：

```sql
sqlCopy code
SELECT * FROM users WHERE username = 'admin'; --' AND password = '$password'
```

这个SQL查询语句将返回用户名为“admin”的所有记录，无需密码即可登录系统。攻击者现在可以访问成绩修改页面，并将学生的成绩信息更改为任意值

预防措施

1. 对于用户名和密码，应该进行输入验证和过滤，以确保它们符合预期的格式和类型，并且不包含恶意的字符和代码。例如，可以使用正则表达式检查用户名和密码是否只包含字母和数字。
2. 不要直接将用户输入的用户名和密码拼接到SQL查询语句中，而应该使用参数化查询语句。参数化查询语句可以确保用户输入的数据被正确地转义和编码，从而防止SQL注入攻击。
3. 使用加盐哈希函数对密码进行加密存储。加盐哈希函数可以确保密码不可逆转，并且防止攻击者使用彩虹表等工具来破解密码。
4. 实现防火墙和访问控制机制。可以使用防火墙和访问控制列表（ACL）来限制只有经过授权的用户才能够访问教务系统中的敏感资源，例如成绩信息。
5. 实现输入验证和过滤机制。可以使用输入验证和过滤机制来确保所有输入数据符合预期的格式和类型，并且不包含恶意的字符和代码。例如，可以使用Java Servlet过滤器来验证和过滤所有HTTP请求参数。
6. 实施会话管理机制。可以使用会话管理机制来管理用户会话，包括会话ID的生成、会话超时的设置、会话ID的验证等。此外，应该使用HTTPS协议来保护会话数据的传输，防止中间人攻击。
7. 实现日志记录和监控机制。可以使用日志记录和监控机制来记录所有的用户活动，并监控不寻常的用户活动。例如，可以使用SIEM系统来实现对教务系统的实时监控和警报。
8. 定期进行安全评估和漏洞扫描。可以定期对教务系统进行安全评估和漏洞扫描，以发现并修复系统中存在的漏洞和安全问题。可以使用漏洞扫描工具来检测SQL注入漏洞和其他常见漏洞。
