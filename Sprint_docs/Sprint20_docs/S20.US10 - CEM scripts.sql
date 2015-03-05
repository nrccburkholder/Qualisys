-- from production environment's nrc_datamart
USE [NRC_DataMart_Extracts]
GO
/****** Object:  StoredProcedure [CEM].[ExportPostProcess00000001] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportPostProcess00000001]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[ExportPostProcess00000001]
GO
/****** Object:  StoredProcedure [CEM].[SelectExportData] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectExportData]
GO
/****** Object:  StoredProcedure [CEM].[SelectExportQueue] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportQueue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectExportQueue]
GO
/****** Object:  StoredProcedure [CEM].[SelectExportQueueFile] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportQueueFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectExportQueueFile]
GO
/****** Object:  StoredProcedure [CEM].[SelectExportTemplateColumn] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportTemplateColumn]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectExportTemplateColumn]
GO
/****** Object:  StoredProcedure [CEM].[SelectExportTemplateColumnResponse] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportTemplateColumnResponse]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectExportTemplateColumnResponse]
GO
/****** Object:  StoredProcedure [CEM].[SelectSystemParams] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectSystemParams]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectSystemParams]
GO
/****** Object:  StoredProcedure [CEM].[SelectTemplate] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectTemplate]
GO
/****** Object:  StoredProcedure [CEM].[SelectTemplateSection] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectTemplateSection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[SelectTemplateSection]
GO
/****** Object:  StoredProcedure [CEM].[InsertExportQueueFile] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[InsertExportQueueFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[InsertExportQueueFile]
GO
/****** Object:  StoredProcedure [CEM].[PullExportData] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[PullExportData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[PullExportData]
GO
/****** Object:  StoredProcedure [CEM].[UpdateExportQueueFile] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[UpdateExportQueueFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CEM].[UpdateExportQueueFile]
GO
/****** Object:  Table [CEM].[Logs] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[Logs]') AND type in (N'U'))
DROP TABLE [CEM].[Logs]
GO
/****** Object:  Table [CEM].[Operator] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[Operator]') AND type in (N'U'))
DROP TABLE [CEM].[Operator]
GO
/****** Object:  Table [CEM].[System_Params] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[System_Params]') AND type in (N'U'))
DROP TABLE [CEM].[System_Params]
GO
/****** Object:  Table [CEM].[Datasource] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[Datasource]') AND type in (N'U'))
DROP TABLE [CEM].[Datasource]
GO
/****** Object:  Table [CEM].[DispositionClause] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[DispositionClause]') AND type in (N'U'))
DROP TABLE [CEM].[DispositionClause]
GO
/****** Object:  Table [CEM].[DispositionInList] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[DispositionInList]') AND type in (N'U'))
DROP TABLE [CEM].[DispositionInList]
GO
/****** Object:  Table [CEM].[DispositionProcess] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[DispositionProcess]') AND type in (N'U'))
DROP TABLE [CEM].[DispositionProcess]
GO
/****** Object:  Table [CEM].[ExportDataset00000001] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportDataset00000001]') AND type in (N'U'))
DROP TABLE [CEM].[ExportDataset00000001]
GO
/****** Object:  Table [CEM].[ExportDataset00000001_norecode] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportDataset00000001_norecode]') AND type in (N'U'))
DROP TABLE [CEM].[ExportDataset00000001_norecode]
GO
/****** Object:  Table [CEM].[ExportNotification] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportNotification]') AND type in (N'U'))
DROP TABLE [CEM].[ExportNotification]
GO
/****** Object:  Table [CEM].[ExportNotificationType] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportNotificationType]') AND type in (N'U'))
DROP TABLE [CEM].[ExportNotificationType]
GO
/****** Object:  Table [CEM].[ExportQueue] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportQueue]') AND type in (N'U'))
DROP TABLE [CEM].[ExportQueue]
GO
/****** Object:  Table [CEM].[ExportQueueFile] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportQueueFile]') AND type in (N'U'))
DROP TABLE [CEM].[ExportQueueFile]
GO
/****** Object:  Table [CEM].[ExportQueueSurvey] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportQueueSurvey]') AND type in (N'U'))
DROP TABLE [CEM].[ExportQueueSurvey]
GO
/****** Object:  Table [CEM].[ExportTemplate] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplate]') AND type in (N'U'))
DROP TABLE [CEM].[ExportTemplate]
GO
/****** Object:  Table [CEM].[ExportTemplateColumn] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateColumn]') AND type in (N'U'))
DROP TABLE [CEM].[ExportTemplateColumn]
GO
/****** Object:  Table [CEM].[ExportTemplateColumnResponse] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateColumnResponse]') AND type in (N'U'))
DROP TABLE [CEM].[ExportTemplateColumnResponse]
GO
/****** Object:  Table [CEM].[ExportTemplateDefaultResponse] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateDefaultResponse]') AND type in (N'U'))
DROP TABLE [CEM].[ExportTemplateDefaultResponse]
GO
/****** Object:  Table [CEM].[ExportTemplateSection] ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateSection]') AND type in (N'U'))
DROP TABLE [CEM].[ExportTemplateSection]
GO
/****** Object:  Schema [CEM] ******/
IF  EXISTS (SELECT * FROM sys.schemas WHERE name = N'CEM')
DROP SCHEMA [CEM]
GO
/****** Object:  Schema [CEM] ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'CEM')
EXEC sys.sp_executesql N'CREATE SCHEMA [CEM] AUTHORIZATION [dbo]'
GO
/****** Object:  Table [CEM].[ExportTemplateSection] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateSection]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportTemplateSection](
	[ExportTemplateSectionID] [int] IDENTITY(1,1) NOT NULL,
	[ExportTemplateSectionName] [varchar](200) NULL,
	[ExportTemplateID] [int] NULL,
	[DefaultNamingConvention] [varchar](200) NULL,
 CONSTRAINT [PK_ExportTemplateSection] PRIMARY KEY CLUSTERED 
(
	[ExportTemplateSectionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportTemplateDefaultResponse] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateDefaultResponse]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportTemplateDefaultResponse](
	[ExportTemplateDefaultResponseID] [int] IDENTITY(1,1) NOT NULL,
	[ExportTemplateID] [int] NULL,
	[RawValue] [int] NULL,
	[RecodeValue] [varchar](200) NOT NULL,
	[ResponseLabel] [varchar](200) NOT NULL,
 CONSTRAINT [PK_ExportTemplateDefaultResponse] PRIMARY KEY CLUSTERED 
(
	[ExportTemplateDefaultResponseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportTemplateColumnResponse] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateColumnResponse]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportTemplateColumnResponse](
	[ExportTemplateColumnResponseID] [int] IDENTITY(1,1) NOT NULL,
	[ExportTemplateColumnID] [int] NULL,
	[RawValue] [int] NOT NULL,
	[ExportColumnName] [varchar](200) NULL,
	[RecodeValue] [varchar](200) NOT NULL,
	[ResponseLabel] [varchar](200) NOT NULL,
 CONSTRAINT [PK_ExportTemplateColumnResponse] PRIMARY KEY CLUSTERED 
(
	[ExportTemplateColumnResponseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportTemplateColumn] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplateColumn]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportTemplateColumn](
	[ExportTemplateColumnID] [int] IDENTITY(1,1) NOT NULL,
	[ExportTemplateSectionID] [int] NOT NULL,
	[ExportTemplateColumnDescription] [varchar](200) NOT NULL,
	[ColumnOrder] [int] NOT NULL,
	[DatasourceID] [int] NOT NULL,
	[ExportColumnName] [varchar](200) NULL,
	[SourceColumnName] [varchar](200) NOT NULL,
	[SourceColumnType] [int] NOT NULL,
	[AggregateFunction] [varchar](30) NULL,
	[DispositionProcessID] [int] NULL,
	[FixedWidthLength] [int] NULL,
	[ColumnSetKey] [int] NULL,
	[FormatID] [int] NULL,
	[MissingThresholdPercentage] [float] NULL,
	[CheckFrequencies] [bit] NULL,
 CONSTRAINT [PK_ExportTemplateColumn] PRIMARY KEY CLUSTERED 
(
	[ExportTemplateColumnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportTemplate] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportTemplate]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportTemplate](
	[ExportTemplateID] [int] IDENTITY(1,1) NOT NULL,
	[ExportTemplateName] [varchar](200) NOT NULL,
	[SurveyTypeID] [int] NOT NULL,
	[SurveySubTypeID] [int] NULL,
	[ValidDateColumnID] [int] NOT NULL,
	[ValidStartDate] [datetime] NULL,
	[ValidEndDate] [datetime] NULL,
	[ExportTemplateVersionMajor] [varchar](100) NOT NULL,
	[ExportTemplateVersionMinor] [int] NOT NULL,
	[CreatedBy] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ClientID] [int] NULL,
	[DefaultNotificationID] [int] NULL,
	[DefaultNamingConvention] [varchar](200) NULL,
	[State] [int] NOT NULL,
	[ReturnsOnly] [bit] NOT NULL,
	[SampleUnitCahpsTypeID] [int] NULL,
	[XMLSchemaDefinition] [xml] NULL,
	[isOfficial] [bit] NULL,
	[DefaultFileMakerType] [int] NULL,
 CONSTRAINT [PK_ExportTemplate] PRIMARY KEY CLUSTERED 
(
	[ExportTemplateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportQueueSurvey] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportQueueSurvey]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportQueueSurvey](
	[ExportQueueSurveyID] [int] IDENTITY(1,1) NOT NULL,
	[ExportQueueID] [int] NULL,
	[SurveyID] [int] NULL,
 CONSTRAINT [PK_ExportQueueSurvey] PRIMARY KEY CLUSTERED 
(
	[ExportQueueSurveyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [CEM].[ExportQueueFile] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportQueueFile]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportQueueFile](
	[ExportQueueFileID] [int] IDENTITY(1,1) NOT NULL,
	[ExportQueueID] [int] NOT NULL,
	[FileState] [smallint] NULL,
	[SubmissionDate] [datetime] NULL,
	[SubmissionBy] [varchar](100) NULL,
	[CMSResponseCode] [varchar](100) NULL,
	[CMSResponseDate] [datetime] NULL,
	[FileMakerType] [int] NULL,
	[FileMakerName] [varchar](200) NULL,
	[FileMakerDate] [datetime] NULL,
 CONSTRAINT [PK_ExportQueueFile] PRIMARY KEY CLUSTERED 
(
	[ExportQueueFileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportQueue] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportQueue]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportQueue](
	[ExportQueueID] [int] IDENTITY(1,1) NOT NULL,
	[ExportTemplateName] [varchar](200) NOT NULL,
	[ExportTemplateVersionMajor] [varchar](100) NOT NULL,
	[ExportTemplateVersionMinor] [int] NULL,
	[ExportDateStart] [datetime] NULL,
	[ExportDateEnd] [datetime] NULL,
	[ReturnsOnly] [bit] NULL,
	[ExportNotificationID] [int] NULL,
	[RequestDate] [datetime] NULL,
	[PullDate] [datetime] NULL,
	[ValidatedDate] [datetime] NULL,
	[ValidatedBy] [varchar](100) NULL,
	[ValidationCode] [varchar](100) NULL,
 CONSTRAINT [PK_ExportQueue] PRIMARY KEY CLUSTERED 
(
	[ExportQueueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportNotificationType] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportNotificationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportNotificationType](
	[ExportNotificationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ExportNotificationID] [int] NULL,
	[Severity] [int] NULL,
	[Type] [int] NULL,
	[Address] [varchar](200) NULL,
 CONSTRAINT [PK_ExportNotificationType] PRIMARY KEY CLUSTERED 
(
	[ExportNotificationTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportNotification] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportNotification]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportNotification](
	[ExportNotificationID] [int] IDENTITY(1,1) NOT NULL,
	[ExportNotificationName] [varchar](200) NULL,
 CONSTRAINT [PK_ExportNotification] PRIMARY KEY CLUSTERED 
(
	[ExportNotificationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportDataset00000001_norecode] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportDataset00000001_norecode]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportDataset00000001_norecode](
	[ResultsID] [int] IDENTITY(1,1) NOT NULL,
	[ExportQueueID] [int] NULL,
	[ExportTemplateID] [int] NULL,
	[SamplePopulationID] [int] NULL,
	[QuestionFormID] [int] NULL,
	[FileMakerName] [varchar](200) NULL,
	[header.facility-name] [varchar](100) NULL,
	[header.facility-id] [varchar](6) NULL,
	[header.sem-survey] [varchar](5) NULL,
	[header.survey-yr] [varchar](5) NULL,
	[header.survey-mode] [varchar](5) NULL,
	[header.number-sampled] [varchar](5) NULL,
	[header.dcstart-date] [varchar](8) NULL,
	[header.dcend-date] [varchar](8) NULL,
	[administration.facility-id] [varchar](6) NULL,
	[administration.sem-survey] [varchar](5) NULL,
	[administration.survey-yr] [varchar](5) NULL,
	[administration.sample-id] [varchar](10) NULL,
	[administration.final-status] [varchar](5) NULL,
	[administration.date-completed] [varchar](8) NULL,
	[administration.language] [varchar](5) NULL,
	[administration.survey-mode] [varchar](5) NULL,
	[administration.field-date] [varchar](8) NULL,
	[patientresponse.where-dialysis] [varchar](5) NULL,
	[patientresponse.how-long-care] [varchar](5) NULL,
	[patientresponse.dr-listen] [varchar](5) NULL,
	[patientresponse.dr-explain] [varchar](5) NULL,
	[patientresponse.dr-respect] [varchar](5) NULL,
	[patientresponse.dr-time] [varchar](5) NULL,
	[patientresponse.dr-care] [varchar](5) NULL,
	[patientresponse.rate-dr] [varchar](5) NULL,
	[patientresponse.dr-informed] [varchar](5) NULL,
	[patientresponse.staff-listen] [varchar](5) NULL,
	[patientresponse.staff-explain] [varchar](5) NULL,
	[patientresponse.staff-respect] [varchar](5) NULL,
	[patientresponse.staff-time] [varchar](5) NULL,
	[patientresponse.staff-care] [varchar](5) NULL,
	[patientresponse.make-comfortable] [varchar](5) NULL,
	[patientresponse.info-private] [varchar](5) NULL,
	[patientresponse.ask-staff] [varchar](5) NULL,
	[patientresponse.ask-affects] [varchar](5) NULL,
	[patientresponse.take-care] [varchar](5) NULL,
	[patientresponse.connect-machine] [varchar](5) NULL,
	[patientresponse.little-pain] [varchar](5) NULL,
	[patientresponse.check-closely] [varchar](5) NULL,
	[patientresponse.problems] [varchar](5) NULL,
	[patientresponse.manage-problems] [varchar](5) NULL,
	[patientresponse.behave-professionally] [varchar](5) NULL,
	[patientresponse.talk-about-eat] [varchar](5) NULL,
	[patientresponse.explain-bloodtest] [varchar](5) NULL,
	[patientresponse.your-rights] [varchar](5) NULL,
	[patientresponse.review-rights] [varchar](5) NULL,
	[patientresponse.what-dohome] [varchar](5) NULL,
	[patientresponse.getoff-machine] [varchar](5) NULL,
	[patientresponse.rate-staff] [varchar](5) NULL,
	[patientresponse.onmachine-15min] [varchar](5) NULL,
	[patientresponse.center-clean] [varchar](5) NULL,
	[patientresponse.rate-center] [varchar](5) NULL,
	[patientresponse.talk-treatment] [varchar](5) NULL,
	[patientresponse.eligible-transplant] [varchar](5) NULL,
	[patientresponse.explain-ineligible] [varchar](5) NULL,
	[patientresponse.talk-peritoneal] [varchar](5) NULL,
	[patientresponse.choose-treatment] [varchar](5) NULL,
	[patientresponse.unhappy-care] [varchar](5) NULL,
	[patientresponse.talk-withstaff] [varchar](5) NULL,
	[patientresponse.satisfied-problems] [varchar](5) NULL,
	[patientresponse.make-complaint] [varchar](5) NULL,
	[patientresponse.overall-health] [varchar](5) NULL,
	[patientresponse.mental-health] [varchar](5) NULL,
	[patientresponse.high-bloodpressure] [varchar](5) NULL,
	[patientresponse.diabetes] [varchar](5) NULL,
	[patientresponse.heart-disease] [varchar](5) NULL,
	[patientresponse.deaf] [varchar](5) NULL,
	[patientresponse.blind] [varchar](5) NULL,
	[patientresponse.difficulty-concentrating] [varchar](5) NULL,
	[patientresponse.difficulty-walking] [varchar](5) NULL,
	[patientresponse.difficulty-dressing] [varchar](5) NULL,
	[patientresponse.difficulty-errands] [varchar](5) NULL,
	[patientresponse.age] [varchar](5) NULL,
	[patientresponse.sex] [varchar](5) NULL,
	[patientresponse.education] [varchar](5) NULL,
	[patientresponse.speak-english] [varchar](5) NULL,
	[patientresponse.speak-other-language] [varchar](5) NULL,
	[patientresponse.language-spoken] [varchar](5) NULL,
	[patientresponse.not-hispanic-phone] [varchar](5) NULL,
	[patientresponse.hispanic-phone] [varchar](5) NULL,
	[patientresponse.not-hispanic-mail] [varchar](5) NULL,
	[patientresponse.race-african-amer-phone] [varchar](5) NULL,
	[patientresponse.race-amer-indian-phone] [varchar](5) NULL,
	[patientresponse.race-asian-phone] [varchar](5) NULL,
	[patientresponse.race-nativehawaiian-pacific-phone] [varchar](5) NULL,
	[patientresponse.race-noneofabove-phone] [varchar](5) NULL,
	[patientresponse.race-white-phone] [varchar](5) NULL,
	[patientresponse.race-asian-indian-phone] [varchar](5) NULL,
	[patientresponse.race-chinese-phone] [varchar](5) NULL,
	[patientresponse.race-filipino-phone] [varchar](5) NULL,
	[patientresponse.race-japanese-phone] [varchar](5) NULL,
	[patientresponse.race-korean-phone] [varchar](5) NULL,
	[patientresponse.race-noneofabove-asian-phone] [varchar](5) NULL,
	[patientresponse.race-otherasian-phone] [varchar](5) NULL,
	[patientresponse.race-vietnamese-phone] [varchar](5) NULL,
	[patientresponse.race-guam-chamarro-phone] [varchar](5) NULL,
	[patientresponse.race-nativehawaiian-phone] [varchar](5) NULL,
	[patientresponse.race-noneofabove-pacific-phone] [varchar](5) NULL,
	[patientresponse.race-otherpacificislander-phone] [varchar](5) NULL,
	[patientresponse.race-samoan-phone] [varchar](5) NULL,
	[patientresponse.race-african-amer-mail] [varchar](5) NULL,
	[patientresponse.race-amer-indian-mail] [varchar](5) NULL,
	[patientresponse.race-asian-indian-mail] [varchar](5) NULL,
	[patientresponse.race-chinese-mail] [varchar](5) NULL,
	[patientresponse.race-filipino-mail] [varchar](5) NULL,
	[patientresponse.race-guamanian-chamorro-mail] [varchar](5) NULL,
	[patientresponse.race-japanese-mail] [varchar](5) NULL,
	[patientresponse.race-korean-mail] [varchar](5) NULL,
	[patientresponse.race-nativehawaiian-mail] [varchar](5) NULL,
	[patientresponse.race-other-pacificislander-mail] [varchar](5) NULL,
	[patientresponse.race-otherasian-mail] [varchar](5) NULL,
	[patientresponse.race-samoan-mail] [varchar](5) NULL,
	[patientresponse.race-vietnamese-mail] [varchar](5) NULL,
	[patientresponse.race-white-mail] [varchar](5) NULL,
	[patientresponse.help-you] [varchar](5) NULL,
	[patientresponse.who-helped] [varchar](5) NULL,
	[patientresponse.help-answer] [varchar](5) NULL,
	[patientresponse.help-other] [varchar](5) NULL,
	[patientresponse.help-read] [varchar](5) NULL,
	[patientresponse.help-translate] [varchar](5) NULL,
	[patientresponse.help-wrote] [varchar](5) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[ExportDataset00000001] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportDataset00000001]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[ExportDataset00000001](
	[ResultsID] [int] IDENTITY(1,1) NOT NULL,
	[ExportQueueID] [int] NULL,
	[ExportTemplateID] [int] NULL,
	[SamplePopulationID] [int] NULL,
	[QuestionFormID] [int] NULL,
	[FileMakerName] [varchar](200) NULL,
	[header.facility-name] [varchar](100) NULL,
	[header.facility-id] [varchar](6) NULL,
	[header.sem-survey] [varchar](1) NULL,
	[header.survey-yr] [varchar](4) NULL,
	[header.survey-mode] [varchar](1) NULL,
	[header.number-sampled] [varchar](3) NULL,
	[header.dcstart-date] [varchar](8) NULL,
	[header.dcend-date] [varchar](8) NULL,
	[administration.facility-id] [varchar](6) NULL,
	[administration.sem-survey] [varchar](1) NULL,
	[administration.survey-yr] [varchar](4) NULL,
	[administration.sample-id] [varchar](10) NULL,
	[administration.final-status] [varchar](3) NULL,
	[administration.date-completed] [varchar](8) NULL,
	[administration.language] [varchar](1) NULL,
	[administration.survey-mode] [varchar](1) NULL,
	[administration.field-date] [varchar](8) NULL,
	[patientresponse.where-dialysis] [varchar](1) NULL,
	[patientresponse.how-long-care] [varchar](1) NULL,
	[patientresponse.dr-listen] [varchar](1) NULL,
	[patientresponse.dr-explain] [varchar](1) NULL,
	[patientresponse.dr-respect] [varchar](1) NULL,
	[patientresponse.dr-time] [varchar](1) NULL,
	[patientresponse.dr-care] [varchar](1) NULL,
	[patientresponse.rate-dr] [varchar](2) NULL,
	[patientresponse.dr-informed] [varchar](1) NULL,
	[patientresponse.staff-listen] [varchar](1) NULL,
	[patientresponse.staff-explain] [varchar](1) NULL,
	[patientresponse.staff-respect] [varchar](1) NULL,
	[patientresponse.staff-time] [varchar](1) NULL,
	[patientresponse.staff-care] [varchar](1) NULL,
	[patientresponse.make-comfortable] [varchar](1) NULL,
	[patientresponse.info-private] [varchar](1) NULL,
	[patientresponse.ask-staff] [varchar](1) NULL,
	[patientresponse.ask-affects] [varchar](1) NULL,
	[patientresponse.take-care] [varchar](1) NULL,
	[patientresponse.connect-machine] [varchar](1) NULL,
	[patientresponse.little-pain] [varchar](1) NULL,
	[patientresponse.check-closely] [varchar](1) NULL,
	[patientresponse.problems] [varchar](1) NULL,
	[patientresponse.manage-problems] [varchar](1) NULL,
	[patientresponse.behave-professionally] [varchar](1) NULL,
	[patientresponse.talk-about-eat] [varchar](1) NULL,
	[patientresponse.explain-bloodtest] [varchar](1) NULL,
	[patientresponse.your-rights] [varchar](1) NULL,
	[patientresponse.review-rights] [varchar](1) NULL,
	[patientresponse.what-dohome] [varchar](1) NULL,
	[patientresponse.getoff-machine] [varchar](1) NULL,
	[patientresponse.rate-staff] [varchar](2) NULL,
	[patientresponse.onmachine-15min] [varchar](1) NULL,
	[patientresponse.center-clean] [varchar](1) NULL,
	[patientresponse.rate-center] [varchar](2) NULL,
	[patientresponse.talk-treatment] [varchar](1) NULL,
	[patientresponse.eligible-transplant] [varchar](1) NULL,
	[patientresponse.explain-ineligible] [varchar](1) NULL,
	[patientresponse.talk-peritoneal] [varchar](1) NULL,
	[patientresponse.choose-treatment] [varchar](1) NULL,
	[patientresponse.unhappy-care] [varchar](1) NULL,
	[patientresponse.talk-withstaff] [varchar](1) NULL,
	[patientresponse.satisfied-problems] [varchar](1) NULL,
	[patientresponse.make-complaint] [varchar](1) NULL,
	[patientresponse.overall-health] [varchar](1) NULL,
	[patientresponse.mental-health] [varchar](1) NULL,
	[patientresponse.high-bloodpressure] [varchar](1) NULL,
	[patientresponse.diabetes] [varchar](1) NULL,
	[patientresponse.heart-disease] [varchar](1) NULL,
	[patientresponse.deaf] [varchar](1) NULL,
	[patientresponse.blind] [varchar](1) NULL,
	[patientresponse.difficulty-concentrating] [varchar](1) NULL,
	[patientresponse.difficulty-walking] [varchar](1) NULL,
	[patientresponse.difficulty-dressing] [varchar](1) NULL,
	[patientresponse.difficulty-errands] [varchar](1) NULL,
	[patientresponse.age] [varchar](1) NULL,
	[patientresponse.sex] [varchar](1) NULL,
	[patientresponse.education] [varchar](1) NULL,
	[patientresponse.speak-english] [varchar](1) NULL,
	[patientresponse.speak-other-language] [varchar](1) NULL,
	[patientresponse.language-spoken] [varchar](1) NULL,
	[patientresponse.not-hispanic-phone] [varchar](1) NULL,
	[patientresponse.hispanic-phone] [varchar](1) NULL,
	[patientresponse.not-hispanic-mail] [varchar](1) NULL,
	[patientresponse.race-african-amer-phone] [varchar](1) NULL,
	[patientresponse.race-amer-indian-phone] [varchar](1) NULL,
	[patientresponse.race-asian-phone] [varchar](1) NULL,
	[patientresponse.race-nativehawaiian-pacific-phone] [varchar](1) NULL,
	[patientresponse.race-noneofabove-phone] [varchar](1) NULL,
	[patientresponse.race-white-phone] [varchar](1) NULL,
	[patientresponse.race-asian-indian-phone] [varchar](1) NULL,
	[patientresponse.race-chinese-phone] [varchar](1) NULL,
	[patientresponse.race-filipino-phone] [varchar](1) NULL,
	[patientresponse.race-japanese-phone] [varchar](1) NULL,
	[patientresponse.race-korean-phone] [varchar](1) NULL,
	[patientresponse.race-noneofabove-asian-phone] [varchar](1) NULL,
	[patientresponse.race-otherasian-phone] [varchar](1) NULL,
	[patientresponse.race-vietnamese-phone] [varchar](1) NULL,
	[patientresponse.race-guam-chamarro-phone] [varchar](1) NULL,
	[patientresponse.race-nativehawaiian-phone] [varchar](1) NULL,
	[patientresponse.race-noneofabove-pacific-phone] [varchar](1) NULL,
	[patientresponse.race-otherpacificislander-phone] [varchar](1) NULL,
	[patientresponse.race-samoan-phone] [varchar](1) NULL,
	[patientresponse.race-african-amer-mail] [varchar](1) NULL,
	[patientresponse.race-amer-indian-mail] [varchar](1) NULL,
	[patientresponse.race-asian-indian-mail] [varchar](1) NULL,
	[patientresponse.race-chinese-mail] [varchar](1) NULL,
	[patientresponse.race-filipino-mail] [varchar](1) NULL,
	[patientresponse.race-guamanian-chamorro-mail] [varchar](1) NULL,
	[patientresponse.race-japanese-mail] [varchar](1) NULL,
	[patientresponse.race-korean-mail] [varchar](1) NULL,
	[patientresponse.race-nativehawaiian-mail] [varchar](1) NULL,
	[patientresponse.race-other-pacificislander-mail] [varchar](1) NULL,
	[patientresponse.race-otherasian-mail] [varchar](1) NULL,
	[patientresponse.race-samoan-mail] [varchar](1) NULL,
	[patientresponse.race-vietnamese-mail] [varchar](1) NULL,
	[patientresponse.race-white-mail] [varchar](1) NULL,
	[patientresponse.help-you] [varchar](1) NULL,
	[patientresponse.who-helped] [varchar](1) NULL,
	[patientresponse.help-answer] [varchar](1) NULL,
	[patientresponse.help-other] [varchar](1) NULL,
	[patientresponse.help-read] [varchar](1) NULL,
	[patientresponse.help-translate] [varchar](1) NULL,
	[patientresponse.help-wrote] [varchar](1) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[DispositionProcess] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[DispositionProcess]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[DispositionProcess](
	[DispositionProcessID] [int] IDENTITY(1,1) NOT NULL,
	[RecodeValue] [varchar](200) NULL,
	[ExportErrorID] [int] NULL,
 CONSTRAINT [PK_DispositionProcess] PRIMARY KEY CLUSTERED 
(
	[DispositionProcessID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[DispositionInList] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[DispositionInList]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[DispositionInList](
	[DispositionInListID] [int] IDENTITY(1,1) NOT NULL,
	[DispositionClauseID] [int] NULL,
	[ListValue] [varchar](100) NULL,
 CONSTRAINT [PK_DispositionInList] PRIMARY KEY CLUSTERED 
(
	[DispositionInListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[DispositionClause] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[DispositionClause]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[DispositionClause](
	[DispositionClauseID] [int] IDENTITY(1,1) NOT NULL,
	[DispositionProcessID] [int] NULL,
	[DispositionPhraseKey] [int] NULL,
	[ExportTemplateColumnID] [int] NULL,
	[OperatorID] [int] NULL,
	[LowValue] [varchar](100) NULL,
	[HighValue] [varchar](100) NULL,
 CONSTRAINT [PK_DispositionClause] PRIMARY KEY CLUSTERED 
(
	[DispositionClauseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[Datasource] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[Datasource]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[Datasource](
	[DatasourceID] [int] IDENTITY(1,1) NOT NULL,
	[HorizontalVertical] [char](1) NOT NULL,
	[TableName] [varchar](200) NOT NULL,
	[TableAlias] [varchar](20) NOT NULL,
	[ForeignKeyField] [varchar](100) NULL,
 CONSTRAINT [PK_Datasource] PRIMARY KEY CLUSTERED 
(
	[DatasourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[System_Params] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[System_Params]') AND type in (N'U'))
BEGIN
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
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[Operator] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[Operator]') AND type in (N'U'))
BEGIN
CREATE TABLE [CEM].[Operator](
	[OperatorID] [int] IDENTITY(1,1) NOT NULL,
	[strOperator] [varchar](20) NULL,
	[strLogic] [varchar](40) NULL,
 CONSTRAINT [PK_Operator] PRIMARY KEY CLUSTERED 
(
	[OperatorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CEM].[Logs] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[Logs]') AND type in (N'U'))
BEGIN
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
	[ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [PK_Logs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  StoredProcedure [CEM].[UpdateExportQueueFile] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[UpdateExportQueueFile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
' 
END
GO
/****** Object:  StoredProcedure [CEM].[PullExportData] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[PullExportData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [CEM].[PullExportData]
@ExportQueueID int, @doRecode bit=1, @doDispositionProc bit=1, @doPostProcess bit=1
as
begin 

--declare @ExportQueueID int = 3,  @doRecode bit=1, @doDispositionProc bit=1, @doPostProcess bit=1

declare @ExportTemplateName varchar(200), @ExportTemplateVersionMajor varchar(200), @ExportTemplateVersionMinor int
declare @ExportTemplateID int, @ExportDateColumnID int, @ExportStart datetime, @exportEnd datetime, @returnsonly bit, @CahpsUnitOnly bit
declare @DateDataSourceID int, @DateFieldName varchar(200), @DateColumnName varchar(200), @surveylist varchar(max)

select @ExportTemplateName=ExportTemplateName, @ExportTemplateVersionMajor=ExportTemplateVersionMajor, @ExportTemplateVersionMinor=ExportTemplateVersionMinor, 
	@exportStart=exportdatestart, @exportEnd=exportdateend, @returnsonly=returnsonly
from CEM.exportqueue eq
where eq.exportqueueid=@ExportQueueID

set @surveylist=''''
select @surveylist=@surveylist+convert(varchar,eqs.SurveyID)+'',''
from CEM.exportqueue eq
inner join CEM.exportqueuesurvey eqs on eq.exportqueueid=eqs.exportqueueid
where eq.exportqueueid=@ExportQueueID

set @surveylist=left(@surveylist,len(@surveylist)-1)

if @ExportTemplateVersionMinor is null
	select @ExportTemplateVersionMinor = max(ExportTemplateVersionMinor)
	from cem.ExportTemplate et
	where ExportTemplateName=@ExportTemplateName 
	and ExportTemplateVersionMajor=@ExportTemplateVersionMajor 

select @ExportTemplateID=ExportTemplateID, @ExportDateColumnID=ValidDateColumnID
from cem.ExportTemplate et
where ExportTemplateName=@ExportTemplateName 
and ExportTemplateVersionMajor=@ExportTemplateVersionMajor 
and ExportTemplateVersionMinor=@ExportTemplateVersionMinor

if @ExportTemplateID is null 
begin
	print ''ERROR! Cannot identify the proper template''
	insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
	select getdate() as EventDateTime
		, ''Error'' as EventLevel
		, system_user as UserName
		, host_name() as MachineName
		, '''' as EventType
		, ''Cannot identify the proper template.'' as EventMessage
		, ''[CEM].[PullExportData] @ExportQueueID='' + convert(varchar,@ExportQueueID) as EventSource
		, ''Stored Procedure'' as EventClass
		, '''' as EventMethod
		, ''ExportTemplateName: ''+@ExportTemplateName
			+'', ExportTemplateVersionMajor: ''+@ExportTemplateVersionMajor
			+'', ExportTemplateVersionMinor: ''+isnull(@ExportTemplateVersionMajor,''NULL'') as ErrorMessage
	return --1
end

select distinct @CahpsUnitOnly=case when isnull(et.sampleunitcahpstypeid,0)=0 then 0 else 1 end
	, @DateDataSourceID=etc.DataSourceID
	, @DateFieldName=etc.ExportColumnName
	, @DateColumnName=etc.SourceColumnName
from CEM.exporttemplate et
inner join CEM.exporttemplatesection ets on et.exporttemplateid=ets.exporttemplateid
inner join CEM.exporttemplatecolumn etc on ets.exporttemplatesectionid=etc.exporttemplatesectionid
where etc.ExportTemplateColumnID=@ExportDateColumnID


declare @sql varchar(max)

if object_id(''tempdb..#allcolumns'') is not null
	drop table #allcolumns

select distinct ets.ExportTemplateSectionID, ets.ExportTemplateSectionName, etc.ExportTemplateColumnID, etc.DispositionProcessID, 
	ds.DataSourceID, ds.TableName, ds.horizontalvertical, ds.TableAlias, etc.ExportTemplateColumnDescription,
	etc.ColumnOrder,etc.ExportColumnName, etc.FixedWidthLength, etc.AggregateFunction, etc.SourceColumnName, etc.SourceColumnType, 
	etcr.RawValue, etcr.ExportColumnName as ExportColumnNameMR, etcr.RecodeValue, 0 as flag
into #allColumns
from CEM.exporttemplate et
inner join CEM.exporttemplatesection ets on et.exporttemplateid=ets.exporttemplateid
inner join CEM.exporttemplatecolumn etc on ets.exporttemplatesectionid=etc.exporttemplatesectionid
inner join CEM.datasource ds on etc.DataSourceID=ds.DataSourceID
left join CEM.exporttemplatecolumnresponse etcr on etc.ExportTemplateColumnID=etcr.ExportTemplateColumnID
where et.ExportTemplateID=@ExportTemplateID
order by etc.ColumnOrder

if exists (	select ExportTemplateColumnID
			from #allcolumns
			where ExportColumnNameMR is not null
			and RawValue <> -9
			group by ExportTemplateColumnID
			having min(FixedWidthLength) <> sum(len(RecodeValue)))
begin
	print ''ERROR! One or more of the multiple response questions doesn''''t have a wide enough FixedWidthLength. Aborting.''
	set @sql=''''
	select @SQL = @SQL + msg + '', ''
	from (	select min(ExportTemplateColumnDescription)+ '' needs '' + convert(varchar,sum(len(RecodeValue))) + '' but is using ''+convert(varchar, min(FixedWidthLength)) as msg
			from #allcolumns
			where ExportColumnNameMR is not null
			and RawValue <> -9
			group by ExportTemplateColumnID
			having min(FixedWidthLength) <> sum(len(RecodeValue))) x

	insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
	select getdate() as EventDateTime
		, ''Error'' as EventLevel
		, system_user as UserName
		, host_name() as MachineName
		, '''' as EventType
		, ''Multiple-response question(s) aren''''t using the proper FixedWidthLength.'' as EventMessage
		, ''[CEM].[PullExportData] @ExportQueueID='' + convert(varchar,@ExportQueueID) as EventSource
		, ''Stored Procedure'' as EventClass
		, '''' as EventMethod
		, @sql as ErrorMessage			
	return --1
end

update #allcolumns set FixedWidthLength=len(RecodeValue)
where ExportColumnNameMR is not null


if object_id(''tempdb..#results'') is null
	create table #results (ResultsID int identity(1,1), ExportQueueID int, ExportTemplateID int, SamplePopulationID int, QuestionFormID int, FileMakerName varchar(200))
else
begin
	-- if #results pre-exists (possible outside the scope of this proc) reset it to just be an empty table with the original 5 columns
	if exists (select * from #results)
		truncate table #results
end

declare @objid int
set @objid=object_id(''tempdb..#results'') 
set @sql = ''alter table #results add ''

select @sql=@sql + ''['' + ExportTemplateSectionName + ''.'' + isnull(ExportColumnName,ExportColumnNameMR) + ''] varchar(''+convert(varchar,
				case 
				when rawwidth >= recodewidth and rawwidth >= defaultwidth then rawwidth 
				when recodewidth >= rawwidth and recodewidth >= defaultwidth then recodewidth
				when defaultwidth >= rawwidth and defaultwidth >= recodewidth then defaultwidth
				else 255 
				end)+'') default '''''''',''
from (	select columnorder, ExportTemplateSectionID, ExportTemplateSectionName, ExportColumnName,ExportColumnNameMR, max(FixedWidthLength) as recodewidth, max(len(isnull(RawValue,0))) as rawwidth
		from #allcolumns
		where isnull(ExportColumnNameMR,'''') <> ''unmarked''
		and ExportTemplateSectionName + ''.'' + isnull(ExportColumnName,ExportColumnNameMR) not in (select name from tempdb.sys.columns where object_id=@objid)
		group by columnorder, ExportTemplateSectionID, ExportTemplateSectionName, ExportColumnName,ExportColumnNameMR) c 
 , (select max(len(RawValue)) as defaultwidth from CEM.ExportTemplateDefaultResponse where ExportTemplateID=@ExportTemplateID) d
order by ExportTemplateSectionid, columnorder

if @@rowcount>0
begin
	set @SQL = left(@sql,len(@sql)-1)
	exec (@SQL)
end


if object_id(''CEM.ExportDataset''+right(convert(varchar,100000000+@ExportTemplateID),8)) is null
begin
	set @SQL = ''create table CEM.ExportDataset''+right(convert(varchar,100000000+@ExportTemplateID),8)+'' (ResultsID int identity(1,1), ExportQueueID int, ExportTemplateID int, SamplePopulationID int, QuestionFormID int)''
	exec (@SQL)

	set @sql = ''alter table CEM.ExportDataset''+right(convert(varchar,100000000+@ExportTemplateID),8)+'' add FileMakerName varchar(200)''

	select @sql=@sql + '',
	['' + ExportTemplateSectionName + ''.'' + isnull(ExportColumnName,ExportColumnNameMR) + ''] varchar(''+convert(varchar,FixedWidthLength)+'')''
	from (	select distinct columnorder, ExportTemplateSectionid, ExportTemplateSectionName, ExportColumnName,ExportColumnNameMR, FixedWidthLength
			from #allcolumns
			where isnull(ExportColumnNameMR,'''') <> ''unmarked'') c 
	order by ExportTemplateSectionid, columnorder

	exec (@SQL)
end
else
begin
	set @SQL = ''insert into #results (SamplePopulationID) 
		select distinct SamplePopulationID 
		from CEM.ExportDataset''+right(convert(varchar,100000000+@ExportTemplateID),8)+''
		where ExportQueueID=''+convert(varchar,@ExportQueueID)
	exec (@SQL)
	if exists (select * from #results)
	begin
		print ''It appears this ExportQueueID''''s data has already been pulled. Aborting.''
		insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
		select getdate() as EventDateTime
			, ''Info'' as EventLevel
			, system_user as UserName
			, host_name() as MachineName
			, '''' as EventType
			, ''Data for ExportQueueID has already been pulled.'' as EventMessage
			, ''[CEM].[PullExportData] @ExportQueueID='' + convert(varchar,@ExportQueueID) as EventSource
			, ''Stored Procedure'' as EventClass
			, '''' as EventMethod
			, ''To re-pull, first: DELETE FROM CEM.ExportDataset''+right(convert(varchar,100000000+@ExportTemplateID),8)+'' WHERE ExportQueueID='' + convert(varchar,@ExportQueueID) as ErrorMessage
		return --
	end
end

declare @sqlInsert varchar(max), @sqlSelect varchar(max), @sqlFrom varchar(max), @sqlWhere varchar(max)
set @sqlInsert=''insert into #results (SamplePopulationID, QuestionFormID, ExportQueueID, ExportTemplateID'' + char(10)
set @sqlSelect=''select distinct sp.SamplePopulationID, qf.QuestionFormID, ''+convert(varchar,@ExportQueueID)+'' as ExportQueueID, ''+convert(varchar,@ExportTemplateID)+'' as ExportTemplateID'' + char(10)
set @sqlFrom=''from NRC_Datamart.dbo.samplepopulation sp 
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
left join NRC_Datamart.dbo.questionform qf on sp.SamplePopulationID=qf.SamplePopulationID and qf.isActive=1'' + char(10)

set @sqlWhere = ''where su.surveyid in (''+@surveylist+'')'' + char(10)

if @CahpsUnitOnly=1
	set @sqlWhere=@sqlWhere+''and su.isCahps = 1'' + char(10)

if @ReturnsOnly=1
	set @sqlWhere = @sqlWhere + ''and qf.ReturnDate is not null'' + char(10)


select @sqlSelect = @sqlSelect + '', isnull('' +
		case when SourceColumnType in (40,61) then ''convert(varchar,'' else '''' end + 
	TableAlias + ''.['' + SourceColumnName + '']''+
		case when SourceColumnType in (40,61) then '',112)'' else '''' end + 
	'','''''''') as [''+ExportTemplateSectionName+''.''+ExportColumnName+'']'' + char(10)
, @sqlInsert = @sqlInsert + '', [''+ExportTemplateSectionName+''.''+ExportColumnName+'']'' + char(10)
from (select distinct horizontalvertical,TableAlias,SourceColumnName,ExportTemplateSectionName,ExportColumnName,SourceColumnType,AggregateFunction from #allcolumns) ac
where horizontalvertical=''H''
and AggregateFunction is null

update #allcolumns set flag=1
where horizontalvertical=''H''
and AggregateFunction is null

if exists (select * from #allcolumns where flag=1 and ExportTemplateColumnID=@ExportDateColumnID)
	select @sqlWhere = @sqlWhere + ''and '' + ds.TableAlias+''.''+@DateColumnName + '' between ''''''+convert(varchar,@exportStart)+'''''' and ''''''+convert(varchar,@exportEnd)+'''''''' + char(10)
	from CEM.datasource ds
	where ds.DataSourceID=@DateDataSourceID
else
begin
	select @sqlFrom = @sqlFrom + ''inner join (select SamplePopulationID, convert(datetime,ColumnValue) as [''+ExportColumnName+''] ''
		+ ''from NRC_Datamart.dbo.Samplepopulationbackgroundfield ''
		+ ''where ''+SourceColumnName+'') datesub ''
		+ ''on sp.SamplePopulationID=datesub.SamplePopulationID'' + char(10)
	 , @sqlWhere = @sqlWhere + ''and datesub.[''+ExportColumnName+''] between ''''''+convert(varchar,@exportStart)+'''''' and ''''''+convert(varchar,@exportEnd)+'''''''' + char(10)
	 , @sqlSelect = @sqlSelect + '', convert(varchar,[''+ExportColumnName+''],112)'' + char(10)
	 , @sqlinsert = @sqlinsert + '', [''+ExportTemplateSectionName+''.''+ExportColumnName+'']'' + char(10)
	from (select distinct ExportColumnName, SourceColumnName, ExportTemplateSectionName, ExportTemplateColumnID from #allcolumns) ac
	where ExportTemplateColumnID=@ExportDateColumnID
	update #allcolumns set flag=1 where ExportTemplateColumnID=@ExportDateColumnID	
end

set @SQL = @sqlinsert + '') ''+@sqlSelect + @sqlFrom + @sqlWhere
print @sql
exec (@SQL)


set @SQL = ''''
select @SQL = @SQL + cmd + char(10)
from (	select distinct ''update r set [''+ExportTemplateSectionName+''.''+ExportColumnName+'']=bg.columnValue
		from #results r
		inner join NRC_Datamart.dbo.samplepopulationbackgroundfield bg on r.SamplePopulationID=bg.SamplePopulationID
		where bg.''+SourceColumnName as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=4) x
print @sql
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=4

set @SQL = ''''
select @SQL = @SQL + cmd + char(10)
from (	select distinct ''update r set [''+ExportTemplateSectionName+''.''+ExportColumnName+'']=rb.ResponseValue
		from #results r
		inner join ResponseBubble rb on r.QuestionFormID=rb.QuestionFormID
		where rb.''+SourceColumnName as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=2
		and ExportColumnName is not null) x
print @sql
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=2 and ExportColumnName is not null


set @SQL = ''''
select @SQL = @SQL + cmd + char(10)
from (	select distinct ''update r set [''+ExportTemplateSectionName+''.''+ExportColumnNameMR+'']=''+convert(varchar,RecodeValue)+''
		from #results r
		inner join ResponseBubble rb on r.QuestionFormID=rb.QuestionFormID
		where rb.''+SourceColumnName+''
		and rb.ResponseValue=''+convert(varchar,RawValue) as cmd
		from #allcolumns 
		where flag=0
		and AggregateFunction is null
		and DataSourceID=2
		and ExportColumnNameMR is not null
		and RawValue <> -9) x
print @sql
exec (@sql)
update #allcolumns set flag=1 where flag=0 and AggregateFunction is null and DataSourceID=2 and ExportColumnNameMR is not null

-- declare @sql varchar(max), @sqlfrom varchar(max)
declare @sectname varchar(200), @colname varchar(200)
select @sql = DefaultNamingConvention, @sqlfrom=''''''''+DefaultNamingConvention+''''''''
from cem.ExportTemplate 
where ExportTemplateID=@ExportTemplateID

while charindex(''{'',@SQL) > 1
begin
	--declare @SQL varchar(max) = ''ICH_{header.facility-id}_{header.survey-yr}_{header.sem-survey}'', @sqlfrom varchar(max), @colname varchar(200)
	set @colname = substring(@SQL, 1 + charindex(''{'', @SQL),  charindex(''}'', @SQL) - charindex(''{'', @SQL) - 1)
	set @sqlfrom = replace(@sqlfrom,@sqlfrom,''replace(''+@sqlfrom+'',''''{''+@colname+''}'''',[''+@colname+''])'')
	set @sql = replace(@sql,''{''+@colname+''}'','''')
end
set @sql = ''update #results set FileMakerName=''+@sqlfrom
print @sql
exec (@sql)

set @sql = ''''
select @sql = @sql + ''update r set [''+ExportTemplateSectionName+''.''+ExportColumnName+'']=sub.Agg
	from #results r
	inner join (select FileMakerName, ''+rtrim(AggregateFunction)+''(''+
		case when SourceColumnType in (40,61) then ''convert(varchar,'' else '''' end+
		TableAlias+''.''+SourceColumnName+case when SourceColumnType in (40,61) then '',112)'' else '''' end+'') as Agg
		from #results r 
		inner join ''+TableName+'' ''+TableAlias+'' on r.''+TableName+''id=''+TableAlias+''.''+TableName+''id
		group by FileMakerName) sub
		on r.FileMakerName=sub.FileMakerName'' + char(10)
from #allcolumns
where flag=0
and ExportColumnName is not null
and AggregateFunction is not null

set @sql = replace(@sql,''count distinct('',''count(distinct '')

print @SQL
exec (@SQL)

update #allcolumns set flag=1
where flag=0
and ExportColumnName is not null
and AggregateFunction is not null

if exists (select * from #allcolumns where flag=0)
begin
	print ''One or more columns were not processed. Aborting.''
	set @sql=''''
	select @SQL = @SQL + msg + '', ''
	from (	select isnull(ExportColumnName,ExportColumnNameMR) as msg
			from #allcolumns
			where flag=0) x

	insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
	select getdate() as EventDateTime
		, ''Error'' as EventLevel
		, system_user as UserName
		, host_name() as MachineName
		, '''' as EventType
		, ''One or more columns were not processed.'' as EventMessage
		, ''[CEM].[PullExportData] @ExportQueueID='' + convert(varchar,@ExportQueueID) as EventSource
		, ''Stored Procedure'' as EventClass
		, '''' as EventMethod
		, ''The procedure doesn''''t know how to handle the following columns: ''+@sql as ErrorMessage
	return --1
end

if @doRecode=1
begin
	if object_id(''tempdb..#recodes'') is not null
		drop table #recodes

	-- use a cartesian join to populate all the default recoding that should happen across all columns
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnName, isnull(convert(varchar,d.RawValue),'''') as RawValue, d.RecodeValue
	into #recodes
	from #allcolumns ac, [CEM].[ExportTemplateDefaultResponse] d
	where ExportColumnName is not null and ac.RecodeValue is not null

	-- update #recodes with any column-specific recodes that override the default behavior
	update #allColumns set flag=0
	update r set RecodeValue=ac.RecodeValue
	from #recodes r
	inner join #allcolumns ac on r.ExportTemplateSectionName=ac.ExportTemplateSectionName and r.ExportColumnName = ac.ExportColumnName and r.RawValue=convert(varchar,ac.RawValue)

	update #allColumns set flag=1
	from #recodes r
	inner join #allcolumns ac on r.ExportTemplateSectionName=ac.ExportTemplateSectionName and r.ExportColumnName = ac.ExportColumnName and r.RawValue=convert(varchar,ac.RawValue)

	-- add column specific recodes to #recodes
	insert into #recodes
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnName, isnull(ac.RawValue,''''), ac.RecodeValue
	from #allcolumns ac
	where ExportColumnName is not null and ac.RecodeValue is not null and flag=0 

	-- execute the recodes
	-- declare @sql varchar(max), @sectname varchar(200), @colname varchar(200)
	select top 1 @sectname=ExportTemplateSectionName, @colname=ExportColumnName from #recodes 
	while @@rowcount>0
	begin
		-- char(7) is used as a flag for "out-of-range"
		set @SQL = ''update R
				set [''+@sectname+''.''+@colname+'']=isnull(RecodeValue,char(7))
				from #results R
				left join (select RawValue, RecodeValue from #recodes where ExportTemplateSectionName=''''''+@sectname+'''''' and ExportColumnName=''''''+@colname+'''''') rc
					on r.[''+@sectname+''.''+@colname+'']=rc.RawValue''
		print @SQL
		exec (@SQL)

		delete from #recodes where ExportTemplateSectionName=@sectname and ExportColumnName=@colname
		select top 1 @sectname=ExportTemplateSectionName, @colname=ExportColumnName from #recodes 
	end


	-- declare @sql varchar(max), @sqlwhere varchar(max)
	insert into #recodes
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, ExportColumnNameMR, isnull(ac.RawValue,''''), ac.RecodeValue
	from #allcolumns ac
	where ExportColumnNameMR is not null 

	declare @etcID int, @notAnsweredCode varchar(200)
	select top 1 @etcID=ExportTemplateColumnID, @notAnsweredCode=RecodeValue from #recodes where RawValue=-9
	while @@rowcount>0
	begin
		select @SQLwhere = '''', @sql=''''
		select @sqlwhere=@sqlwhere + ''[''+ExportTemplateSectionName+''.''+ExportColumnName+'']+''
		from #recodes
		where ExportTemplateColumnID = @etcID
		and ExportColumnName <> ''unmarked''
		set @sqlwhere = left(@sqlwhere,len(@sqlwhere)-1)
		
		select @sql=@sql + ''update #results set [''+ExportTemplateSectionName+''.''+ExportColumnName+'']=''''''+@notAnsweredCode+'''''' where len(''+@sqlwhere+'')>0 and [''+ExportTemplateSectionName+''.''+ExportColumnName+'']<>''''''+RecodeValue+'''''''' + char(10) 
		from #recodes
		where ExportTemplateColumnID = @etcID
		and ExportColumnName <> ''unmarked''
		
		exec (@SQL)
		
		delete from #recodes where ExportTemplateColumnID = @etcID
		select top 1 @etcID=ExportTemplateColumnID, @notAnsweredCode=RecodeValue from #recodes where RawValue=-9
	end
end /* @doRecode=1 */

if @doDispositionProc=1
begin
	if object_id(''tempdb..#disproc'') is not null
		drop table #disproc

	select distinct dp.DispositionProcessID, dp.RecodeValue, dc.DispositionClauseID, dc.DispositionPhraseKey, ''[''+ac.ExportTemplateSectionName+''.''+isnull(ExportColumnName,ExportColumnNameMR)+''] ''+o.strOperator+'' ''
		+replace(replace(o.strLogic,''%strLowValue%'',isnull(LowValue,'''')),''%strHighValue%'',isnull(HighValue,'''')) as strWhere
	into #disproc
	from CEM.DispositionProcess dp
	inner join CEM.DispositionClause dc on dp.DispositionProcessID=dc.DispositionProcessID
	inner join #allcolumns ac on dc.[ExportTemplateColumnID]=ac.[ExportTemplateColumnID]
	inner join CEM.Operator o on dc.OperatorID=o.OperatorID

	-- declare @sql varchar(max)
	declare @dpid int, @dcid int, @dpk int 

	select top 1 @dcid = DispositionClauseID from #disproc where strWhere like ''%[%]inlist[%]%''
	while @@rowcount>0 
	begin
		set @sql = ''(''
		select @sql = @sql + '''''''' + ListValue + '''''',''	
		from #disproc dc
		inner join CEM.dispositioninlist dil on dc.DispositionClauseID=dil.DispositionClauseID
		where dc.DispositionClauseID=@dcid
		
		set @sql = left(@sql,len(@sql)-1)+'')''
		
		update #disproc set strwhere = replace(strWhere, ''%inlist%'', @sql) where DispositionClauseID=@dcid
		select top 1 @dcid = DispositionClauseID from #disproc where strWhere like ''%[%]inlist[%]%''
	end

	-- declare @sql varchar(max), @dpid int, @dpk int, @dcid int 
	while exists (select 1 from #disproc group by DispositionProcessID, DispositionPhraseKey having count(*)>1)
	begin
		select top 1 @dpid=DispositionProcessID, @dcid=min(DispositionClauseID), @dpk=DispositionPhraseKey 
		from #disproc 
		group by DispositionProcessID, DispositionPhraseKey  
		having count(*)>1
		
		set @SQL = ''''
		select @sql=@sql+strWhere + '' and ''
		from #disproc
		where DispositionProcessID = @dpid 
		and DispositionPhraseKey = @dpk
		
		set @sql = left(@sql,len(@sql)-4)
		
		delete from #disproc where DispositionProcessID = @dpid and DispositionPhraseKey=@dpk and DispositionClauseID <> @dcid
		update #disproc set strWhere = @sql where DispositionProcessID = @dpid and DispositionPhraseKey=@dpk 
	end

	-- declare @sql varchar(max), @dpid int, @dpk int, @dcid int 
	while exists (select DispositionProcessID from #disproc group by DispositionProcessID having count(*)>1)
	begin
		select top 1 @dpid = DispositionProcessID, @dcid=min(DispositionClauseID) from #disproc group by DispositionProcessID having count(*)>1
		
		set @SQL = ''''
		select @sql=@sql+''(''+strWhere + '') or ''
		from #disproc
		where DispositionProcessID = @dpid 
		
		set @sql = left(@sql,len(@sql)-3)
		
		delete from #disproc where DispositionProcessID = @dpid and DispositionClauseID <> @dcid
		update #disproc set strWhere = @sql where DispositionProcessID = @dpid 
	end

	select top 1 @dpid=DispositionProcessID from #disproc
	while @@rowcount>0
	begin
		set @sql = ''update #results set ''
		select @sql = @sql + char(10) + ''['' + ac.ExportTemplateSectionName + ''.'' + ac.ExportColumnName+''] = '''''' + replicate(dc.RecodeValue,ac.FixedWidthLength) + '''''','' 
		from (	select distinct DispositionProcessID,ExportTemplateSectionName,isnull(ExportColumnNameMR,ExportColumnName) as ExportColumnName,FixedWidthLength 
				from #allcolumns
				where isnull(ExportColumnNameMR,'''') <> ''unmarked'') ac
		inner join #disproc dc on ac.DispositionProcessID=dc.DispositionProcessID
		where ac.DispositionProcessID=@dpid
		
		select @sql = left(@sql,len(@sql)-1) + '' where '' + strWhere
		from #disproc
		where DispositionProcessID=@dpid
		
		print @SQL
		exec (@SQL)

		delete from #disproc where DispositionProcessID=@dpid
		select top 1 @dpid=DispositionProcessID from #disproc
	end
end /* @doDispositionProc=1 */

if @doRecode=1 and @doDispositionProc=1
begin
	-- move recoded results into permanent table
	-- declare @sql varchar(max), @ExportTemplateID int=1
	set @sql = ''''
	select @sql = @sql + '',[''+ExportTemplateSectionName+''.''+ExportColumnName+'']''
	from (select distinct ExportTemplateSectionName,isnull(ExportColumnName,ExportColumnNameMR) as ExportColumnName from #allcolumns where isnull(ExportColumnNameMR,'''') <> ''unmarked'') x

	print ''insert into CEM.ExportDataset''+right(convert(varchar,100000000+@ExportTemplateID),8)+'' (ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName'' + @sql + '')''
	print ''select ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName''+@sql
	print ''from #results''
	
	set @sql = ''insert into CEM.ExportDataset''+right(convert(varchar,100000000+@ExportTemplateID),8)+'' (ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName'' + @sql + '')
	select ExportqueueID, ExportTemplateID, SamplePopulationID, QuestionFormID, FileMakerName''+@sql+''
	from #results''

	exec (@SQL)

	if @doPostProcess=1
		AND exists (SELECT * 
					FROM  sys.schemas ss 
						  INNER JOIN sys.procedures sp ON ss.schema_id = sp.schema_id 
					WHERE ss.NAME = ''CEM'' 
						  AND sp.NAME = ''ExportPostProcess'' + RIGHT(CONVERT(VARCHAR, 100000000+@ExportTemplateID), 8) )
	begin
		set @SQL = ''exec CEM.ExportPostProcess''+right(convert(varchar,100000000+@ExportTemplateID),8) + '' '' + convert(varchar,@ExportQueueID)
		begin try
			exec (@SQL)
		end try
		begin catch
			print ''error running ExportPostProcess''
			insert into [CEM].[Logs] (EventDateTime, EventLevel, UserName, MachineName, EventType, EventMessage, EventSource, EventClass, EventMethod, ErrorMessage)
			select getdate() as EventDateTime
				, ''Error'' as EventLevel
				, system_user as UserName
				, host_name() as MachineName
				, '''' as EventType
				, ''Export post process failed'' as EventMessage
				, ''[CEM].[PullExportData] @ExportQueueID='' + convert(varchar,@ExportQueueID) as EventSource
				, ''Stored Procedure'' as EventClass
				, '''' as EventMethod
				, @sql as ErrorMessage			
			return --1
		end catch
		
	end

	update CEM.ExportQueue 
	set PullDate=getdate()
	where ExportQueueID=@ExportQueueID
end

drop table #allcolumns
if object_id(''tempdb..#recodes'') is not null 
	drop table #recodes
if object_id(''tempdb..#disproc'') is not null 
	drop table #disproc

end
' 
END
GO
/****** Object:  StoredProcedure [CEM].[InsertExportQueueFile] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[InsertExportQueueFile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectTemplateSection] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectTemplateSection]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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

' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectTemplate] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectTemplate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
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
' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectSystemParams] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectSystemParams]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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

' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectExportTemplateColumnResponse] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportTemplateColumnResponse]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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

' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectExportTemplateColumn] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportTemplateColumn]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectExportQueueFile] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportQueueFile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectExportQueue] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportQueue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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
' 
END
GO
/****** Object:  StoredProcedure [CEM].[SelectExportData] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[SelectExportData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
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

	declare @tablename varchar(25) = N''CEM.ExportDataset'' + REPLICATE(''0'', 8 - LEN(CAST(@ExportTemplateID as varchar))) + CAST(@ExportTemplateID as varchar)

	create table #Columns (ExportTemplateColumnID int, ExportColumnName char(200))

	insert into #Columns (ExportTemplateColumnID,ExportColumnName)
	select distinct etc.ExportTemplateColumnID
	,@sectionname + ''.'' + ISNULL(etc.ExportColumnName, etcr.ExportColumnName)
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
		SET @columnlist = ''[SamplePopulationID],''
	ELSE SET @columnlist = ''''

	select top 1 @ExportTemplateColumnID=ExportTemplateColumnID, @ExportColumnName=ExportColumnName from #Columns
	while @@rowcount>0
	begin
		-- Check to see if the column is in the table. If not, skip it.
		if exists(select * from sys.columns 
            where Name = LTRIM(RTRIM(@ExportColumnName)) and Object_ID = Object_ID(@tablename))
		begin
			SET @columnlist = @columnlist + ''['' + LTRIM(RTRIM(@ExportColumnName)) + ''],''
		end
		else
		begin
			SET @columnlist = @columnlist + ''NULL ['' + LTRIM(RTRIM(@ExportColumnName)) + ''],''
		end
		
		delete from #Columns where ExportColumnName=@ExportColumnName
		select top 1 @ExportTemplateColumnID=ExportTemplateColumnID, @ExportColumnName=ExportColumnName from #Columns
	end
	
	Set @sqlCommand = ''SELECT distinct '' + @columnlist + '''''' '''''' + '' from '' + @tableName + '' WHERE ExportQueueID = '' + CAST(@ExportQueueID as varchar) + '' AND FileMakerName = '''''' + @FileMakerName + ''''''''
	 
	exec sp_executesql  @sqlCommand

	drop table #Columns


END
' 
END
GO
/****** Object:  StoredProcedure [CEM].[ExportPostProcess00000001] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CEM].[ExportPostProcess00000001]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [CEM].[ExportPostProcess00000001]
@ExportQueueID int
as
update CEM.ExportDataset00000001
set [patientresponse.race-white-phone]=''M'', [patientresponse.race-african-amer-phone]=''M'', [patientresponse.race-amer-indian-phone]=''M'', [patientresponse.race-asian-phone]=''M'', 
	[patientresponse.race-nativehawaiian-pacific-phone]=''M'', [patientresponse.race-noneofabove-phone]=''M'' 
where len([patientresponse.race-white-phone]+[patientresponse.race-african-amer-phone]+[patientresponse.race-amer-indian-phone]+[patientresponse.race-asian-phone]
	+[patientresponse.race-nativehawaiian-pacific-phone]+[patientresponse.race-noneofabove-phone])=0
and [administration.final-status] in (''110'',''120'',''130'',''140'',''150'',''160'',''190'',''199'',''210'')
and [administration.survey-mode]<>''X''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.race-asian-indian-phone]=''M'', [patientresponse.race-chinese-phone]=''M'', [patientresponse.race-filipino-phone]=''M'', [patientresponse.race-japanese-phone]=''M'', 
	[patientresponse.race-korean-phone]=''M'', [patientresponse.race-vietnamese-phone]=''M'', [patientresponse.race-otherasian-phone]=''M'', [patientresponse.race-noneofabove-asian-phone]=''M''
where len([patientresponse.race-asian-indian-phone]+[patientresponse.race-chinese-phone]+[patientresponse.race-filipino-phone]+[patientresponse.race-japanese-phone]
	+[patientresponse.race-korean-phone]+[patientresponse.race-vietnamese-phone]+[patientresponse.race-otherasian-phone]+[patientresponse.race-noneofabove-asian-phone])=0
and [administration.final-status] in (''110'',''120'',''130'',''140'',''150'',''160'',''190'',''199'',''210'')
and [administration.survey-mode]<>''X''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.race-nativehawaiian-phone]=''M'', [patientresponse.race-guam-chamarro-phone]=''M'', [patientresponse.race-samoan-phone]=''M'', [patientresponse.race-otherpacificislander-phone]=''M'',
	[patientresponse.race-noneofabove-pacific-phone]=''M''
where len([patientresponse.race-nativehawaiian-phone]+[patientresponse.race-guam-chamarro-phone]+[patientresponse.race-samoan-phone]+[patientresponse.race-otherpacificislander-phone]
	+[patientresponse.race-noneofabove-pacific-phone])=0
and [administration.final-status] in (''110'',''120'',''130'',''140'',''150'',''160'',''190'',''199'',''210'')
and [administration.survey-mode]<>''X''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.race-white-mail]=''M'', [patientresponse.race-african-amer-mail]=''M'', [patientresponse.race-amer-indian-mail]=''M'', [patientresponse.race-asian-indian-mail]=''M'', 
	[patientresponse.race-chinese-mail]=''M'', [patientresponse.race-filipino-mail]=''M'', [patientresponse.race-japanese-mail]=''M'', [patientresponse.race-korean-mail]=''M'', 
	[patientresponse.race-vietnamese-mail]=''M'', [patientresponse.race-otherasian-mail]=''M'', [patientresponse.race-nativehawaiian-mail]=''M'', [patientresponse.race-guamanian-chamorro-mail]=''M'', 
	[patientresponse.race-samoan-mail]=''M'', [patientresponse.race-other-pacificislander-mail]=''M''
where len([patientresponse.race-white-mail]+[patientresponse.race-african-amer-mail]+[patientresponse.race-amer-indian-mail]+[patientresponse.race-asian-indian-mail]
	+[patientresponse.race-chinese-mail]+[patientresponse.race-filipino-mail]+[patientresponse.race-japanese-mail]+[patientresponse.race-korean-mail]+[patientresponse.race-vietnamese-mail]
	+[patientresponse.race-otherasian-mail]+[patientresponse.race-nativehawaiian-mail]+[patientresponse.race-guamanian-chamorro-mail]+[patientresponse.race-samoan-mail]
	+[patientresponse.race-other-pacificislander-mail])=0
and [administration.final-status] in (''110'',''120'',''130'',''140'',''150'',''160'',''190'',''199'',''210'')
and [administration.survey-mode]<>''X''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [patientresponse.help-answer]=''M'', [patientresponse.help-other]=''M'', [patientresponse.help-read]=''M'', [patientresponse.help-translate]=''M'', [patientresponse.help-wrote]=''M''
where len([patientresponse.help-answer]+[patientresponse.help-other]+[patientresponse.help-read]+[patientresponse.help-translate]+[patientresponse.help-wrote])=0
and [administration.final-status] in (''110'',''120'',''130'',''140'',''150'',''160'',''190'',''199'',''210'')
and [administration.survey-mode]<>''X''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [header.dcstart-date]=''20141017''
where [header.dcstart-date]=''''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000001
set [header.dcend-date]=''20150110''
where [header.dcend-date]=''''
and ExportQueueID=@ExportQueueID
' 
END
GO
use nrc_datamart
go
exec sp_rename 'cem.System_Params', 'System_Params_'
exec sp_rename 'cem.ExportDataset00000001', 'ExportDataset00000001_'
exec sp_rename 'cem.datasource_', 'Datasource_'
exec sp_rename 'cem.ExportTemplate', 'ExportTemplate_'
exec sp_rename 'cem.ExportTemplateSection', 'ExportTemplateSection_'
exec sp_rename 'cem.ExportTemplateDefaultResponse', 'ExportTemplateDefaultResponse_'
exec sp_rename 'cem.ExportTemplateColumn', 'ExportTemplateColumn_'
exec sp_rename 'cem.ExportTemplateColumnResponse', 'ExportTemplateColumnResponse_'
exec sp_rename 'cem.DispositionProcess', 'DispositionProcess_'
exec sp_rename 'cem.Logs', 'Logs_'
exec sp_rename 'cem.DispositionClause', 'DispositionClause_'
exec sp_rename 'cem.DispositionInList', 'DispositionInList_'
exec sp_rename 'cem.ExportQueue', 'ExportQueue_'
exec sp_rename 'cem.ExportQueueFile', 'ExportQueueFile_'
exec sp_rename 'cem.ExportQueueSurvey', 'ExportQueueSurvey_'
exec sp_rename 'cem.ExportNotification', 'ExportNotification_'
exec sp_rename 'cem.ExportNotificationType', 'ExportNotificationType_'
exec sp_rename 'cem.Operator', 'Operator_'