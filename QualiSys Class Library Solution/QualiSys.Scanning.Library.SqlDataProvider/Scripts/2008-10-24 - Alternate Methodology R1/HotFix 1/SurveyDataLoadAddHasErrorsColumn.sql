---------------------------------------------------------------------------------------
--DL_SurveyDataLoad
---------------------------------------------------------------------------------------
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO
ALTER TABLE dbo.DL_SurveyDataLoad ADD
	bitHasErrors bit NOT NULL CONSTRAINT DF_DL_SurveyDataLoad_bitHasErrors DEFAULT 0
GO
