/*
   Monday, July 09, 20072:02:04 PM
   User: qpsa
   Server: Wonderwoman
   Database: QP_Load
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DataFile ADD
	IsDRGUpdate bit NOT NULL CONSTRAINT DF_DataFile_IsDRGUpdate DEFAULT 0
GO
COMMIT
