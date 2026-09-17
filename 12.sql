with tab1 as (select c.customer_id, c.customer_name, c.signup_date, o.order_date
from customers5 c
join orders5 o
on c.customer_id = o.customer_id
and (o.order_date > c.signup_date and o.order_date < date_add(c.signup_date, interval 7 day))
)

select customer_id, customer_name, signup_date,  min(order_date) as first_purchase_date, datediff(min(order_date), signup_date) days_to_first_purchase
from tab1
group by customer_id, customer_name, signup_date


