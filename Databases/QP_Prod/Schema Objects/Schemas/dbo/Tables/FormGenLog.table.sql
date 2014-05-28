CREATE TABLE [dbo].[FormGenLog](
	[FormGenLog_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NULL,
	[strSampleSurvey_nm] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datSampleCreate_dt] [datetime] NULL,
	[MailingStep_id] [int] NULL,
	[intSequence] [int] NULL,
	[datGenerated] [datetime] NULL,
	[Quantity] [int] NULL
) ON [PRIMARY]


