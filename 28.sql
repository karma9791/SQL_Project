CREATE TABLE daily_orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    quantity INT,
    price DECIMAL(10,2)
);
INSERT INTO daily_orders VALUES

(1,'2025-01-01',2,100),
(2,'2025-01-02',1,150),
(3,'2025-01-03',3,100),
(4,'2025-01-04',2,200),
(5,'2025-01-05',1,300),
(6,'2025-01-06',4,100),
(7,'2025-01-07',2,250),

(8,'2025-01-08',5,200),
(9,'2025-01-09',3,300),
(10,'2025-01-10',6,200),

(11,'2025-01-11',1,100),
(12,'2025-01-12',5,150);

with tab1 as (
select order_date, sum(quantity* price) as daily_revenue 
from daily_orders
group by order_date)
, tab2 as (
select order_date, daily_revenue, 
avg(daily_revenue) over (order by daily_revenue rows between 7 preceding and 1 preceding) as previous_7_day_avg,
COUNT(*) OVER (
            ORDER BY order_date
            ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
        ) AS previous_days
from tab1)
select * from tab2 
where daily_revenue > previous_7_day_avg
and ;

