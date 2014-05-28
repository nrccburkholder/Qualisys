CREATE TABLE [dbo].[GHS_MailMergeLog](
	[Job_ID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorCode] [smallint] NOT NULL DEFAULT (0),
	[Template_ID] [int] NOT NULL DEFAULT (0),
	[Project_ID] [int] NOT NULL DEFAULT (0),
	[Faqss_ID] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
	[MailStep] [tinyint] NOT NULL DEFAULT (0),
	[PaperConfig_ID] [int] NOT NULL DEFAULT (0),
	[PaperSize_ID] [int] NOT NULL DEFAULT (0),
	[SurveyDataDirectory] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
	[MainDocDirectory] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
	[OutputDirectory] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
	[ArchiveDirectory] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
	[TotalRecNum] [int] NOT NULL DEFAULT (0),
	[MergedRecNum] [int] NOT NULL DEFAULT (0),
	[SubJobNum] [smallint] NOT NULL DEFAULT (0),
	[PrinterName] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL DEFAULT (''),
	[SaveMergedDoc] [bit] NOT NULL DEFAULT (1),
	[IsAllMergedDocSaved] [bit] NOT NULL DEFAULT (1),
	[DateRun] [datetime] NOT NULL DEFAULT (getdate()),
	[DateLogged] [datetime] NOT NULL DEFAULT (getdate()),
	[strNTLogin_NM] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Job_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


