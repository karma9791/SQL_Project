CREATE TABLE customer_orders13 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);
INSERT INTO customer_orders13 VALUES
(1,101,'2025-01-10',100),
(2,101,'2025-02-01',200),
(3,101,'2025-07-15',300),

(4,102,'2025-01-05',100),
(5,102,'2025-02-10',150),
(6,102,'2025-03-20',200),

(7,103,'2025-01-01',50),
(8,103,'2025-05-10',400),

(9,104,'2025-04-01',100),
(10,104,'2025-08-01',200),

(11,105,'2025-01-01',100),
(12,105,'2025-01-15',100),
(13,105,'2025-05-01',100),
(14,105,'2025-10-10',100);

select * from customer_orders13;

with customer_lead as (
select customer_id, order_date, lead(order_date) over (partition by customer_id order by order_date) as reactivation_date
from customer_orders13

)
select customer_id, order_date,reactivation_date, datediff(reactivation_date, order_date) as inactive_days
from customer_lead
where datediff(reactivation_date, order_date) > 90
order by customer_id;


CREATE TABLE user_events (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_time DATETIME
);
INSERT INTO user_events VALUES

(1,101,'2025-01-01 09:00:00'),
(2,101,'2025-01-01 09:10:00'),
(3,101,'2025-01-01 09:25:00'),
(4,101,'2025-01-01 10:10:00'),
(5,101,'2025-01-01 10:20:00'),

(6,102,'2025-01-01 08:00:00'),
(7,102,'2025-01-01 08:40:00'),
(8,102,'2025-01-01 09:00:00'),

(9,103,'2025-01-01 12:00:00');

select * from user_events;


with tab1 as (
select user_id, event_time, lag(event_time) over(partition by user_id order by event_time) as prev_event from user_events
)
, tab2 as (
select user_id, event_time, prev_event, timestampdiff(minute, prev_event, event_time ) as diff from tab1
), tab3 as (
select  user_id, event_time, prev_event, 
	case 
		when diff is null then 1
        when diff > 30 then 1
        else 0
	end as sessionid
from tab2)
, tab4 as (
select user_id, event_time, prev_event, sum(sessionid) over (partition by user_id order by event_time) as session_id from tab3
)
select user_id, session_id, min(event_time) as session_start, max(event_time) as session_start , count(*) as event_count
from tab4
group by user_id, session_id


;
CREATE TABLE monthly_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2)
);

INSERT INTO monthly_orders VALUES

(1,101,'2025-01-10',100),
(2,101,'2025-02-10',200),
(3,101,'2025-03-10',300),
(4,101,'2025-05-10',500),

(5,102,'2025-01-05',100),
(6,102,'2025-03-05',200),
(7,102,'2025-04-05',300),
(8,102,'2025-05-05',400),

(9,103,'2025-06-01',100),
(10,103,'2025-07-01',200),
(11,103,'2025-08-01',300),

(12,104,'2025-01-01',50),
(13,104,'2025-02-01',60);

with customer_month as (
select distinct customer_id, date_format(order_date, '%Y-%m-01') as dt from monthly_orders
)
, customer_month_rn as (
select customer_id, dt , row_number() over (partition by customer_id order by dt) as rn from customer_month
), customer_groups as (
select customer_id, dt, date_sub(dt, interval rn month) as intv from customer_month_rn
)
select customer_id, min(dt) as streak_start_month, max(dt) as streak_end_month, count(*) as number_of_months
from customer_groups
group by customer_id, intv
having count(*) >=3
order by customer_id;


