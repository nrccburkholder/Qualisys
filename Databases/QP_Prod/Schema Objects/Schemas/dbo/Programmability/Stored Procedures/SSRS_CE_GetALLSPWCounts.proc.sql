CREATE procedure [dbo].[SSRS_CE_GetALLSPWCounts]
 @mindate datetime,  
 @maxdate datetime,  
-- @survey_id int,
 @selections varchar(8000),
 @ExceptionsOnly bit
  
as  
  
/*  
/***/declare @mindate datetime,@maxdate datetime,@survey_id int  
/***/set @mindate='1/1/2008'  
/***/set @maxdate='1/31/2008'  
  
/***/set @survey_id=5443  
*/  
  
declare @criteria varchar(8000),@sql varchar(8000),@selectiontype varchar(1)    
declare @criteria2 varchar(8000)
set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))    
    
if left(@selections,1)='P'    
begin    
set @selectiontype='P'    
set @selections=replace(@selections,'P','')    
set @criteria='and cssad.employee_id in ('+@selections+')'    
set @criteria2='and employee_id in ('+@selections+')'
end    
    
if left(@selections,1)='C'    
begin    
set @selectiontype='C'    
set @selections=replace(@selections,'C','')    
set @criteria='and cssad.client_id in ('+@selections+')'   
set @criteria2='and survey_id in (select y.survey_id
from study x inner join survey_def y
 on x.study_id = y.study_id
where x.client_id in ('+@selections+'))'
end    


create table #counts  
 (survey_id int,sampleunit_id int,parentsampleunit_id int,strSampleUnit_nm varchar(100),intTreeOrder int,Available int,  
  Needed int,Sampled int,[Difference] int, intLevel int)  
  
--create table for applicable samplesets    
create table #samplesets     
 (survey_id int,sampleset_id int)    
  create clustered index idx_clustered_surveyid on #samplesets (survey_id)    

--create table for the last sample encounter range    
create table #lser     
 (survey_id int,LastEncDateRange varchar(100))    
  create clustered index idx_clustered_surveyid on #lser (survey_id)  

set @sql=    
'insert #samplesets'+char(10)+    
'select ss.survey_id,ss.sampleset_id'+char(10)+    
'from sampleset ss'+char(10)+    
' inner join css_ad_view cssad'+char(10)+    
'  on (ss.survey_id=cssad.survey_id)'+char(10)+    
'where ss.datsamplecreate_dt between '''+convert(varchar,@mindate)+''''+' and '''+convert(varchar,@maxdate)+''' '+char(10)    
    
print @sql+@criteria    
exec (@sql+@criteria)    
    
insert #lser    
select survey_id,isnull(convert(char(10),datDateRange_FromDate,101)+' - '+convert(char(10),datDateRange_ToDate,101),'Unspecified')    
from sampleset    
where  sampleset_id in (select max(sampleset_id) from #samplesets group by survey_id)  
  

--calculate SPW counts for the samplesets in the selected date range for the survey  
set @sql = 'insert #counts (survey_id,sampleunit_id,parentsampleunit_id,strsampleunit_nm,Available,Needed,Sampled,[Difference])  
select ss.survey_id,spw.sampleunit_id,su.parentsampleunit_id,su.strSampleUnit_nm,  
  isnull(sum(spw.intAvailableUniverse),0) [Available],  
  isnull(sum(spw.intOutgoNeededNow),0) [Needed],  
  isnull(sum(spw.intSampledNow),0) [Sampled],  
  isnull(abs(sum(spw.intSampledNow)-sum(spw.intOutgoNeededNow)),0) [Difference]  
from sampleplanworksheet spw  
 inner join sampleunit su  
  on (spw.sampleunit_id=su.sampleunit_id)  
 inner join sampleset ss  
  on (spw.sampleset_id=ss.sampleset_id)  
where ss.datsamplecreate_dt between ''' + cast(@mindate as varchar) + ''' and ''' + cast(@maxdate as varchar) + ''' '
  + @criteria2 +
' group by spw.sampleunit_id,su.parentsampleunit_id,su.strSampleUnit_nm,ss.survey_id'
print @sql
exec(@sql)

  
--get count of samplepops sampled   
set @sql = 'select ss.survey_id,count(*) Total  
into tmp_totals  
from samplepop sp  
 inner join sampleset ss  
  on (sp.sampleset_id=ss.sampleset_id)  
where ss.datsamplecreate_dt between ''' + cast(@mindate as varchar) + ''' and ''' + cast(@maxdate as varchar) + ''' '
  + @criteria2 +
' group by ss.survey_id'
  
print @sql
exec(@sql)

--update the counts table to show the count of samplepops at the root unit  
update c  
 set c.Sampled=t.Total  
from #counts c  
 inner join tmp_totals t  
  on (c.survey_id=t.survey_id)  
where c.parentsampleunit_id is null  
  
--get the SampleUnitTree for this survey  
create table #SampleUnits   
  (SampleUnit_id int,strSampleUnit_nm varchar(100),intTier int,intTreeOrder int,ParentSampleUnit_id int,intTargetReturn int)  
  
/*
exec sp_SampleUnitTree @survey_id  
*/
--update #counts to show the sample unit name indents  
update c  
set c.strSampleUnit_nm=sus.strSampleUnit_nm,  
 c.intTreeOrder=sus.intOrder,
 c.intLevel = sus.intLevel  
from #counts c  
 inner join datamart.qp_comments.dbo.sampleunit sus  
  on (c.sampleunit_id=sus.sampleunit_id)  

set @criteria=''    
    
if @ExceptionsOnly=1    
begin    
set @criteria=' and c.Needed<>c.Sampled '
end    
  
exec('select css.AD [PM],left(css.strSurvey_nm,4) Project,lser.LastEncDateRange,css.strClient_nm,css.client_id,css.strStudy_nm,css.study_id,css.strSurvey_nm,c.survey_id,c.sampleunit_id,replicate('' '', intLevel+intLevel)+c.strSampleUnit_nm as strSampleUnit_nm,intTreeOrder,   
  c.Available,c.Needed,c.Sampled,c.[Difference]
from #counts c  
 inner join css_ad_view css  
  on (c.survey_id=css.survey_id)  
inner join #lser lser
  on (css.survey_id=lser.survey_id)' + @criteria)

--order by css.survey_id, c.intTreeOrder  
  
drop table tmp_totals
drop table #lser 
drop table #samplesets


