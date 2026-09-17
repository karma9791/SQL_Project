CREATE TABLE customers10 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
INSERT INTO customers10
(customer_id, customer_name)
VALUES
(101,'John'),
(102,'Alice'),
(103,'Bob'),
(104,'David'),
(105,'Emma');

with tab1 as (
select distinct customer_id,  year(order_date), month(order_date)
from orders10 
where year(order_date) = "2025" and month(order_date) in ("1", "2", "3")
),
tab2 as (
select customer_id
from tab1
group by customer_id
having count(*) = 3)
select t.customer_id, c.customer_name 
from tab2 t
join customers10 c
on t.customer_id = c.customer_id





CREATE TABLE orders10 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO orders10
(order_id, customer_id, order_date, amount)
VALUES

-- Customer 101
-- Active Jan, Feb, Mar ✅
(1,101,'2025-01-05',100),
(2,101,'2025-02-10',200),
(3,101,'2025-03-15',300),

-- Customer 102
-- Missing March ❌
(4,102,'2025-01-10',100),
(5,102,'2025-02-15',200),

-- Customer 103
-- Has multiple orders in Jan but missing Feb ❌
(6,103,'2025-01-05',50),
(7,103,'2025-01-20',70),
(8,103,'2025-03-10',100),

-- Customer 104
-- Active all months, multiple orders ✅
(9,104,'2025-01-01',500),
(10,104,'2025-02-01',600),
(11,104,'2025-02-20',700),
(12,104,'2025-03-01',800),

-- Customer 105
-- Only March ❌
(13,105,'2025-03-05',100);