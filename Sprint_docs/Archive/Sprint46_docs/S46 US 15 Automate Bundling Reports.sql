/*

S46 US15 Automate Bundling Reports 
As a Printing Associate, I want bundling sheets functions automated, so that I do not spend 8 hours just printing bundling sheets
Quick hit to create report when file printed

Tim Butler

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


SET @strParam_nm  = 'Environment'
SET @strParam_grp = 'QueueManager'
SET @strParam_Value  = 'TEST'
SET @Comment = 'The environment in which QueueManager is running. Valid values are TEST, STAGE, PROD'

IF NOT EXISTS (SELECT 1 FROM dbo.QUALPRO_PARAMS WHERE STRPARAM_NM = 'Environment' and STRPARAM_GRP = 'QueueManager')
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