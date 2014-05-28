CREATE TABLE [dbo].[WebSurveyQueue](
	[Survey_id] [int] NULL,
	[BarCode]  AS ([dbo].[LithoToWAC]([Litho])),
	[Litho] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitPopulatedValues] [bit] NULL,
	[bitProcessed] [bit] NULL
) ON [PRIMARY]


