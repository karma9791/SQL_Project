CREATE TABLE customers18 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
INSERT INTO customers18 VALUES
(101,'John'),
(102,'Alice'),
(103,'Bob'),
(104,'David'),
(105,'Emma');
CREATE TABLE orders19 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    quantity INT,
    price DECIMAL(10,2)
);

with order_customer as (
select customer_id, quantity * price as rev , date_format(order_date, '%Y-%m-01') as months
from orders19
)
, order_monthly as (
select customer_id,  months, sum(rev) as revenue
from order_customer
group by customer_id,  months)
, order_rank as(
select customer_id,  months, revenue, 
rank() over (partition by months order by revenue desc) as rank1,  
row_number() over (partition by months order by revenue desc, customer_id) as rn
from order_monthly)
select customer_id,  months, revenue, rank1 from order_rank where rank1 <= 3  and rn <=3 order by months, revenue desc





INSERT INTO orders19 VALUES

(1,101,'2025-01-10',2,100),
(2,101,'2025-01-20',1,300),

(3,102,'2025-01-05',5,100),

(4,103,'2025-01-15',1,800),

(5,104,'2025-01-18',2,400),

(6,101,'2025-02-01',3,200),
(7,102,'2025-02-10',5,100),
(8,103,'2025-02-15',2,300),

(9,104,'2025-02-20',1,1000),

(10,105,'2025-02-25',5,200);


