CREATE TABLE Orders38 (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);
INSERT INTO Orders38
    (OrderID, CustomerID, OrderDate, Quantity, UnitPrice)
VALUES

-- January cohort
(1, 101, '2025-01-05', 1, 100),
(2, 101, '2025-02-10', 1, 200),
(3, 101, '2025-03-15', 1, 150),

(4, 102, '2025-01-10', 1, 100),
(5, 102, '2025-02-20', 1, 200),

(6, 103, '2025-01-15', 1, 300),
(7, 103, '2025-03-20', 1, 200),

(8, 104, '2025-01-20', 1, 150),

-- February cohort
(9, 105, '2025-02-05', 1, 100),
(10, 105, '2025-03-10', 1, 200),
(11, 105, '2025-04-15', 1, 300),

(12, 106, '2025-02-10', 1, 200),
(13, 106, '2025-04-10', 1, 250),

(14, 107, '2025-02-15', 1, 300),
(15, 107, '2025-03-15', 1, 200),

-- March cohort
(16, 108, '2025-03-05', 1, 100),
(17, 108, '2025-04-05', 1, 200),
(18, 108, '2025-05-05', 1, 300),

(19, 109, '2025-03-10', 1, 150),

(20, 110, '2025-03-20', 1, 200),
(21, 110, '2025-05-20', 1, 300);


select * from orders38;





with tab1 as (
select customerId, date_format(orderdate, '%Y-%m-01') as orderMonth from orders38
)
, tab2 as (
select *, min(orderMonth) over(partition by customerid) as cohortMonth from tab1
), tab3 as (
select *, timestampdiff(month, cohortMonth, orderMonth) as monthNumber from tab2
),
tab4 as (
select 
	cohortMonth, 
	count(distinct customerid) as cohortcustomers , 
    sum(
		case 
			when monthNumber = 0 then 1
            else 0
        end
    ) as Month0Customers,
    sum(
		case 
			when monthNumber = 1 then 1
            else 0
        end
    ) as Month1Customers,
    sum(
		case 
			when monthNumber = 2 then 1
            else 0
        end
    ) as Month2Customers
from tab3
group by cohortMonth
)
select * ,
	(Month0Customers - Month1Customers) * 100 / Month0Customers as Month1Retention ,
    (Month0Customers - Month2Customers) * 100 / Month0Customers as Month1Retention 
from tab4
order by cohortMonth




