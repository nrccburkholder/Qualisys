CREATE TABLE [dbo].[bm_Chart_SamplePop](
	[SampleUnit_ID] [int] NOT NULL,
	[SamplePop_ID] [int] NOT NULL,
	[DischargeDate] [datetime] NOT NULL,
	[datReturned] [datetime] NULL,
	[datMailed] [datetime] NULL,
	[HCAHPSValue] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


