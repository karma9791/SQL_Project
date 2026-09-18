-- CREATE TABLE Orders28
-- (
--     OrderID INT,
--     CustomerID INT,
--     OrderDate DATE,
--     OrderAmount DECIMAL(10,2)
-- );

-- INSERT INTO Orders28
--     (OrderID, CustomerID, OrderDate, OrderAmount)
-- VALUES
--     -- Customer 101: qualifies
--     (1, 101, '2025-01-05', 100.00),
--     (2, 101, '2025-01-20', 150.00),
--     (3, 101, '2025-02-10', 200.00),
--     (4, 101, '2025-05-01', 300.00),

--     -- Customer 102: does not qualify
--     (5, 102, '2025-01-05', 100.00),
--     (6, 102, '2025-03-10', 200.00),
--     (7, 102, '2025-04-15', 150.00),

--     -- Customer 103: qualifies
--     (8, 103, '2025-01-01', 500.00),
--     (9, 103, '2025-01-15', 100.00),
--     (10, 103, '2025-02-01', 200.00),

--     -- Customer 104: does not qualify
--     (11, 104, '2025-01-01', 100.00),
--     (12, 104, '2025-01-10', 100.00),

--     -- Customer 105: has multiple qualifying sequences
--     (13, 105, '2025-01-01', 100.00),
--     (14, 105, '2025-01-10', 100.00),
--     (15, 105, '2025-01-25', 100.00),
--     (16, 105, '2025-06-01', 500.00),
--     (17, 105, '2025-06-15', 200.00),
--     (18, 105, '2025-06-30', 300.00),

--     -- Customer 106: exactly 30 days apart
--     (19, 106, '2025-01-01', 100.00),
--     (20, 106, '2025-01-31', 200.00),
--     (21, 106, '2025-03-02', 300.00),

--     -- Customer 107: one gap > 30 days
--     (22, 107, '2025-01-01', 100.00),
--     (23, 107, '2025-01-20', 200.00),
--     (24, 107, '2025-03-01', 300.00),
--     (25, 107, '2025-03-20', 400.00);
--     

select * from Orders28;

with tab1 as (
select customerid, orderdate, lag(orderdate) over(partition by customerId order by orderdate) as previous_date, orderamount
from orders28),
tab2 as (
select *, datediff(orderdate, previous_date) as diff from tab1
),
tab3 as (
select *, 
case 
	when diff is null then 1
    when diff>30 then 1
    else 0
end as kk
	
 from tab2)
 , tab4 as (
 select *, sum(kk) over(partition by customerid order by orderdate) as grp from tab3
 )
 
 select customerid, max(orderdate), min(orderdate) , count(customerid), sum(orderamount) 
 from tab4
 group by customerid, grp
 having count(*) >= 3
 
 