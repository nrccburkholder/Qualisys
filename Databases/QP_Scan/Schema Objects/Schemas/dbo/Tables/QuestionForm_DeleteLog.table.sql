CREATE TABLE [dbo].[QuestionForm_DeleteLog](
	[QuestionForm_id] [int] NOT NULL,
	[Batch_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
	[paper_type] [int] NOT NULL,
	[language] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_QuestionForm_DeleteLog_DateCreated]  DEFAULT (getdate())
) ON [PRIMARY]


