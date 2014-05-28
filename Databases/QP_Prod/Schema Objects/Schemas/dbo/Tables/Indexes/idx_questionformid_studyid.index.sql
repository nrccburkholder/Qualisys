CREATE NONCLUSTERED INDEX [idx_questionformid_studyid] ON [dbo].[QuestionForm_Extract]
(
	[QuestionForm_ID] ASC,
	[Study_ID] ASC
)
INCLUDE ( 	[tiExtracted],
	[datExtracted_DT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


