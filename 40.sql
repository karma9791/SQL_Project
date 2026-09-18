-- CREATE TABLE Orders31 (
--     OrderID INT,
--     CustomerID INT,
--     OrderDate DATE,
--     Quantity INT,
--     UnitPrice DECIMAL(10,2)
-- );
-- INSERT INTO Orders31
--     (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
-- VALUES
--     (1, 101, '2025-01-10', 2, 100),
--     (2, 101, '2025-02-10', 3, 100),
--     (3, 101, '2025-03-10', 5, 100),
--     (4, 101, '2025-04-10', 2, 100),

--     (5, 102, '2025-01-05', 5, 100),
--     (6, 102, '2025-02-05', 2, 100),
--     (7, 102, '2025-04-05', 10, 100),

--     (8, 103, '2025-01-15', 10, 50),
--     (9, 103, '2025-02-15', 10, 50),
--     (10, 103, '2025-03-15', 20, 50),

--     (11, 104, '2025-02-01', 10, 100),
--     (12, 104, '2025-03-01', 20, 100),
--     (13, 104, '2025-04-01', 30, 100),

--     (14, 105, '2025-01-20', 5, 100),
--     (15, 105, '2025-03-20', 10, 100),
--     (16, 105, '2025-04-20', 5, 100);
--     
--   
-- with tab1 as (
-- select 
-- 	customerid, 
--     date_format(orderdate, '%Y-%m-01') as `month`,
--     sum(quantity * unitprice) as revenue,
--     lag(sum(quantity * unitprice)) over(partition by customerid order by date_format(orderdate, '%Y-%m-01')) as previous_revenue
-- from orders31
-- group by 
-- 	customerid, 
--     date_format(orderdate, '%Y-%m-01')
-- )
-- select * , round((revenue - previous_revenue)* 100/previous_revenue, 2) as growth 
-- from tab1 
-- order by customerid, `month`;
--     
--     
--     
-- 	


-- CREATE TABLE Orders32 (
--     OrderID INT,
--     CustomerID INT,
--     OrderDate DATE,
--     Quantity INT,
--     UnitPrice DECIMAL(10,2)
-- );

-- INSERT INTO Orders32
--     (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
-- VALUES

-- -- Customer 101: 4 consecutive months increasing
-- (1, 101, '2025-01-05', 1, 100),
-- (2, 101, '2025-02-05', 1, 150),
-- (3, 101, '2025-03-05', 1, 200),
-- (4, 101, '2025-04-05', 1, 300),

-- -- Customer 102: increase, then decrease
-- (5, 102, '2025-01-10', 1, 100),
-- (6, 102, '2025-02-10', 1, 200),
-- (7, 102, '2025-03-10', 1, 150),
-- (8, 102, '2025-04-10', 1, 300),

-- -- Customer 103: exactly 3 months increasing
-- (9, 103, '2025-01-15', 1, 100),
-- (10, 103, '2025-02-15', 1, 200),
-- (11, 103, '2025-03-15', 1, 300),

-- -- Customer 104: increasing but missing March
-- (12, 104, '2025-01-01', 1, 100),
-- (13, 104, '2025-02-01', 1, 200),
-- (14, 104, '2025-04-01', 1, 400),
-- (15, 104, '2025-05-01', 1, 500),

-- -- Customer 105: 3-month increasing sequence, then decrease
-- (16, 105, '2025-01-01', 1, 100),
-- (17, 105, '2025-02-01', 1, 200),
-- (18, 105, '2025-03-01', 1, 300),
-- (19, 105, '2025-04-01', 1, 250),
-- (20, 105, '2025-05-01', 1, 400),

-- -- Customer 106: same revenue, not increasing
-- (21, 106, '2025-01-01', 1, 100),
-- (22, 106, '2025-02-01', 1, 100),
-- (23, 106, '2025-03-01', 1, 100),
-- (24, 106, '2025-04-01', 1, 100);


with customer_monthly as (
	select 
		customerid, 
		date_format(orderdate, '%Y-%m-01') as orderMonth, 
		sum(quantity * unitprice) as monthlyRevenue 
	from orders32
	group by 
		customerid, 
		date_format(orderdate, '%Y-%m-01') 
),
customer_preMonth as (
	select 
		* ,
		lag(monthlyRevenue) over(partition by customerid order by orderMonth) as prevRev
	from customer_monthly
),
customer_preMonth2 as (
	select * from customer_preMonth where prevRev is null or prevRev < monthlyRevenue
),
customer_monthly_rn as (
	select * , row_number() over(partition by customerid order by orderMonth) as rn
    from customer_preMonth2
),
customer_groups as (
	select * , 
    date_sub(orderMonth, interval rn month) as grpMonth
    from customer_monthly_rn 
)
select customerid, min(orderMonth) as start , max(ordermonth) as end , count(*)
from customer_groups 
group by customerid
order by customerid;



