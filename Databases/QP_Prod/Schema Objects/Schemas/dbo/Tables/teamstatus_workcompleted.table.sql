CREATE TABLE [dbo].[teamstatus_workcompleted](
	[dummy_id] [int] NULL,
	[AcctDir] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientID] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StudyID] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurveyID] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProjectNumber] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailFrequency] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContractStart] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContractEnd] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sampled] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SampleSet] [int] NULL,
	[SampleDate] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dummy_Step] [int] NULL,
	[MailingStep] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Scheduled] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenDate] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Generated] [int] NULL,
	[PrintDate] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Printed] [int] NULL,
	[MailDate] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Mailed] [int] NULL
) ON [PRIMARY]


