CREATE TABLE Orders42 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Orders42
    (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
VALUES

-- Customer 101
(1, 101, '2025-01-05', 5, 100),       -- 500
(2, 101, '2025-02-05', 6, 100),       -- 600
(3, 101, '2025-03-05', 7, 100),       -- 700
(4, 101, '2025-04-05', 4, 100),       -- 400
(5, 101, '2025-05-05', 4.5, 100),     -- 450
(6, 101, '2025-06-05', 5.5, 100),     -- 550
(7, 101, '2025-07-05', 8, 100),       -- 800

-- Customer 102
-- Increasing streak but never recovers above starting revenue
(8, 102, '2025-01-05', 5, 100),       -- 500
(9, 102, '2025-02-05', 6, 100),       -- 600
(10, 102, '2025-03-05', 7, 100),      -- 700
(11, 102, '2025-04-05', 3, 100),      -- 300
(12, 102, '2025-05-05', 4, 100),      -- 400
(13, 102, '2025-06-05', 4.5, 100),    -- 450

-- Customer 103
-- Multiple increasing streaks
(14, 103, '2025-01-05', 3, 100),      -- 300
(15, 103, '2025-02-05', 4, 100),      -- 400
(16, 103, '2025-03-05', 5, 100),      -- 500
(17, 103, '2025-04-05', 2, 100),      -- 200
(18, 103, '2025-05-05', 3, 100),      -- 300
(19, 103, '2025-06-05', 4, 100),      -- 400
(20, 103, '2025-07-05', 5, 100),      -- 500
(21, 103, '2025-08-05', 6, 100),      -- 600

-- Customer 104
-- No 3-month increasing streak
(22, 104, '2025-01-05', 5, 100),      -- 500
(23, 104, '2025-02-05', 6, 100),      -- 600
(24, 104, '2025-03-05', 5, 100),      -- 500
(25, 104, '2025-04-05', 7, 100),      -- 700
(26, 104, '2025-05-05', 6, 100);      -- 600


select * from orders42;


with tab1 as (
select customerid, date_format(orderdate, '%Y-%m-01') as ordermonth, sum(quantity * unitprice) as rev
from orders42 
group by customerid, date_format(orderdate, '%Y-%m-01')
)
, tab2 as (
	select 
		customerid, 
        ordermonth, 
        rev,
        lag(ordermonth) over(partition by customerid order by ordermonth) as prevMonth,
        lag(rev) over(partition by customerid order by ordermonth) as prevrev
	from tab1
)
,
tab3 as (
	select *, 
		case
			when prevMonth is null then 1
			when prevrev >= rev then 1 
			else 0
		end as grp,
        max(ordermonth) over(partition by customerid order by ordermonth desc) as RecoveryMonth,
        first_value(rev) over(partition by customerid order by ordermonth desc) as RecoveryRevenue 
    from tab2
), 
tab4 as (
	select *, sum(grp) over(partition by customerid order by ordermonth) as newgrp from tab3
)
select 
	customerid, 
	min(ordermonth) as StreakStartMonth,
	max(ordermonth) as StreakEndMonth,
	min(rev) as StartRevenue,
    max(rev) as PeakRevenue,
    RecoveryMonth,
    RecoveryRevenue
from tab4 
group by customerid, newgrp, RecoveryMonth, RecoveryRevenue
having count(*) >= 3 and RecoveryRevenue > min(rev)

order by customerid, StreakStartMonth



