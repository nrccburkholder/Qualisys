/*

S33 US13 ICH Methodology

As an authorized ICH-CAHPS vendor, we need to create a new methodology for Fall 2015 fielding, so that we can field in compliance with the updated schedule.



Tim Butler

13.1	insert records for new methodology and update old methodology into standard methodology tables


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

begin tran

declare @SMid int, @SMSid int
declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'ICH Mixed Mail-Phone'
SET @MethodologyType = 'Mixed Mail-Phone'


Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
from StandardMethodologyBySurveyType 
where StandardMethodologyID in (
	select top 3 StandardMethodologyID
	from StandardMethodologyBySurveyType 
	where bitExpired = 1
	and StandardMethodologyID in (
		select StandardMethodologyID
		from StandardMethodology where strStandardMethodology_nm like 'ICH%'	
	)
	order by StandardMethodologyID desc
)



select *
from StandardMethodology 
where strStandardMethodology_nm like 'ICH%'
and StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodologyBySurveyType 
	where bitExpired = 0
	and StandardMethodologyID in (
		select StandardMethodologyID
		from StandardMethodology where strStandardMethodology_nm like 'ICH%'	
	)
)

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodologyBySurveyType 
	where bitExpired = 0
	and StandardMethodologyID in (
		select StandardMethodologyID
		from StandardMethodology where strStandardMethodology_nm like 'ICH%'	
	)
)


select *
from StandardMethodologyBySurveyType 
where bitExpired = 0
and StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'ICH%'	
)



commit tran
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


