/***********************************************************************************  
--Created by dknaus on 5/13/2008--   
  
This procedure is used primarily for a Client Experience Reporting Services report  
***********************************************************************************/  
--exec SSRS_CE_GetSelectionsByExpSampleDate '0','3/1/2008','3/31/2008'
CREATE procedure [dbo].[SSRS_CE_GetSelectionsByExpSampleDate] 
	@ListType int,@mindate datetime,@maxdate datetime
as  

set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))
  
--0=Project Managers  
--1=Clients  
if @ListType=0  
begin  
select '_All' [Name],'P0' [Name_id]
union
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


