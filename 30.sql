CREATE TABLE customers16 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
INSERT INTO customers16 VALUES
(101,'John'),
(102,'Alice'),
(103,'Bob'),
(104,'David');

 with customer_last as (
select customer_id , max(order_date) as last_order_date, datediff("2025-12-01", max(order_date)) as days_since_last_order
from orders17
group by customer_id
having count(*) > 1)

select * , "Churned" as customer_status from customer_last where days_since_last_order > 90


CREATE TABLE orders17 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);
INSERT INTO orders17 VALUES

(1,101,'2025-01-01',100),
(2,101,'2025-05-01',200),

(3,102,'2025-06-01',300),

(4,103,'2024-01-01',500),
(5,103,'2024-03-01',700),

(6,104,'2025-08-01',100);