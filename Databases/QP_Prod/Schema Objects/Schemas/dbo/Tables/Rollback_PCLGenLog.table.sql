CREATE TABLE [dbo].[Rollback_PCLGenLog](
	[Rollback_id] [int] NOT NULL,
	[PCLGENLOG_ID] [int] NULL,
	[PCLGENRUN_ID] [int] NULL,
	[SURVEY_ID] [int] NULL,
	[SENTMAIL_ID] [int] NULL,
	[LOGENTRY] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DATLOGGED] [datetime] NULL
) ON [PRIMARY]


