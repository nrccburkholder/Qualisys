/*
S14.US6	CEM Architecture
	FileMaker service
		
Tim Butler

CREATE TABLE [CEM].[Logs]
CREATE PROCEDURE [CEM].[SelectExportQueue]
CREATE PROCEDURE [CEM].[SelectTemplate]
CREATE PROCEDURE [CEM].[UpdateExportQueueFile]
CREATE PROCEDURE [CEM].[InsertExportQueueFile]
CREATE PROCEDURE [CEM].[SelectExportQueueFile]
CREATE PROCEDURE [CEM].[SelectExportData]
CREATE PROCEDURE [CEM].[SelectExportTemplateColumn]
CREATE PROCEDURE [CEM].[SelectExportTemplateColumnResponse]
CREATE PROCEDURE [CEM].[SelectTemplateSection]
CREATE PROCEDURE [CEM].[SelectSystemParams]

*/
USE [NRC_Datamart_Extracts]
GO



SET ANSI_PADDING OFF
GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'

/****** Object:  Table [CEM].[Logs]    Script Date: 12/12/2014 10:13:38 AM ******/
IF EXISTS (SELECT * FROM sys.tables where schema_id=@schema_id and name = 'Logs')
	DROP TABLE [CEM].[Logs]
GO

/****** Object:  Table [CEM].[Logs]    Script Date: 12/12/2014 10:13:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [CEM].[Logs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EventDateTime] [datetime] NOT NULL,
	[EventLevel] [nvarchar](100) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[MachineName] [nvarchar](100) NOT NULL,
	[EventType] [nvarchar](100) NULL,
	[EventMessage] [nvarchar](max) NULL,
	[EventSource] [nvarchar](100) NULL,
	[EventClass] [nvarchar](500) NULL,
	[EventMethod] [nvarchar](max) NULL,
	[ErrorMessage] [nvarchar](max) NULL
 CONSTRAINT [PK_Logs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'

IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectExportQueue')
	DROP PROCEDURE [CEM].[SelectExportQueue]
GO


/****** Object:  StoredProcedure [CEM].[SelectExportQueue]    Script Date: 12/4/2014 9:02:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CEM].[SelectExportQueue]
	@ExportQueueID int = null,
	@ExportTemplateName varchar(200) = null,
	@ExportTemplateVersionMajor varchar(100) = null,
	@ExportTemplateVersionMinor int = null,
	@ExportDateStart datetime = null,
	@ExportDateEnd datetime = null, 
	@PullDate datetime = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [ExportQueueID]
	  ,[ExportTemplateName]
      ,[ExportTemplateVersionMajor]
      ,[ExportTemplateVersionMinor]
      ,[ExportDateStart]
      ,[ExportDateEnd]
      ,[ReturnsOnly]
      ,[ExportNotificationID]
      ,[RequestDate]
      ,[PullDate]
      ,[ValidatedDate]
      ,[ValidatedBy]
      ,[ValidationCode]
  FROM [NRC_Datamart].[CEM].[ExportQueue]
  WHERE ((@ExportQueueID is null) or (ExportQueueID = @ExportQueueID)) and
		((@ExportTemplateName is null) or (ExportTemplateName = @ExportTemplateName)) and
		((@ExportTemplateVersionMajor is null) or (ExportTemplateVersionMajor = @ExportTemplateVersionMajor)) and
	    ((@ExportTemplateVersionMinor is null) or (ExportTemplateVersionMinor = @ExportTemplateVersionMinor))
END
GO
DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'

IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectTemplate')
	DROP PROCEDURE [CEM].[SelectTemplate]
GO


/****** Object:  StoredProcedure [CEM].[SelectTemplate]    Script Date: 12/4/2014 9:33:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tim Butler
-- Create date: 11/14/2014
-- Description:	Returns a template
-- =============================================
CREATE PROCEDURE [CEM].[SelectTemplate]
	@exportTemplateId int = null,
	@SurveyTypeId int = null,
	@ExportTemplateName varchar(200) = null,
	@ExportTemplateVersionMajor varchar(100) = null,
	@ExportTemplateVersionMinor int = null,
	@ClientId int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--Template
	SELECT [ExportTemplateID]
		  ,[ExportTemplateName]
		  ,[SurveyTypeID]
		  ,[SurveySubTypeID]
          ,[ValidDateColumnID]
		  ,[ValidStartDate]
		  ,[ValidEndDate]
		  ,[ExportTemplateVersionMajor]
		  ,[ExportTemplateVersionMinor]
		  ,[CreatedBy]
		  ,[CreatedOn]
		  ,[ClientID]
		  ,[DefaultNotificationID]
		  ,[DefaultNamingConvention]
		  ,[State]
		  ,[ReturnsOnly]
		  ,[SampleUnitCahpsTypeID]
		  ,[XMLSchemaDefinition]
		  ,[isOfficial]
		  ,[DefaultFileMakerType]
	  FROM [CEM].[ExportTemplate] 
	  WHERE ((@exportTemplateId is null) or (ExportTemplateID = @exportTemplateId)) and
	        ((@SurveyTypeId is null) or (SurveyTypeId = @SurveyTypeId)) and
			((@ExportTemplateName is null) or (ExportTemplateName = @ExportTemplateName)) and
			((@ExportTemplateVersionMajor is null) or (ExportTemplateVersionMajor = @ExportTemplateVersionMajor)) and
			((@ExportTemplateVersionMinor is null) or (ExportTemplateVersionMinor = @ExportTemplateVersionMinor)) and
			((@ClientId is null) or (ClientId = @ClientId))

END
GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'

IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'UpdateExportQueueFile')
	DROP PROCEDURE [CEM].[UpdateExportQueueFile]
GO

/****** Object:  StoredProcedure [CEM].[UpdateExportQueueFile]    Script Date: 12/5/2014 10:28:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CEM].[UpdateExportQueueFile]
	@ExportQueueFileID int,
	@FileState smallint,
	@SubmissionDate datetime = null,
	@SubmissionBy varchar(100) = null,
	@CMSResponseCode varchar(100) = null,
	@CMSResponseDate datetime = null,
	@FileMakerType int = null,
	@FileMakerName varchar(200) = null,
	@FileMakerDate datetime = null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [CEM].[ExportQueueFile]
	   SET [FileState] = @FileState
		  ,[SubmissionDate] = @SubmissionDate
		  ,[SubmissionBy] = @SubmissionBy
		  ,[CMSResponseCode] = @CMSResponseCode
		  ,[CMSResponseDate] = @CMSResponseDate
		  ,[FileMakerType] = @FileMakerType
		  ,[FileMakerName] = @FileMakerName
		  ,[FileMakerDate] = @FileMakerDate
	WHERE ExportQueueFileID = @ExportQueueFileID


END
GO
DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'


IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'InsertExportQueueFile')
	DROP PROCEDURE [CEM].[InsertExportQueueFile]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CEM].[InsertExportQueueFile]
	@ExportQueueID int,
	@SubmissionDate datetime = null,
	@SubmissionBy varchar(100) = null,
	@CMSResponseCode varchar(100) = null,
	@CMSResponseDate datetime = null,
	@FileMakerType int = null,
	@FileMakerName varchar(200) = null,
	@FileMakerDate datetime = null
AS
BEGIN

	INSERT INTO [CEM].[ExportQueueFile]
           ([ExportQueueID]
		   ,[FileState]
           ,[SubmissionDate]
           ,[SubmissionBy]
           ,[CMSResponseCode]
           ,[CMSResponseDate]
           ,[FileMakerType]
           ,[FileMakerName]
           ,[FileMakerDate])
     VALUES
           (@ExportQueueID
		   ,0
           ,@SubmissionDate
           ,@SubmissionBy
           ,@CMSResponseCode
           ,@CMSResponseDate
           ,@FileMakerType
           ,@FileMakerName
           ,@FileMakerDate)

END
GO
DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'


IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectExportQueueFile')
	DROP PROCEDURE [CEM].[SelectExportQueueFile]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CEM].[SelectExportQueueFile]
	@ExportQueueFileID int = null,
	@ExportQueueID int = null,
	@FileState smallint = null,
	@SubmissionDate datetime = null,
	@SubmissionBy varchar(100) = null,
	@CMSResponseCode varchar(100) = null,
	@CMSResponseDate datetime = null,
	@FileMakerType int = null,
	@FileMakerName varchar(200) = null,
	@FileMakerDate datetime = null
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT [ExportQueueFileID]
			,[ExportQueueID]
			,[FileState]
			,[SubmissionDate]
			,[SubmissionBy]
			,[CMSResponseCode]
			,[CMSResponseDate]
			,[FileMakerType]
			,[FileMakerName]
			,[FileMakerDate]
		FROM [CEM].[ExportQueueFile]
		WHERE ((@ExportQueueFileID is null) or (ExportQueueFileID = @ExportQueueFileID)) and
		((@ExportQueueID is null) or (ExportQueueID = @ExportQueueID)) and
		((@FileMakerName is null) or (FileMakerName = @FileMakerName)) and
		((@FileState is null) or (FileState = @FileState))


END
GO
DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'


IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectExportData')
	DROP PROCEDURE [CEM].[SelectExportData]
GO


GO
/****** Object:  StoredProcedure [CEM].[SelectExportData]    Script Date: 12/12/2014 3:42:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CEM].[SelectExportData]
	@ExportQueueID int,
	@ExportTemplateID int,
	@sectionname varchar(200),
	@FileMakerName varchar(200),
	@OneRecordPerPatient bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @tablename varchar(25) = N'CEM.ExportDataset' + REPLICATE('0', 8 - LEN(CAST(@ExportTemplateID as varchar))) + CAST(@ExportTemplateID as varchar)

	create table #Columns (ExportTemplateColumnID int, ExportColumnName char(200))

	insert into #Columns (ExportTemplateColumnID,ExportColumnName)
	select distinct etc.ExportTemplateColumnID
	,@sectionname + '.' + ISNULL(etc.ExportColumnName, etcr.ExportColumnName)
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	left join [CEM].[ExportTemplateColumnResponse] etcr on etcr.ExportTemplateColumnID = etc.ExportTemplateColumnID
	where ets.ExportTemplateID = @ExportTemplateID
	and ets.ExportTemplateSectionName = @sectionname

	/* process each column, one at a time */
	declare @ExportTemplateColumnID int, @ExportColumnName char(200)
	declare @columnlist nvarchar(max)
	declare @sqlCommand nvarchar(max)
	
	if (@OneRecordPerPatient = 1)
		SET @columnlist = '[SamplePopulationID],'
	ELSE SET @columnlist = ''

	select top 1 @ExportTemplateColumnID=ExportTemplateColumnID, @ExportColumnName=ExportColumnName from #Columns
	while @@rowcount>0
	begin
		-- Check to see if the column is in the table. If not, skip it.
		if exists(select * from sys.columns 
            where Name = LTRIM(RTRIM(@ExportColumnName)) and Object_ID = Object_ID(@tablename))
		begin
			SET @columnlist = @columnlist + '[' + LTRIM(RTRIM(@ExportColumnName)) + '],'
		end
		else
		begin
			SET @columnlist = @columnlist + 'NULL [' + LTRIM(RTRIM(@ExportColumnName)) + '],'
		end
		
		delete from #Columns where ExportColumnName=@ExportColumnName
		select top 1 @ExportTemplateColumnID=ExportTemplateColumnID, @ExportColumnName=ExportColumnName from #Columns
	end
	
	Set @sqlCommand = 'SELECT distinct ' + @columnlist + ''' ''' + ' from ' + @tableName + ' WHERE ExportQueueID = ' + CAST(@ExportQueueID as varchar) + ' AND FileMakerName = ''' + @FileMakerName + ''''
	 
	exec sp_executesql  @sqlCommand

	drop table #Columns


END
GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'


IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectExportTemplateColumn')
	DROP PROCEDURE [CEM].[SelectExportTemplateColumn]
GO

	-- Columns
CREATE PROCEDURE [CEM].[SelectExportTemplateColumn]
@exportTemplateId as int = null,
@exportTemplateSectionId as int = null,
@exportTemplateColumnID as int = null,
@exportColumnName as varchar(100) = null,
@ColumnSetKey as int = null,
@DataSourceID as int = null
AS
BEGIN
	select ets.ExportTemplateID
	,ets.ExportTemplateSectionID
	,etc.ExportTemplateColumnID
	,etc.ExportTemplateColumnDescription
	,etc.ColumnOrder
	,etc.DatasourceID
	,etc.ExportColumnName
	,etc.DispositionProcessID
	,etc.FixedWidthLength
	,etc.ColumnSetKey
	,etc.FormatID
	,etc.MissingThresholdPercentage
	,etc.CheckFrequencies
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	where ((@exportTemplateId is null) or (ets.ExportTemplateID=@exportTemplateId)) and
		((@exportTemplateSectionId is null) or (ets.ExportTemplateSectionID=@exportTemplateSectionId)) and
		((@exportTemplateColumnId is null) or (etc.ExportTemplateColumnId = @exportTemplateColumnId)) and
		((@exportColumnName is null) or (etc.ExportColumnName = @exportColumnName)) and
		((@ColumnSetKey is null) or (etc.ColumnSetKey=@ColumnSetKey)) and
		((@DataSourceId is null) or (etc.DataSourceId=@DataSourceId))
END
GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'


IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectExportTemplateColumnResponse')
	DROP PROCEDURE [CEM].[SelectExportTemplateColumnResponse]
GO

/****** Object:  StoredProcedure [CEM].[SelectExportTemplateColumnResponse]    Script Date: 12/15/2014 3:10:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CEM].[SelectExportTemplateColumnResponse]
@exportTemplateId as int = null,
@exportTemplateSectionId as int = null,
@exportTemplateColumnID as int = null,
@exportColumnName as varchar(100) = null
AS
BEGIN
	select distinct
	etcr.ExportTemplateColumnResponseID
	,etcr.ExportTemplateColumnID
	,etcr.ExportColumnName
	,etcr.RawValue
	,etcr.RecodeValue
	,etcr.ResponseLabel
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	left join [CEM].[ExportTemplateColumnResponse] etcr on etcr.ExportTemplateColumnID = etc.ExportTemplateColumnID
	where ((@exportTemplateId is null) or (ets.ExportTemplateID=@exportTemplateId)) and
		((@exportTemplateSectionId is null) or (ets.ExportTemplateSectionID=@exportTemplateSectionId)) and
		((@exportTemplateColumnId is null) or (etc.ExportTemplateColumnId = @exportTemplateColumnId)) and
		((@exportColumnName is null) or (etc.ExportColumnName = @exportColumnName))

END

GO
USE [NRC_Datamart]
GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'


IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectTemplateSection')
	DROP PROCEDURE [CEM].[SelectTemplateSection]
GO

/****** Object:  StoredProcedure [CEM].[SelectTemplateSection]    Script Date: 12/15/2014 3:12:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    -- Sections
CREATE PROCEDURE [CEM].[SelectTemplateSection]
	@exportTemplateId int = null,
	@exportTemplateSectionID int = null,
	@exportTemplateSectionName varchar(100) = null
AS
BEGIN	
select ets.ExportTemplateSectionID,ets.ExportTemplateSectionName,ets.ExportTemplateID,ets.DefaultNamingConvention  
	from [CEM].[ExportTemplateSection] ets
	where ((@exportTemplateId is null) or (ets.ExportTemplateID=@exportTemplateId)) and
	((@exportTemplateSectionID is null) or (ets.ExportTemplateSectionID = @exportTemplateSectionID)) and
	((@exportTemplateSectionName is null) or (ets.exportTemplateSectionName = @exportTemplateSectionName)) 
END

GO

USE [NRC_Datamart]
GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'CEM'


IF EXISTS (SELECT * FROM sys.procedures where schema_id=@schema_id and name = 'SelectSystemParams')
	DROP PROCEDURE [CEM].[SelectSystemParams]
GO

/****** Object:  StoredProcedure [CEM].[SelectSystemParams]    Script Date: 12/15/2014 3:12:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CEM].[SelectSystemParams]
	@PARAM_ID int = null
	,@STRPARAM_NM varchar(75) = null
    ,@STRPARAM_TYPE char(1) = null
    ,@STRPARAM_GRP varchar(40) = null
    ,@STRPARAM_VALUE varchar(255) = null
    ,@NUMPARAM_VALUE int = null
    ,@DATPARAM_VALUE datetime = null
    ,@COMMENTS varchar(255) = null
AS
BEGIN

	SELECT [PARAM_ID]
		  ,[STRPARAM_NM]
		  ,[STRPARAM_TYPE]
		  ,[STRPARAM_GRP]
		  ,[STRPARAM_VALUE]
		  ,[NUMPARAM_VALUE]
		  ,[DATPARAM_VALUE]
		  ,[COMMENTS]
	  FROM [CEM].[System_Params]

END

GO




