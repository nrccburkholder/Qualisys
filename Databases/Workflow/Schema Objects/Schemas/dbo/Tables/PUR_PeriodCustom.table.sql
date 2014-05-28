CREATE TABLE [dbo].[PUR_PeriodCustom](
	[PUReport_ID] [int] NOT NULL,
	[Survey_ID] [int] NOT NULL,
	[Period_ID] [tinyint] NOT NULL,
	[SampleSet_ID] [int] NOT NULL,
 CONSTRAINT [PK_PUR_PeriodCustom] PRIMARY KEY CLUSTERED 
(
	[PUReport_ID] ASC,
	[Survey_ID] ASC,
	[Period_ID] ASC,
	[SampleSet_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


