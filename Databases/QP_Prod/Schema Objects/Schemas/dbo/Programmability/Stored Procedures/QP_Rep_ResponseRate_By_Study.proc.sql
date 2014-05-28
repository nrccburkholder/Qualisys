CREATE PROCEDURE [dbo].[QP_Rep_ResponseRate_By_Study] 
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @FirstSampleSet varchar(50),
 @LastSampleSet varchar(50)
AS
set transaction isolation level read uncommitted
set nocount on

Declare @intStudy_id int, @intSampleSet_id1 int, @intSampleSet_id2 int, @intSamplePlan_id int, @intsurvey_id int, @survey_nm varchar(10), @strsql varchar(200)

select @intStudy_id=s.study_id 
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id

select @intSampleSet_id1=SampleSet_id
from SampleSet
where abs(datediff(second,datSampleCreate_Dt,convert(datetime,@FirstSampleSet)))<=1

select @intSampleSet_id2=SampleSet_id
from SampleSet
where abs(datediff(second,datSampleCreate_Dt,convert(datetime,@LastSampleSet)))<=1

select distinct ss.survey_id
into #survey
from sampleset ss, survey_def sd
where ss.sampleset_id between @intsampleset_id1 and @intsampleset_id2
and ss.survey_id = sd.survey_id
and sd.study_id = @intstudy_id

create table #display (SampleUnit varchar(250), [Unit ID] int, dummyOrder int, Sampled int, Nondel int, Returned int, Target int, [Current RespRate] decimal(4,1), [Historical RespRate] int, [Returned - Target] as (returned - target))

while (select count(*) from #survey) > 0
begin

set @intsurvey_id = (select top 1 survey_id from #survey order by survey_id)

set @survey_nm = (select rtrim(strsurvey_nm) from survey_def where survey_id = @intsurvey_id)

create table #rr (sampleset_id int, sampleunit_id int, intSampled int, intUD int, intReturned int)

insert into #rr
select sampleset_id, rrc.sampleunit_id, intSampled, intUD, intReturned 
from datamart.qp_comments.dbo.respratecount rrc, SampleUnit su
where survey_id=@intSurvey_id
  and sampleset_id between @intSampleSet_id1 and @intSampleSet_id2
  and rrc.SampleUnit_id=su.SampleUnit_id
  and su.bitSuppress=0
UNION
select sampleset_id, rrc.sampleunit_id, intSampled, intUD, intReturned 
from datamart.qp_comments.dbo.respratecount rrc
where survey_id=@intSurvey_id
  and sampleset_id between @intSampleSet_id1 and @intSampleSet_id2
  and rrc.SampleUnit_id=0

select @intSamplePlan_id=SamplePlan_id 
from SamplePlan 
where Survey_id=@intSurvey_id

create table #SampleUnits
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  intTreeOrder int,
  intTargetReturn int,
  intHistoricalRR int)

exec sp_SampleUnits @intSamplePlan_id

update su 
set inttargetreturn = s.inttargetreturn, intHistoricalRR = numresponserate
from #sampleunits su, sampleunit s
where su.sampleunit_id = s.sampleunit_id

insert into #rr
select 0, sampleunit_id, 0,0,0
from #sampleunits
where sampleunit_id not in (select sampleunit_id from #rr)

insert into #display
select ''''+isnull(convert(varchar(250),strSampleUnit_nm),'Total outgo for survey ' + convert(varchar,@intsurvey_id) + ' (' + @survey_nm + ')') as SampleUnit,
  #rr.sampleunit_id as [Unit ID],
  su.intTreeOrder as dummyOrder,
  sum(intsampled) as Sampled, 
  sum(intUD) as Nondel, 
  sum(intReturned) as Returned,
  su.inttargetreturn as Target,
--  sum(intReturned)/convert(float,sum(intSampled)) as RespRate,
  100*(sum(intReturned)/convert(float,sum(intSampled-intUD))) as 'Current RespRate',
  su.intHistoricalRR as 'Historical RespRate'
from #rr left outer join #sampleunits su on #rr.sampleunit_id=su.sampleunit_id
group by strSampleUnit_nm, #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder, su.intHistoricalRR
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
  convert(int,null) as 'Current RespRate',
  su.intHistoricalRR as 'Historical RespRate'
from #rr left outer join #sampleunits su on #rr.sampleunit_id=su.sampleunit_id
group by strSampleUnit_nm, #rr.SampleUnit_id, su.inttargetreturn, su.intTreeOrder, su.intHistoricalRR
having sum(intsampled)-sum(intUD)=0
order by su.intTreeOrder

insert into #display (sampleunit)
select ''

drop table #rr
drop table #sampleunits

delete #survey where survey_id = @intsurvey_id

end

select SampleUnit, [Unit ID], Sampled, Nondel, Returned, Target, [Current RespRate], [Historical RespRate], [Returned - Target] from #display

drop table #display

set transaction isolation level read committed


