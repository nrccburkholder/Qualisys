

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

delete from
[dbo].[SurveyValidationFields]
where surveytype_id = @SurveyType_id
	and Subtype_id = @Subtype_Id

/*
go
commit tran

rollback tran

*/

SELECT *
FROM [QP_Prod].[dbo].[SurveyValidationFields]
