USE [QP_Prod]
GO

/****** Object:  Index [IX_EligibleEncLog_sampleset_id_sampleunit_id_includes]    Script Date: 2/11/2016 2:13:42 PM ******/
DROP INDEX [IX_EligibleEncLog_sampleset_id_sampleunit_id_includes] ON [dbo].[EligibleEncLog]
GO

/****** Object:  Index [IX_EligibleEncLog_sampleset_id_sampleunit_id_includes]    Script Date: 2/11/2016 2:13:42 PM ******/
CREATE NONCLUSTERED INDEX [IX_EligibleEncLog_sampleset_id_sampleunit_id_includes] ON [dbo].[EligibleEncLog]
(
	[sampleset_id] ASC,
	[sampleunit_id] ASC
)
INCLUDE ([pop_id],	[enc_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


