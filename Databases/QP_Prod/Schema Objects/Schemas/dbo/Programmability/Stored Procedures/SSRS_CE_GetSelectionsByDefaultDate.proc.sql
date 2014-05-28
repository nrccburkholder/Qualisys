/***********************************************************************************  
--Created by dknaus on 1/17/2008--   
  
This procedure is used primarily for a Client Experience Reporting Services report  
***********************************************************************************/  
CREATE procedure [dbo].[SSRS_CE_GetSelectionsByDefaultDate] @ListType int  
as  
  
declare @mindate datetime,@maxdate datetime  
  
set @mindate=dateadd(q,-1,current_timestamp)  
set @maxdate=dateadd(q,1,current_timestamp)  
  
--0=Project Managers  
--1=Clients  
if @ListType=0  
begin  
select distinct cssad.ad [Name], 'P'+convert(varchar,cssad.employee_id) [Name_id]  
from perioddef p (nolock)
	right outer join perioddates pd (nolock)
		on (p.perioddef_id=pd.perioddef_id)
	inner join css_ad_view cssad
		on (cssad.survey_id=p.survey_id)
where pd.datscheduledsample_dt between @mindate and @maxdate
	and cssad.employee_id not in (select employee_id from lu_ssrs_excludedemployees)
order by [Name]  
  
end  
  
if @ListType=1  
begin  
select distinct cssad.strclient_nm [Name], 'C'+convert(varchar,cssad.client_id) [Name_id]  
from perioddef p (nolock)
	right outer join perioddates pd (nolock)
		on (p.perioddef_id=pd.perioddef_id)
	inner join css_ad_view cssad
		on (cssad.survey_id=p.survey_id)
where pd.datscheduledsample_dt between @mindate and @maxdate  
order by [Name]  
end  
  
/***********************************************************************************  
***********************************************************************************/


