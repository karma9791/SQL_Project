select * from customer_orders2;

with tab1 as (
select distinct customer_id, date_format(order_date, '%Y-%m-01') as mon
from customer_orders2
),
tab2 as (
select customer_id, mon, row_number() over(partition by customer_id order by mon) as rm
from tab1
),
tab3 as (
select customer_id, date_sub(mon, interval rm month) as new_date  from tab2
)
select customer_id , max(ct) as longest_streak from (
select customer_id, count(*) as ct 
from tab3
group by customer_id, new_date
having count(*) >= 3) a 
group by customer_id
order by customer_id

