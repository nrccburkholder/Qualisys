CREATE procedure [dbo].[sp_TP_PopInfo2]
@survey_id int, @tp_id int
as

set nocount on

declare @study_id int, @sampleplan_id int, @pop_id int, @sampleset_id int
select @study_id=max(study_id), @sampleplan_id=max(sampleplan_id) from clientstudysurvey_view where survey_id=@survey_id

create table #SampleUnits
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  intTreeOrder int)

exec sp_SampleUnits @SamplePlan_id

select @pop_id=pop_id, @sampleset_id=sampleset_id
from testprint_log 
where tp_id=@tp_id

update su
set intTier=null
from #sampleunits su, selectedsample ss 
where su.sampleunit_id=ss.sampleunit_id 
and ss.pop_id=@pop_id 
and ss.sampleset_id=@sampleset_id
and ss.study_id=@study_id

delete from #sampleunits where intTier is not null

select su.SampleUnit_id, convert(char(30),su.strSampleUnit_nm) as SampleUnit_nm, sq.Section_id, convert(char(30),sq.label) as Section_nm
from #sampleunits su
inner join sampleunitsection sus on su.sampleunit_id=sus.sampleunit_id
inner join sel_qstns sq on sus.selqstnssurvey_id = sq.survey_id and sus.selqstnssection = sq.section_id
where sus.selqstnssurvey_id = @survey_id
and sq.section_id>-1
and sq.language=1
and sq.subtype=3
order by su.intTreeOrder, sq.section_id

drop table #sampleunits


