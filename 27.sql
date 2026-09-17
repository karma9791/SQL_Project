CREATE TABLE customers13 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
INSERT INTO customers13 VALUES
(101,'John'),
(102,'Alice'),
(103,'Bob'),
(104,'David');
CREATE TABLE products13 (
    product_id INT PRIMARY KEY,
    category VARCHAR(30)
);
INSERT INTO products13 VALUES
(1,'Electronics'),
(2,'Electronics'),
(3,'Electronics'),
(4,'Clothing'),
(5,'Clothing'),
(6,'Books');

CREATE TABLE orders13 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT
);
INSERT INTO orders13 VALUES
(1,101,1),
(2,101,2),
(3,101,3),
(4,101,4),
(5,101,5),

(6,102,1),
(7,102,4),

(8,103,6),
(9,103,6),

(10,104,1),
(11,104,2),
(12,104,3),
(13,104,4);

select a.customer_id, a.product_id, 
case category when "Electronics" then 1 else 0 end as electronics,
case category when "Clothing" then 1 else 0 end as clothing,
case  when category != "Clothing" and category != "Electronics"  then 1 else 0 end as other
from orders13 a
join products13 b
on a.product_id = b.product_id;

with customer_summ as (
select a.customer_id, c.customer_name,
sum(case category when "Electronics" then 1 else 0 end) as electronics_orders,
sum(case category when "Clothing" then 1 else 0 end) as clothing_orders,
sum(case  when category != "Clothing" and category != "Electronics"  then 1 else 0 end) as other_orders
from orders13 a
join products13 b
join customers13 c
on a.product_id = b.product_id
and c.customer_id = a.customer_id
group by a.customer_id, c.customer_name)
select * , 
case 
	when electronics_orders >=3 and clothing_orders >= 2 then "VIP" 
    else "Regular"
end as customer_type
from customer_summ

;



CREATE TABLE employees1 (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100)
);

INSERT INTO employees1 VALUES
(101,'John'),
(102,'Alice'),
(103,'Bob'),
(104,'David');

CREATE TABLE salary_history (
    id INT PRIMARY KEY,
    employee_id INT,
    salary DECIMAL(10,2),
    effective_date DATE
);
INSERT INTO salary_history VALUES

(1,101,5000,'2025-01-01'),
(2,101,5500,'2025-06-01'),
(3,101,6000,'2026-01-01'),

(4,102,7000,'2025-01-01'),
(5,102,6500,'2025-07-01'),

(6,103,4000,'2025-01-01'),

(7,104,8000,'2025-01-01'),
(8,104,9000,'2025-03-01'),
(9,104,8500,'2025-09-01');

with tab1 as (
select employee_id, 
salary as current_salary, 
lead(salary) over (partition by employee_id order by effective_date desc) as prev_salary,
(salary - lead(salary) over (partition by employee_id order by effective_date desc)) as diff,
row_number() over(partition by employee_id order by effective_date desc) as rn
from salary_history
)

select distinct a.employee_id
from tab1 a
join employees1 b
on a.employee_id = b.employee_id
where a.current_salary > a.prev_salary;
select a.employee_id, b.employee_name,  a.prev_salary as previous_salary, a.current_salary, diff as salary_difference
from tab1 a
join employees1 b
on a.employee_id = b.employee_id
where rn = 1 and diff > 0

