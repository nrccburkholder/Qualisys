CREATE TABLE [dbo].[ReturnRates](
	[Survey_id] [int] NULL,
	[Days] [int] NULL,
	[TotalOutgo] [int] NULL,
	[FirstSurvey] [bit] NULL,
	[Returned] [int] NULL,
	[PercentReturned]  AS ([Returned] / ([TotalOutgo] * 1.0))
) ON [PRIMARY]


