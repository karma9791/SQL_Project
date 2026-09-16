select * from customer_updates;

with tab1 as (
select * , row_number() over(partition by customer_id order by updated_at desc, update_id desc) as rn
from customer_updates)
select update_id, customer_id, customer_name, city, updated_at 
from tab1
where rn = 1;


select * from orders;

select *, date_format(order_date, '%Y-%m-01') as months from orders;

with tab1 as(
select distinct customer_id, date_format(order_date, '%Y-%m-01') as months
from orders
)
, tab2 as (
select customer_id, date_add(months, interval 1 month) as next_month from tab1
)
select a.customer_id, a.months, b.next_month
from tab1 a
left join tab2 b 
on a.months = b.next_month


