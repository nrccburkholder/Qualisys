/*
S12.US18	CEM - Build Database Objects
	Build the Export Manager Database Objects

T18.1	Build all the tables

Dave Gilsdorf

CREATE SCHEMA [CEM] 
CREATE TABLE [CEM].[ExportTemplate]
CREATE TABLE [CEM].[ExportTemplateSection] 
CREATE TABLE [CEM].[ExportTemplateDefaultResponse] 
CREATE TABLE [CEM].[ExportTemplateColumn] 
CREATE TABLE [CEM].[ExportTemplateColumnResponse] 
CREATE TABLE [CEM].[DispositionProcess] 
CREATE TABLE [CEM].[DispositionClause]
CREATE TABLE [CEM].[DispositionInList] 
CREATE TABLE [CEM].[ExportQueue] 
CREATE TABLE [CEM].[ExportQueueFile] 
CREATE TABLE [CEM].[ExportQueueSurvey] 
CREATE TABLE [CEM].[ExportNotification] 
CREATE TABLE [CEM].[ExportNotificationType] 
CREATE TABLE [CEM].[Operator]
ALTER TABLE [dbo].[SurveyType]
*/
use NRC_Datamart
go
begin tran
go
IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'CEM' ) 
    EXEC('CREATE SCHEMA [CEM] AUTHORIZATION [dbo]');
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'Datasource') 
	DROP TABLE [CEM].[Datasource]
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportTemplate') 
	DROP TABLE [CEM].[ExportTemplate]
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportTemplateSection') 
	DROP TABLE [CEM].[ExportTemplateSection] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportTemplateDefaultResponse') 
    DROP TABLE [CEM].[ExportTemplateDefaultResponse] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportTemplateColumn') 
    DROP TABLE [CEM].[ExportTemplateColumn] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportTemplateColumnResponse') 
    DROP TABLE [CEM].[ExportTemplateColumnResponse] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'DispositionProcess') 
    DROP TABLE [CEM].[DispositionProcess] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'DispositionClause') 
    DROP TABLE [CEM].[DispositionClause]
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'DispositionInList') 
    DROP TABLE [CEM].[DispositionInList] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportQueueFile') 
    DROP TABLE [CEM].[ExportQueueFile] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportQueue') 
    DROP TABLE [CEM].[ExportQueue] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportQueueSurvey') 
    DROP TABLE [CEM].[ExportQueueSurvey] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportNotification') 
    DROP TABLE [CEM].[ExportNotification] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'ExportNotificationType') 
    DROP TABLE [CEM].[ExportNotificationType] 
GO
IF EXISTS ( SELECT  *
            FROM    sys.schemas ss
            inner join sys.tables st on ss.schema_id=st.schema_id
            WHERE   ss.name = N'CEM' and st.name=N'Operator') 
    DROP TABLE [CEM].[Operator] 
GO
CREATE TABLE [CEM].[Datasource]
  ( 
     [DatasourceID]           INT IDENTITY(1, 1), 
     [HorizontalVertical]     CHAR(1) NOT NULL,
     [TableName]              VARCHAR(200) NOT NULL, 
     [TableAlias]             VARCHAR(20) NOT NULL,
     [ForeignKeyField]        VARCHAR(100) NULL,
     CONSTRAINT [PK_Datasource] PRIMARY KEY CLUSTERED ([DatasourceID] 
     ASC) WITH (pad_index = OFF, statistics_norecompute = OFF, ignore_dup_key = 
     OFF, allow_row_locks = on, allow_page_locks = on) 
   )
go
CREATE TABLE [CEM].[ExportTemplate] 
  ( 
     [ExportTemplateID]           INT IDENTITY(1, 1), 
     [ExportTemplateName]         VARCHAR(200) NOT NULL, 
     [SurveyTypeID]               INT NOT NULL, 
     [SurveySubTypeID]            INT NULL, 
     [ValidDateColumnID]          INT NOT NULL, 
     [ValidStartDate]             DATETIME NULL, 
     [ValidEndDate]               DATETIME NULL, 
     [ExportTemplateVersionMajor] VARCHAR(100) NOT NULL, 
     [ExportTemplateVersionMinor] INT NOT NULL, 
     [CreatedBy]                  VARCHAR(100) NOT NULL, 
     [CreatedOn]                  DATETIME NOT NULL, 
     [ClientID]                   INT NULL, 
     [DefaultNotificationID]      INT NULL, 
     [DefaultNamingConvention]    VARCHAR(200) NULL, 
     [State]                      INT NOT NULL, 
     [ReturnsOnly]                BIT NOT NULL, 
     [SampleUnitCahpsTypeID]      INT NULL, 
     [XMLSchemaDefinition]        XML NULL, 
     [isOfficial]                 BIT NULL, 
     [DefaultFileMakerType]       INT NULL,
     CONSTRAINT [PK_ExportTemplate] PRIMARY KEY CLUSTERED ([ExportTemplateID] 
     ASC) WITH (pad_index = OFF, statistics_norecompute = OFF, ignore_dup_key = 
     OFF, allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportTemplateSection] 
  ( 
     [ExportTemplateSectionID]   INT IDENTITY(1, 1), 
     [ExportTemplateSectionName] VARCHAR(200), 
     [ExportTemplateID]          INT, 
     [DefaultNamingConvention]   VARCHAR(200) NULL, 
     CONSTRAINT [PK_ExportTemplateSection] PRIMARY KEY CLUSTERED ( 
     [ExportTemplateSectionID] ASC) WITH (pad_index = OFF, 
     statistics_norecompute = OFF, ignore_dup_key = OFF, allow_row_locks = on, 
     allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportTemplateDefaultResponse] 
  ( 
     [ExportTemplateDefaultResponseID] INT IDENTITY(1, 1), 
	 [ExportTemplateID]                INT NULL,
     [RawValue]                        INT NULL, 
     [RecodeValue]                     VARCHAR(200) NOT NULL, 
     [ResponseLabel]                   VARCHAR(200) NOT NULL, 
     CONSTRAINT [PK_ExportTemplateDefaultResponse] PRIMARY KEY CLUSTERED ( 
     [ExportTemplateDefaultResponseID] ASC) WITH (pad_index = OFF, 
     statistics_norecompute = OFF, ignore_dup_key = OFF, allow_row_locks = on, 
     allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportTemplateColumn] 
  ( 
     [ExportTemplateColumnID]          INT IDENTITY(1, 1), 
     [ExportTemplateSectionID]         INT NOT NULL, 
     [ExportTemplateColumnDescription] VARCHAR(200) NOT NULL, 
     [ColumnOrder]                     INT NOT NULL, 
     [DatasourceID]                    INT NOT NULL, 
     [ExportColumnName]                VARCHAR(200) NULL, 
     [SourceColumnName]                VARCHAR(200) NOT NULL, 
	 [SourceColumnType]                INT NOT NULL,
	 [AggregateFunction]               VARCHAR(30) NULL,
     [DispositionProcessID]            INT NULL, 
     [FixedWidthLength]                INT NULL, 
     [ColumnSetKey]                    INT NULL, 
     [FormatID]                        INT NULL, 
     [MissingThresholdPercentage]      FLOAT, 
     [CheckFrequencies]                BIT, 
     CONSTRAINT [PK_ExportTemplateColumn] PRIMARY KEY CLUSTERED ( 
     [ExportTemplateColumnID] ASC) WITH (pad_index = OFF, statistics_norecompute 
     = OFF, ignore_dup_key = OFF, allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportTemplateColumnResponse] 
  ( 
     [ExportTemplateColumnResponseID] INT IDENTITY(1, 1), 
     [ExportTemplateColumnID]         INT, 
     [RawValue]                       INT NOT NULL, 
     [ExportColumnName]               VARCHAR(200) NULL, 
     [RecodeValue]                    VARCHAR(200) NOT NULL, 
     [ResponseLabel]                  VARCHAR(200) NOT NULL, 
     CONSTRAINT [PK_ExportTemplateColumnResponse] PRIMARY KEY CLUSTERED ( 
     [ExportTemplateColumnResponseID] ASC) WITH (pad_index = OFF, 
     statistics_norecompute = OFF, ignore_dup_key = OFF, allow_row_locks = on, 
     allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[DispositionProcess] 
  ( 
     [DispositionProcessID] INT IDENTITY(1, 1), 
     [RecodeValue]          VARCHAR(200) NULL, 
     [ExportErrorID]        INT NULL, 
     CONSTRAINT [PK_DispositionProcess] PRIMARY KEY CLUSTERED ( 
     [DispositionProcessID] ASC) WITH (pad_index = OFF, statistics_norecompute = 
     OFF, ignore_dup_key = OFF, allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[DispositionClause] 
  ( 
     [DispositionClauseID]    INT IDENTITY(1, 1), 
     [DispositionProcessID]   INT,
     [DispositionPhraseKey]   INT, 
     [ExportTemplateColumnID] INT, 
     [OperatorID]             INT, 
     [LowValue]               VARCHAR(100), 
     [HighValue]              VARCHAR(100), 
     CONSTRAINT [PK_DispositionClause] PRIMARY KEY CLUSTERED ( 
     [DispositionClauseID] ASC) WITH (pad_index = OFF, statistics_norecompute = 
     OFF, ignore_dup_key = OFF, allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[DispositionInList] 
  ( 
     [DispositionInListID] INT IDENTITY(1, 1), 
     [DispositionClauseID] INT, 
     [ListValue]           VARCHAR(100), 
     CONSTRAINT [PK_DispositionInList] PRIMARY KEY CLUSTERED ( 
     [DispositionInListID] ASC) WITH (pad_index = OFF, statistics_norecompute = 
     OFF, ignore_dup_key = OFF, allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportQueue] 
  ( 
     [ExportQueueID]              INT IDENTITY(1, 1), 
     [ExportTemplateName]         VARCHAR(200) NOT NULL, 
     [ExportTemplateVersionMajor] VARCHAR(100) NOT NULL, 
     [ExportTemplateVersionMinor] INT NULL, 
     [ExportDateStart]            DATETIME, 
     [ExportDateEnd]              DATETIME, 
     [ReturnsOnly]                BIT, 
     [ExportNotificationID]       INT, 
     [RequestDate]                DATETIME, 
     [PullDate]                   DATETIME, 
     [ValidatedDate]              DATETIME, 
     [ValidatedBy]                VARCHAR(100), 
     [ValidationCode]             VARCHAR(100), 
     CONSTRAINT [PK_ExportQueue] PRIMARY KEY CLUSTERED ([ExportQueueID] ASC) 
     WITH (pad_index = OFF, statistics_norecompute = OFF, ignore_dup_key = OFF, 
     allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportQueueFile]
  ( 
     [ExportQueueFileID]          INT IDENTITY(1, 1), 
	 [ExportQueueID]              INT NOT NULL,
	 [FileState]                  SMALLINT,
     [SubmissionDate]             DATETIME, 
     [SubmissionBy]               VARCHAR(100), 
     [CMSResponseCode]            VARCHAR(100), 
     [CMSResponseDate]            DATETIME, 
     [FileMakerType]              INT, 
     [FileMakerName]              VARCHAR(200), 
     [FileMakerDate]              DATETIME, 
     CONSTRAINT [PK_ExportQueueFile] PRIMARY KEY CLUSTERED ([ExportQueueFileID] ASC) 
     WITH (pad_index = OFF, statistics_norecompute = OFF, ignore_dup_key = OFF, 
     allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportQueueSurvey] 
  ( 
     [ExportQueueSurveyID] INT IDENTITY(1, 1), 
     [ExportQueueID]       INT, 
     [SurveyID]            INT, 
     CONSTRAINT [PK_ExportQueueSurvey] PRIMARY KEY CLUSTERED ( 
     [ExportQueueSurveyID] ASC) WITH (pad_index = OFF, statistics_norecompute = 
     OFF, ignore_dup_key = OFF, allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportNotification] 
  ( 
     [ExportNotificationID]   INT IDENTITY(1, 1), 
     [ExportNotificationName] VARCHAR(200), 
     CONSTRAINT [PK_ExportNotification] PRIMARY KEY CLUSTERED ( 
     [ExportNotificationID] ASC) WITH (pad_index = OFF, statistics_norecompute = 
     OFF, ignore_dup_key = OFF, allow_row_locks = on, allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[ExportNotificationType] 
  ( 
     [ExportNotificationTypeID] INT IDENTITY(1, 1), 
     [ExportNotificationID]     INT, 
     [Severity]                 INT, 
     [Type]                     INT, 
     [Address]                  VARCHAR(200), 
     CONSTRAINT [PK_ExportNotificationType] PRIMARY KEY CLUSTERED ( 
     [ExportNotificationTypeID] ASC) WITH (pad_index = OFF, 
     statistics_norecompute = OFF, ignore_dup_key = OFF, allow_row_locks = on, 
     allow_page_locks = on) 
  )
GO
CREATE TABLE [CEM].[Operator] 
  ( 
     [OperatorID]  INT IDENTITY(1, 1), 
     [strOperator] VARCHAR(20),
     [strLogic]    VARCHAR(40),
     CONSTRAINT [PK_Operator] PRIMARY KEY CLUSTERED ( 
     [OperatorID] ASC) WITH (pad_index = OFF, 
     statistics_norecompute = OFF, ignore_dup_key = OFF, allow_row_locks = on, 
     allow_page_locks = on) 
  )
GO

IF NOT EXISTS (SELECT * 
               FROM   sys.tables st 
                      INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
               WHERE  st.NAME = 'SurveyType' AND sc.NAME = 'DefaultExportTemplateMajorVersion') 
  ALTER TABLE [dbo].[SurveyType] ADD [DefaultExportTemplateMajorVersion] INT NULL 
go 
commit tran
