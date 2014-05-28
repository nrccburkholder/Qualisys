CREATE TABLE [dbo].[HandWrittenPos](
	[QuestionForm_id] [int] NOT NULL,
	[intPage_num] [tinyint] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[Item] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[Line_id] [tinyint] NOT NULL,
	[X_Pos] [smallint] NOT NULL,
	[Y_Pos] [smallint] NOT NULL,
	[intWidth] [smallint] NOT NULL,
 CONSTRAINT [PK_HandWrittenPos] PRIMARY KEY CLUSTERED 
(
	[QuestionForm_id] ASC,
	[intPage_num] ASC,
	[QstnCore] ASC,
	[Item] ASC,
	[SampleUnit_id] ASC,
	[Line_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


