/*

S32 US 11 ACO Survey Validation	As an Implementation Associate, I want survey validation updated with the new core numbers, so that I can validate updated surveys for Fall 2015 fielding.

Task 11.2	add validation rule for questionnaire type


Tim Butler


CREATE PROCEDURE [dbo].[SV_CAHPS_QuestionnaireType]
Insert new SurveyValidationProcs record and the SurveyValidationProcsBySurveyType mapping 

*/


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_QuestionnaireType]    Script Date: 8/21/2015 11:00:27 AM ******/
if exists (select * from sys.procedures where schema_id=1 and name = 'SV_CAHPS_QuestionnaireType')
	DROP PROCEDURE [dbo].[SV_CAHPS_QuestionnaireType]
go
CREATE PROCEDURE [dbo].[SV_CAHPS_QuestionnaireType]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF EXISTS (			
			  SELECT 1
			  FROM [QP_Prod].[dbo].[SurveySubtype] ss
			  INNER JOIN [QP_Prod].[dbo].[SubType] st on (st.Subtype_id = ss.Subtype_id)
			  INNER JOIN [QP_Prod].[dbo].[SurveyTypeSubtype] sts ON (ss.Subtype_id = sts.Subtype_id)
			  where Survey_id = @Survey_id
			  and st.bitActive = 1
			)
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Active Questionnaire Version selected.'
ELSE
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'An Active Questionnaire Version must be selected for this survey type.'


SELECT * FROM #M

DROP TABLE #M

GO


/*
Inserts new SurveyValidationProcs record 
and the SurveyValidationProcsBySurveyType mapping 

*/

declare @svpid int
declare @intOrder int

declare @ACOCAHPS int
SELECT @ACOCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'ACOCAHPS'

begin tran

	Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

	SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_QuestionnaireType'
	IF @@ROWCOUNT = 0	
	BEGIN
		INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_QuestionnaireType','A QuestionnaireType is selected for the survey.',@intOrder)
		set @svpid=scope_identity()
	END

	if Not exists (select 1 from [dbo].[SurveyValidationProcsBySurveyType] WHERE SurveyValidationProcs_id = @svpid and CAHPSType_ID = @ACOCAHPS)
		INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@ACOCAHPS)


commit tran

