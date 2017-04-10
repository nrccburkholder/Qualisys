/*
S72_ATL-1429 Update OAS CPT Code Exclusions [QP_Load] - Rollback.sql

Lanny Boswell

4/6/2017

DROP TABLE [dbo].[OasExcludedCptCode]

*/

USE [QP_Load]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OasExcludedCptCode]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[OasExcludedCptCode]
END
GO
