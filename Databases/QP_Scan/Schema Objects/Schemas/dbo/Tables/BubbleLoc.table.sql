CREATE TABLE [dbo].[BubbleLoc](
	[QuestionForm_id] [int] NOT NULL,
	[SelQstns_id] [int] NOT NULL,
	[Item] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[CharSet] [int] NULL,
	[Val] [int] NULL,
	[intRespType] [int] NULL,
	[RelX] [int] NULL,
	[RelY] [int] NULL,
 CONSTRAINT [PK_BubbleLoc] PRIMARY KEY NONCLUSTERED 
(
	[QuestionForm_id] ASC,
	[SelQstns_id] ASC,
	[Item] ASC,
	[SampleUnit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


