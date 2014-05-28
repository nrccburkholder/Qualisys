--exec SSRS_CE_GetSelectionsBySampleDate '1/1/2008','1/31/2008',0
CREATE procedure [dbo].[SSRS_CE_GetSelectionsBySampleDate]
	@mindate datetime,@maxdate datetime,@ListType int
as

/* For testing
set @mindate='1/1/2008'
set @maxdate='1/31/2008'
set @ListType=1
*/

set @maxdate=dateadd(ms,-3,dateadd(dd,1,@maxdate))

--0=Project Managers
--1=Clients

if @ListType=0
begin
select distinct rtrim(ltrim(cssad.AD)) [Name],'P'+rtrim(ltrim(convert(varchar,cssad.employee_id))) [Name_id]
from sampleset ss
	inner join css_ad_view cssad
		on (ss.survey_id=cssad.survey_id)
where ss.datsamplecreate_dt between @mindate and @maxdate
	and cssad.employee_id not in (select employee_id from lu_ssrs_excludedemployees)
order by [Name]
	
end

if @ListType=1
begin
select distinct rtrim(ltrim(css.strclient_nm)) [Name],'C'+rtrim(ltrim(convert(varchar,css.client_id))) [Name_id]
from sampleset ss
	inner join css_view css
		on (ss.survey_id=css.survey_id)
where ss.datsamplecreate_dt between @mindate and @maxdate
order by [Name]
end


