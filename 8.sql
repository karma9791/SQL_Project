-- CREATE TABLE customers1 (
--     customer_id INT PRIMARY KEY,
--     customer_name VARCHAR(100),
--     signup_date DATE
-- );

-- INSERT INTO customers1 (customer_id, customer_name, signup_date)
-- VALUES
-- (101, 'John', '2025-01-01'),
-- (102, 'Alice', '2025-01-10'),
-- (103, 'Bob', '2025-02-01'),
-- (104, 'David', '2025-02-15'),
-- (105, 'Emma', '2025-03-01');

-- CREATE TABLE orders1 (
--     order_id INT PRIMARY KEY,
--     customer_id INT,
--     order_date DATE,
--     amount DECIMAL(10,2),
--     FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
-- );

-- INSERT INTO orders1 (order_id, customer_id, order_date, amount)
-- VALUES
-- (1, 101, '2025-01-05', 100),
-- (2, 101, '2025-01-20', 200),
-- (3, 101, '2025-02-10', 150),

-- (4, 102, '2025-01-05', 300), -- before signup
-- (5, 102, '2025-01-15', 250),
-- (6, 102, '2025-02-01', 100),

-- (7, 103, '2025-01-25', 400), -- before signup
-- (8, 103, '2025-02-05', 500),

-- (9, 104, '2025-03-01', 200),
-- (10, 104, '2025-03-15', 350),

-- (11, 105, '2025-02-25', 100); -- before signup

select * from customers1;
select * from orders1;
with tab1 as (
select c.customer_id, c.customer_name, o.order_date, o.amount
from customers1 c
left join orders1 o
on c.customer_id = o.customer_id
where o.order_date > c.signup_date),
tab2 as (
select customer_id, customer_name, order_date, amount, row_number() over(partition by customer_id order by order_date, amount desc) as rm
from tab1),
tab3 as (
select customer_id, customer_name, order_date, amount
from tab2
where rm = 1)
select a.customer_id, a.customer_name, b.order_date, b.amount
from customers1 a
left join tab3 b
on a.customer_id = b.customer_id
;
