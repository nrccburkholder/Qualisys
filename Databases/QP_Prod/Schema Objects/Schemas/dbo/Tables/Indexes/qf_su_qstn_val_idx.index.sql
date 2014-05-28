CREATE NONCLUSTERED INDEX [qf_su_qstn_val_idx] ON [dbo].[cmnt_questionresult_work]
(
	[questionform_id] ASC,
	[sampleunit_id] ASC,
	[qstncore] ASC,
	[val] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


