CREATE NONCLUSTERED INDEX [IX_QuestionForm_PopulateLog_batch_id] ON [dbo].[QuestionForm_PopulateLog]
(
	[batch_id] ASC
)
INCLUDE ( 	[questionform_id],
	[survey_id],
	[paper_type],
	[language]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


