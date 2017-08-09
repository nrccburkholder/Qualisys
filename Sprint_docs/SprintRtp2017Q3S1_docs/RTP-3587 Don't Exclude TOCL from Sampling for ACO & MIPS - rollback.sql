/*
	RTP-3587 Don't Exclude TOCL from Sampling for ACO & MIPS - rollback.sql

	Lanny Boswell

	ALTER TABLE [dbo].[SurveyType]

*/

USE [QP_Prod]
GO

IF EXISTS(SELECT * FROM sys.sysobjects
	WHERE [Name] = 'DF_SurveyType_BypassToclExclusion' AND [Type] = 'D')
BEGIN
	ALTER TABLE [dbo].[SurveyType] DROP CONSTRAINT DF_SurveyType_BypassToclExclusion
END
GO

IF EXISTS(SELECT * FROM sys.columns	
	WHERE object_id = OBJECT_ID(N'[dbo].[SurveyType]') AND ([Name] = 'BypassToclExclusion'))
BEGIN
	ALTER TABLE [dbo].[SurveyType] DROP COLUMN [BypassToclExclusion]
END
GO
