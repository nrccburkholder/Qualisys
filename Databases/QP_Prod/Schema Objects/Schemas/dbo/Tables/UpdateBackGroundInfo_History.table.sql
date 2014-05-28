CREATE TABLE [dbo].[UpdateBackGroundInfo_History](
	[Study_id] [int] NULL,
	[Pop_id] [int] NULL,
	[SamplePop_id] [int] NULL,
	[strSetClause] [varchar](7800) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datScheduled] [datetime] NULL,
	[Attempted] [bit] NULL DEFAULT ((0))
) ON [PRIMARY]


