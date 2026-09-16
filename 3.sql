
-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


-- Insert Orders data
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
    (1, 101, '2025-01-10', 250.00),
    (2, 101, '2025-02-15', 100.00),
    (3, 103, '2025-01-20', 300.00),
    (4, 105, '2025-03-01', 150.00);


-- Verify data
SELECT * FROM Customers;
SELECT * FROM Orders;


select * from customers
where customer_id not in (select distinct(customer_id) from orders);


select  c.customer_id, c.customer_name, c.country from customers c
left join orders o
on c.customer_id = o.customer_id
where o.customer_id is null;

with tab1 as (
select customer_id, month(order_date) as mon
from orders
where year(order_date) = 2025
),
 tab2 as (select customer_id , count(distinct(mon)) as month_count
from tab1
group by customer_id
having count(distinct(mon)) > 12
)
select customer_id from tab2;

with tab1 as (
select distinct customer_id, month(order_date) as mon
from orders
where year(order_date) = 2025
order by customer_id, mon asc
)
select customer_id , min(mon) as min_mon, max(mon) as max_mon, count(mon) as total_mon 
from tab1 
where total_mon >= 3 and (max_mon - min_mon + 1)
;


WITH monthly_orders AS (
    -- Step 1: Get unique order months per customer
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m-01') AS order_month
    FROM orders
),
month_groups AS (
    -- Step 2: Assign row numbers to each customer's ordered months
    SELECT
        customer_id,
        order_month,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id 
            ORDER BY order_month
        ) AS rn
    FROM monthly_orders
),
islands AS (
    -- Step 3: Consecutive months will have the same difference
    SELECT
        customer_id,
        order_month,
        DATE_SUB(
            order_month,
            INTERVAL rn MONTH
        ) AS grp
    FROM month_groups
)select * from islands;





select * from orders;

with tab1 as (
select customer_id, date_format(order_date, '%Y-%m-01') as dt from orders
),
tab2 as (
select customer_id, dt, row_number() over (partition by customer_id order by dt) as rn from tab1
),
tab3 as (select customer_id, Date_sub(dt, interval rn month ) as dateInterval from tab2)
select customer_id
from tab3
group by customer_id, dateInterval
having count(*) >= 2;














