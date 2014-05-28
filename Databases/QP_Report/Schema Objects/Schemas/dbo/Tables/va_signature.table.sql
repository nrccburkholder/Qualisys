CREATE TABLE [dbo].[va_signature](
	[SENTMAIL_ID] [int] NOT NULL,
	[SCHEDULEDMAILING_ID] [int] NULL,
	[DATGENERATED] [datetime] NULL,
	[DATPRINTED] [datetime] NULL,
	[DATMAILED] [datetime] NULL,
	[METHODOLOGY_ID] [int] NULL,
	[PAPERCONFIG_ID] [int] NULL,
	[STRLITHOCODE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRPOSTALBUNDLE] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INTPAGES] [int] NULL,
	[DATUNDELIVERABLE] [datetime] NULL,
	[INTRESPONSESHAPE] [int] NULL,
	[STRGROUPDEST] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datDeleted] [datetime] NULL,
	[datBundled] [datetime] NULL,
	[intReprinted] [int] NULL,
	[datReprinted] [datetime] NULL,
	[LangID] [int] NULL,
	[datExpire] [datetime] NULL,
	[samplepop_id] [int] NULL,
	[mailingstep_id] [int] NULL
) ON [PRIMARY]


