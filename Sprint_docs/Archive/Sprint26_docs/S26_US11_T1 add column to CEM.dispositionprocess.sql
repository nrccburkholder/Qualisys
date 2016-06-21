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

IF NOT EXISTS (SELECT * FROM SYS.COLUMNS WHERE OBJECT_NAME(OBJECT_ID)='DispositionProcess' AND NAME='DispositionActionID')
	ALTER TABLE [CEM].[DispositionProcess] ADD DispositionActionID [int]
GO
UPDATE [CEM].[DispositionProcess] SET DispositionActionID =1

GO

IF NOT EXISTS (SELECT * FROM SYS.TABLES WHERE SCHEMA_ID=SCHEMA_ID('CEM') AND NAME='DispositionAction')
	CREATE TABLE [CEM].[DispositionAction](
		[DispositionActionID] [int] IDENTITY(1,1) NOT NULL,
		[DispositionAction] varchar(20) NULL,
	 CONSTRAINT [PK_DispositionAction] PRIMARY KEY CLUSTERED 
	(
		[DispositionActionID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

GO

if not exists (select * from [CEM].[DispositionAction] where [DispositionAction]='recode')
	INSERT INTO [CEM].[DispositionAction] ([DispositionAction]) VALUES ('recode')
if not exists (select * from [CEM].[DispositionAction] where [DispositionAction]='delete')
	INSERT INTO [CEM].[DispositionAction] ([DispositionAction]) VALUES ('delete')
	