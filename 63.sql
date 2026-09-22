CREATE TABLE Orders36 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

INSERT INTO Orders36
    (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
VALUES

-- January
(1, 101, '2025-01-05', 2, 200),
(2, 101, '2025-01-10', 2, 300),
(3, 101, '2025-01-20', 1, 100),

(4, 102, '2025-01-05', 4, 150),
(5, 102, '2025-01-15', 2, 300),

(6, 103, '2025-01-10', 10, 200),

(7, 104, '2025-01-05', 4, 150),
(8, 104, '2025-01-20', 2, 300),

-- February
(9, 101, '2025-02-05', 2, 300),
(10, 101, '2025-02-15', 2, 200),

(11, 102, '2025-02-05', 1, 500),

(12, 103, '2025-02-10', 5, 200),
(13, 103, '2025-02-20', 5, 200),

(14, 104, '2025-02-05', 2, 300),
(15, 104, '2025-02-25', 2, 300),

-- March
(16, 101, '2025-03-05', 5, 200),
(17, 101, '2025-03-15', 2, 250),

(18, 102, '2025-03-10', 10, 100),
(19, 102, '2025-03-20', 5, 200),

(20, 103, '2025-03-05', 2, 500),

(21, 104, '2025-03-05', 5, 200),
(22, 104, '2025-03-15', 5, 200);

select * from orders36;

with tab1 as (
select customerid, date_format(orderDate, '%Y-%m-01') as orderMonth, sum(quantity * unitprice) as rev, count(*) as ordercount
from orders36 
group by customerid, date_format(orderDate, '%Y-%m-01')
having orderCount >= 2
),
tab2 as (
select * , dense_rank() over(partition by ordermonth order by rev desc) as rn
from tab1
)
select customerid, ordermonth, ordercount, rev as total_revenue
from tab2
where rn = 1

