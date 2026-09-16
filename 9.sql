select * from customers3;
select * from orders4;
with tab1 as (
select c.customer_id, c.customer_name, o.order_date, o.amount, row_number() over(partition by customer_id order by order_date, amount desc) as rm
from customers3 c
join orders4 o
on c.customer_id = o.customer_id and o.order_date > c.signup_date )
,
tab2 as (select customer_id, customer_name, order_date, amount from tab1 where rm = 2)
select a.customer_id, a.customer_name , b.order_date, b.amount
from customers3 a 
left join tab2 b 
on a.customer_id = b.customer_id;
