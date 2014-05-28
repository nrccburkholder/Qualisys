CREATE TABLE [dbo].[HandWrittenPos](
	[QuestionForm_id] [int] NOT NULL,
	[intPage_num] [tinyint] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[Item] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[Line_id] [tinyint] NOT NULL,
	[X_Pos] [smallint] NOT NULL,
	[Y_Pos] [smallint] NOT NULL,
	[intWidth] [smallint] NOT NULL
) ON [PRIMARY]


