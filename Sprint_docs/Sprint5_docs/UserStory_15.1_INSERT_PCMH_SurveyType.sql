
USE [QP_Prod]
GO

DECLARE @SurveyType_Id int

DECLARE @SurveyType_dsc varchar(100)
DECLARE @CAHPSType_id int
DECLARE @SeedMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)

SET @SurveyType_dsc = 'PCMH'
SET @CAHPSType_id = 11
SET @SeedMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL


SELECT @SurveyType_Id = [SurveyType_ID]
FROM SurveyType
WHERE SurveyType_dsc = @SurveyType_dsc

IF @@ROWCOUNT = 0
BEGIN

	INSERT INTO [dbo].[SurveyType]
			   ([SurveyType_dsc]
			   ,[CAHPSType_id]
			   ,[SeedMailings]
			   ,[SeedSurveyPercent]
			   ,[SeedUnitField])
		 VALUES
			   (@SurveyType_dsc
			   ,@CAHPSType_id
			   ,@SeedMailings
			   ,@SeedSurveyPercent
			   ,@SeedUnitField)

END
ELSE
BEGIN
	
	UPDATE [dbo].[SurveyType]
		SET SurveyType_dsc = @SurveyType_dsc
			,CAHPSType_id = @CAHPSType_id
			,SeedMailings = @SeedMailings
			,SeedSurveyPercent = @SeedSurveyPercent
			,SeedUnitField = @SeedUnitField
	WHERE SurveyType_ID = @SurveyType_Id

END
GO



