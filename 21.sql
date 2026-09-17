CREATE TABLE customers8 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    signup_date DATE
);
INSERT INTO customers8
(customer_id, customer_name, signup_date)
VALUES

(101, 'John', '2025-01-01'),
(102, 'Alice', '2025-01-05'),
(103, 'Bob', '2025-01-10'),
(104, 'David', '2025-01-15'),
(105, 'Emma', '2025-01-20'),
(106, 'Mike', '2025-01-25');
CREATE TABLE orders8 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);
INSERT INTO orders8
(order_id, customer_id, order_date, amount)
VALUES

-- Customer 101
-- Converted (4 days after signup)
(1,101,'2025-01-05',100),

-- Customer 102
-- Converted (7 days exactly)
(2,102,'2025-01-12',200),

-- Customer 103
-- Not converted (10 days later)
(3,103,'2025-01-20',300),

-- Customer 104
-- No order

-- Customer 105
-- Converted (same day)
(4,105,'2025-01-20',500),

-- Customer 106
-- Multiple orders
-- First order is within 7 days
(5,106,'2025-01-28',100),
(6,106,'2025-02-20',200);

-- Soltion 1
with tab1 as (
select count(distinct c.customer_id) as conveted_customer, (select count(customer_id) from customers8) as total_customer
from customers8 c
join orders8 o 
on c.customer_id = o.customer_id
where o.order_date >= c.signup_date and  o.order_date <= date_add( c.signup_date, interval 7 day)
)

select total_customer, conveted_customer, round((conveted_customer*100)/total_customer, 2) as conversion_rate from tab1;

-- solution2
with totalCutomer as (
select count(customer_id) as total_customer from customers8
),
convertedCustomer as (
select count(distinct c.customer_id) as conveted_customer
from customers8 c
join orders8 o 
on c.customer_id = o.customer_id
where o.order_date >= c.signup_date and  o.order_date <= date_add( c.signup_date, interval 7 day)
)
select total_customer, conveted_customer , round((conveted_customer*100)/total_customer, 2) as conversion_rate
from totalCutomer 
join convertedCustomer
