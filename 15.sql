CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

INSERT INTO products
(product_id, product_name, category)
VALUES
(1, 'Laptop', 'Electronics'),
(2, 'Phone', 'Electronics'),
(3, 'Tablet', 'Electronics'),
(4, 'Monitor', 'Electronics'),
(5, 'Keyboard', 'Accessories'),
(6, 'Mouse', 'Accessories'),
(7, 'Headset', 'Accessories'),
(8, 'Chair', 'Furniture'),
(9, 'Desk', 'Furniture'),
(10, 'Lamp', 'Furniture');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO orders
(order_id, product_id, quantity, price, order_date)
VALUES

-- Electronics
(1,1,2,1000,'2025-01-10'),
(2,1,1,1000,'2025-02-15'),

(3,2,5,500,'2025-01-20'),
(4,2,3,500,'2025-03-10'),

(5,3,4,300,'2025-02-05'),
(6,3,2,300,'2025-03-15'),

(7,4,10,200,'2025-01-25'),


-- Accessories
(8,5,20,50,'2025-01-05'),
(9,5,10,50,'2025-02-10'),

(10,6,50,20,'2025-01-15'),
(11,6,30,20,'2025-03-20'),

(12,7,15,100,'2025-02-25'),


-- Furniture
(13,8,5,200,'2025-01-01'),
(14,8,2,200,'2025-02-01'),

(15,9,3,500,'2025-01-15'),

(16,10,20,50,'2025-03-01');


with tab1 as (
select product_id, quantity * price as rev 
from orders
),
tab2 as (
select product_id, sum(rev) as total_rev
from tab1
group by product_id
),
tab3 as (
select b.category, b.product_name, a.total_rev, dense_rank() over(partition by category order by total_rev desc) as rn
from tab2 a
join products b
on a.product_id = b.product_id
)
select * from tab3 where rn <= 3



