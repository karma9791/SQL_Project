CREATE TABLE customers7 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    account_created_date DATE
);
INSERT INTO customers7
(customer_id, customer_name, account_created_date)
VALUES

(101, 'John', '2025-01-01'),
(102, 'Alice', '2025-01-10'),
(103, 'Bob', '2025-02-01'),
(104, 'David', '2025-02-15'),
(105, 'Emma', '2025-03-01');
CREATE TABLE transactions7 (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    amount DECIMAL(10,2)
);
INSERT INTO transactions7
(transaction_id, customer_id, transaction_date, amount)
VALUES

-- Customer 101
(1,101,'2024-12-25',500),   -- before account creation
(2,101,'2025-01-05',100),
(3,101,'2025-01-10',200),

-- Customer 102
(4,102,'2025-01-10',300),   -- same day as creation
(5,102,'2025-01-20',500),

-- Customer 103
(6,103,'2025-01-25',100),   -- before account creation
(7,103,'2025-02-05',400),

-- Customer 104
(8,104,'2025-02-10',200),   -- before account creation

-- Customer 105
(9,105,'2025-03-01',700),
(10,105,'2025-03-15',900);

select customer_id, customer_name, transaction_date as first_transaction_date , amount from (
select c.customer_id, c.customer_name, t.transaction_date ,amount,  row_number() over(partition by c.customer_id order by t.transaction_date, t.transaction_id) as rn
from customers7 c
join transactions7 t
on c.customer_id = t.customer_id
and t.transaction_date >= c.account_created_date) a
where rn = 1
