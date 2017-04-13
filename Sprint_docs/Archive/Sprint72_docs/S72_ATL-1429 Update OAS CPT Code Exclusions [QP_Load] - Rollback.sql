/*
S72_ATL-1429 Update OAS CPT Code Exclusions [QP_Load] - Rollback.sql

Lanny Boswell

4/6/2017

DROP TABLE [dbo].[OasExcludedCptCode]

*/

USE [QP_Load]
GO

IF (OBJECT_ID(N'[dbo].[OasExcludedCptCode]') IS NOT NULL)
BEGIN
	DROP TABLE [dbo].[OasExcludedCptCode]
END
GO
