CREATE TABLE Orders30
(
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    OrderAmount DECIMAL(10,2)
);

INSERT INTO Orders30
    (OrderID, CustomerID, OrderDate, OrderAmount)
VALUES
    -- Customer 101: cohort Jan, returns Feb and Mar
    (1, 101, '2025-01-05', 100.00),
    (2, 101, '2025-02-10', 150.00),
    (3, 101, '2025-03-15', 200.00),

    -- Customer 102: cohort Jan, returns Feb
    (4, 102, '2025-01-10', 200.00),
    (5, 102, '2025-02-20', 100.00),

    -- Customer 103: cohort Jan, no return
    (6, 103, '2025-01-15', 300.00),

    -- Customer 104: cohort Feb, returns Mar and Apr
    (7, 104, '2025-02-05', 150.00),
    (8, 104, '2025-03-10', 200.00),
    (9, 104, '2025-04-15', 250.00),

    -- Customer 105: cohort Feb, returns Apr
    (10, 105, '2025-02-10', 100.00),
    (11, 105, '2025-04-20', 200.00),

    -- Customer 106: cohort Mar, returns Apr
    (12, 106, '2025-03-01', 300.00),
    (13, 106, '2025-04-05', 100.00),

    -- Customer 107: cohort Mar, no return
    (14, 107, '2025-03-15', 150.00),

    -- Customer 108: multiple orders in same month
    (15, 108, '2025-01-05', 100.00),
    (16, 108, '2025-01-20', 200.00),
    (17, 108, '2025-02-10', 100.00),

    -- Customer 109: cohort Apr, returns May
    (18, 109, '2025-04-01', 500.00),
    (19, 109, '2025-05-10', 300.00);
    
    
select * from orders30;

with tab1 as (

select customerId, min(date_format(orderdate, '%Y-%m-01')) cohordMonth from orders30 group by customerId
)
, tab2 as (
select o.customerid , t.cohordMonth, date_format(orderdate, '%Y-%m-01') as ordermonth, timestampdiff(month, cohordMonth, date_format(orderdate, '%Y-%m-01')) as diffMonth
from orders30 o
join tab1 t
on o.customerid = t.customerid
order by cohordMonth
)
, tab3 as (
select cohordMonth, ordermonth, count(distinct customerid) as ActiveCustomers
from tab2
group by cohordMonth, ordermonth
),
tab4 as (
select cohordMonth, count(distinct customerid) as CohortCustomers
from tab2
group by cohordMonth
)

select *, round(a.activecustomers *100 / b.CohortCustomers) from tab3 a join tab4 b on a.cohordMonth = b.cohordMonth order by b.CohortCustomers, a.ordermonth

;






