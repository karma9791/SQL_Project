select * from orders;

with customer_months as (
select distinct customer_Id, date_format(order_date, '%Y-%m-01') as current_dt from orders
),
customer_prev as (
select distinct customer_id, date_format(date_add(order_date, interval 1 month), '%Y-%m-01')  as prev_dt from orders
),
tab1 as (
select a.customer_id as aid, b.customer_Id as bid, a.current_dt, b.prev_dt 
from customer_months a
left join customer_prev b
on a.customer_id = b.customer_id and a.current_dt = b.prev_dt)
select current_dt, count(aid) as active_count, count(bid) as ret_count  , round(count(bid)/count(aid),2 ) from tab1
group by current_dt;


with tab1 as (
select distinct customer_Id, date_format(order_date, '%Y-%m-01') as current_dt from orders
)
select * from tab1 ;

