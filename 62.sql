-- with recursive tab1 as (  
-- 	select 1 as ct
--     union     
--     select ct + 1 FROM tab1    
--     where ct < 10 )  
-- select * from tab1


CREATE TABLE Orders35 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Orders35
    (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
VALUES

-- Customer 101: reactivated after >60 days
(1, 101, '2025-01-05', 2, 100),
(2, 101, '2025-01-20', 1, 100),
(3, 101, '2025-02-10', 3, 100),
(4, 101, '2025-05-01', 2, 200),
(5, 101, '2025-05-15', 1, 100),

-- Customer 102: never has a 60-day gap
(6, 102, '2025-01-01', 1, 100),
(7, 102, '2025-02-15', 2, 100),
(8, 102, '2025-03-20', 1, 200),
(9, 102, '2025-05-01', 2, 100),

-- Customer 103: exactly 60 days
(10, 103, '2025-01-01', 1, 100),
(11, 103, '2025-03-02', 2, 150),
(12, 103, '2025-03-20', 1, 100),

-- Customer 104: multiple reactivations
(13, 104, '2025-01-01', 1, 100),
(14, 104, '2025-01-10', 1, 100),
(15, 104, '2025-04-01', 2, 200),
(16, 104, '2025-04-15', 1, 100),
(17, 104, '2025-08-01', 3, 100),

-- Customer 105: only one order
(18, 105, '2025-02-01', 5, 100),

-- Customer 106: gap less than 60 days
(19, 106, '2025-01-01', 1, 100),
(20, 106, '2025-02-28', 2, 100),
(21, 106, '2025-04-25', 1, 200),

-- Customer 107: multiple orders on same day
(22, 107, '2025-01-01', 1, 100),
(23, 107, '2025-01-01', 2, 100),
(24, 107, '2025-04-01', 1, 300);

select * from orders35;


with tab1 as (
select 
	customerid, 
    orderdate as ReactivationDate , 
    datediff(orderdate, lag(orderdate) over(partition by customerid order by orderdate)) as DaysSincePreviousOrder ,
    quantity * unitprice as ReactivationRevenue
from orders35
)
select * from tab1 where DaysSincePreviousOrder >=60 

