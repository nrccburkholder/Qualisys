/*

S16.US16.2	As an Implementation Associate, I want a new survey type w/ appropriate defaults for CIHI, so I can set up the survey correctly.

Tim Butler

*/

use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
DECLARE @SeededMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)
DECLARE @IsCAHPS bit

SET @IsCAHPS = 0

SET @SurveyType_desc = 'CIHI'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL

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
			   ,@SeededMailings
			   ,@SeedSurveyPercent
			   ,@SeedUnitField)

	SELECT @SurveyType_ID = SCOPE_IDENTITY()

	IF @IsCAHPS = 1
		UPDATE SurveyType
		SET CAHPSType_id = @SurveyType_ID
		WHERE SurveyType_ID = @SurveyType_ID

END

go

commit tran

