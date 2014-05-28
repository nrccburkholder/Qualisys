CREATE TABLE [dbo].[PeriodDates](
	[PeriodDef_id] [int] NOT NULL,
	[SampleNumber] [int] NOT NULL,
	[datScheduledSample_dt] [datetime] NOT NULL,
	[SampleSet_id] [int] NULL,
	[datSampleCreate_dt] [datetime] NULL,
 CONSTRAINT [PK_PeriodDates] PRIMARY KEY CLUSTERED 
(
	[PeriodDef_id] ASC,
	[SampleNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


