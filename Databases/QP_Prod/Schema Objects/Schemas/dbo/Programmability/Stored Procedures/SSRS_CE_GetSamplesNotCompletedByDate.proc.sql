/***********************************************************************************        
--Created by dknaus on 4/3/2008--        
      
      
        
This procedure is used primarily for a Client Experience Reporting Services report        
***********************************************************************************/        
--exec SSRS_CE_GetSamplesNotCompletedByDate '3/1/2008','3/31/2008','P280',1      
Create procedure [dbo].[SSRS_CE_GetSamplesNotCompletedByDate]      
 @mindate datetime,@maxdate datetime,@selections varchar(2000),@bitHCAHPSOnly bit      
as      
    
---- For Testing      
--/***/declare @mindate datetime,@maxdate datetime,@selections varchar(2000),@bitHCAHPSOnly bit     
--/***/set @mindate='3/31/2008'      
--/***/set @maxdate='5/31/2008'      
--/***/set @selections='C63'    
--/***/set @bitHCAHPSOnly=0  
    
declare @sql varchar(8000),@criteria varchar(2000)      
      
--look at parameters from SSRS to see if it should be listed by PM or client    
--build criteria based on that    
if left(@selections,1)='P'    
    
begin    
if @selections='P0'    
begin      
set @criteria=''      
end      
    
else    
begin    
set @selections=replace(@selections,'P','')    
set @criteria='and cssad.employee_id in ('+@selections+')'    
end    
end    
    
if left(@selections,1)='C'    
begin    
set @selections=replace(@selections,'C','')    
set @criteria='and cssad.client_id in ('+@selections+')'    
end    
    
if @bitHCAHPSOnly=1    
begin    
set @criteria=@criteria+' and sd.surveytype_id=2'     
end    
      
--compensate for SQL thinking '2/29/2008' is '2/29/2008 00:00:00.000', since that's how it gets passed from SSRS      
set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))      
      
--create temp table for the samples      
create table #samples      
 (survey_id int,PeriodDefSampleNumber int,sampleset_id int,datscheduledsample_dt datetime, datsamplecreate_dt datetime,      
  ExpEncDateRange varchar(50),bitCanceled bit,PM varchar(50)      
   primary key clustered (PeriodDefSampleNumber))      
 create nonclustered index idx_clustered_surveyid on #samples (survey_id)      
      
--insert into samples the samples applicable to the report      
set @sql=      
'insert #samples (survey_id,PeriodDefSampleNumber,sampleset_id,datscheduledsample_dt,datsamplecreate_dt,ExpEncDateRange,bitCanceled,PM)'+char(10)+      
'select p.survey_id,'+char(10)+      
'  convert(int,convert(varchar,pd.perioddef_id)+convert(varchar,pd.samplenumber)) [PeriodDefSampleNumber],'+char(10)+      
'  pd.sampleset_id,pd.datScheduledSample_dt,pd.datSampleCreate_dt,'+char(10)+      
'  convert(varchar,datExpectedEncStart,101)+'' - ''+convert(varchar,datExpectedEncEnd,101),'+char(10)+      
'  case when pd.sampleset_id is null and pd.datSampleCreate_dt is not null then 1 else 0 end,'+char(10)+      
'  cssad.ad'+char(10)+      
'from perioddef p (nolock)  '+char(10)+      
' left outer join perioddates pd (nolock)  '+char(10)+      
'  on (p.perioddef_id=pd.perioddef_id)'+char(10)+  
' inner join survey_def sd'+char(10)+  
' on (sd.survey_id=p.survey_id)'+char(10)+      
' inner join css_ad_view cssad'+char(10)+  
'  on (cssad.survey_id=p.survey_id)'+char(10)+  
'where pd.datscheduledsample_dt between '''+convert(varchar,@mindate)+''' and '''+convert(varchar,@maxdate)+''' '+char(10)+      
' and pd.sampleset_id is null'+char(10)+      
' and cssad.employee_id not in (select employee_id from lu_ssrs_excludedemployees) '      
      
print @sql+@criteria      
exec (@sql+@criteria)      
      
select css.strclient_nm [Client],css.client_id,css.strstudy_nm [Study],css.study_id,      
  case 
	when sd.surveytype_id=2 then css.strsurvey_nm+' (H)' 
	when sd.surveytype_id=3 then css.strsurvey_nm+' (HH)' 
	when sd.surveytype_id=4 then css.strsurvey_nm+' (MN)' 
	else css.strsurvey_nm end [Survey],      
  left(css.strsurvey_nm,4) [PJ #],      
  s.survey_id,perioddefsamplenumber,      
  case when s.bitCanceled=1 then convert(varchar,datscheduledsample_dt,101)+' (C)' else convert(varchar,datscheduledsample_dt,101) end [Scheduled Sample Date],s.ExpEncDateRange,      
  s.PM,sd.surveytype_id      
from css_view css   
 inner join #samples s      
  on (css.survey_id=s.survey_id)      
 inner join survey_def sd      
  on (s.survey_id=sd.survey_id)      
order by [Client],[Study],[Survey],datscheduledsample_dt      
      
/***/--select * from #samples order by survey_id      
/***/--select @mindate,@maxdate      
      
--cleanup      
drop table #samples


