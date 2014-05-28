CREATE TABLE [dbo].[rollbacks](
	[rollback_id] [int] IDENTITY(1,1) NOT NULL,
	[survey_id] [int] NULL,
	[study_id] [int] NULL,
	[datrollback_dt] [datetime] NULL,
	[rollbacktype] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cnt] [int] NULL,
	[datSampleCreate_dt] [datetime] NULL,
	[MailingStep_id] [int] NULL
) ON [PRIMARY]


