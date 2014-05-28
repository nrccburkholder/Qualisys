CREATE TABLE [dbo].[QuestionForm_Extract](
	[QFExtract_ID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionForm_ID] [int] NOT NULL,
	[tiExtracted] [tinyint] NOT NULL CONSTRAINT [DF_QuestionForm_Extract_bitExtracted]  DEFAULT (0),
	[datExtracted_DT] [datetime] NULL,
	[Study_ID] [int] NULL
) ON [PRIMARY]


