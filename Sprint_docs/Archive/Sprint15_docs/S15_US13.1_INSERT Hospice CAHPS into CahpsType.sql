/*
	S15 US13 Add Hospice CAHPS type to NRC_Datamart

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

SET @SurveyTypeName = 'Hospice CAHPS'
SET @SurveyType_ID = 11
SET @CahpsTypeID = 6
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

