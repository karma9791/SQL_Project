CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_time DATETIME,
    amount DECIMAL(10,2)
);

INSERT INTO transactions
(transaction_id, customer_id, transaction_time, amount)
VALUES

-- Customer 101
-- Duplicate within 10 minutes
(1,101,'2025-01-10 10:00:00',500),
(2,101,'2025-01-10 10:05:00',500),

-- Not duplicate (different amount)
(3,101,'2025-01-10 10:08:00',700),

-- Not duplicate (more than 10 minutes)
(4,101,'2025-01-10 10:30:00',500),


-- Customer 102
-- Duplicate
(5,102,'2025-01-11 09:00:00',1000),
(6,102,'2025-01-11 09:07:00',1000),


-- Customer 103
-- Same amount but different day
(7,103,'2025-01-12 08:00:00',200),
(8,103,'2025-01-13 08:05:00',200),


-- Customer 104
-- Only one transaction
(9,104,'2025-01-15 12:00:00',300);


select * from transactions;

select t1.customer_id, t1.transaction_id as transaction_id_1 , t2.transaction_id as transaction_id_2 , t1.amount  , timestampdiff(minute, t1.transaction_time, t2.transaction_time) as time_difference_minutes
from transactions t1
join transactions t2
on t1.transaction_id < t2.transaction_id 
and t1.amount = t2.amount
and timestampdiff(minute, t1.transaction_time, t2.transaction_time) < 10



