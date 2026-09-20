CREATE TABLE EmployeeAttendance44 (
    EmployeeID INT,
    AttendanceDate DATE,
    Status CHAR(1)
);

INSERT INTO EmployeeAttendance44
    (EmployeeID, AttendanceDate, Status)
VALUES

-- Employee 101
(101, '2025-01-06', 'P'),
(101, '2025-01-07', 'A'),
(101, '2025-01-08', 'A'),
(101, '2025-01-09', 'A'),
(101, '2025-01-10', 'P'),
(101, '2025-01-13', 'P'),

-- Employee 102
(102, '2025-01-06', 'P'),
(102, '2025-01-07', 'A'),
(102, '2025-01-08', 'A'),
(102, '2025-01-09', 'P'),
(102, '2025-01-10', 'A'),
(102, '2025-01-13', 'A'),

-- Employee 103
(103, '2025-01-06', 'A'),
(103, '2025-01-07', 'A'),
(103, '2025-01-08', 'A'),
(103, '2025-01-09', 'A'),
(103, '2025-01-10', 'P'),

-- Employee 104
(104, '2025-01-06', 'P'),
(104, '2025-01-07', 'A'),
(104, '2025-01-08', 'P'),
(104, '2025-01-09', 'A'),
(104, '2025-01-10', 'A');

select * from EmployeeAttendance44;


with employee_grps as (
	select 
		employeeid, 
        attendanceDate, 
        date_sub(attendanceDate, interval (row_number() over(partition by employeeid order by attendanceDate)) day) as grpDate , 
        Status
	from EmployeeAttendance44
	where Status = 'A'
)

select 
	employeeid, 
    min(attendanceDate) as AbsenceStart, 
    max(attendanceDate) as AbsenceEnd, 
    count(*) as AbsentDays
from employee_grps
group by employeeid, grpDate
having count(*) >= 3
order by employeeid
