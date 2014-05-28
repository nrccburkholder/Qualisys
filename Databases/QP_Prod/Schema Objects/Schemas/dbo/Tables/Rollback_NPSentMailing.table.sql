CREATE TABLE [dbo].[Rollback_NPSentMailing](
	[Rollback_id] [int] NOT NULL,
	[SENTMAIL_ID] [int] NULL,
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
	[STRGROUPDEST] [char](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datDeleted] [datetime] NULL,
	[datBundled] [datetime] NULL,
	[intReprinted] [int] NOT NULL,
	[datReprinted] [datetime] NULL
) ON [PRIMARY]


