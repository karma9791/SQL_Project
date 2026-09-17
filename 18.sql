CREATE TABLE customer_orders5 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO customer_orders5
(order_id, customer_id, order_date, amount)
VALUES

-- Customer 101 increasing
(1,101,'2025-01-10',100),
(2,101,'2025-02-10',150),
(3,101,'2025-03-10',220),

-- Customer 102 decreasing
(4,102,'2025-01-05',500),
(5,102,'2025-02-05',300),
(6,102,'2025-03-05',200),

-- Customer 103 increasing
(7,103,'2025-01-01',50),
(8,103,'2025-02-01',70),

-- Customer 104 only one order
(9,104,'2025-01-15',400),

-- Customer 105 same amount
(10,105,'2025-01-01',100),
(11,105,'2025-02-01',100);

select * from customer_orders5;

with customerWithRank as (
select  customer_id, order_id, amount, order_date, lag(amount) over (partition by customer_id order by order_date) as previous_amount, row_number() over (partition by customer_id order by order_date desc) as rm
from customer_orders5
)
select customer_id, order_id as latest_order_id, order_date as latest_order_date,  amount as latest_amount, previous_amount from customerWithRank 
where rm <= 1 and previous_amount is not null and amount > previous_amount
order by latest_order_id






