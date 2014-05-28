CREATE TABLE [dbo].[HandWrittenLoc](
	[QuestionForm_id] [int] NOT NULL,
	[SelQstns_id] [int] NOT NULL,
	[Item] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[Line_id] [tinyint] NOT NULL,
	[RelX] [smallint] NOT NULL,
	[RelY] [smallint] NOT NULL,
	[intWidth] [smallint] NOT NULL,
 CONSTRAINT [PK_HandWrittenLoc] PRIMARY KEY CLUSTERED 
(
	[QuestionForm_id] ASC,
	[SelQstns_id] ASC,
	[Item] ASC,
	[SampleUnit_id] ASC,
	[Line_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


