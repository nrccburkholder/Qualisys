use QP_Prod

/*
S8.US5 - Remove PCMH Data from Stage and Test
As a ALLCAHPS team, we want to remove PMCH changes from Test and Stage so that the environments are in sync.
Tim Butler
*/

begin tran
go

declare @StandardMethodologyID int, @StandardMailingStepID int, @SurveyTypeid int, @Subtype_Id int
																												
select @SurveyTypeid = surveytype_id from surveytype where SurveyType_dsc='CGCAHPS'	

select @subtype_id = st.subtype_id 
from surveytypesubtype stst
inner join subtype st on st.subtype_id = stst.subtype_id
where st.Subtype_nm = 'PCMH'

select @StandardMethodologyID = StandardMethodologyID
from StandardMethodology
WHERE strStandardMethodology_nm = 'PCMH Mixed Mail-Phone'
	
delete [dbo].[StandardMailingStep]
WHERE StandardMethodologyID = @StandardMethodologyID

delete  [dbo].[StandardMethodologyBySurveyType]
where StandardMethodologyID = @StandardMethodologyID
	
delete [dbo].[StandardMethodology]
where StandardMethodologyID = @StandardMethodologyID

	
select @StandardMethodologyID = StandardMethodologyID
from StandardMethodology
WHERE strStandardMethodology_nm = 'PCMH Mail Only'
	
delete [dbo].[StandardMailingStep]
WHERE StandardMethodologyID = @StandardMethodologyID

delete  [dbo].[StandardMethodologyBySurveyType]
where StandardMethodologyID = @StandardMethodologyID
	
delete [dbo].[StandardMethodology]
where StandardMethodologyID = @StandardMethodologyID


select @StandardMethodologyID = StandardMethodologyID
from StandardMethodology
WHERE strStandardMethodology_nm = 'PCMH Phone Only'
	
delete [dbo].[StandardMailingStep]
WHERE StandardMethodologyID = @StandardMethodologyID

delete  [dbo].[StandardMethodologyBySurveyType]
where StandardMethodologyID = @StandardMethodologyID
	
delete [dbo].[StandardMethodology]
where StandardMethodologyID = @StandardMethodologyID

																					
/*

  go
  commit tran

  rollback tran

*/

select *
from StandardMethodology where strStandardMethodology_nm like 'PCMH%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'PCMH%'
)

select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'PCMH%'
)


	


