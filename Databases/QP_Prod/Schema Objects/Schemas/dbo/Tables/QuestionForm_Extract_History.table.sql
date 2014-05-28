CREATE TABLE [dbo].[QuestionForm_Extract_History](
	[QFExtract_ID] [int] NOT NULL,
	[QuestionForm_ID] [int] NOT NULL,
	[tiExtracted] [tinyint] NOT NULL,
	[datExtracted_DT] [datetime] NULL,
	[Study_ID] [int] NULL
) ON [PRIMARY]


