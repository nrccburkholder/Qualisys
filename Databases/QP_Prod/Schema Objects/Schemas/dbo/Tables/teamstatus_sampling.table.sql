CREATE TABLE [dbo].[teamstatus_sampling](
	[AD] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_ID] [int] NULL,
	[Survey] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey_ID] [int] NULL,
	[strMailFreq] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intSamplesInPeriod] [int] NULL,
	[DateNewPeriod] [datetime] NULL,
	[SampledThisPeriod] [int] NULL,
	[ShouldhaveSampled] [int] NULL,
	[RemainingSamples] [int] NULL,
	[LastSample] [datetime] NULL
) ON [PRIMARY]


