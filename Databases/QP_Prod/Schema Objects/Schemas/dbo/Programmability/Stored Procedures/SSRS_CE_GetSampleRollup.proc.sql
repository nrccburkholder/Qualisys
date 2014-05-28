/***********************************************************************************  
--Created by dknaus on 4/11/2008--  
  
  
  
This procedure is used primarily for a Client Experience Reporting Services report  
***********************************************************************************/  
CREATE procedure [dbo].[SSRS_CE_GetSampleRollup]  
 @mindate datetime,@maxdate datetime,@selections varchar(8000),@ExceptionsOnly bit  
as  

--exec SSRS_CE_GetSampleRollup '1/1/2008','1/31/2008','C253',0    
--/***/declare @mindate datetime,@maxdate datetime,@selections varchar(2000),@ExceptionsOnly bit  
--/***/set @mindate='1/1/2008'  
--/***/set @maxdate='1/31/2008'  
--/***/set @selections='C253'  
--/***/set @ExceptionsOnly=1  
  
  
declare @criteria varchar(8000),@sql varchar(8000),@selectiontype varchar(1)  
  
set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))  
  
--look at parameters from SSRS to see if it should be listed by PM or client  
--build criteria based on that  
if left(@selections,1)='P'  
begin  
set @selectiontype='P'  
set @selections=replace(@selections,'P','')  
set @criteria='and cssad.employee_id in ('+@selections+')'  
end  
  
if left(@selections,1)='C'  
begin  
set @selectiontype='C'  
set @selections=replace(@selections,'C','')  
set @criteria='and cssad.client_id in ('+@selections+')'  
end  
  
--create table for applicable samplesets  
create table #samplesets   
 (survey_id int,sampleset_id int)  
  create clustered index idx_clustered_surveyid on #samplesets (survey_id)  
  
--create table for the last sample encounter range  
create table #lser   
 (survey_id int,LastEncDateRange varchar(100))  
  create clustered index idx_clustered_surveyid on #lser (survey_id)  
  
--create table for total samplepops in samplesets  
create table #totals   
 (survey_id int,total int)  
  create clustered index idx_clustered_surveyid on #totals (survey_id)  
  
--create table for the spw counts  
create table #spwcounts  
 (survey_id int,Available int,Needed int)  
  create clustered index idx_clustered_surveyid on #spwcounts (survey_id)  
  
--create table for the results  
create table #results  
 (PM varchar(25),Client varchar(100),Study varchar(100),Survey varchar(100),Project varchar(100),  
  survey_id int,Available int,Needed int,Sampled int,[Difference] int,HCAHPSSampled int,LastEncDateRange varchar(100))  
  create clustered index idx_clustered_surveyid on #results (survey_id)  
  
--pull samplesets dynamically based on the parameters in the procedure  
set @sql=  
'insert #samplesets'+char(10)+  
'select ss.survey_id,ss.sampleset_id'+char(10)+  
'from sampleset ss'+char(10)+  
' inner join css_ad_view cssad'+char(10)+  
'  on (ss.survey_id=cssad.survey_id)'+char(10)+  
'where ss.datsamplecreate_dt between '''+convert(varchar,@mindate)+''''+' and '''+convert(varchar,@maxdate)+''' '+char(10)  
  
--print @sql+@criteria  
exec (@sql+@criteria)  
  
insert #lser  
select survey_id,isnull(convert(char(10),datDateRange_FromDate,101)+' - '+convert(char(10),datDateRange_ToDate,101),'Unspecified')  
from sampleset  
where  sampleset_id in (select max(sampleset_id) from #samplesets group by survey_id)  
  
--get total number of people that sampled for each survey  
insert #totals (survey_id,total)  
select ss.survey_id,count(*)  
from sampleset ss (nolock)  
 inner join samplepop sp (nolock)  
  on (ss.sampleset_id=sp.sampleset_id)  
where ss.sampleset_id in (select sampleset_id from #samplesets)  
group by ss.survey_id  
  
--calculate SPW counts for the samplesets in the selected date range for the survey  
insert #spwcounts (survey_id,Available,Needed)  
select ss.survey_id,  
  isnull(sum(case when spw.parentsampleunit_id is null then spw.intAvailableUniverse else 0 end),0) [Available],  
  isnull(sum(case when spw.intOutgoNeededNow<0 then 0 else spw.intOutgoNeededNow end),0) [Needed]  
from sampleplanworksheet spw (nolock)  
 inner join #samplesets ss  
  on (spw.sampleset_id=ss.sampleset_id)  
group by ss.survey_id  
  
--bring everything together  
set @criteria=''  
  
if @ExceptionsOnly=1  
begin  
set @criteria=' and sc.Needed-t.Total<>0'  
end  
  
set @sql=  
'select cssad.AD [PM],cssad.strClient_nm,cssad.client_id,ltrim(rtrim(cssad.strStudy_nm)) strStudy_nm,cssad.study_id,cssad.strSurvey_nm,'+char(10)+  
'  left(cssad.strSurvey_nm,4) Project,cssad.survey_id,'+char(10)+  
'  sc.Available,sc.Needed,t.Total,sc.Needed-t.Total [Difference],lser.LastEncDateRange'+char(10)+  
'from css_ad_view cssad'+char(10)+  
' inner join #spwcounts sc'+char(10)+  
'  on (cssad.survey_id=sc.survey_id)'+char(10)+  
' inner join #totals t'+char(10)+  
'  on (cssad.survey_id=t.survey_id)'+char(10)+  
' inner join #lser lser'+char(10)+  
'  on (cssad.survey_id=lser.survey_id)'+char(10)+  
'where cssad.employee_id not in (select employee_id from lu_ssrs_excludedemployees) '+char(10)+  
 @criteria+char(10)+  
'order by cssad.strClient_nm,cssad.strStudy_nm,cssad.strSurvey_nm'  
--print @sql  
exec (@sql)  
  
  
/***/--select '' lser,* from #lser  
/***/--select '' spwcounts,* from #spwcounts order by survey_id  
/***/--select '' samplesets,* from #samplesets where survey_id=5107 order by survey_id  
/***/--select '' totals,* from #totals order by survey_id  
/***/--select '' results,* from #results  
  
drop table #lser  
drop table #samplesets  
drop table #spwcounts  
drop table #totals  
drop table #results


