CREATE NONCLUSTERED INDEX [idx_samplingexclusionlog_surveyid] ON [dbo].[Sampling_ExclusionLog]
(
	[Survey_ID] ASC
)
INCLUDE ( 	[Pop_ID],
	[Enc_ID],
	[SamplingExclusionType_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


