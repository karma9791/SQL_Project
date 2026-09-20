create table nums (
	id int 
	);
    
insert into nums(id) 
values (1),(2),(3),(4),(5);


select * from nums;

with recursive recNums  as (
	select id, 1 as ct
    from nums
    union 
    select id, (ct + 1) as ct
    from recNums
    where ct < id
)

select id from recNums order by id ;

-- 01 kk 02
-- 02 k2 01
-- 03 k2 null
rec
-- 01 kk 02 0 01
-- 02 k2 01 1  01,02
-- 01 k2 02 2

with recursive empR as (
	select 
		empid, 
		name, 
        manager_id, 0 as lvl,
        cast(empid as CHAR(1000)) as seen_emp_id
    from employees
    where empid = 101
    union all
	select e.emp_id, e.name, e.manager_id, er.lvl+1 as lvl, concat(seen_emp_id, ",", emp_id) as seen_emp_id
    from employees e
    join empR er
    on e.empid = er.manager_id
    where find_in_set(e.empid, er.seen_emp_id)
   
)


select empid, name , lvl as level 
from empR
where lvl != 0
order by lvl

truncate table empdata;

create table empdata (
	id int,
    sal int,
    updatedate DATE
);

insert into empdata (id, sal, updatedate)
values 
	(1, 10, '2025-01-10'),
	(2, 10, '2025-01-10'),
    (1, 9, '2025-01-09'),
	(2, 9, '2025-01-09'),
    (1, 8, '2025-01-07'),
	(2, 8, '2025-01-07'),
    (1, 7, '2025-01-05'),
	(2, 7, '2025-01-05'),
    (1, 6, '2025-01-01'),
	(2, 6, '2025-01-01')
;

select * from empdata;

-- 1 11 11 
-- id, sal, valid_from , valid_to, latest
-- 1   10   10  99 1
-- 1   9    9   9   0

update res r
join empdata e
on e.id = r.id
set 
	r.valid_to = DATE_SUB(e.updatedate, INTERVAL 1 DAY),
    latest = False
where latest = True 
and e.sal <> e.sal 
;

insert into res
select e.id, e.sal. e.update_date as valid_from, '9999-12-31' as valid_to, True as latest
from emp e
left join res r
on e.id = r.id
and r.latest = True
where t.is is null or e.sal <> r.sal







with latestRec as (
select * from res where latest
);
-- insert
insert into latestRec 
select e.id, e.sal, e.updatedate as valid_from , '9999-12-31' as valid_to, true as latest
from empdata e
join latestRec l
on e.id = l.id
where e.updatedate > valid_from;

update latestRec
set valid_to = (
	select updatedate 
    from empdata e
    join latestRec l
	on e.id = l.id
	where e.updatedate > valid_from
)

;


with tab1 as (
select * , lag(updatedate) over(partition by id order by updatedate desc) as prevDate from empdata
)
select 
	id, 
	sal, 
    updateDate as valid_from ,
    case
		when prevDate is null then '9999-12-31'
        else date_sub(prevDate,interval 1 day)
    end as valid_to,
    case
		when prevDate is null then True
        else False
    end as latest
from tab1





    












