CREATE TABLE [dbo].[QuestionResult2](
	[QuestionResult_ID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionForm_ID] [int] NOT NULL,
	[SampleUnit_ID] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intResponseVal] [int] NOT NULL,
	[QPC_TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_QuestionResult2] PRIMARY KEY CLUSTERED 
(
	[QuestionResult_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


