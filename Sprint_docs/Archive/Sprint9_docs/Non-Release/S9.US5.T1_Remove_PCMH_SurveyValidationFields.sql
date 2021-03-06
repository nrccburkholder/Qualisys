USE [QP_Prod]
/*
S8.US5 - Remove PCMH Data from Stage and Test
As a ALLCAHPS team, we want to remove PMCH changes from Test and Stage so that the environments are in sync.
Tim Butler
*/

begin tran
go

DECLARE @Surveytype_id int
DECLARE @Subtype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = 'PCMH'

if exists (select * from survey_def where surveytype_id = @Surveytype_id and survey_id in (select survey_id from surveysubtype where subtype_id=@Subtype_id))
	print 'There are still surveys that use the PCMH subtype. Aborting'
else
	delete from
	[dbo].[SurveyValidationFields]
	where surveytype_id = @Surveytype_id
		and Subtype_id = @Subtype_id

/*
go
commit tran

rollback tran

*/

SELECT *
FROM [QP_Prod].[dbo].[SurveyValidationFields]
