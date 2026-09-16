select * from user_logins;

with tab1 as (
select user_id, login_date, row_number() over (partition by user_id order by login_date) as rn
from user_logins
),
tab2 as (
select user_id, date_sub(login_date, interval rn day) as interval_date from tab1
)
select distinct user_id
from tab2
group by user_id, interval_date
having count(*) >= 3 ;



select * from orders;

with tab1 as (
select user_id, login_date, row_number() over(partition by user_id order by login_date) as rn
from user_logins
),
tab2 as (
select user_id, date_sub(login_date, interval rn day) as dt from tab1
),
tab3 as (
select user_id, count(*) as ct
from tab2
group by user_id, dt
)
select  user_id, max(ct) as mx
from tab3
group by user_id
;








