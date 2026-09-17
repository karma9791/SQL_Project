CREATE TABLE customers9 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

INSERT INTO customers9
(customer_id, customer_name)
VALUES
(101,'John'),
(102,'Alice'),
(103,'Bob'),
(104,'David'),
(105,'Emma');

CREATE TABLE orders9 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    quantity INT,
    price DECIMAL(10,2)
);


with tab1 as (
select customer_id, date_format(order_date, '%Y-%m') as months, quantity * price as rev from orders9
)
, tab2 as (
	select customer_id, months, sum(rev) as revenue
    from tab1
    group by customer_id, months
)
, tab3 as (
	select o.months, o.customer_id, c.customer_name, revenue, dense_rank() over(partition by o.months order by revenue desc) as `rank`
    from tab2 o 
    join customers9 c
    on o.customer_id = c.customer_id
)
select months as `month`, customer_id, customer_name, revenue, `rank` from tab3 where `rank` <=3 order by `month`, `rank`;


INSERT INTO orders9
(order_id, customer_id, order_date, quantity, price)
VALUES

-- January 2025

(1,101,'2025-01-05',2,100),
(2,101,'2025-01-20',1,200),

-- John revenue = 400


(3,102,'2025-01-10',5,50),

-- Alice revenue = 250


(4,103,'2025-01-15',3,100),

-- Bob revenue = 300


(5,104,'2025-01-25',1,500),

-- David revenue = 500


-- February 2025

(6,101,'2025-02-05',5,100),

-- John = 500


(7,102,'2025-02-10',2,300),

-- Alice = 600


(8,103,'2025-02-15',10,50),

-- Bob = 500


(9,105,'2025-02-20',4,200),

-- Emma = 800


-- March 2025

(10,101,'2025-03-01',3,100),

(11,102,'2025-03-10',2,100),

(12,103,'2025-03-15',5,100),

(13,104,'2025-03-20',10,100);



