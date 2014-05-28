CREATE TABLE [dbo].[NrcNorm](
	[Client_ID] [int] NOT NULL,
	[Study_ID] [int] NOT NULL,
	[Survey_ID] [int] NOT NULL,
	[SampleUnit_ID] [int] NOT NULL,
	[datReturned] [datetime] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[ScaleID] [int] NOT NULL,
	[Val] [int] NOT NULL,
	[Count] [int] NOT NULL
) ON [PRIMARY]


