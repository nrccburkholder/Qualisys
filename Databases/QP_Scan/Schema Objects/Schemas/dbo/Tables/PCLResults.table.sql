CREATE TABLE [dbo].[PCLResults](
	[QuestionForm_id] [int] NOT NULL,
	[PCLResults_id] [int] NOT NULL,
	[QstnCore] [int] NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[Height] [int] NULL,
	[Width] [int] NULL,
	[PageNum] [int] NULL,
	[Side] [int] NULL,
	[Sheet] [int] NULL,
	[SelQstns_id] [int] NULL,
	[BegColumn] [int] NULL,
	[ReadMethod] [int] NULL,
	[intRespCol] [int] NULL,
	[SampleUnit_id] [int] NULL,
 CONSTRAINT [PK_PCLResults] PRIMARY KEY NONCLUSTERED 
(
	[QuestionForm_id] ASC,
	[PCLResults_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [PX_PCLResults] UNIQUE CLUSTERED 
(
	[QuestionForm_id] ASC,
	[PCLResults_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


