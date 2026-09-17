CREATE TABLE products2 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);
INSERT INTO products2
(product_id, product_name, category)
VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Phone', 'Electronics'),
(3, 'Tablet', 'Electronics'),

(4, 'Keyboard', 'Accessories'),
(5, 'Mouse', 'Accessories'),

(6, 'Chair', 'Furniture');
CREATE TABLE customer_orders3 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE
);
INSERT INTO customer_orders3
(order_id, customer_id, product_id, order_date)
VALUES

-- Customer 101 bought all electronics products
(1,101,1,'2025-01-05'),
(2,101,2,'2025-01-10'),
(3,101,3,'2025-01-15'),

-- Customer 102 missed Tablet
(4,102,1,'2025-01-05'),
(5,102,2,'2025-01-10'),

-- Customer 103 bought all electronics + accessories
(6,103,1,'2025-02-01'),
(7,103,2,'2025-02-05'),
(8,103,3,'2025-02-10'),
(9,103,4,'2025-02-15'),

-- Customer 104 bought only accessories
(10,104,4,'2025-03-01'),
(11,104,5,'2025-03-02'),

-- Customer 105 bought electronics twice
(12,105,1,'2025-03-01'),
(13,105,2,'2025-03-05'),
(14,105,3,'2025-03-10'),
(15,105,3,'2025-03-15');

select customer_id , count(distinct product_id) from customer_orders3 as purchased_product_count, 
(select count(*) from products2)
group by customer_id;

-- Solution1
with electronic_orders as (
select customer_id, product_id
from customer_orders3 
where product_id in (select distinct product_id from products2 where category = "Electronics")
),
customer_electronic_count as (
select customer_id, count(distinct product_id) as ele_prod_ct, (select count(*) from products2 where category = "Electronics") as ct
from electronic_orders
group by customer_id
)
select customer_id from  customer_electronic_count where ele_prod_ct = ct;

-- solution2
with categoryToProductCount as (
select category, count(*) as product_ct
from products2
group by category
)
, custPrd as (
select distinct c.customer_id, c.product_id, p.category from customer_orders3 c join products2 p on c.product_id = p.product_id

),
tab1 as (
select customer_id, category, count(*) as prod_count
from custPrd
group by customer_id, category
)

select distinct customer_id
from tab1 a 
join categoryToProductCount b
on  a.category = b.category 
where b.category = "Electronics"
and a.prod_count = b.product_ct;





