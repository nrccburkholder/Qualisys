CREATE TABLE [dbo].[jf_ExpireProblem](
	[SENTMAIL_ID] [int] NOT NULL,
	[SCHEDULEDMAILING_ID] [int] NULL,
	[DATGENERATED] [datetime] NULL,
	[DATPRINTED] [datetime] NULL,
	[DATMAILED] [datetime] NULL,
	[STRLITHOCODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRPOSTALBUNDLE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DATUNDELIVERABLE] [datetime] NULL,
	[datDeleted] [datetime] NULL,
	[datBundled] [datetime] NULL,
	[LangID] [int] NULL,
	[datExpire] [datetime] NULL,
	[QUESTIONFORM_ID] [int] NOT NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[DATRETURNED] [datetime] NULL,
	[SURVEY_ID] [int] NULL,
	[UnusedReturn_id] [int] NULL,
	[datUnusedReturn] [datetime] NULL,
	[datResultsImported] [datetime] NULL,
	[bitComplete] [bit] NULL,
	[ReceiptType_id] [int] NULL
) ON [PRIMARY]


