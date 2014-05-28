CREATE TABLE [dbo].[yyy_SampleUnitResult](
	[Survey_ID] [int] NOT NULL,
	[Period_ID] [tinyint] NOT NULL,
	[SampleUnit_ID] [int] NOT NULL,
	[datDateRange_FromDate] [datetime] NULL,
	[datDateRange_ToDate] [datetime] NULL,
	[ParentSampleUnit_ID] [int] NULL,
	[Tier] [tinyint] NULL,
	[TreeOrder] [smallint] NULL,
	[Target] [int] NULL,
	[KidTarget] [int] NULL,
	[Sampled] [int] NULL,
	[Undel] [int] NULL,
	[Returned] [int] NULL
) ON [PRIMARY]


