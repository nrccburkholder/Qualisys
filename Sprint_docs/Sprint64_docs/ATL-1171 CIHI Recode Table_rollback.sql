
USE [QP_Prod]
GO

IF EXISTS (SELECT * FROM SYS.TABLES where schema_name(schema_id)='CIHI' and name = 'Recode')
	DROP TABLE [CIHI].[Recode];


	