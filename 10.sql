CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

INSERT INTO customer_orders
(order_id, customer_id, order_date, amount)
VALUES

-- Customer 101 (Increasing every month)
(1, 101, '2025-01-05', 100),
(2, 101, '2025-01-20', 50),

(3, 101, '2025-02-10', 200),

(4, 101, '2025-03-05', 300),
(5, 101, '2025-03-25', 50),


-- Customer 102 (Not increasing)
(6, 102, '2025-01-10', 300),

(7, 102, '2025-02-15', 200),

(8, 102, '2025-03-20', 400),


-- Customer 103 (Increasing)
(9, 103, '2025-01-01', 100),

(10, 103, '2025-02-01', 150),

(11, 103, '2025-03-01', 250),

(12, 103, '2025-04-01', 400),


-- Customer 104 (Only one month)
(13, 104, '2025-03-10', 500),


-- Customer 105 (Decrease in middle)
(14, 105, '2025-01-05', 100),
(15, 105, '2025-02-05', 300),
(16, 105, '2025-03-05', 200);




with tab1 as (
select customer_id, dt , sum(amount) as tot from (
select customer_id, date_format(order_date, '%Y-%m-01') as dt , amount from customer_orders) a
group by customer_id, dt
),
tab2 as (
select customer_id, dt , tot , lead(tot) over(partition by customer_id order by dt) as ltot
from tab1),
tab3 as (
select customer_id, dt  , ltot - tot as rem
from tab2
where ltot is not null)
,tab4 as (
select customer_id, min(rem) minrem
from tab3
group by customer_id
)
select customer_id
from tab4
where minrem > 0;
















