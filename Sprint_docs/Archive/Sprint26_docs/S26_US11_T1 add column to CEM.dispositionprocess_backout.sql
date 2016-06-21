/*
	S26.US11	ICHCAHPS submission file changes
		as an authorized ICHCAHPS vendor, we must remove records from the submission file that were sampled in error


	T11.1	add a column to CEM.dispositionprocess

Dave Gilsdorf

NRC_DataMart_Extracts:
ALTER TABLE/UPDATE [CEM].[DispositionProcess] 
CREATE TABLE/INSERT [CEM].[DispositionAction]

*/
USE [NRC_DataMart_Extracts]
GO

IF EXISTS (SELECT * FROM SYS.COLUMNS WHERE OBJECT_NAME(OBJECT_ID)='DispositionProcess' AND NAME='DispositionActionID')
	ALTER TABLE [CEM].[DispositionProcess] DROP COLUMN DispositionActionID 

GO

IF EXISTS (SELECT * FROM SYS.TABLES WHERE SCHEMA_ID=SCHEMA_ID('CEM') AND NAME='DispositionAction')
	DROP TABLE [CEM].[DispositionAction]
