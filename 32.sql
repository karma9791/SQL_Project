CREATE TABLE transactions18 (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_time DATETIME,
    amount DECIMAL(10,2)
);

select t1.customer_id, t1.transaction_id as transaction_id_1, t2.transaction_id as transaction_id_2, t1.amount, 
timestampdiff(minute, t1.transaction_time, t2.transaction_time) as time_difference_minutes
from transactions18 t1
join transactions18 t2
on t1.customer_id = t2.customer_id
and t1.amount = t2.amount
and t1.transaction_time < t2.transaction_time
where timestampdiff(minute, t1.transaction_time, t2.transaction_time) < 5;

INSERT INTO transactions18 VALUES

(1,101,'2025-01-01 10:00:00',500),
(2,101,'2025-01-01 10:03:00',500),

(3,101,'2025-01-01 11:00:00',700),

(4,102,'2025-01-01 09:00:00',300),
(5,102,'2025-01-01 09:10:00',300),

(6,103,'2025-01-01 12:00:00',100),
(7,103,'2025-01-01 12:04:00',100),
(8,103,'2025-01-01 12:08:00',100);