CREATE TABLE [dbo].[TeamStatus_SampleInfo](
	[AD] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProjectNum] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey_id] [int] NULL,
	[FirstApply] [datetime] NULL,
	[SampleSet_id] [int] NULL,
	[SampleDate] [datetime] NULL,
	[MailFrequency] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SamplesInPeriod] [int] NULL,
	[SamplesPulled] [int] NULL,
	[RolledBack] [bit] NULL DEFAULT (0),
	[TotalRolledback] [int] NULL CONSTRAINT [DF_TeamStatus_SampleInfo_TotalRolledback]  DEFAULT (0)
) ON [PRIMARY]


