CREATE procedure sp_dbm_targetinfo
as

set nocount on
select perioddate, target, sampleunit_id into #targets from targetinfo

delete targetinfo where perioddate >= dateadd(month,-4,getdate())

--insert into targetinfo select 'No Mailing this Period', null,null,null,null,null,null,null,null,null,null

declare @survey_id int

declare survey cursor for select survey_id from survey_def order by survey_id

create table #samplesets (sampleset_id int,survey_id int, datperioddate datetime)

open survey
fetch next from survey into @survey_id
while @@fetch_status = 0
begin
  insert into #samplesets
  select sampleset_id, survey_id, (select min(datperioddate) from period where survey_id=@survey_id and datperioddate > datsamplecreate_dt) as PeriodDate  
  from sampleset 
  where survey_id = @survey_id
  and (select min(datperioddate) from period where survey_id=@survey_id and datperioddate > datsamplecreate_dt) >= dateadd(month,-4,getdate())

 fetch next from survey into @survey_id
end

close survey
deallocate survey

create table #sampleunit (sampleunit_id int, cnt int, target int, perioddate datetime)

insert into #sampleunit (sampleunit_id, cnt, perioddate)
select sampleunit_id, count(*) as cnt, ts.datperioddate
from questionform qf, #samplesets ts, samplepop sp, selectedsample ss
where qf.survey_id = ts.survey_id
and qf.datreturned is not null
and qf.samplepop_id = sp.samplepop_id
and sp.sampleset_id = ts.sampleset_id
and sp.sampleset_id = ss.sampleset_id
and sp.pop_id = ss.pop_id
group by sampleunit_id, ts.datperioddate


update tsu set target = inttargetreturn
from #sampleunit tsu, sampleunit su
where tsu.sampleunit_id = su.sampleunit_id

delete #sampleunit where target = 0

insert into targetinfo (sampleunit_id, target, returns, perioddate)
select sampleunit_id, target, cnt, perioddate from #sampleunit

drop table #samplesets
drop table #sampleunit

update ti set ti.strclient_nm = c.strclient_nm, ti.client_id = c.client_id, ti.strstudy_nm = s.strstudy_nm,
ti.study_id = s.study_id, ti.strsurvey_nm = sd.strsurvey_nm, ti.survey_id = sd.survey_id, ti.strsampleunit_nm = su.strsampleunit_nm
from targetinfo ti, client c, study s, survey_def sd, sampleunit su, sampleplan sp
where ti.sampleunit_id = su.sampleunit_id
and su.sampleplan_id = sp.sampleplan_id
and sp.survey_id = sd.survey_id 
and sd.study_id = s.study_id
and s.client_id = c.client_id
and ti.client_id is null

update ti set ti.target = t.target
from targetinfo ti, #targets t
where ti.perioddate = t.perioddate
and ti.sampleunit_id = t.sampleunit_id

drop table #targets


