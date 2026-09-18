-- USE karmadb;

-- -- Create Orders table
-- CREATE TABLE Orders (
--     order_id INT PRIMARY KEY,
--     customer_id INT NOT NULL,
--     order_date DATE NOT NULL,
--     amount DECIMAL(10,2) NOT NULL
-- );

-- -- Insert sample data
-- INSERT INTO Orders (order_id, customer_id, order_date, amount)
-- VALUES
--     (1, 101, '2025-01-01', 100.00),
--     (2, 101, '2025-01-15', 200.00),
--     (3, 101, '2025-02-10', 150.00),
--     (4, 102, '2025-01-05', 50.00),
--     (5, 102, '2025-02-01', 75.00),
--     (6, 103, '2025-03-01', 300.00);

-- -- Verify the data
-- SELECT * FROM Orders;


-- select customer_id, 
-- count(order_id) as total_order, 
-- sum(amount) as total_amount_spend,
-- avg(amount) as average_order_value,
-- min(order_date) as first_order,
-- max(order_date) as last_date
-- from orders
-- group by customer_id
-- order by total_amount_spend desc


-- CREATE TABLE customers20 (
--     customer_id INT,
--     customer_name VARCHAR(100)
-- );

-- INSERT INTO customers20 (customer_id, customer_name)
-- VALUES
--     (1, 'Alice'),
--     (2, 'Bob'),
--     (3, 'Charlie'),
--     (4, 'David');
--     
-- CREATE TABLE orders20 (
--     order_id INT,
--     customer_id INT,
--     order_date DATE,
--     amount DECIMAL(10, 2)
-- );

-- INSERT INTO orders20 (order_id, customer_id, order_date, amount)
-- VALUES
--     (101, 1, '2026-01-10', 100),
--     (102, 1, '2026-01-20', 200),
--     (103, 1, '2026-02-15', 300),
--     (104, 2, '2026-01-12', 500),
--     (105, 2, '2026-03-05', 100),
--     (106, 3, '2026-01-15', 200),
--     (107, 3, '2026-02-10', 300),
--     (108, 3, '2026-03-12', 400),
--     (109, 4, '2026-01-05', 100);

with tab1 as (
select distinct customer_id, date_format(order_date, '%Y-%m-01') as months from orders20
),
tab2 as (
select *, date_sub(months, interval row_number() over(partition by customer_id order by months) month) as rn  from tab1
),
tab3 as (
select  customer_id, count(*) as strk
	from tab2
	group by customer_id, rn
    )

select customer_id, strk from tab3 where strk = (select max(strk) from tab3)




