CREATE TABLE [dbo].[teamstatus_scheduledwork](
	[Client] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_id] [int] NULL,
	[Survey] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurveyID] [int] NULL,
	[SampleSet] [int] NULL,
	[MailingStep] [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Methodology] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dategenerate] [datetime] NULL,
	[Cnt] [int] NULL
) ON [PRIMARY]


