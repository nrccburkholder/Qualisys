/*
-- modified 10/08/2007 by djk (added rollbacktype to temp table and query)
*/
CREATE procedure [dbo].[QP_Rep_Generation_Rollbacks]
 @Associate varchar(50),
 @BeginDate datetime,
 @EndDate datetime
AS
set transaction isolation level read uncommitted
create table #display (AccountDirector varchar(42), Survey_id int, Study_id int, RollbackDate datetime, [Count] int, Type varchar(42))

insert into #display
select e.strntlogin_nm, r.survey_id, r.study_id, r.datrollback_dt, r.cnt, r.rollbacktype
from employee e, study s, rollbacks r
where r.study_id = s.study_id
and s.ademployee_id = e.employee_id
and datrollback_dt between @BeginDate and dateadd(day,1,@EndDate)
union
select 'No AD Assigned', r.survey_id, r.study_id, r.datrollback_dt, r.cnt, r.rollbacktype
from employee e, study s, rollbacks r
where r.study_id = s.study_id
and s.ademployee_id is null
and datrollback_dt between @BeginDate and dateadd(day,1,@EndDate)
order by datrollback_dt

if (select count(*) from #display) < 1
begin
 insert into #display (AccountDirector)
	select 'No Rollbacks Logged'
end

select * from #display

drop table #display

set transaction isolation level read committed


