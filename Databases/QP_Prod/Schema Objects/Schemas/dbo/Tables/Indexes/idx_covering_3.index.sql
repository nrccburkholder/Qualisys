CREATE NONCLUSTERED INDEX [idx_covering] ON [dbo].[cmnt_questionresult_work]
(
	[datGenerated] ASC,
	[qstncore] ASC,
	[val] ASC
)
INCLUDE ( 	[questionform_id],
	[sampleunit_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


