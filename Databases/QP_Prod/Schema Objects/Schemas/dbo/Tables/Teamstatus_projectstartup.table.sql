CREATE TABLE [dbo].[Teamstatus_projectstartup](
	[tswc_id] [int] NULL,
	[Client] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientID] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AcctDir] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StudyID] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurveyID] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProjectNumber] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[taskspec_id] [int] NULL,
	[PeriodMailFreq] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailFreqDays] [int] NULL,
	[SampleSetID] [int] NULL,
	[Effective_dt] [datetime] NULL,
	[TargetFirstMail_dt] [datetime] NULL,
	[FirstMail_dt] [datetime] NULL,
	[Project_Startup_Days] [int] NULL,
	[ExpectedSamples] [int] NULL
) ON [PRIMARY]


