CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

INSERT INTO employees
(emp_id, emp_name, department, salary)
VALUES

-- Engineering
(1, 'John', 'Engineering', 120000),
(2, 'Alice', 'Engineering', 110000),
(3, 'Bob', 'Engineering', 110000),
(4, 'David', 'Engineering', 90000),

-- Sales
(5, 'Mike', 'Sales', 100000),
(6, 'Sarah', 'Sales', 85000),
(7, 'Tom', 'Sales', 85000),
(8, 'Emma', 'Sales', 70000),

-- HR
(9, 'Lisa', 'HR', 80000),
(10, 'James', 'HR', 70000),

-- Finance
(11, 'Robert', 'Finance', 90000);

select * from employees;

select emp_id, emp_name, department, salary from (
select emp_id, emp_name, department, salary, dense_rank() over(partition by department order by salary desc) as rn
from employees) a 
where rn = 2
order by salary desc, emp_name




