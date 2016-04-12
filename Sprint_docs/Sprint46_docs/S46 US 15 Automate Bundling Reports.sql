/*

S46 US15 Automate Bundling Reports 
As a Printing Associate, I want bundling sheets functions automated, so that I do not spend 8 hours just printing bundling sheets
Quick hit to create report when file printed

Tim BUtler

*/

USE [QP_Prod]
GO

DECLARE @strParam_nm as varchar(75) = 'BundlingSheetPrinter'
DECLARE @strParam_grp as varchar(40) = 'QueueManager'
DECLARE @strParam_Value as varchar(255) = '\\lnk0pprn02\LNK05P3015NW'
DECLARE @Comment as varchar(255) = 'The printer where the BundlingSheets will be automatically printed'

IF NOT EXISTS (SELECT 1 FROM dbo.QUALPRO_PARAMS WHERE STRPARAM_NM = 'BundlingSheetPrinter' and STRPARAM_GRP = 'QueueManager')
	INSERT INTO [dbo].[QUALPRO_PARAMS]
			   ([STRPARAM_NM]
			   ,[STRPARAM_TYPE]
			   ,[STRPARAM_GRP]
			   ,[STRPARAM_VALUE]
			   ,[NUMPARAM_VALUE]
			   ,[DATPARAM_VALUE]
			   ,[COMMENTS])
		 VALUES
			   (@strParam_nm
			   ,'S'
			   ,@strParam_grp
			   ,@strParam_Value
			   ,NULL
			   ,NULL
			   ,@Comment)
ELSE
	UPDATE [dbo].[QUALPRO_PARAMS]
	   SET [STRPARAM_VALUE] = @strParam_Value
	 WHERE STRPARAM_NM = @strParam_nm and STRPARAM_GRP = @strParam_grp




select *
from dbo.QUALPRO_PARAMS
where STRPARAM_GRP = @strParam_grp

GO