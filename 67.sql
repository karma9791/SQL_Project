-- CREATE TABLE Orders40 (
--     OrderID INT,
--     CustomerID INT,
--     OrderDate DATE,
--     Quantity INT,
--     UnitPrice DECIMAL(10,2)
-- );

-- INSERT INTO Orders40
--     (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
-- VALUES

-- -- Customer 101
-- -- Jan → Feb → Mar → Apr increasing
-- (1, 101, '2025-01-05', 5, 100),      -- 500
-- (2, 101, '2025-02-05', 6, 100),      -- 600
-- (3, 101, '2025-03-05', 7, 100),      -- 700
-- (4, 101, '2025-04-05', 9, 100),      -- 900

-- -- Customer 102
-- -- Jan → Feb increase, Feb → Mar decrease
-- (5, 102, '2025-01-10', 5, 100),      -- 500
-- (6, 102, '2025-02-10', 7, 100),      -- 700
-- (7, 102, '2025-03-10', 6, 100),      -- 600
-- (8, 102, '2025-04-10', 8, 100),      -- 800

-- -- Customer 103
-- Two separate increasing sequences
-- (9, 103, '2025-01-05', 5, 100),       -- 500
-- (10, 103, '2025-02-05', 6, 100),      -- 600
-- (11, 103, '2025-03-05', 7, 100),      -- 700
-- (12, 103, '2025-04-05', 5, 100),      -- 500
-- (13, 103, '2025-05-05', 6, 100),      -- 600
-- (14, 103, '2025-06-05', 7, 100),      -- 700
-- (15, 103, '2025-07-05', 8, 100),      -- 800

-- Customer 104
-- Missing March → cannot form Jan-Feb-Mar sequence
-- (16, 104, '2025-01-05', 5, 100),      -- 500
-- (17, 104, '2025-02-05', 6, 100),      -- 600
-- (18, 104, '2025-04-05', 8, 100),      -- 800
-- (19, 104, '2025-05-05', 9, 100),      -- 900

-- Customer 105
-- Revenue remains equal → NOT strictly increasing
-- (20, 105, '2025-01-05', 5, 100),      -- 500
-- (21, 105, '2025-02-05', 5, 100),      -- 500
-- (22, 105, '2025-03-05', 5, 100),      -- 500
-- (23, 105, '2025-04-05', 6, 100),      -- 600

-- Customer 106
-- Long increasing sequence
-- (24, 106, '2025-01-05', 1, 1000),     -- 1000
-- (25, 106, '2025-02-05', 2, 1000),     -- 2000
-- (26, 106, '2025-03-05', 3, 1000),     -- 3000
-- (27, 106, '2025-04-05', 4, 1000),     -- 4000
-- (28, 106, '2025-05-05', 5, 1000);     -- 5000



select * from orders40 where customerid = 105;

with tab1 as (
select customerid, date_format(orderdate, '%Y-%m-01') orderMonth, sum(quantity * unitprice) as monthRevenue
from orders40
group by customerid, date_format(orderdate, '%Y-%m-01')
)
, tab2 as (
select 
	customerid, 
    ordermonth, 
    monthRevenue, 
    lag(ordermonth) over(partition by customerid order by ordermonth) as prevMonth,
    lag(monthRevenue) over(partition by customerid order by ordermonth) as prevRev
   -- date_SUB(montherRevenue, interval (row_number() over(partition by customerid order by orderMonth)) month) as groupMonth
from tab1
)
, tab3 as (
select 
	*,
    case
		when prevMonth is null then 1
        when timestampdiff(month, prevMonth, ordermonth) > 1 then 1
        when prevRev >= monthRevenue then 1
        else 0
    end as grp
from tab2 
)
, tab4 as (
select * , sum(grp) over(partition by customerid order by ordermonth) as new_grp
from tab3
)

select 
	customerid, 
    min(ordermonth) as StartMonth, 
    max(ordermonth) as EndMonth, 
    min(monthRevenue) as StartRevenue, 
    max(monthRevenue) as EndRevenue, 
    sum(monthRevenue) as TotalRevenue
from tab4
group by customerid, new_grp
having count(*) >= 3





