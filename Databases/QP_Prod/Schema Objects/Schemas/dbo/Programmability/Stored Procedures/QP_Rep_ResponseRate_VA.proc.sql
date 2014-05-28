CREATE procedure QP_Rep_ResponseRate_VA
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @FirstSampleSet varchar(50),
 @LastSampleSet varchar(50)
AS
set transaction isolation level read uncommitted

set nocount on

Declare @intSurvey_id int, @intSampleSet_id1 int, @intSampleSet_id2 int, @intSamplePlan_id int
select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id1=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@FirstSampleSet)))<=1

select @intSampleSet_id2=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@LastSampleSet)))<=1

select sampleset_id, sampleunit_id, intSampled, intUD, intReturned 
into #rr
from RespRateCount 
where survey_id=@intSurvey_id
  and sampleset_id between @intSampleSet_id1 and @intSampleSet_id2

declare @datLastExtract datetime
select @datLastExtract=rrrundate from RR_Date where qpc_timestamp=(select max(qpc_timestamp) from RR_Date)

select qf.survey_id, ss.sampleset_id, ss.sampleunit_id, sp.samplepop_id 
into #rtrn
from questionform qf, samplepop sp, selectedsample ss
where qf.survey_id=@intSurvey_id
  and qf.datreturned > @datLastExtract
  and qf.samplepop_id=sp.samplepop_id
  and sp.sampleset_id=ss.sampleset_id
  and sp.sampleset_id between @intSampleSet_id1 and @intSampleSet_id2
  and sp.pop_id=ss.pop_Id
  and ss.strUnitSelectType='D'

select qf.survey_id, ss.sampleset_id, ss.sampleunit_id, sp.samplepop_id 
into #ud
from sentmailing sm, questionform qf, samplepop sp, selectedsample ss
where qf.survey_id=@intSurvey_id
  and qf.sentmail_id=sm.sentmail_id
  and sm.datundeliverable > @datLastExtract
  and qf.samplepop_id=sp.samplepop_id
  and sp.sampleset_id=ss.sampleset_id
  and sp.sampleset_id between @intSampleSet_id1 and @intSampleSet_id2
  and sp.pop_id=ss.pop_Id
  and ss.strUnitSelectType='D'

update rr
set intReturned=intReturned+cnt
from #RR rr, 
  (select sampleset_id,sampleunit_id,count(*) as cnt 
   from #rtrn 
   group by sampleset_id,sampleunit_id) sub
where rr.sampleset_id=sub.sampleset_id
  and rr.sampleunit_id=sub.sampleunit_id

update rr
set intUD=intUD+cnt
from #RR rr, 
  (select sampleset_id,sampleunit_id,count(*) as cnt 
   from #UD 
   group by sampleset_id,sampleunit_id) sub
where rr.sampleset_id=sub.sampleset_id
  and rr.sampleunit_id=sub.sampleunit_id

update rr
set intReturned=intReturned+cnt
from #RR rr,
  (select sampleset_id,count(*) as cnt 
   from (select distinct sampleset_id,samplepop_id from #rtrn) sub2
   group by sampleset_id) sub
where rr.sampleset_id=sub.sampleset_id
  and rr.sampleunit_id=0

update rr
set intUD=intUD+cnt
from #RR rr,
  (select sampleset_id,count(*) as cnt 
   from (select distinct sampleset_id,samplepop_id from #UD) sub2
   group by sampleset_id) sub
where rr.sampleset_id=sub.sampleset_id
  and rr.sampleunit_id=0

select @intSamplePlan_id=SamplePlan_id 
from SamplePlan 
where Survey_id=@intSurvey_id

create table #SampleUnits
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  intTreeOrder int,
  intTargetReturn int)

exec sp_SampleUnits @intSamplePlan_id

update su set inttargetreturn = s.inttargetreturn
from #sampleunits su, sampleunit s
where su.sampleunit_id = s.sampleunit_id

select ''''+isnull(convert(varchar(250),strSampleUnit_nm),'Total outgo') as SampleUnit,
  #rr.sampleunit_id as [Unit ID],
  su.intTreeOrder as dummyOrder,
  sum(intsampled) as Sampled, 
  sum(intUD) as Nondel, 
  sum(intReturned) as Returned,
  su.inttargetreturn as Target,
--  sum(intReturned)/convert(float,sum(intSampled)) as RespRate,
  sum(intReturned)/convert(float,sum(intSampled-intUD)) as 'Current RespRate'
into #a
from #rr left outer join #sampleunits su on #rr.sampleunit_id=su.sampleunit_id
group by strSampleUnit_nm, #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder
having sum(intsampled)-sum(intUD)>0
union
select ''''+isnull(convert(varchar(250),strSampleUnit_nm),'Total outgo') as SampleUnit,
  #rr.sampleunit_id as [Unit ID],
  su.intTreeOrder as dummyOrder,
  sum(intsampled) as Sampled, 
  sum(intUD) as Nondel, 
  sum(intReturned) as Returned,
  su.inttargetreturn as Target,
--  sum(intReturned)/convert(float,sum(intSampled)) as RespRate,
  convert(int,null) as 'Current RespRate'
from #rr left outer join #sampleunits su on #rr.sampleunit_id=su.sampleunit_id
group by strSampleUnit_nm, #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder
having sum(intsampled)-sum(intUD)=0
order by su.intTreeOrder

create table #display (SampleUnit varchar(250), [Unit ID] int, dummyorder int, Sampled int, Nondel int, Returned int, Target int, [Current RespRate] float)

insert into #display (sampleunit, [unit id])
select  ''''+strsampleunit_nm, sampleunit_id
from #sampleunits
order by inttreeorder

update d
set d.[Unit id] = a.[unit id], d.dummyorder = a.dummyorder, d.sampled = a.sampled, d.nondel = a.nondel, d.returned = a.returned, d.target = a.target, d.[current resprate] = a.[current resprate]
from #display d, #a a
where d.[unit id] = a.[unit id]

select * from #display

drop table #rr
drop table #rtrn
drop table #ud
drop table #sampleunits

set transaction isolation level read committed


