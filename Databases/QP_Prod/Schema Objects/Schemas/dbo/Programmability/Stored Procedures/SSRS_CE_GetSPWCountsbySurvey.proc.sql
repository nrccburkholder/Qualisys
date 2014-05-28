CREATE procedure [dbo].[SSRS_CE_GetSPWCountsbySurvey]
	@mindate datetime,
	@maxdate datetime,
	@survey_id int

as

/*
/***/declare @mindate datetime,@maxdate datetime,@survey_id int
/***/set @mindate='1/1/2008'
/***/set @maxdate='1/31/2008'

/***/set @survey_id=5443
*/

set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))  

create table #counts
	(survey_id int,sampleunit_id int,parentsampleunit_id int,strSampleUnit_nm varchar(100),intTreeOrder int,Available int,
		Needed int,Sampled int,[Difference] int)

--calculate SPW counts for the samplesets in the selected date range for the survey
insert #counts (survey_id,sampleunit_id,parentsampleunit_id,strsampleunit_nm,Available,Needed,Sampled,[Difference])
select	ss.survey_id,spw.sampleunit_id,su.parentsampleunit_id,su.strSampleUnit_nm,
		isnull(sum(spw.intAvailableUniverse),0) [Available],
		isnull(sum(spw.intOutgoNeededNow),0) [Needed],
		isnull(sum(spw.intSampledNow),0) [Sampled],
		isnull(abs(sum(spw.intSampledNow)-sum(spw.intOutgoNeededNow)),0) [Difference]
from sampleplanworksheet spw
	inner join sampleunit su
		on (spw.sampleunit_id=su.sampleunit_id)
	inner join sampleset ss
		on (spw.sampleset_id=ss.sampleset_id)
where ss.datsamplecreate_dt between @mindate and @maxdate
	and ss.survey_id in (@survey_id)
group by spw.sampleunit_id,su.parentsampleunit_id,su.strSampleUnit_nm,ss.survey_id

--get count of samplepops sampled for this survey
select ss.survey_id,count(*) Total
into #totals
from samplepop sp
	inner join sampleset ss
		on (sp.sampleset_id=ss.sampleset_id)
where ss.datsamplecreate_dt between @mindate and @maxdate
	and ss.survey_id in (@survey_id)
group by ss.survey_id

--update the counts table to show the count of samplepops at the root unit
update c
	set c.Sampled=t.Total
from #counts c
	inner join #totals t
		on (c.survey_id=t.survey_id)
where c.parentsampleunit_id is null

--get the SampleUnitTree for this survey
create table #SampleUnits 
		(SampleUnit_id int,strSampleUnit_nm varchar(100),intTier int,intTreeOrder int,ParentSampleUnit_id int,intTargetReturn int)

exec sp_SampleUnitTree @survey_id

--update #counts to show the sample unit name indents
update c
set c.strSampleUnit_nm=sus.strSampleUnit_nm,
	c.intTreeOrder=sus.intTreeOrder
from #counts c
	inner join #SampleUnits sus
		on (c.sampleunit_id=sus.sampleunit_id)

select	css.strClient_nm,css.client_id,css.strStudy_nm,css.study_id,css.strSurvey_nm,c.survey_id,c.sampleunit_id,c.strSampleUnit_nm,intTreeOrder,	
		c.Available,c.Needed,c.Sampled,c.[Difference]
from #counts c
	inner join css_view css
		on (c.survey_id=css.survey_id)
order by c.intTreeOrder


drop table #SampleUnits
drop table #counts
drop table #totals


