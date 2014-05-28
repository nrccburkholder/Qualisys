CREATE TABLE [dbo].[ss_pclgenlog](
	[PCLGENLOG_ID] [int] NOT NULL,
	[PCLGENRUN_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NULL,
	[SENTMAIL_ID] [int] NULL,
	[LOGENTRY] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DATLOGGED] [datetime] NOT NULL
) ON [PRIMARY]


