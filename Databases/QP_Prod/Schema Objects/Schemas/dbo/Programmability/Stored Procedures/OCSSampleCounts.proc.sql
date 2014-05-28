-- =============================================
-- Author:		Dana Petersen
-- Create date: 11/23/2010
-- Description:	Source for OCS Sample Counts SSRS Report
-- =============================================
CREATE PROCEDURE [dbo].[OCSSampleCounts] 
	-- Add the parameters for the stored procedure here
	@Month varchar(2), 
	@Year varchar(4)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @EncounterStartDate varchar(10)
declare @EncounterEndDate varchar(10)
set @EncounterStartDate = @Year + '-' + @Month + '-01'
set @EncounterEndDate = @Year + '-' + @Month + '-01'

print @Month
print @Year
print @EncounterStartDate

create table #tmpOCSSurveys (clientname varchar(100), client_id int, studyname varchar(20), study_id int, surveyname varchar(20), survey_id int)

insert into #tmpOCSSurveys
select c.STRCLIENT_NM, c.CLIENT_ID, s.STRSTUDY_NM, s.STUDY_ID, sd.STRSURVEY_NM, sd.SURVEY_ID 
from CLIENT c, study s, SURVEY_DEF sd
where sd.STUDY_ID = s.STUDY_ID
and s.CLIENT_ID = c.CLIENT_ID
and c.ClientGroup_ID = 5
order by c.STRCLIENT_NM, s.STRSTUDY_NM, sd.STRSURVEY_NM


create table #tmpOCSFacilities (clientname varchar(100), client_id int, studyname varchar(20), 
study_id int, surveyname varchar(20), survey_id int, MedicareNumber varchar(10), suFacility_id int)

insert into  #tmpOCSFacilities
select distinct tos.*, suf.MedicareNumber, suf.SUFacility_id 
from #tmpOCSSurveys tos left outer join SAMPLEPLAN sp
on sp.SURVEY_ID = tos.survey_id
left outer join SAMPLEUNIT su
on sp.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
left outer join SUFacility suf
on su.SUFacility_id = suf.SUFacility_id

create table #tmpOCSSamples (clientname varchar(100), client_id int, studyname varchar(20), 
study_id int, surveyname varchar(20), survey_id int, MedicareNumber varchar(10), suFacility_id int,
sampleset_id int, datSampled datetime)

insert into #tmpOCSSamples
select tof.*, sst.SAMPLESET_ID, sst.DATSAMPLECREATE_DT
from #tmpOCSFacilities tof 
left outer join SAMPLESET sst
on tof.survey_id = sst.SURVEY_ID
where sst.datDateRange_FromDate between @EncounterStartDate and @EncounterEndDate


create table #tmpOCSSampleUnits (survey_id int, sampleunit_id int)

insert into #tmpOCSSampleUnits
select tos.survey_id, su.SAMPLEUNIT_ID
from #tmpOCSSamples tos, SAMPLEPLAN spl, SAMPLEUNIT su
where tos.survey_id = spl.SURVEY_ID
and spl.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
and su.bitHHCAHPS = 1


select tos.clientname as "Client", tos.MedicareNumber as "CCN", spw.intSampledNow as "Count Sampled" 
from #tmpOCSSamples tos, #tmpOCSSampleUnits tosu, SamplePlanWorksheet spw
where tos.survey_id = tosu.survey_id
and tos.sampleset_id = spw.Sampleset_id
and tosu.sampleunit_id = spw.SampleUnit_id
order by tos.clientname


--cleanup
drop table #tmpOCSSurveys
drop table #tmpOCSFacilities
drop table #tmpOCSSamples
drop table #tmpOCSSampleUnits
END


