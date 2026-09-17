CREATE TABLE orders14 (
    order_id INT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(10,2)
);
INSERT INTO orders14 VALUES

(1,'2025-01-01',100),
(2,'2025-01-05',200),
(3,'2025-01-10',300),
(4,'2025-01-20',400),
(5,'2025-02-05',500),
(6,'2025-02-10',600),
(7,'2025-02-20',700);


select order_date , amount as daily_revenue, 
sum(amount) over(order by order_date rows between 30 preceding and current row) as rolling_30_day_revenue
from orders14;

with tab1 as (
select a.customer_id, a.customer_name, 
order_date,
first_value(amount) over (partition by a.customer_id order by order_date) as f_order,
last_value(amount) over (partition by a.customer_id order by order_date) as l_order
from customers14  a
join orders15 b
on a.customer_id  = b.customer_id )

select a.customer_id, a.customer_name, min(order_date) as first_order_date , 
min(f_order) as first_order_amount, min(order_date) as first_order_date, min(l_order) as latest_order_amount
from tab1
group by a.customer_id, a.customer_name



