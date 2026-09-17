CREATE TABLE customers11 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    signup_date DATE
);
INSERT INTO customers11 VALUES
(101,'John','2025-01-01'),
(102,'Alice','2025-01-10'),
(103,'Bob','2025-02-01'),
(104,'David','2025-03-01'),
(105,'Emma','2025-01-15');

-- as row numbner


with tab1 as (
select customer_id, order_date , row_number() over(partition by customer_id order by order_date) as rm
from orders11),
tab3 as (
select a.customer_id, b.customer_name
from tab1 a
join customers11 b
on a.customer_id = b.customer_id
where rm = 1 and a.order_date >= b.signup_date and a.order_date <= date_add(b.signup_date, interval 30 day)
)
, tab4 as (
select  a.customer_id, b.customer_name, a.order_date , lag(order_date) over(partition by customer_id order by order_date) as dt, rm
from tab1 a 
join tab3 b 
on a.customer_id = b.customer_id
)
select customer_id, customer_name, dt as fist_date , order_date as second_order , datediff(order_date, dt) as days_between_orders
from tab4 
where rm = 2
order by customer_id


-- first order within 30 days




with firstOrder as (
select customer_id,  min(order_date) as first_order
from orders11
group by customer_id
)
, customer_first as (
select a.customer_id, b.customer_name , a.first_order
from firstOrder a
join customers11 b
on a.customer_id =  b.customer_id
where b.signup_date <= a.first_order and date_add(b.signup_date, interval 30 day) >= a.first_order
)
select a.customer_id, a.customer_name, a.first_order, b.order_date, datediff(b.order_date, a.first_order) as days_between_orders
from customer_first a
join orders11 b
on a.customer_id = b.customer_id
where datediff(b.order_date, a.first_order) > 60










-- 1 2jan
-- 1  2


with tab1 as (
select c.customer_id, c.customer_name, o.order_date
from customers11 c
join orders11 o 
on c.customer_id = o.customer_id
)
, tab2 as (
select customer_id, customer_name, min(o.order_date) as first_order
from tab1
group by customer_id, customer_name
)
, tab3 as (
select c1.customer_id, c1.customer_name, c2.order_date 
from 
)



select * from tab1




group by c.customer_id, c.customer_name


CREATE TABLE orders11 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO orders11 VALUES
(1,101,'2025-01-10',100),
(2,101,'2025-03-15',200),

(3,102,'2025-02-20',300),
(4,102,'2025-03-10',200),

(5,103,'2025-03-01',500),
(6,103,'2025-05-10',300),

(7,104,'2025-04-15',100),
(8,104,'2025-05-20',200),

(9,105,'2025-02-20',150),
(10,105,'2025-04-25',300);