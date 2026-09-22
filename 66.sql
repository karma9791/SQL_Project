CREATE TABLE Orders39 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);
INSERT INTO Orders39
    (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
VALUES

-- Customer 101
(1, 101, '2025-01-05', 5, 100),       -- 500
(2, 101, '2025-02-05', 6, 100),       -- 600
(3, 101, '2025-03-05', 8, 100),       -- 800
(4, 101, '2025-05-05', 10, 100),      -- 1000

-- Customer 102
(5, 102, '2025-01-10', 10, 100),      -- 1000
(6, 102, '2025-02-10', 8, 100),       -- 800
(7, 102, '2025-04-10', 10, 100),      -- 1000
(8, 102, '2025-05-10', 12, 100),      -- 1200

-- Customer 103
(9, 103, '2025-01-15', 4, 100),       -- 400
(10, 103, '2025-02-15', 6, 100),      -- 600
(11, 103, '2025-03-15', 5, 100),      -- 500
(12, 103, '2025-04-15', 7, 100),      -- 700

-- Customer 104
(13, 104, '2025-01-20', 3, 200),      -- 600
(14, 104, '2025-02-20', 4, 200),      -- 800
(15, 104, '2025-03-20', 2, 200),      -- 400
(16, 104, '2025-04-20', 5, 200),      -- 1000

-- Customer 105
(17, 105, '2025-01-25', 2, 300),      -- 600
(18, 105, '2025-02-25', 3, 300),      -- 900
(19, 105, '2025-03-25', 4, 300),      -- 1200
(20, 105, '2025-04-25', 5, 300);      -- 1500



select * from orders39;


with tab1 as (
select customerid, date_format(orderdate, '%Y-%m-01') as ordermonth , sum(quantity * unitprice) as monthlyRevenue
from orders39
group by customerid, date_format(orderdate, '%Y-%m-01')
),
tab2 as (
select *, lag(monthlyRevenue) over(partition by customerid order by ordermonth) as previousMonthRevenue
from tab1
), 
tab3 as (
select * 
from tab2
where previousMonthRevenue < monthlyRevenue
and monthlyRevenue > 500
),
tab4 as (
select *, dense_rank() over (partition by orderMonth order by monthlyRevenue desc) as RevenueRank, round( (monthlyRevenue-previousMonthRevenue)*100 / nullif(previousMonthRevenue, 0), 2) as growthPercentage
from tab3
)
select * from tab4 where RevenueRank <= 3























