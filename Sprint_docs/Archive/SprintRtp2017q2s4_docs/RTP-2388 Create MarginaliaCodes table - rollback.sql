/*
	RTP-2388 Create MarginaliaCodes table - rollback.sql

	Lanny Boswell

	6/9/2017
*/

USE [QP_Prod]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarginaliaCodes]') AND type in (N'U'))
	DROP TABLE [dbo].[MarginaliaCodes]
GO
