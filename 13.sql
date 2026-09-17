CREATE TABLE customer_orders1 (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2)
);
INSERT INTO customer_orders1
(order_id, customer_id, order_date, amount)
VALUES

-- Customer 101 (Increasing order frequency)
(1, 101, '2025-01-05', 100),
(2, 101, '2025-02-10', 120),
(3, 101, '2025-02-15', 80),
(4, 101, '2025-03-01', 150),
(5, 101, '2025-03-10', 200),
(6, 101, '2025-03-20', 50),


-- Customer 102 (Not increasing)
(7, 102, '2025-01-05', 100),
(8, 102, '2025-01-15', 120),
(9, 102, '2025-02-10', 80),
(10,102, '2025-03-01', 150),
(11,102, '2025-03-15', 200),


-- Customer 103 (Increasing)
(12,103, '2025-01-01', 100),
(13,103, '2025-02-01', 100),
(14,103, '2025-02-15', 150),
(15,103, '2025-03-01', 200),
(16,103, '2025-03-15', 250),
(17,103, '2025-03-20', 300),
(18,103, '2025-03-25', 350),


-- Customer 104 (Only two months)
(19,104, '2025-01-10', 100),
(20,104, '2025-02-10', 200),


-- Customer 105 (Decrease)
(21,105, '2025-01-05', 100),
(22,105, '2025-01-10', 100),
(23,105, '2025-01-20', 100),
(24,105, '2025-02-10', 100),
(25,105, '2025-03-10', 50);



select * from customer_orders1;

with tab1 as (
select customer_id, date_format(order_date, '%Y-%m-01') as months from customer_orders1
),
tab2 as (
select customer_id, months, count(*) as ct, row_number() over(partition by customer_id order by months) as rn
from tab1
group by customer_id, months
),
reject_for_count as (
select customer_id 
from tab2
group by customer_id
having count(*) < 3
),
tab3 as (
select customer_id, months, ct, date_sub(months, interval rn month) as dt2 , lag(ct) over(partition by customer_id order by months) as prev_ct
from tab2
where customer_id not in (select customer_id from reject_for_count)
)
, 
rjCust as (
select customer_id from tab3 where ct < prev_ct 
)
, 
tab4 as (
select  * from tab3 
where customer_id not in (select customer_id from rjCust)
)


select customer_Id from (
select distinct customer_id , dt2
from tab4 ) a
group by customer_id
having count(*) = 1;


