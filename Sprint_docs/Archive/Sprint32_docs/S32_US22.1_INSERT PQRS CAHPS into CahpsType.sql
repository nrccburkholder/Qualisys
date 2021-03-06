/*
	S32_US22.1_INSERT PQRS CAHPS into CahpsType.sql

	Chris Burkholder

	INSERT INTO [dbo].[SurveyType]
	INSERT INTO [dbo].[CahpsType]

*/
USE [NRC_Datamart]
GO

DECLARE @SurveyTypeName varchar(20)
DECLARE @SurveyType_ID int
DECLARE @CahpsTypeID int
DECLARE @CutoffDays int

SET @SurveyTypeName = 'PQRS CAHPS'
SET @SurveyType_ID = 13
SET @CahpsTypeID = 8
SET @CutoffDays = 64

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

USE [NRC_Datamart_CA]
GO

DECLARE @SurveyTypeName varchar(20)
DECLARE @SurveyType_ID int
DECLARE @CahpsTypeID int
DECLARE @CutoffDays int

SET @SurveyTypeName = 'PQRS CAHPS'
SET @SurveyType_ID = 13
SET @CahpsTypeID = 8
SET @CutoffDays = 64

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
