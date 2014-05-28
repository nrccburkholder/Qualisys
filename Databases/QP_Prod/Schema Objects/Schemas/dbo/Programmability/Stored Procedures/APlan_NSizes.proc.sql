create procedure APlan_NSizes
as

select m.sampset as sampleset_id
into #sampsets
from #MRD m, 
     (select sampleset_id,sum(intreturned) as intReturned 
      from RespRateCount 
      where sampleunit_id=0 -- and sampleset_id=sampset 
      group by sampleset_id) RRC
where rrc.sampleset_id = m.sampset
group by m.sampset, rrc.intreturned
having count(distinct m.lithocd)/(rrc.intReturned+0.0)>.75
order by m.sampset

insert into #report (sampunit,qstncore,crnt)
  select sampunit,0,count(distinct lithocd)
  from #mrd 
  where samptype='D'
  group by sampunit

select distinct survey_id, sampleplan_id
into #surveys
from sampleset, #sampsets
where sampleset.sampleset_id=#sampsets.sampleset_id

select rrc.sampleset_id, sampleunit_id, intSampled, intUD, intReturned 
into #rr
from RespRateCount rrc, #sampsets ss, #surveys s
where rrc.survey_id=s.survey_id
  and rrc.sampleset_id = ss.sampleset_id

declare @datLastExtract datetime
select @datLastExtract=rrrundate from RR_Date where qpc_timestamp=(select max(qpc_timestamp) from RR_Date)

select qf.survey_id, ss.sampleset_id, ss.sampleunit_id, sp.samplepop_id 
into #rtrn
from questionform qf, samplepop sp, selectedsample ss, #sampsets st, #surveys s
where qf.survey_id=s.survey_id
  and qf.datreturned > @datLastExtract
  and qf.samplepop_id=sp.samplepop_id
  and sp.sampleset_id=ss.sampleset_id
  and sp.sampleset_id=st.sampleset_id
  and sp.pop_id=ss.pop_Id
  and ss.strUnitSelectType='D'

select qf.survey_id, ss.sampleset_id, ss.sampleunit_id, sp.samplepop_id 
into #ud
from sentmailing sm, questionform qf, samplepop sp, selectedsample ss, #sampsets st, #surveys s
where qf.survey_id=s.survey_id
  and qf.sentmail_id=sm.sentmail_id
  and sm.datundeliverable > @datLastExtract
  and qf.samplepop_id=sp.samplepop_id
  and sp.sampleset_id=ss.sampleset_id
  and sp.sampleset_id=st.sampleset_id
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

create table #SampleUnits
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  intTreeOrder int)

declare @intSamplePlan_id int
select @intSamplePlan_id = min(sampleplan_id) from #surveys
while @intSamplePlan_id is not null
begin
    print @intSamplePlan_id
    exec sp_SampleUnits @intSamplePlan_id
    delete from #surveys where sampleplan_id=@intSamplePlan_id
    select @intSamplePlan_id = min(sampleplan_id) from #surveys
end

create table #APRespRate (sampleunit_id int, intSampled int, intUD int, intReturned int)
declare @Tier int
select @Tier=max(intTier) from #sampleunits

while @Tier>0
begin
  insert into #APRespRate
  select #rr.sampleunit_id, sum(intsampled) as intSampled,sum(intUD) as intUD,sum(intReturned) as intReturned
  from #rr, #Sampleunits tsu
  where #rr.sampleunit_id=tsu.sampleunit_id
    and tsu.intTier=@Tier
  group by #rr.sampleunit_id
  
  insert into #APRespRate
  select su.parentsampleunit_id, sum(intSampled) as intsampled,sum(intUD) as intUD,sum(intReturned) as intReturned
  from #APRespRate, #Sampleunits tsu, sampleunit su
  where #APRespRate.sampleunit_id=tsu.sampleunit_id
    and tsu.sampleunit_id=su.sampleunit_id
    and su.parentsampleunit_id is not null
    and tsu.intTier=@Tier
  group by su.parentsampleunit_id

  set @Tier = @Tier - 1
end

insert into #report (sampunit,qstncore,crnt)
  select sampleunit_id,-1,100.0*sum(intReturned)/sum(intSampled+0.0)
  from #APRespRate
  group by sampleunit_id

insert into #report (sampunit,qstncore,crnt)
  select sampleunit_id,-2,100.0*sum(intReturned)/sum(intSampled-intUD)
  from #APRespRate
  group by sampleunit_id

drop table #rr
drop table #rtrn
drop table #ud
drop table #sampleunits
drop table #APRespRate
drop table #surveys


