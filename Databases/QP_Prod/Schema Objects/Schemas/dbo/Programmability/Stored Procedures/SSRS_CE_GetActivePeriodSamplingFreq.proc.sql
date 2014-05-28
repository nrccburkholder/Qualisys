/***********************************************************************************  
--Created by dknaus on 1/16/2008--  
  
This procedure returns all active sampling periods, 'DaysPerSample', sampling  
frequency and Project Manager for surveys that have an expected sample date within   
a date range of today plus or minus one quarter.  
  
This procedure is used primarily for a Client Experience Reporting Services report  
***********************************************************************************/  

CREATE procedure [dbo].[SSRS_CE_GetActivePeriodSamplingFreq]  
		@selections varchar(8000)  
as

declare @mindate datetime,@maxdate datetime,@criteria varchar(8000),@sql varchar(8000)  

/***/--set @selections='P280'
  
set @mindate=dateadd(q,-1,current_timestamp)  
set @maxdate=dateadd(q,1,current_timestamp)  
  
--look at parameters from SSRS to see if it should be listed by PM or client  
if left(@selections,1)='P'  
begin  
set @selections=replace(@selections,'P','')  
set @criteria='and cssad.employee_id in ('+@selections+')'  
end  
  
if left(@selections,1)='C'  
begin  
set @selections=replace(@selections,'C','')  
set @criteria='and cssad.client_id in ('+@selections+')'  
end  
  
create table #activeperiods (survey_id int,perioddef_id int)  
  
--find the surveys with expected sample dates either a quarter in the past  
--or a quarter in the future  
set @sql=  
'insert #activeperiods (survey_id) '+char(10)+
'select distinct p.survey_id '+ char(10)+ 
'from perioddef p (nolock)'+char(10)+
'	right outer join perioddates pd (nolock)'+char(10)+
'		on (p.perioddef_id=pd.perioddef_id)'+char(10)+
'	inner join css_ad_view cssad'+char(10)+
'		on (p.survey_id=cssad.survey_id)'+char(10)+
'where pd.datscheduledsample_dt between'''+convert(varchar,@mindate)+''' and '''+ convert(varchar,@maxdate)+''' '+char(10)

 
print @sql +@criteria
exec (@sql+@criteria)  
  
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
from #activeperiods ap (nolock),perioddef p (nolock)  
where ap.survey_id=p.survey_id  
 and ap.perioddef_id is null  
 and p.perioddef_id in (  
  select max(p.perioddef_id)  
  from perioddef p (nolock)  
   left outer join perioddates pd (nolock)  
    on (p.perioddef_id=pd.perioddef_id)  
  group by p.survey_id)  
  
select distinct cssad.strclient_nm [Client],cssad.strstudy_nm [Study],cssad.strsurvey_nm [Survey],  
    left(cssad.strSurvey_nm,4) [Proj],p.strperioddef_nm [Period],  
    isnull(  
   convert(varchar,round(convert(float,(datediff(dd,p.datexpectedencstart,p.datexpectedencend)/(p.intexpectedsamples*1.0))),2))  
   ,'Unknown') [DaysPerSample],  
   case   
 when (datediff(dd,p.datexpectedencstart,p.datexpectedencend)/(p.intexpectedsamples*1.0)) between 0 and 1.5 then 'Daily'  
 when (datediff(dd,p.datexpectedencstart,p.datexpectedencend)/(p.intexpectedsamples*1.0)) between 6 and 8 then 'Weekly'  
 when (datediff(dd,p.datexpectedencstart,p.datexpectedencend)/(p.intexpectedsamples*1.0)) between 12 and 16 then 'Bi-Monthly'  
 when (datediff(dd,p.datexpectedencstart,p.datexpectedencend)/(p.intexpectedsamples*1.0)) between 26 and 33 then 'Monthly'  
 when (datediff(dd,p.datexpectedencstart,p.datexpectedencend)/(p.intexpectedsamples*1.0)) between 85 and 95 then 'Quarterly'  
 when (datediff(dd,p.datexpectedencstart,p.datexpectedencend)/(p.intexpectedsamples*1.0)) is null then 'Unknown'  
 else 'Undefined'  
 end as [SamplingFreq],  
  cssad.ad [PM],cssad.employee_id,p.perioddef_id  
from css_ad_view cssad (nolock)
	inner join #activeperiods ap
		on (cssad.survey_id=ap.survey_id)
	inner join perioddef p (nolock)
		on (p.perioddef_id=ap.perioddef_id)
order by [Client],[Study],[Survey] 
  
drop table #activeperiods  
/***********************************************************************************  
***********************************************************************************/


