CREATE TABLE [dbo].[CommentLoc](
	[QuestionForm_id] [int] NOT NULL,
	[SelQstns_id] [int] NOT NULL,
	[Line] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[RelX] [int] NULL,
	[RelY] [int] NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
 CONSTRAINT [PK_CommentLoc] PRIMARY KEY CLUSTERED 
(
	[QuestionForm_id] ASC,
	[SelQstns_id] ASC,
	[Line] ASC,
	[SampleUnit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


