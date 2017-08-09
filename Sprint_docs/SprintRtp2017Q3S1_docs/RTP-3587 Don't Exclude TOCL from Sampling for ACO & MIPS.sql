/*
	RTP-3587 Don't Exclude TOCL from Sampling for ACO & MIPS.sql

	Lanny Boswell

	ALTER TABLE [dbo].[SurveyType]
*/

USE [QP_Prod]
GO

IF NOT EXISTS(SELECT * FROM sys.columns	
	WHERE object_id = OBJECT_ID(N'[dbo].[SurveyType]') AND ([Name] = 'BypassToclExclusion'))
BEGIN
	ALTER TABLE [dbo].[SurveyType] 
		ADD [BypassToclExclusion] BIT NOT NULL 
		CONSTRAINT DF_SurveyType_BypassToclExclusion DEFAULT(0)
END
GO

UPDATE [dbo].[SurveyType] SET [BypassToclExclusion] = 1 WHERE SurveyType_ID IN (10, 13)
