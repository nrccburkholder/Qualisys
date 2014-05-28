CREATE procedure [dbo].[SSRS_CE_GetTargetReport]
	@mindate datetime,@maxdate datetime

as

--exec SSRS_CE_GetTargetReport '3/26/2008','9/26/2008'
--/***/if object_id('tempdb..#activeperiods') is not null drop table #activeperiods
--/***/if object_id('tempdb..#samplesets') is not null drop table #samplesets
--/***/if object_id('tempdb..#counts') is not null drop table #counts
--/***/if object_id('tempdb..#sampleunittree') is not null drop table #sampleunittree
--/***/if object_id('tempdb..#totalpops') is not null drop table #totalpops
--
--/***/declare @mindate datetime,@maxdate datetime
--/***/set @mindate='1/1/2007'
--/***/set @maxdate='6/30/2007'

set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))  

create table #activeperiods (survey_id int,perioddef_id int)  
  
--find the surveys with periods with expected sample dates during the specified date range
insert #activeperiods (survey_id)
select distinct p.survey_id
from perioddef p (nolock)
	right outer join perioddates pd (nolock)
		on (p.perioddef_id=pd.perioddef_id)
	inner join css_ad_view cssad
		on (p.survey_id=cssad.survey_id)
where pd.datscheduledsample_dt between @mindate and @maxdate

--set active period to the minimum perioddef_id with incompleted samples  
update ap  
set ap.perioddef_id=p.perioddef_id  
from #activeperiods ap,perioddef p (nolock)  
where ap.survey_id=p.survey_id  
 and p.perioddef_id in (  
  select min(pd.perioddef_id)   
  from perioddef p (nolock), perioddates pd (nolock)  
  where p.perioddef_id=pd.perioddef_id  
   and pd.datsamplecreate_dt is null  
  group by p.survey_id)  
  
--set active period to the period with the last completed sample where there is no  
--incompleted sample  
update ap  
set ap.perioddef_id=p.perioddef_id  
from #activeperiods ap,perioddef p (nolock)  
where ap.survey_id=p.survey_id  
 and ap.perioddef_id is null  
 and p.perioddef_id in (  
  select max(p.perioddef_id)  
  from perioddef p (nolock)  
   left outer join perioddates pd (nolock)  
    on (p.perioddef_id=pd.perioddef_id)  
  group by p.survey_id)  

create table #samplesets (survey_id int,sampleset_id int)

--build list of samplesets in the active period
insert #samplesets (survey_id,sampleset_id)
select distinct ap.survey_id,pd.sampleset_id
from #activeperiods ap
	inner join PeriodDates pd (nolock)
		on (pd.perioddef_id=ap.perioddef_id)
where pd.sampleset_id is not null 

create table #totalpops (survey_id int,totalpops int)

--find distinct pops for surveys for the samplesets for each survey
insert #totalpops (survey_id,totalpops)
select ss.survey_id,count(*) Total
from samplepop sp (nolock)
	inner join #samplesets ss
		on (sp.sampleset_id=ss.sampleset_id)
group by ss.survey_id,ss.sampleset_id

create table #counts (survey_id int,sampleunit_id int,ParentSampleUnit_id int,Available int,Needed int,Sampled int,[Difference] int)

--get counts in SPW for the samplesets in the active period
insert #counts
select ss.survey_id,spw.sampleunit_id,su.ParentSampleUnit_id,
		isnull(sum(spw.intAvailableUniverse),0) [Available],
		isnull(sum(spw.intOutgoNeededNow),0) [Needed],
		isnull(sum(spw.intSampledNow),0) [Sampled],
		isnull(abs(sum(spw.intSampledNow)-sum(spw.intOutgoNeededNow)),0) [Difference]
from SamplePlanWorkSheet spw (nolock)
	inner join #samplesets sst
		on (spw.sampleset_id=sst.sampleset_id)
	inner join sampleset ss (nolock)
		on (sst.sampleset_id=ss.sampleset_id)
	inner join sampleunit su (nolock)
		on (spw.sampleunit_id=su.sampleunit_id)
group by spw.sampleunit_id,su.ParentSampleUnit_id,ss.survey_id

--update counts table with the distinct pops for each survey
update c
set Sampled=totalpops
from #counts c
	inner join #totalpops tp
		on (c.survey_id=tp.survey_id)
where c.ParentSampleUnit_id is null

--build final results
select	cssad.strClient_nm,cssad.client_id,cssad.strStudy_nm,cssad.study_id,cssad.strSurvey_nm,cssad.survey_id,
		replicate('   ',dsu.intLevel-1)+dsu.strSampleUnit_nm [strSampleUnit_nm],
		case when su.bitHCAHPS=1 then 'Y' else 'N' end [HCAHPS Unit],
		c.Available,c.Needed,c.Sampled,c.[Difference],pd.strPeriodDef_nm,su.bitSuppress,dsu.intLevel
from css_ad_view cssad
	inner join #counts c
		on (cssad.survey_id=c.survey_id)
	inner join datamart.qp_comments.dbo.sampleunit dsu
		on (c.sampleunit_id=dsu.sampleunit_id)
	inner join sampleunit su (nolock)
		on (c.sampleunit_id=su.sampleunit_id)
	inner join #activeperiods ap
		on (c.survey_id=ap.survey_id)
	inner join PeriodDef pd (nolock)
		on (ap.PeriodDef_id=pd.PeriodDef_id)
where su.bitSuppress=0
	--and (c.[Difference]>0 and c.Needed<>0)
order by cssad.strClient_nm,cssad.strStudy_nm,cssad.strSurvey_nm,dsu.intOrder

drop table #activeperiods
drop table #samplesets
drop table #counts
drop table #totalpops


