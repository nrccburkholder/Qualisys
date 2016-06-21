/*

S14.US17.1	As an Implementation Associate, I want a new survey type w/ appropriate defaults for Hospice CAHPS, so I can set up the survey correctly.

Tim Butler

*/

use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'Hospice CAHPS'

begin tran

if not exists (	SELECT 1 FROM SurveyType WHERE SurveyType_dsc = @SurveyType_desc)
BEGIN

	INSERT INTO [dbo].[SurveyType]
			   ([SurveyType_dsc]
			   ,[CAHPSType_id]
			   ,[SeedMailings]
			   ,[SeedSurveyPercent]
			   ,[SeedUnitField])
		 VALUES
			   (@SurveyType_desc
			   ,NULL
			   ,1
			   ,2
			   ,'CAHPSType_id')

	SELECT @SurveyType_ID = SCOPE_IDENTITY()

	UPDATE SurveyType
	SET CAHPSType_id = @SurveyType_ID
	WHERE SurveyType_ID = @SurveyType_ID

END

go

commit tran

