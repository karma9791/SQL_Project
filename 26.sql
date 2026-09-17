CREATE TABLE user_events2 (
    event_id INT PRIMARY KEY,
    user_id INT,
    event_name VARCHAR(30),
    event_time DATETIME
);
INSERT INTO user_events2 VALUES

(1,101,'signup','2025-01-01 09:00:00'),
(2,101,'view_product','2025-01-01 09:10:00'),
(3,101,'add_to_cart','2025-01-01 09:15:00'),
(4,101,'purchase','2025-01-01 09:20:00'),

(5,102,'signup','2025-01-01 10:00:00'),
(6,102,'purchase','2025-01-01 10:10:00'),

(7,103,'signup','2025-01-01 11:00:00'),
(8,103,'view_product','2025-01-01 11:10:00'),
(9,103,'purchase','2025-01-01 11:20:00'),

(10,104,'signup','2025-01-01 12:00:00'),
(11,104,'view_product','2025-01-01 12:05:00'),
(12,104,'add_to_cart','2025-01-01 12:10:00'),

(13,105,'signup','2025-01-01 13:00:00'),
(14,105,'view_product','2025-01-01 13:10:00'),
(15,105,'add_to_cart','2025-01-01 13:15:00'),
(16,105,'purchase','2025-01-01 13:30:00');

with tab1 as (
select user_id, event_name, event_time, dense_rank() over(partition by user_id order by event_time ) as dr,
case event_name
	when "signup" then 1
    when "view_product" then 2
    when "add_to_cart" then 3
    when "purchase" then 4
    else 9
end as rn
 from user_events2
)
select distinct user_id
from tab1
where dr = rn
group by user_id
having count(*) = 4
order by user_id