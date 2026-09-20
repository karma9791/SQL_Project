CREATE TABLE Orders41 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Orders41
    (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
VALUES

-- Customer 101
(1, 101, '2025-01-01', 1, 100),
(2, 101, '2025-01-10', 2, 100),
(3, 101, '2025-01-25', 1, 200),
(4, 101, '2025-03-01', 2, 150),
(5, 101, '2025-03-15', 1, 100),
(6, 101, '2025-05-20', 3, 100),

-- Customer 102
-- Exactly 30 days → same session
(7, 102, '2025-01-01', 1, 100),
(8, 102, '2025-01-31', 2, 100),
(9, 102, '2025-02-15', 1, 200),
(10, 102, '2025-04-01', 2, 100),

-- Customer 103
-- Continuous activity
(11, 103, '2025-01-01', 1, 100),
(12, 103, '2025-01-05', 1, 100),
(13, 103, '2025-01-20', 2, 100),
(14, 103, '2025-02-01', 1, 200),

-- Customer 104
-- Multiple sessions
(15, 104, '2025-01-01', 1, 500),
(16, 104, '2025-02-10', 1, 500),
(17, 104, '2025-02-20', 1, 500),
(18, 104, '2025-04-01', 2, 300),
(19, 104, '2025-04-15', 1, 200),
(20, 104, '2025-06-01', 1, 400);



select * from orders41;

with tab1 as (
	select customerid, orderdate, timestampdiff(day, lag(orderdate) over(partition by customerid order by orderdate), orderdate) as daysDiff, quantity * unitprice as revenue
	from orders41
    )
,  tab2 as (
select customerid, 
orderdate,
	case 
		when daysdiff is null then 1
        when daysdiff >=30 then 1
        else 0
    end as grp,
    revenue
from tab1
), tab3 as (
select customerid, orderdate, sum(grp) over(partition by customerid order by orderdate) as newGrp, revenue
from tab2)

select 
	customerid, 
    min(orderdate) as SessionStart, 
    max(orderdate) as SessionEnd, 
    count(*) as OrderCount, 
    sum(revenue) as TotalRevenue, 
    timestampdiff(day, min(orderdate), max(orderdate)) as SessionDurationDays
from tab3
group by customerid, newgrp
order by customerid, sessionstart


