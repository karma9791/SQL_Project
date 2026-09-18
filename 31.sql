CREATE TABLE customers17 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);
INSERT INTO customers17 VALUES
(101,'John'),
(102,'Alice'),
(103,'Bob'),
(104,'David');


with tab1 as (
select 
	o.customer_id, 
    c.customer_name,
    sum(o.quantity * o.price) as total_revenue, 
    count(*) as total_orders, 
    min(o.order_date) as first_order_date,
    max(o.order_date) as last_order_date
from orders18 o 
join customers17 c
on o.customer_id = c.customer_id
group by o.customer_id, c.customer_name
)
select customer_id, customer_name, total_revenue, total_orders, first_order_date, last_order_date, 
case 
	when total_revenue >= 1000 then "High Value"
    when total_revenue between 500 and 999 then "Medium Value"
    else "Low Value"
end as customer_segment
from tab1

CREATE TABLE orders18 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    quantity INT,
    price DECIMAL(10,2)
);
INSERT INTO orders18 VALUES

(1,101,'2025-01-01',2,100),
(2,101,'2025-03-01',3,200),
(3,101,'2025-06-01',1,300),
(4,102,'2025-02-01',5,100),
(5,102,'2025-04-01',2,100),
(6,103,'2025-01-15',1,200),
(7,104,'2025-01-10',5,200),
(8,104,'2025-02-10',2,300);