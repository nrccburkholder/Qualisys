CREATE TABLE [dbo].[AcctOutgo](
	[Outgo_id] [int] IDENTITY(1,1) NOT NULL,
	[Month] [int] NULL,
	[Year] [int] NULL,
	[Client_id] [int] NULL,
	[Study_id] [int] NULL,
	[Survey_id] [int] NULL,
	[SampleSurvey_nm] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SampleCreate_dt] [datetime] NULL,
	[Mailingstep] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sequence] [int] NULL,
	[total] [int] NULL
) ON [PRIMARY]


