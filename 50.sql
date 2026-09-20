CREATE TABLE EmployeeSalary43 (
    EmployeeID INT,
    Salary DECIMAL(10,2),
    EffectiveDate DATE
);
INSERT INTO EmployeeSalary43
    (EmployeeID, Salary, EffectiveDate)
VALUES
-- Employee 101
(101, 50000, '2022-01-01'),
(101, 55000, '2023-01-01'),
(101, 60000, '2024-01-01'),
(101, 65000, '2025-01-01'),

-- Employee 102
(102, 70000, '2022-06-01'),
(102, 70000, '2023-06-01'),
(102, 75000, '2024-06-01'),
(102, 80000, '2025-06-01'),

-- Employee 103
(103, 45000, '2022-03-01'),
(103, 50000, '2023-03-01'),
(103, 48000, '2024-03-01'),
(103, 52000, '2025-03-01'),

-- Employee 104
(104, 60000, '2022-01-01'),
(104, 65000, '2023-01-01'),
(104, 70000, '2024-01-01');

select * from EmployeeSalary43;

with tab1 as (
select employeeid, salary, lag(salary) over(partition by employeeid order by effectivedate) as prevSalary, effectivedate
from EmployeeSalary43
),
tab2 as (
select * from tab1 where employeeid not in (select employeeid from tab1 where prevSalary >= salary)
)
select 
	employeeid, 
    min(salary) as StartingSalary,
    max(salary) as CurrentSalary,
    (max(salary) - min(salary))TotalIncreases
from tab2
group by employeeid
order by employeeid



