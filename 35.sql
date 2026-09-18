USE karmadb;
-- CREATE TABLE Orders25
-- (
--     OrderID       INT,
--     CustomerID    INT,
--     OrderDate     DATE,
--     ProductID     INT,
--     Quantity      INT,
--     UnitPrice     DECIMAL(10,2)
-- );

-- INSERT INTO Orders25
--     (OrderID, CustomerID, OrderDate, ProductID, Quantity, UnitPrice)
-- VALUES
--     (1, 101, '2025-01-05', 1001, 2, 50.00),
--     (2, 101, '2025-01-20', 1002, 1, 100.00),
--     (3, 101, '2025-02-10', 1003, 3, 30.00),
--     (4, 101, '2025-03-15', 1004, 1, 200.00),
--     
--     (5, 102, '2025-01-10', 1001, 1, 50.00),
--     (6, 102, '2025-02-15', 1002, 2, 100.00),
--     (7, 102, '2025-04-01', 1005, 1, 150.00),

--     (8, 103, '2025-01-12', 1003, 2, 30.00),
--     (9, 103, '2025-01-25', 1004, 1, 200.00),
--     (10, 103, '2025-02-20', 1005, 2, 150.00),
--     (11, 103, '2025-03-05', 1001, 1, 50.00),

--     (12, 104, '2025-02-01', 1002, 1, 100.00),
--     (13, 104, '2025-03-10', 1003, 2, 30.00),

--     (14, 105, '2025-01-03', 1001, 5, 50.00),
--     (15, 105, '2025-01-20', 1002, 1, 100.00),
--     (16, 105, '2025-02-10', 1004, 2, 200.00),
--     (17, 105, '2025-03-01', 1005, 1, 150.00),
--     (18, 105, '2025-04-05', 1003, 3, 30.00),

--     (19, 106, '2025-01-15', 1001, 1, 50.00),
--     (20, 106, '2025-03-15', 1002, 1, 100.00),

--     (21, 107, '2025-02-10', 1003, 4, 30.00),
--     (22, 107, '2025-03-20', 1004, 1, 200.00),
--     (23, 107, '2025-04-10', 1005, 2, 150.00),

--     (24, 108, '2025-01-05', 1001, 2, 50.00),
--     (25, 108, '2025-02-05', 1002, 1, 100.00),
--     (26, 108, '2025-02-25', 1003, 2, 30.00);
--     
--     
-- with customer_order as (
-- select distinct CustomerId, date_format(OrderDate, '%Y-%m-01') as OrderMonth from Orders25
-- ),
-- customer_rn as (
--  select CustomerId, 
--  date_sub(OrderMonth, interval (row_number() over(partition by CustomerId order by OrderMonth)) month) as grp
--  from customer_order
--  )
--  select distinct customerId 
--  from customer_rn
--  group by CustomerId, grp
--  having count(*) >= 3


-- CREATE TABLE Orders26
-- (
--     OrderID INT,
--     CustomerID INT,
--     OrderDate DATE,
--     ProductID INT,
--     Quantity INT,
--     UnitPrice DECIMAL(10,2)
-- );

-- INSERT INTO Orders26
--     (OrderID, CustomerID, OrderDate, ProductID, Quantity, UnitPrice)
-- VALUES
--     (1, 101, '2025-01-05', 1001, 2, 100.00),
--     (2, 101, '2025-01-20', 1002, 1, 200.00),
--     (3, 101, '2025-02-10', 1003, 3, 100.00),
--     (4, 101, '2025-03-15', 1004, 2, 150.00),

--     (5, 102, '2025-01-10', 1001, 1, 50.00),
--     (6, 102, '2025-02-15', 1002, 1, 100.00),
--     (7, 102, '2025-03-01', 1005, 2, 100.00),

--     (8, 103, '2025-01-12', 1003, 5, 100.00),
--     (9, 103, '2025-01-25', 1004, 2, 150.00),
--     (10, 103, '2025-02-20', 1005, 3, 200.00),
--     (11, 103, '2025-03-05', 1001, 2, 100.00),

--     (12, 104, '2025-01-01', 1002, 1, 100.00),
--     (13, 104, '2025-03-10', 1003, 3, 100.00),
--     (14, 104, '2025-05-15', 1004, 2, 200.00),

--     (15, 105, '2025-01-03', 1001, 4, 100.00),
--     (16, 105, '2025-02-10', 1002, 3, 150.00),
--     (17, 105, '2025-03-01', 1004, 2, 200.00),
--     (18, 105, '2025-04-05', 1005, 1, 100.00),

--     (19, 106, '2025-01-15', 1001, 1, 50.00),
--     (20, 106, '2025-02-15', 1002, 2, 50.00),
--     (21, 106, '2025-04-15', 1003, 1, 100.00),

--     (22, 107, '2025-02-10', 1003, 3, 100.00),
--     (23, 107, '2025-03-20', 1004, 3, 150.00),
--     (24, 107, '2025-04-10', 1005, 2, 200.00);


-- select * from Orders26;

-- with order_rev as (
-- 	select 
-- 		customerId, 
-- 		date_format(orderDate, '%Y-%m-01') as order_month,
-- 		(quantity * unitPrice) as revenue
-- 	from orders26
-- ),
-- order_monthly as (
-- 	select 
-- 		customerid,
-- 		order_month,
-- 		sum(revenue) as total_revenue
-- 	from order_rev
--     group by customerId, order_month
--     
-- )

-- select 
-- 	customerId, 
--     count(order_month) as MonthCount , 
--     avg(total_revenue) as AverageMonthlyRevenue
-- from order_monthly 
-- group by customerId
-- having count(order_month) >= 3 and avg(total_revenue) > 200


-- CREATE TABLE Orders27
-- (
--     OrderID INT,
--     CustomerID INT,
--     OrderDate DATE,
--     Region VARCHAR(50),
--     Quantity INT,
--     UnitPrice DECIMAL(10,2)
-- );

-- CREATE TABLE Returns27
-- (
--     ReturnID INT,
--     OrderID INT,
--     ReturnDate DATE,
--     RefundAmount DECIMAL(10,2)
-- );

-- INSERT INTO Orders27
--     (OrderID, CustomerID, OrderDate, Region, Quantity, UnitPrice)
-- VALUES
--     (1, 101, '2025-01-05', 'North', 2, 100.00),
--     (2, 101, '2025-01-15', 'North', 1, 200.00),
--     (3, 102, '2025-01-10', 'North', 3, 100.00),
--     (4, 103, '2025-01-12', 'North', 2, 250.00),
--     (5, 104, '2025-01-20', 'North', 5, 100.00),
--     (6, 105, '2025-01-25', 'North', 4, 150.00),

--     (7, 106, '2025-01-10', 'South', 2, 200.00),
--     (8, 106, '2025-01-20', 'South', 1, 100.00),
--     (9, 107, '2025-01-15', 'South', 3, 200.00),
--     (10, 108, '2025-01-18', 'South', 2, 300.00),
--     (11, 109, '2025-01-22', 'South', 5, 120.00),
--     (12, 110, '2025-01-28', 'South', 4, 150.00),

--     (13, 111, '2025-01-05', 'East', 2, 300.00),
--     (14, 112, '2025-01-10', 'East', 4, 150.00),
--     (15, 113, '2025-01-15', 'East', 3, 200.00),
--     (16, 114, '2025-01-20', 'East', 2, 300.00),
--     (17, 115, '2025-01-25', 'East', 5, 120.00),

--     (18, 116, '2025-01-05', 'West', 2, 250.00),
--     (19, 117, '2025-01-10', 'West', 3, 200.00),
--     (20, 118, '2025-01-15', 'West', 4, 150.00),
--     (21, 119, '2025-01-20', 'West', 5, 100.00),
--     (22, 120, '2025-01-25', 'West', 2, 400.00);
-- INSERT INTO Returns27
--     (ReturnID, OrderID, ReturnDate, RefundAmount)
-- VALUES
--     (1, 2, '2025-01-20', 200.00),
--     (2, 4, '2025-01-25', 250.00),
--     (3, 7, '2025-01-25', 100.00),
--     (4, 9, '2025-01-30', 200.00),
--     (5, 13, '2025-01-20', 300.00),
--     (6, 16, '2025-01-25', 300.00),
--     (7, 18, '2025-01-20', 250.00),
--     (8, 22, '2025-01-25', 400.00);


select * from orders27;


select * from returns27;


with order_summary as (
	select 
		o.region, 
		o.customerId, 
		sum((o.quantity * o.unitprice)) as TotalRevenue ,  
		sum(coalesce(r.refundAmount, 0)) as TotalRefund,
		(sum((o.quantity * o.unitprice)) - sum(coalesce(r.refundAmount, 0))) as NetRevenue
	from orders27 o
	left join returns27 r
	on o.orderid = r.orderid
	group by o.region, o.customerId
),
order_rank as (
select 
	region,
    customerId,
    TotalRevenue,
    TotalRefund,
    NetRevenue,
    dense_rank() over(partition by region order by NetRevenue desc) as `Rank`
from order_summary 
)

select * from order_rank where `rank` <=3 order by region, `rank`

