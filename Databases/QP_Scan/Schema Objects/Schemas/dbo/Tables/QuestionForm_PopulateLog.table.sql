CREATE TABLE [dbo].[QuestionForm_PopulateLog](
	[questionform_id] [int] NULL,
	[batch_id] [int] NULL,
	[survey_id] [int] NULL,
	[paper_type] [int] NULL,
	[language] [int] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_QuestionForm_PopulateLog_DateCreated]  DEFAULT (getdate())
) ON [PRIMARY]


