/*

ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!

S43 US13 ICH: New Methodologies 
As an authorized ICH-CAHPS vendor, we need to set up new methodologies for Spring 2016, so that we can field compliantly

Tim Butler

Task 2 - Create script using prior examples, plus Catalyst table & run same


*/



use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
DECLARE @SeededMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)
DECLARE @Country_id int


SET @SurveyType_desc = 'ICHCAHPS'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = 'ICHCAHPS'



declare @SMid int, @SMSid int
declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'ICH Mixed Mail-Phone'
SET @MethodologyType = 'Mixed Mail-Phone'

select top 3 StandardMethodologyID
into #temp
	from StandardMethodologyBySurveyType 
	where bitExpired = 0
	and StandardMethodologyID in (
		select StandardMethodologyID
		from StandardMethodology where strStandardMethodology_nm like 'ICH%'	
	)


delete
from StandardMethodologyBySurveyType 
where StandardMethodologyID in (
	select StandardMethodologyID from #temp
	)



delete
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID from #temp
)

delete
from StandardMethodology 
where strStandardMethodology_nm like 'ICH%'
and StandardMethodologyID in (
	select StandardMethodologyID from #temp
)



declare @StandardMethodologyID int
declare @StandardMailingStepID int

select @StandardMethodologyID = max(standardMethodologyID) from dbo.StandardMethodology
select @StandardMailingStepID = max(standardmailingstepId) from dbo.standardMailingStep


DBCC CHECKIDENT ('dbo.StandardMethodology', RESEED, @standardmethodologyid)
DBCC CHECKIDENT ('dbo.standardMailingStep', RESEED, @StandardMailingStepID) 

go




select *
from StandardMethodology where strStandardMethodology_nm like 'ICH%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'ICH%'
)


select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'ICH%'
)

go


