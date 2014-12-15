/*
S14.US6	CEM Architecture
	FileMaker service
		
Tim Butler

CREATE TABLE [CEM].[System_Params]
INSERT parameter records for CEM

*/

USE NRC_DataMart

/****** Object:  Table [CEM].[System_Params]    Script Date: 12/10/2014 10:58:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'

IF EXISTS (SELECT * FROM sys.tables where schema_id=@schema_id and name = 'System_Params')
	DROP TABLE [CEM].[System_Params]
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [CEM].[System_Params](
	[PARAM_ID] [int] IDENTITY(1,1) NOT NULL,
	[STRPARAM_NM] [varchar](75) NOT NULL,
	[STRPARAM_TYPE] [char](1) NOT NULL,
	[STRPARAM_GRP] [varchar](40) NOT NULL,
	[STRPARAM_VALUE] [varchar](255) NULL,
	[NUMPARAM_VALUE] [int] NULL,
	[DATPARAM_VALUE] [datetime] NULL,
	[COMMENTS] [varchar](255) NULL,
 CONSTRAINT [PK_System_Para,s] PRIMARY KEY CLUSTERED 
(
	[PARAM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO



DECLARE @param_id int
DECLARE @strparam_nm varchar(75)
DECLARE @strparam_type char(1)
DECLARE @strparam_grp varchar(20)
DECLARE @strparam_value varchar(255)
DECLARE @numparam_value int
DECLARE @dataparam_value datetime
DECLARE @comments varchar(255)

SET @strparam_grp = 'CEM'

begin tran

SET @strparam_nm = 'FileLocation'
SET @strparam_type = 'S'
SET @strparam_value = '\\superman\Production\CEMFiles' --'\\lnk0pfil01\Teams\Client Services\Audit Team\Accountable Care Organizations\ACS result files'
SET @dataparam_value = NULL
SET @comments = 'Location to download files'

SET @param_id = null
SELECT @param_id = param_id
FROM cem.System_Params 
WHERE STRPARAM_GRP = @strparam_grp
AND STRPARAM_NM = @strparam_nm

IF @@ROWCOUNT = 0
BEGIN

	INSERT INTO [cem].[System_Params]
           ([STRPARAM_NM]
           ,[STRPARAM_TYPE]
           ,[STRPARAM_GRP]
           ,[STRPARAM_VALUE]
           ,[NUMPARAM_VALUE]
           ,[DATPARAM_VALUE]
           ,[COMMENTS])
     VALUES
           (@strparam_nm
           ,@strparam_type
           ,@strparam_grp
           ,@strparam_value
           ,@numparam_value
           ,@dataparam_value
           ,@comments)
END
ELSE
BEGIN
	UPDATE [cem].[System_Params]
	   SET [STRPARAM_NM] = @strparam_nm
		  ,[STRPARAM_TYPE] = @strparam_type
		  ,[STRPARAM_GRP] = @strparam_grp
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END



SET @strparam_nm = 'ServiceInterval'
SET @strparam_type = 'S'
SET @strparam_value = '0 0 23 1/1 * ? *' -- this is set to run once a day at 11:00 PM
SET @numparam_value = NULL
SET @dataparam_value = NULL
SET @comments = 'Service Interval -- CronExpression'

SET @param_id = null
SELECT @param_id = param_id
FROM cem.System_Params 
WHERE STRPARAM_GRP = @strparam_grp
AND STRPARAM_NM = @strparam_nm

IF @@ROWCOUNT = 0
BEGIN

	INSERT INTO [cem].[System_Params]
           ([STRPARAM_NM]
           ,[STRPARAM_TYPE]
           ,[STRPARAM_GRP]
           ,[STRPARAM_VALUE]
           ,[NUMPARAM_VALUE]
           ,[DATPARAM_VALUE]
           ,[COMMENTS])
     VALUES
           (@strparam_nm
           ,@strparam_type
           ,@strparam_grp
           ,@strparam_value
           ,@numparam_value
           ,@dataparam_value
           ,@comments)
END
ELSE
BEGIN
	UPDATE [cem].[System_Params]
	   SET [STRPARAM_NM] = @strparam_nm
		  ,[STRPARAM_TYPE] = @strparam_type
		  ,[STRPARAM_GRP] = @strparam_grp
		  ,[STRPARAM_VALUE] = @STRPARAM_VALUE
		  ,[NUMPARAM_VALUE] = @numparam_value
		  ,[DATPARAM_VALUE] = @dataparam_value
		  ,[COMMENTS] = @comments
	 WHERE PARAM_ID = @param_id
END


commit tran



SELECT *
FROM CEM.System_Params
WHERE STRPARAM_GRP = @strparam_grp

