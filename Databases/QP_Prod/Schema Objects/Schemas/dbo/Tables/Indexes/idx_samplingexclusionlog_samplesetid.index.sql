CREATE NONCLUSTERED INDEX [idx_samplingexclusionlog_samplesetid] ON [dbo].[Sampling_ExclusionLog]
(
	[Sampleset_ID] ASC
)
INCLUDE ( 	[SamplingExlusionLog_ID],
	[Survey_ID],
	[Sampleunit_ID],
	[Pop_ID],
	[Enc_ID],
	[SamplingExclusionType_ID],
	[DQ_BusRule_ID],
	[DateCreated]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


