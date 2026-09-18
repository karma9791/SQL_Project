-- CREATE TABLE Orders33 (
--     OrderID INT,
--     CustomerID INT,
--     OrderDate DATE,
--     Quantity INT,
--     UnitPrice DECIMAL(10,2)
-- );

-- INSERT INTO Orders33
--     (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
-- VALUES

-- -- Customer 101: increasing sequence, total = 600 -> NOT qualify
-- (1, 101, '2025-01-05', 1, 100),
-- (2, 101, '2025-02-05', 1, 200),
-- (3, 101, '2025-03-05', 1, 300),

-- -- Customer 102: increasing sequence, total = 1200 -> QUALIFY
-- (4, 102, '2025-01-05', 1, 300),
-- (5, 102, '2025-02-05', 1, 400),
-- (6, 102, '2025-03-05', 1, 500),

-- -- Customer 103: increasing, but only 2 months -> NOT qualify
-- (7, 103, '2025-01-05', 1, 500),
-- (8, 103, '2025-02-05', 1, 600),

-- -- Customer 104: increasing sequence, then decrease
-- (9, 104, '2025-01-05', 1, 200),
-- (10, 104, '2025-02-05', 1, 300),
-- (11, 104, '2025-03-05', 1, 400),
-- (12, 104, '2025-04-05', 1, 100),

-- -- Customer 105:
-- -- First sequence = 600 -> NOT qualify
-- -- Second sequence = 1650 -> QUALIFY
-- (13, 105, '2025-01-05', 1, 100),
-- (14, 105, '2025-02-05', 1, 200),
-- (15, 105, '2025-03-05', 1, 300),
-- (16, 105, '2025-04-05', 1, 150),
-- (17, 105, '2025-05-05', 1, 400),
-- (18, 105, '2025-06-05', 1, 500),
-- (19, 105, '2025-07-05', 1, 600),

-- -- Customer 106: missing month
-- -- Jan -> Feb -> Apr -> May
-- -- Should NOT be treated as one continuous sequence
-- (20, 106, '2025-01-05', 1, 200),
-- (21, 106, '2025-02-05', 1, 300),
-- (22, 106, '2025-04-05', 1, 500),
-- (23, 106, '2025-05-05', 1, 600),

-- -- Customer 107: increasing sequence, total = 1500 -> QUALIFY
-- (24, 107, '2025-02-05', 1, 300),
-- (25, 107, '2025-03-05', 1, 500),
-- (26, 107, '2025-04-05', 1, 700),

-- -- Customer 108: revenue stays same -> NOT increasing
-- (27, 108, '2025-01-05', 1, 300),
-- (28, 108, '2025-02-05', 1, 300),
-- (29, 108, '2025-03-05', 1, 500),
-- (30, 108, '2025-04-05', 1, 700);



select * from Orders33;

with order_monthly as (
	select 
		customerid, 
        date_format(orderDate, '%Y-%m-01') as ordermonth ,
        sum(quantity * unitprice) as rev 
	from orders33
	group by customerid, date_format(orderDate, '%Y-%m-01')
), 
order_prev as (
select 
	* ,
    lag(ordermonth) over(partition by customerid order by ordermonth) as prevMonth,
    lag(rev) over(partition by customerid order by ordermonth) as prevRev
from order_monthly
    ),
order_group as (
select *,
	case 
		when prevMonth is null then 1
        when prevRev >= rev then 1
        when timestampdiff(month, prevMonth, ordermonth) <> 1 then 1
        else 0
	end grp
from order_prev
),
order_group2 as (
select *,
	sum(grp) over(partition by customerid order by ordermonth) as new_grp
from order_group
)
select 
	customerid, 
    min(ordermonth) as start , 
    max(ordermonth) as end, 
    count(*) as monthCount , 
    sum(rev) as SequenceRevenue
from order_group2
group by customerid, new_grp
having count(*) >= 3 and sum(rev) > 1000
order by customerid;
    






