/*
	S16.US16	As an Implementation Associate, I want a new survey type w/ appropriate defaults forCIHIS, so I can set up the survey correctly.

	16.2	Create new Suvey type and properties' defaults

	Tim Butler

	INSERT INTO [dbo].[SurveyType]
	INSERT INTO [dbo].[CahpsType]

*/
USE [NRC_Datamart]
GO

DECLARE @SurveyTypeName varchar(20)
DECLARE @SurveyType_ID int
DECLARE @CahpsTypeID int
DECLARE @CutoffDays int

SET @SurveyTypeName = 'CIHI CPES-IC'
SET @SurveyType_ID = 12
SET @CahpsTypeID = 7
SET @CutoffDays = 84

if not exists (	SELECT 1 FROM [dbo].[CahpsType] WHERE Label = @SurveyTypeName)
BEGIN

	INSERT INTO [dbo].[CahpsType]
           ([CahpsTypeID]
           ,[Label]
           ,[NumberCutoffDays])
     VALUES
           (@CahpsTypeID
           ,@SurveyTypeName
           ,@CutoffDays)

END

if not exists (	SELECT 1 FROM SurveyType WHERE Label = @SurveyTypeName)
BEGIN

	INSERT INTO [dbo].[SurveyType]
           ([SurveyTypeID]
           ,[Label]
           ,[CahpsTypeID]
           ,[SurveyCategoryID]
           ,[DefaultExportTemplateMajorVersion])
     VALUES
           (@SurveyType_ID
           ,@SurveyTypeName
           ,@CahpsTypeID
           ,1
           ,NULL)
END

GO

