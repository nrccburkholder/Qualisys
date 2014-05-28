CREATE TABLE [dbo].[bad_qstns_individual](
	[IndivQstns_id] [int] NULL,
	[SelQstns_id] [int] NULL,
	[Survey_id] [int] NULL,
	[QuestionForm_id] [int] NULL,
	[Language] [int] NULL,
	[SampleUnit_id] [int] NULL,
	[RichText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScaleID] [int] NULL,
	[SamplePop_id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


