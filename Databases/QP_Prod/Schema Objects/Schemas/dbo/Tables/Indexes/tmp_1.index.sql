CREATE NONCLUSTERED INDEX [tmp] ON [dbo].[drm_maine_ids]
(
	[study_id] ASC,
	[old_pop_id] ASC,
	[old_enc_id] ASC
)
INCLUDE ( 	[new_pop_id],
	[new_enc_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


