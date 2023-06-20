# 3.8

![image-20230314081803742](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20230314081803742.png) 

### a. Find the ID of each customer of the bank who has an account but not a loan. 

```sql
select id 
from depositor
EXCEPT (select id
from borrower)
```

### b. Find the ID of each customer who lives on the same street and in the same city as customer '12345'. 

```sql
select id
from customer  
where (customer_street, customer_city ) in ( 
    select customer_street,customer_city 
    from customer
    where id = '12345'
)
```

### c. Find the name of each **branch** that has at least **one customer** who has an account in the bank and who lives in “Harrison”

```sql
select distinct account.branch_name
from account, customer, depositor
where customer.id = depositor.id and  customer.customer_city = 'Harrison' and account.account_number = depositor.account_number 
```

# 3.9

![image-20230314082537096](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20230314082537096.png)

### a. Find the ID, name, and city of residence of each employee who works for “First Bank Corporation”. 

```sql
select employee.id, employee.person_name,employee.city 
from works,employee 
where employee.id = works.id and works.company_name = 'First Bank Corporation'
```

### b. Find the ID, name, and city of residence of each employee who works for “First Bank Corporation” and earns more than $10000. 

```sql
select id, person_name, city
from employee 
where id in (
    select id
    from works
    where company_name = 'First Bank Corporation' and salary > 10000
) 
```

### c. Find the ID of each employee who does not work for “First Bank Corporation”. 

```sql
select id 
from employee
where id not in(
    select id
    from works
    where company_name = 'First Bank Corporation'
)
```

### d. Find the ID of each employee who earns more than every employee of “Small Bank Corporation”. 

```sql
select id
from works
where salary > all(
    select salary
    from works
    where company_name = 'Small Bank Corporation'
)
```

### e. Assume that companies may be located in several cities. Find the name of each company that is located in every city in which “Small Bank Corporation” is located. 

```sql
select S.company_name 
from company as S 
where not exists (
    (
        select city
        from company
        where company_name = 'Small Bank Corporation'
    )
    except
    (
        select city
        from company as T
        where T.company_name = S.company_name
    )
)
```

### f. Find the name of the company that has the most employees (or companies, in the case where there is a tie for the most). 

```sql
select company_name
from works 
group by company_name
having count(distinct id) >= all(
    select count(id) 
    from works 
    group by company_name
)
```

### g. Find the name of each company whose employees earn a higher salary, on average, than the average salary at “First Bank Corporation”.

```sql
select company_name
from works 
group by company_name
having avg(salary) > all (
    select avg(salary)
    from works 
    where company_name = 'First Bank Corporation' 
)
```
