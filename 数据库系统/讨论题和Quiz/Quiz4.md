```	SQL
CREATE TABLE EMPLOYEE (
  id INT PRIMARY KEY,
  salary INT,
  phone VARCHAR(20)
);

CREATE TABLE DEPARTMENT (
  d_no INT PRIMARY KEY,
  d_name VARCHAR(50),
  budget INT,
  manager_e_id INT,
  FOREIGN KEY (manager_id) REFERENCES EMPLOYEE(id)
);

CREATE TABLE CHILD (
  c_name VARCHAR(50) PRIMARY KEY,
  c_age INT,
  parent_e_id INT,
  FOREIGN KEY (parent_id) REFERENCES EMPLOYEE(id)
);
```

