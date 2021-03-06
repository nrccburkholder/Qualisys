/*

S32 US 11 ACO Survey Validation	As an Implementation Associate, I want survey validation updated with the new core numbers, so that I can validate updated surveys for Fall 2015 fielding.

Task 11.2	add validation rule for questionnaire type

ROLLBACK	

Tim Butler


drop  PROCEDURE [dbo].[SV_CAHPS_QuestionnaireType]
Insert new SurveyValidationProcs record and the SurveyValidationProcsBySurveyType mapping 

*/


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_QuestionnaireType]    Script Date: 8/21/2015 11:00:27 AM ******/
if exists (select * from sys.procedures where schema_id=1 and name = 'SV_CAHPS_QuestionnaireType')
	DROP PROCEDURE [dbo].[SV_CAHPS_QuestionnaireType]
go


/*
Inserts new SurveyValidationProcs record 
and the SurveyValidationProcsBySurveyType mapping 

*/

declare @svpid int
declare @intOrder int

declare @ACOCAHPS int
SELECT @ACOCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'ACOCAHPS'

begin tran


	SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_QuestionnaireType'

	IF @@ROWCOUNT > 0	
	BEGIN
		DELETE [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) WHERE SurveyValidationProcs_id = @svpid and CAHPSType_ID = @ACOCAHPS
		set @svpid=scope_identity()
	END

	DELETE [dbo].[SurveyValidationProcsBySurveyType] WHERE SurveyValidationProcs_id = @svpid and CAHPSType_ID = @ACOCAHPS

commit tran

