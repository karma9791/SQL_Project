CREATE TABLE Orders37 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);
INSERT INTO Orders37
    (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
VALUES

-- Customer 101: Jan -> Feb -> Mar ✅
(1, 101, '2025-01-05', 2, 100),
(2, 101, '2025-02-10', 1, 200),
(3, 101, '2025-03-15', 2, 150),

-- Customer 102: Jan -> Feb -> Apr ❌
(4, 102, '2025-01-05', 1, 200),
(5, 102, '2025-02-05', 2, 100),
(6, 102, '2025-04-05', 3, 100),

-- Customer 103: Feb -> Mar -> Apr -> May ✅
(7, 103, '2025-02-01', 1, 300),
(8, 103, '2025-03-10', 1, 400),
(9, 103, '2025-04-15', 2, 200),
(10, 103, '2025-05-20', 1, 500),

-- Customer 104: Jan -> Mar -> Apr ❌
(11, 104, '2025-01-05', 1, 100),
(12, 104, '2025-03-05', 2, 200),
(13, 104, '2025-04-05', 1, 300),

-- Customer 105: only one month ❌
(14, 105, '2025-03-01', 5, 100),

-- Customer 106: May -> Jun -> Jul -> Aug ✅
(15, 106, '2025-05-01', 1, 500),
(16, 106, '2025-06-01', 2, 200),
(17, 106, '2025-07-01', 1, 300),
(18, 106, '2025-08-01', 1, 400),

-- Customer 107: Jan -> Feb -> Mar -> Apr, but multiple orders
(19, 107, '2025-01-05', 1, 100),
(20, 107, '2025-01-20', 2, 100),
(21, 107, '2025-02-10', 1, 300),
(22, 107, '2025-02-25', 2, 200),
(23, 107, '2025-03-15', 1, 500);


select * from orders37;

with tab1 as (
select distinct customerid, date_format(orderdate, '%Y-%m-01') as ordermonth
from orders37
)
,
tab2 as (
select 
	customerid, 
    min(ordermonth) over(partition by  customerid) as firstOrder,
    ordermonth, 
    lead(ordermonth) over(partition by customerid order by ordermonth) as SecondMonth
    -- lead(lead(ordermonth) over(partition by customerid order by ordermonth)) over(partition by customerid order by lead(ordermonth) over(partition by customerid order by ordermonth)) as thirdmonth
from tab1
)
, tab3 as (
select *, lead(SecondMonth) over(partition by customerid order by SecondMonth) as thirdMonth
from tab2
)
select customerid, ordermonth as firstpurchasemonth, secondmonth, thirdmonth from tab3
where firstOrder = ordermonth and
timestampdiff(month, ordermonth, secondmonth) = 1 and
timestampdiff(month, secondmonth, thirdMonth) = 1
order by customerid
