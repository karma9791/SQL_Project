CREATE TABLE ApiLogs45 (
    RequestID INT,
    ServiceName VARCHAR(50),
    UserID INT,
    RequestTime DATETIME,
    StatusCode INT,
    ResponseTimeMs INT
);
INSERT INTO ApiLogs45
    (RequestID, ServiceName, UserID, RequestTime, StatusCode, ResponseTimeMs)
VALUES

-- Payment service
(1, 'Payment', 101, '2025-01-10 10:00:00', 200, 120),
(2, 'Payment', 102, '2025-01-10 10:01:00', 500, 900),
(3, 'Payment', 103, '2025-01-10 10:02:00', 500, 1100),
(4, 'Payment', 104, '2025-01-10 10:03:00', 200, 130),
(5, 'Payment', 105, '2025-01-10 10:04:00', 500, 950),
(6, 'Payment', 106, '2025-01-10 10:05:00', 200, 150),

-- Search service
(7, 'Search', 201, '2025-01-10 10:00:00', 200, 100),
(8, 'Search', 202, '2025-01-10 10:01:00', 200, 110),
(9, 'Search', 203, '2025-01-10 10:02:00', 500, 800),
(10, 'Search', 204, '2025-01-10 10:03:00', 200, 120),
(11, 'Search', 205, '2025-01-10 10:04:00', 200, 130),

-- Recommendation service
(12, 'Recommendation', 301, '2025-01-10 10:00:00', 500, 1000),
(13, 'Recommendation', 302, '2025-01-10 10:01:00', 500, 1200),
(14, 'Recommendation', 303, '2025-01-10 10:02:00', 500, 1100),
(15, 'Recommendation', 304, '2025-01-10 10:03:00', 500, 1300),
(16, 'Recommendation', 305, '2025-01-10 10:04:00', 200, 150),

-- Catalog service
(17, 'Catalog', 401, '2025-01-10 10:00:00', 200, 200),
(18, 'Catalog', 402, '2025-01-10 10:01:00', 200, 210),
(19, 'Catalog', 403, '2025-01-10 10:02:00', 200, 190),
(20, 'Catalog', 404, '2025-01-10 10:03:00', 200, 180);

select * from ApiLogs45;

with tab1 as (
select serviceName, 
	count(*) as total_requests,
    sum(
		case
			when statuscode >= 500 then 1 
            else 0
        end
		) as failed_requests,
	round(avg(ResponseTimeMs), 2) as AvgResponseTime,
	max(ResponseTimeMs) as MaxResponseTime
from ApiLogs45
group by serviceName
)

select 
	*, 
    round(failed_requests * 100/ total_requests, 2) as failedPercentage
from tab1
where 
	failed_requests >= 2 and 
    round(failed_requests * 100/ total_requests, 2) >= 40
order by failedPercentage desc;


with tab1 as (
select customerid
from (
	select distinct customerid, date_format('%Y-%m-01', order_date) as order_month
	from orders26 as tt
group by customerid
having count(*) >= 2
)
)

select a.customerid, acustomername
from customers26 a
join tab1 b
on b.customerid = a.customerid;


select 1



