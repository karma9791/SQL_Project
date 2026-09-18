CREATE TABLE Products29
(
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);
CREATE TABLE Orders29
(
    OrderID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);
INSERT INTO Products29
    (ProductID, ProductName, Category)
VALUES
    (101, 'Laptop', 'Electronics'),
    (102, 'Phone', 'Electronics'),
    (103, 'Headphones', 'Electronics'),
    (104, 'Tablet', 'Electronics'),

    (201, 'Running Shoes', 'Sports'),
    (202, 'Football', 'Sports'),
    (203, 'Tennis Racket', 'Sports'),
    (204, 'Yoga Mat', 'Sports'),

    (301, 'Coffee Maker', 'Home'),
    (302, 'Vacuum Cleaner', 'Home'),
    (303, 'Toaster', 'Home'),
    (304, 'Blender', 'Home');
INSERT INTO Orders29
    (OrderID, ProductID, OrderDate, Quantity, UnitPrice)
VALUES
    (1, 101, '2025-01-01', 5, 1000),
    (2, 101, '2025-01-10', 3, 1000),
    (3, 102, '2025-01-05', 10, 500),
    (4, 102, '2025-01-15', 5, 500),
    (5, 103, '2025-01-03', 10, 100),
    (6, 104, '2025-01-05', 20, 200),

    (7, 201, '2025-01-02', 10, 100),
    (8, 201, '2025-01-15', 5, 100),
    (9, 202, '2025-01-04', 10, 100),
    (10, 202, '2025-01-20', 5, 100),
    (11, 203, '2025-01-05', 5, 200),
    (12, 204, '2025-01-10', 20, 50),

    (13, 301, '2025-01-01', 10, 100),
    (14, 302, '2025-01-02', 5, 200),
    (15, 303, '2025-01-03', 10, 50),
    (16, 304, '2025-01-04', 5, 100);
    
with prod_rev as(
select productid, sum(quantity * unitprice) as revenue
from orders29
group by productid)
, final as (
select p.category, p.productid, p.productname, o.revenue , rank() over(partition by p.category order by o.revenue desc) as rk
from prod_rev o
join products29 p
on o.productid = p.productid
)
select * from final where rk <=2

